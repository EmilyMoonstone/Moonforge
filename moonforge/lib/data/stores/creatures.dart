import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final creaturesRepositoryProvider = Provider<CreaturesRepository>((ref) {
  final db = ref.watch(driftDatabase);
  return CreaturesRepository(db);
});

class CreaturesRepository {
  CreaturesRepository(this._db);

  final AppDatabase _db;

  Stream<List<CreaturesTableData>> watchAll() {
    return _db.select(_db.creaturesTable).watch();
  }

  Future<int> add(CreaturesTableData creature) {
    return _db.into(_db.creaturesTable).insert(creature);
  }

  Future<bool> update(CreaturesTableData creature) {
    return _db.update(_db.creaturesTable).replace(creature);
  }

  Future<void> upsert(CreaturesTableData creature) async {
    await _db.into(_db.creaturesTable).insertOnConflictUpdate(creature);
  }

  Future<int> delete(CreaturesTableData creature) {
    return _db.delete(_db.creaturesTable).delete(creature);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(_db.creaturesTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}

class CreaturesNotifier extends StreamNotifier<List<CreaturesTableData>> {
  @override
  Stream<List<CreaturesTableData>> build() {
    return ref.watch(creaturesRepositoryProvider).watchAll();
  }
}

final creaturesProvider =
    StreamNotifierProvider<CreaturesNotifier, List<CreaturesTableData>>(
      CreaturesNotifier.new,
    );

final creaturesCommandsProvider =
    AsyncNotifierProvider<CreaturesCommands, void>(
      CreaturesCommands.new,
    );

class CreaturesCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addCreature(CreaturesTableData creature) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(creaturesRepositoryProvider).add(creature);
    });
  }

  Future<void> updateCreature(CreaturesTableData creature) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(creaturesRepositoryProvider).update(creature);
    });
  }

  Future<void> upsertCreature(CreaturesTableData creature) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(creaturesRepositoryProvider).upsert(creature);
    });
  }

  Future<void> deleteCreature(CreaturesTableData creature) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(creaturesRepositoryProvider).delete(creature);
    });
  }

  Future<void> deleteCreatureById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(creaturesRepositoryProvider).deleteById(id);
    });
  }
}
