import 'dart:async';

import 'package:powersync/powersync.dart';
import 'package:powersync_core/attachments/attachments.dart';

import 'local_storage_unsupported.dart'
    if (dart.library.io) 'local_storage_native.dart';
import 'remote_storage_adapter.dart';
import 'watch_attachments.dart';

AttachmentQueue? _attachmentQueue;
LocalStorage? _attachmentLocalStorage;
Completer<AttachmentQueue>? _queueCompleter;

Future<AttachmentQueue> initializeAttachmentQueue(
  PowerSyncDatabase db,
) async {
  final existing = _attachmentQueue;
  if (existing != null) {
    return existing;
  }

  final inflight = _queueCompleter;
  if (inflight != null) {
    return inflight.future;
  }

  final completer = Completer<AttachmentQueue>();
  _queueCompleter = completer;

  try {
    final localStorage = await localAttachmentStorage();
    _attachmentLocalStorage = localStorage;
    final queue = AttachmentQueue(
      db: db,
      remoteStorage: SupabaseStorageAdapter(),
      localStorage: localStorage,
      watchAttachments: () => watchImageAttachments(db),
    );
    await queue.startSync();
    _attachmentQueue = queue;
    completer.complete(queue);
    return queue;
  } catch (error, stackTrace) {
    _queueCompleter = null;
    completer.completeError(error, stackTrace);
    rethrow;
  }
}

AttachmentQueue? attachmentQueueOrNull() => _attachmentQueue;

LocalStorage? attachmentLocalStorageOrNull() => _attachmentLocalStorage;

Future<void> disposeAttachmentQueue() async {
  final queue = _attachmentQueue;
  _attachmentLocalStorage = null;
  _attachmentQueue = null;
  _queueCompleter = null;
  await queue?.close();
}

Stream<List<WatchedAttachmentItem>> _emptyWatchAttachments() {
  return Stream.value(const <WatchedAttachmentItem>[]);
}
