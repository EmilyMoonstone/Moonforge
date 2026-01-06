import 'dart:convert';
import 'dart:typed_data';

import 'package:powersync_core/attachments/attachments.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _knownBuckets = {'images', 'profile_pictures'};

class SupabaseStorageAdapter implements RemoteStorage {
  SupabaseStorageAdapter({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<void> uploadFile(
    Stream<Uint8List> fileData,
    Attachment attachment,
  ) async {
    final resolved = _resolveBucketAndPath(attachment);
    final bytes = await _collectBytes(fileData);

    await _client.storage.from(resolved.bucket).uploadBinary(
          resolved.path,
          bytes,
          fileOptions: FileOptions(
            contentType: attachment.mediaType ?? 'application/octet-stream',
          ),
        );
  }

  @override
  Future<Stream<List<int>>> downloadFile(Attachment attachment) async {
    final resolved = _resolveBucketAndPath(attachment);
    final bytes = await _client.storage.from(resolved.bucket).download(
          resolved.path,
        );
    return Stream.value(bytes);
  }

  @override
  Future<void> deleteFile(Attachment attachment) async {
    final resolved = _resolveBucketAndPath(attachment);
    await _client.storage.from(resolved.bucket).remove([resolved.path]);
  }
}

({String bucket, String path}) _resolveBucketAndPath(Attachment attachment) {
  final metaBucket = _bucketFromMetaData(attachment.metaData);
  if (metaBucket != null) {
    return (bucket: metaBucket, path: attachment.filename);
  }

  final parts = attachment.filename.split('/');
  if (parts.length > 1 && _knownBuckets.contains(parts.first)) {
    return (
      bucket: parts.first,
      path: parts.sublist(1).join('/'),
    );
  }

  throw StateError(
    'Attachment ${attachment.id} is missing bucket metadata.',
  );
}

String? _bucketFromMetaData(String? metaData) {
  if (metaData == null) {
    return null;
  }

  final trimmed = metaData.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  if (_knownBuckets.contains(trimmed)) {
    return trimmed;
  }

  try {
    final decoded = jsonDecode(trimmed);
    if (decoded is Map<String, dynamic>) {
      final bucket = decoded['bucket'];
      if (bucket is String && _knownBuckets.contains(bucket)) {
        return bucket;
      }
    }
  } catch (_) {}

  return null;
}

Future<Uint8List> _collectBytes(Stream<Uint8List> data) async {
  final builder = BytesBuilder(copy: false);
  await for (final chunk in data) {
    builder.add(chunk);
  }
  return builder.takeBytes();
}
