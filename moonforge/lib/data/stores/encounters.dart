import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final encountersRepositoryProvider = Provider<EncountersRepository>((ref) {
  final db = ref.watch(driftDatabase);
  return EncountersRepository(db);
});

class EncountersRepository {
  EncountersRepository(this._db);

  final AppDatabase _db;

  Stream<List<EncountersTableData>> watchAll() {
    return _db.select(_db.encountersTable).watch();
  }

  Stream<List<EncountersTableData>> watchByCampaignId(String campaignId) {
    return (_db.select(
      _db.encountersTable,
    )..where((tbl) => tbl.campaignId.equals(campaignId))).watch();
  }

  Stream<List<EncountersTableData>> watchByScopes(List<String> scopeIds) {
    return (_db.select(_db.encountersTable)
          ..where((tbl) => tbl.scopeId.isIn(scopeIds)))
        .watch();
  }

  Stream<List<EncountersWithScope>> watchWithScopes() {
    return _db.select(_db.encountersWithScopes).watch();
  }

  Future<int> add(EncountersTableData encounter) {
    return _db.into(_db.encountersTable).insert(encounter);
  }

  Future<bool> update(EncountersTableData encounter) {
    return _db.update(_db.encountersTable).replace(encounter);
  }

  Future<void> upsert(EncountersTableData encounter) async {
    await _db.into(_db.encountersTable).insertOnConflictUpdate(encounter);
  }

  Future<int> delete(EncountersTableData encounter) {
    return _db.delete(_db.encountersTable).delete(encounter);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(_db.encountersTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}

class EncountersNotifier extends StreamNotifier<List<EncountersTableData>> {
  @override
  Stream<List<EncountersTableData>> build() {
    return ref.watch(encountersRepositoryProvider).watchAll();
  }
}

final encountersProvider =
    StreamNotifierProvider<EncountersNotifier, List<EncountersTableData>>(
      EncountersNotifier.new,
    );

final encountersCommandsProvider =
    AsyncNotifierProvider<EncountersCommands, void>(
      EncountersCommands.new,
    );

class EncountersCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addEncounter(EncountersTableData encounter) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(encountersRepositoryProvider).add(encounter);
    });
  }

  Future<void> updateEncounter(EncountersTableData encounter) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(encountersRepositoryProvider).update(encounter);
    });
  }

  Future<void> upsertEncounter(EncountersTableData encounter) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(encountersRepositoryProvider).upsert(encounter);
    });
  }

  Future<void> deleteEncounter(EncountersTableData encounter) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(encountersRepositoryProvider).delete(encounter);
    });
  }

  Future<void> deleteEncounterById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(encountersRepositoryProvider).deleteById(id);
    });
  }
}
