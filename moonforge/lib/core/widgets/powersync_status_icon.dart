import 'dart:async';

import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/powersync.dart';
import 'package:powersync/powersync.dart';

enum Status { success, error, neutral }

class PowerSyncStatusIcon extends ConsumerStatefulWidget {
  const PowerSyncStatusIcon({super.key, this.big = false});

  final bool big;

  @override
  ConsumerState<PowerSyncStatusIcon> createState() =>
      _PowerSyncStatusIconState();
}

class _PowerSyncStatusIconState extends ConsumerState<PowerSyncStatusIcon> {
  SyncStatus? _connectionState;
  StreamSubscription<SyncStatus>? _syncStatusSubscription;
  late PowerSyncDatabase dbPowerSync;

  @override
  void initState() {
    super.initState();
    initalize();
  }

  Future<void> initalize() async {
    dbPowerSync = await ref.read(powerSyncInstanceProvider.future);
    _connectionState = dbPowerSync.currentStatus;
    _syncStatusSubscription = dbPowerSync.statusStream.listen((event) {
      if (!mounted) {
        return;
      }
      setState(() {
        _connectionState = dbPowerSync.currentStatus;
      });
    });
  }

  @override
  void dispose() {
    _syncStatusSubscription?.cancel();
    super.dispose();
  }

  Widget _makeIcon(String string, IconData icon, Status status) {
    final color = status == Status.success
        ? Theme.of(context).colorScheme.primary
        : status == Status.error
        ? Theme.of(context).colorScheme.destructive
        : Theme.of(context).colorScheme.secondary;

    return Tooltip(
      tooltip: TooltipContainer(child: Text(string)).call,
      child: SizedBox(
        width: 51,
        child: Icon(icon, size: widget.big ? 24 : 20, color: color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectionState = _connectionState;
    if (connectionState == null) {
      return _makeIcon('Connecting', Icons.cloud_sync_outlined, Status.neutral);
    }
    if (connectionState.anyError != null) {
      if (!connectionState.connected) {
        return _makeIcon(
          connectionState.anyError!.toString(),
          Icons.cloud_off,
          Status.error,
        );
      } else {
        return _makeIcon(
          connectionState.anyError!.toString(),
          Icons.sync_problem,
          Status.error,
        );
      }
    } else if (connectionState.connecting) {
      return _makeIcon('Connecting', Icons.cloud_sync_outlined, Status.neutral);
    } else if (!connectionState.connected) {
      return _makeIcon('Not connected', Icons.cloud_off, Status.error);
    } else if (connectionState.uploading && connectionState.downloading) {
      // The status changes often between downloading, uploading and both,
      // so we use the same icon for all three
      return _makeIcon(
        'Uploading and downloading',
        Icons.cloud_sync_outlined,
        Status.neutral,
      );
    } else if (connectionState.uploading) {
      return _makeIcon('Uploading', Icons.cloud_sync_outlined, Status.neutral);
    } else if (connectionState.downloading) {
      return _makeIcon(
        'Downloading',
        Icons.cloud_sync_outlined,
        Status.neutral,
      );
    } else {
      return _makeIcon(
        'All changes synced to the Astal Plane',
        Icons.cloud_queue,
        Status.success,
      );
    }
  }
}
