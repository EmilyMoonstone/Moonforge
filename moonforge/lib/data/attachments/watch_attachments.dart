import 'package:powersync/powersync.dart';
import 'package:powersync_core/attachments/attachments.dart';
import 'package:sqlite3/common.dart';

const _imagesBucket = 'images';

Stream<List<WatchedAttachmentItem>> watchImageAttachments(
  PowerSyncDatabase db,
) {
  const sql = '''
select icon as path, '$_imagesBucket' as bucket
from campaigns
where icon is not null and icon <> ''
union all
select title_image as path, '$_imagesBucket' as bucket
from campaigns
where title_image is not null and title_image <> ''
union all
select image as path, '$_imagesBucket' as bucket
from maps
where image is not null and image <> ''
union all
select avatar as path, '$_imagesBucket' as bucket
from organizations
where avatar is not null and avatar <> ''
union all
select image as path, '$_imagesBucket' as bucket
from items
where image is not null and image <> ''
union all
select avatar as path, '$_imagesBucket' as bucket
from creatures
where avatar is not null and avatar <> ''
union all
select avatar as path, '$_imagesBucket' as bucket
from characters
where avatar is not null and avatar <> ''
''';

  return db.watch(
    sql,
    triggerOnTables: const [
      'campaigns',
      'maps',
      'organizations',
      'items',
      'creatures',
      'characters',
    ],
  ).map(_rowsToWatchedItems);
}

List<WatchedAttachmentItem> _rowsToWatchedItems(ResultSet results) {
  final items = <WatchedAttachmentItem>[];
  final seen = <String>{};

  for (final row in results) {
    final path = _normalizePath(row['path']);
    if (path == null) {
      continue;
    }

    final bucket = _normalizePath(row['bucket']) ?? _imagesBucket;
    final parsed = _parsePath(path);
    final key = '$bucket::${parsed.id}';
    if (!seen.add(key)) {
      continue;
    }

    items.add(
      WatchedAttachmentItem(
        id: parsed.id,
        fileExtension: parsed.fileExtension,
        filename: parsed.fileExtension == null ? path : null,
        metaData: bucket,
      ),
    );
  }

  return items;
}

String? _normalizePath(Object? value) {
  if (value is! String) {
    return null;
  }
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}

({String id, String? fileExtension}) _parsePath(String path) {
  final lastSlash = path.lastIndexOf('/');
  final lastSegment = lastSlash >= 0 ? path.substring(lastSlash + 1) : path;
  final dotIndex = lastSegment.lastIndexOf('.');
  if (dotIndex <= 0 || dotIndex == lastSegment.length - 1) {
    return (id: path, fileExtension: null);
  }

  final extension = lastSegment.substring(dotIndex + 1);
  final suffixLength = lastSegment.length - dotIndex;
  final id = path.substring(0, path.length - suffixLength);
  return (id: id, fileExtension: extension);
}
