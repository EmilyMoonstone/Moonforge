import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:powersync/powersync.dart';
import 'package:powersync_core/attachments/attachments.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../attachments/queue.dart';
import '../attachments/local_storage_unsupported.dart'
    if (dart.library.io) '../attachments/local_storage_native.dart';
import '../enums.dart';

Future<Uint8List?> resolveImageBytes({
  required PowerSyncDatabase db,
  required StorageBuckets bucket,
  required String path,
  bool preferLocal = true,
}) async {
  final normalizedPath = _normalizePath(path);
  if (normalizedPath == null) {
    return null;
  }

  if (preferLocal && bucket == StorageBuckets.images) {
    final localBytes = await _readLocalAttachmentBytes(db, normalizedPath);
    if (localBytes != null) {
      return localBytes;
    }
  }

  return _downloadRemoteBytes(bucket, normalizedPath);
}

Future<ImageProvider?> resolveImageProvider({
  required PowerSyncDatabase db,
  required StorageBuckets bucket,
  required String path,
  bool preferLocal = true,
}) async {
  final bytes = await resolveImageBytes(
    db: db,
    bucket: bucket,
    path: path,
    preferLocal: preferLocal,
  );
  if (bytes == null) {
    return null;
  }
  return MemoryImage(bytes);
}

Future<Uint8List?> _readLocalAttachmentBytes(
  PowerSyncDatabase db,
  String path,
) async {
  final attachmentId = _attachmentIdFromPath(path);
  if (attachmentId == null) {
    return null;
  }

  final localRow = await db.getOptional(
    '''
select local_uri
from attachments_queue
where id = ?
  and local_uri is not null
  and local_uri <> ''
limit 1
''',
    [attachmentId],
  );

  final localUri = localRow?['local_uri']?.toString();
  if (localUri == null || localUri.isEmpty) {
    return null;
  }

  final storage =
      attachmentLocalStorageOrNull() ?? await localAttachmentStorage();

  try {
    return await _collectBytes(storage.readFile(localUri));
  } catch (_) {
    return null;
  }
}

Future<Uint8List?> _downloadRemoteBytes(
  StorageBuckets bucket,
  String path,
) async {
  final bucketName = storageBucketNames[bucket];
  if (bucketName == null || bucketName.isEmpty) {
    return null;
  }

  try {
    return await Supabase.instance.client.storage
        .from(bucketName)
        .download(path);
  } catch (_) {
    return null;
  }
}

String? _normalizePath(String path) {
  final trimmed = path.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}

String? _attachmentIdFromPath(String path) {
  final lastSlash = path.lastIndexOf('/');
  final lastSegment = lastSlash >= 0 ? path.substring(lastSlash + 1) : path;
  final dotIndex = lastSegment.lastIndexOf('.');
  if (dotIndex <= 0 || dotIndex == lastSegment.length - 1) {
    return path;
  }

  final suffixLength = lastSegment.length - dotIndex;
  return path.substring(0, path.length - suffixLength);
}

Future<Uint8List> _collectBytes(Stream<Uint8List> data) async {
  final builder = BytesBuilder(copy: false);
  await for (final chunk in data) {
    builder.add(chunk);
  }
  return builder.takeBytes();
}

class AttachmentImageProvider extends ImageProvider<AttachmentImageProvider> {
  const AttachmentImageProvider({
    required this.dbFuture,
    required this.bucket,
    required this.path,
    this.preferLocal = true,
    this.scale = 1.0,
  });

  final Future<PowerSyncDatabase> dbFuture;
  final StorageBuckets bucket;
  final String path;
  final bool preferLocal;
  final double scale;

  @override
  Future<AttachmentImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AttachmentImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    AttachmentImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, (buffer) => decode(buffer)),
      scale: key.scale,
      debugLabel: 'AttachmentImageProvider(${key.path})',
    );
  }

  @override
  ImageStreamCompleter loadBuffer(
    AttachmentImageProvider key,
    DecoderBufferCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, (buffer) => decode(buffer)),
      scale: key.scale,
      debugLabel: 'AttachmentImageProvider(${key.path})',
    );
  }

  Future<ui.Codec> _loadAsync(
    AttachmentImageProvider key,
    Future<ui.Codec> Function(ui.ImmutableBuffer buffer) decode,
  ) async {
    final db = await key.dbFuture;
    final bytes = await resolveImageBytes(
      db: db,
      bucket: key.bucket,
      path: key.path,
      preferLocal: key.preferLocal,
    );
    if (bytes == null || bytes.isEmpty) {
      throw StateError('Attachment image not available: ${key.path}');
    }

    return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is AttachmentImageProvider &&
        other.path == path &&
        other.bucket == bucket &&
        other.dbFuture == dbFuture &&
        other.scale == scale &&
        other.preferLocal == preferLocal;
  }

  @override
  int get hashCode => Object.hash(path, bucket, dbFuture, scale, preferLocal);
}
