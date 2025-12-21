import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final encounterCreaturesRepositoryProvider =
    Provider<EncounterCreaturesRepository>((ref) {
  final db = ref.watch(driftDatabase);
  return EncounterCreaturesRepository(db);
});

class EncounterCreaturesRepository {
  EncounterCreaturesRepository(this._db);

  final AppDatabase _db;

  Stream<List<EncounterCreaturesTableData>> watchAll() {
    return _db.select(_db.encounterCreaturesTable).watch();
  }

  Future<int> add(EncounterCreaturesTableData encounterCreature) {
    return _db.into(_db.encounterCreaturesTable).insert(encounterCreature);
  }

  Future<bool> update(EncounterCreaturesTableData encounterCreature) {
    return _db.update(_db.encounterCreaturesTable).replace(encounterCreature);
  }

  Future<void> upsert(EncounterCreaturesTableData encounterCreature) async {
    await _db
        .into(_db.encounterCreaturesTable)
        .insertOnConflictUpdate(encounterCreature);
  }

  Future<int> delete(EncounterCreaturesTableData encounterCreature) {
    return _db.delete(_db.encounterCreaturesTable).delete(encounterCreature);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(_db.encounterCreaturesTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}

class EncounterCreaturesNotifier
    extends StreamNotifier<List<EncounterCreaturesTableData>> {
  @override
  Stream<List<EncounterCreaturesTableData>> build() {
    return ref.watch(encounterCreaturesRepositoryProvider).watchAll();
  }
}

final encounterCreaturesProvider = StreamNotifierProvider<
    EncounterCreaturesNotifier, List<EncounterCreaturesTableData>>(
  EncounterCreaturesNotifier.new,
);

final encounterCreaturesCommandsProvider =
    AsyncNotifierProvider<EncounterCreaturesCommands, void>(
  EncounterCreaturesCommands.new,
);

class EncounterCreaturesCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addEncounterCreature(
    EncounterCreaturesTableData encounterCreature,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(encounterCreaturesRepositoryProvider)
          .add(encounterCreature);
    });
  }

  Future<void> updateEncounterCreature(
    EncounterCreaturesTableData encounterCreature,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(encounterCreaturesRepositoryProvider)
          .update(encounterCreature);
    });
  }

  Future<void> upsertEncounterCreature(
    EncounterCreaturesTableData encounterCreature,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(encounterCreaturesRepositoryProvider)
          .upsert(encounterCreature);
    });
  }

  Future<void> deleteEncounterCreature(
    EncounterCreaturesTableData encounterCreature,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(encounterCreaturesRepositoryProvider)
          .delete(encounterCreature);
    });
  }

  Future<void> deleteEncounterCreatureById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(encounterCreaturesRepositoryProvider)
          .deleteById(id);
    });
  }
}
