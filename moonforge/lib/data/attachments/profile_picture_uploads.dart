import 'dart:async';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../enums.dart';

const _uuid = Uuid();

Future<String> uploadProfilePicture({
  required Stream<List<int>> data,
  required String mediaType,
  required String fileExtension,
  String? path,
  SupabaseClient? client,
}) async {
  final supabase = client ?? Supabase.instance.client;
  final user = supabase.auth.currentUser;
  if (user == null) {
    throw StateError('No authenticated user for profile picture upload.');
  }

  final String? oldProfilePicture = user.userMetadata?['profile_picture'];

  final normalizedExtension = _normalizeExtension(fileExtension, mediaType);
  final resolvedPath = path ?? '${user.id}/${_uuid.v4()}.$normalizedExtension';

  final bytes = await _collectBytes(data);

  await supabase.storage
      .from(storageBucketNames[StorageBuckets.profilePictures]!)
      .uploadBinary(
        resolvedPath,
        bytes,
        //fileOptions: FileOptions(contentType: mediaType),
      );

  await supabase.auth.updateUser(
    UserAttributes(data: <String, dynamic>{'profile_picture': resolvedPath}),
  );

  //Delete old profile picture.
  if (oldProfilePicture != null && oldProfilePicture.isNotEmpty) {
    await supabase.storage
        .from(storageBucketNames[StorageBuckets.profilePictures]!)
        .remove([oldProfilePicture]);
  }

  return resolvedPath;
}

String _normalizeExtension(String extension, String mediaType) {
  var value = extension.trim();
  if (value.startsWith('.')) {
    value = value.substring(1);
  }
  if (value.isEmpty) {
    final slashIndex = mediaType.indexOf('/');
    if (slashIndex >= 0 && slashIndex + 1 < mediaType.length) {
      value = mediaType.substring(slashIndex + 1);
    }
  }
  if (value.isEmpty) {
    value = 'bin';
  }
  return value.toLowerCase();
}

Future<Uint8List> _collectBytes(Stream<List<int>> data) async {
  final builder = BytesBuilder(copy: false);
  await for (final chunk in data) {
    builder.add(chunk);
  }
  return builder.takeBytes();
}
