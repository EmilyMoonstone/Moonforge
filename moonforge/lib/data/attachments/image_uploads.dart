import 'dart:async';

import 'package:powersync/powersync.dart';
import 'package:powersync_core/attachments/attachments.dart';
import 'package:sqlite_async/sqlite_async.dart';
import 'package:uuid/uuid.dart';

import '../enums.dart';
import 'queue.dart';

const _uuid = Uuid();

Future<Attachment> saveCampaignIconAttachment({
  required PowerSyncDatabase db,
  required String campaignId,
  required Stream<List<int>> data,
  required String mediaType,
  required String fileExtension,
  String? previousPath,
}) {
  return _saveImageAttachment(
    db: db,
    table: 'campaigns',
    column: 'icon',
    recordId: campaignId,
    campaignId: campaignId,
    folder: ImageFolders.avatars,
    data: data,
    mediaType: mediaType,
    fileExtension: fileExtension,
    previousPath: previousPath,
  );
}

Future<Attachment> saveCampaignTitleImageAttachment({
  required PowerSyncDatabase db,
  required String campaignId,
  required Stream<List<int>> data,
  required String mediaType,
  required String fileExtension,
  String? previousPath,
}) {
  return _saveImageAttachment(
    db: db,
    table: 'campaigns',
    column: 'title_image',
    recordId: campaignId,
    campaignId: campaignId,
    folder: ImageFolders.images,
    data: data,
    mediaType: mediaType,
    fileExtension: fileExtension,
    previousPath: previousPath,
  );
}

Future<Attachment> saveMapImageAttachment({
  required PowerSyncDatabase db,
  required String campaignId,
  required String mapId,
  required Stream<List<int>> data,
  required String mediaType,
  required String fileExtension,
  String? previousPath,
}) {
  return _saveImageAttachment(
    db: db,
    table: 'maps',
    column: 'image',
    recordId: mapId,
    campaignId: campaignId,
    folder: ImageFolders.maps,
    data: data,
    mediaType: mediaType,
    fileExtension: fileExtension,
    previousPath: previousPath,
  );
}

Future<Attachment> saveItemImageAttachment({
  required PowerSyncDatabase db,
  required String campaignId,
  required String itemId,
  required Stream<List<int>> data,
  required String mediaType,
  required String fileExtension,
  String? previousPath,
}) {
  return _saveImageAttachment(
    db: db,
    table: 'items',
    column: 'image',
    recordId: itemId,
    campaignId: campaignId,
    folder: ImageFolders.images,
    data: data,
    mediaType: mediaType,
    fileExtension: fileExtension,
    previousPath: previousPath,
  );
}

Future<Attachment> saveCreatureAvatarAttachment({
  required PowerSyncDatabase db,
  required String campaignId,
  required String creatureId,
  required Stream<List<int>> data,
  required String mediaType,
  required String fileExtension,
  String? previousPath,
}) {
  return _saveImageAttachment(
    db: db,
    table: 'creatures',
    column: 'avatar',
    recordId: creatureId,
    campaignId: campaignId,
    folder: ImageFolders.images,
    data: data,
    mediaType: mediaType,
    fileExtension: fileExtension,
    previousPath: previousPath,
  );
}

Future<Attachment> saveOrganizationAvatarAttachment({
  required PowerSyncDatabase db,
  required String campaignId,
  required String organizationId,
  required Stream<List<int>> data,
  required String mediaType,
  required String fileExtension,
  String? previousPath,
}) {
  return _saveImageAttachment(
    db: db,
    table: 'organizations',
    column: 'avatar',
    recordId: organizationId,
    campaignId: campaignId,
    folder: ImageFolders.images,
    data: data,
    mediaType: mediaType,
    fileExtension: fileExtension,
    previousPath: previousPath,
  );
}

Future<Attachment> saveCharacterAvatarAttachment({
  required PowerSyncDatabase db,
  required String campaignId,
  required String characterId,
  required Stream<List<int>> data,
  required String mediaType,
  required String fileExtension,
  String? previousPath,
}) {
  return _saveImageAttachment(
    db: db,
    table: 'characters',
    column: 'avatar',
    recordId: characterId,
    campaignId: campaignId,
    folder: ImageFolders.images,
    data: data,
    mediaType: mediaType,
    fileExtension: fileExtension,
    previousPath: previousPath,
  );
}

Future<Attachment> _saveImageAttachment({
  required PowerSyncDatabase db,
  required String table,
  required String column,
  required String recordId,
  required String campaignId,
  required ImageFolders folder,
  required Stream<List<int>> data,
  required String mediaType,
  required String fileExtension,
  String? previousPath,
}) async {
  final queue = await initializeAttachmentQueue(db);
  final extension = _normalizeExtension(fileExtension, mediaType);
  final fileId = _uuid.v4();
  final folderName = imageFolderNames[folder];
  if (folderName == null) {
    throw StateError('Missing folder name for $folder');
  }

  final basePath = '$campaignId/$folderName/$fileId';

  final attachment = await queue.saveFile(
    data: data,
    mediaType: mediaType,
    fileExtension: extension,
    id: basePath,
    metaData: storageBucketNames[StorageBuckets.images],
    updateHook: (SqliteWriteContext context, Attachment attachment) async {
      await context.execute('UPDATE $table SET $column = ? WHERE id = ?', [
        attachment.filename,
        recordId,
      ]);
    },
  );

  await _deletePreviousAttachment(
    queue: queue,
    previousPath: previousPath,
    currentPath: attachment.filename,
  );

  return attachment;
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

Future<void> _deletePreviousAttachment({
  required AttachmentQueue queue,
  String? previousPath,
  required String currentPath,
}) async {
  final trimmed = previousPath?.trim() ?? '';
  if (trimmed.isEmpty || trimmed == currentPath) {
    return;
  }

  final previousId = _attachmentIdFromPath(trimmed);
  if (previousId == null || previousId.isEmpty) {
    return;
  }

  try {
    await queue.deleteFile(
      attachmentId: previousId,
      updateHook: (SqliteWriteContext _, Attachment __) async {},
    );
  } catch (_) {}
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
