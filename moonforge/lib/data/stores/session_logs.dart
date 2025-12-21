import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final sessionLogsRepositoryProvider =
    Provider<SessionLogsRepository>((ref) {
  final db = ref.watch(driftDatabase);
  return SessionLogsRepository(db);
});

class SessionLogsRepository {
  SessionLogsRepository(this._db);

  final AppDatabase _db;

  Stream<List<SessionLogsTableData>> watchAll() {
    return _db.select(_db.sessionLogsTable).watch();
  }

  Future<int> add(SessionLogsTableData sessionLog) {
    return _db.into(_db.sessionLogsTable).insert(sessionLog);
  }

  Future<bool> update(SessionLogsTableData sessionLog) {
    return _db.update(_db.sessionLogsTable).replace(sessionLog);
  }

  Future<void> upsert(SessionLogsTableData sessionLog) async {
    await _db
        .into(_db.sessionLogsTable)
        .insertOnConflictUpdate(sessionLog);
  }

  Future<int> delete(SessionLogsTableData sessionLog) {
    return _db.delete(_db.sessionLogsTable).delete(sessionLog);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(_db.sessionLogsTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}

class SessionLogsNotifier
    extends StreamNotifier<List<SessionLogsTableData>> {
  @override
  Stream<List<SessionLogsTableData>> build() {
    return ref.watch(sessionLogsRepositoryProvider).watchAll();
  }
}

final sessionLogsProvider =
    StreamNotifierProvider<SessionLogsNotifier, List<SessionLogsTableData>>(
      SessionLogsNotifier.new,
    );

final sessionLogsCommandsProvider =
    AsyncNotifierProvider<SessionLogsCommands, void>(
      SessionLogsCommands.new,
    );

class SessionLogsCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addSessionLog(SessionLogsTableData sessionLog) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(sessionLogsRepositoryProvider).add(sessionLog);
    });
  }

  Future<void> updateSessionLog(SessionLogsTableData sessionLog) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(sessionLogsRepositoryProvider).update(sessionLog);
    });
  }

  Future<void> upsertSessionLog(SessionLogsTableData sessionLog) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(sessionLogsRepositoryProvider).upsert(sessionLog);
    });
  }

  Future<void> deleteSessionLog(SessionLogsTableData sessionLog) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(sessionLogsRepositoryProvider).delete(sessionLog);
    });
  }

  Future<void> deleteSessionLogById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(sessionLogsRepositoryProvider).deleteById(id);
    });
  }
}
