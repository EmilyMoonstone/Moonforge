import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final scenesRepositoryProvider = Provider<ScenesRepository>((ref) {
  final db = ref.watch(driftDatabase);
  return ScenesRepository(db);
});

class ScenesRepository {
  ScenesRepository(this._db);

  final AppDatabase _db;

  Stream<List<ScenesTableData>> watchAll() {
    return _db.select(_db.scenesTable).watch();
  }

  Future<int> add(ScenesTableData scene) {
    return _db.into(_db.scenesTable).insert(scene);
  }

  Future<bool> update(ScenesTableData scene) {
    return _db.update(_db.scenesTable).replace(scene);
  }

  Future<void> upsert(ScenesTableData scene) async {
    await _db.into(_db.scenesTable).insertOnConflictUpdate(scene);
  }

  Future<int> delete(ScenesTableData scene) {
    return _db.delete(_db.scenesTable).delete(scene);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(_db.scenesTable)..where((t) => t.id.equals(id))).go();
  }
}

class ScenesNotifier extends StreamNotifier<List<ScenesTableData>> {
  @override
  Stream<List<ScenesTableData>> build() {
    return ref.watch(scenesRepositoryProvider).watchAll();
  }
}

final scenesProvider =
    StreamNotifierProvider<ScenesNotifier, List<ScenesTableData>>(
      ScenesNotifier.new,
    );

final scenesCommandsProvider = AsyncNotifierProvider<ScenesCommands, void>(
  ScenesCommands.new,
);

class ScenesCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addScene(ScenesTableData scene) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(scenesRepositoryProvider).add(scene);
    });
  }

  Future<void> updateScene(ScenesTableData scene) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(scenesRepositoryProvider).update(scene);
    });
  }

  Future<void> upsertScene(ScenesTableData scene) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(scenesRepositoryProvider).upsert(scene);
    });
  }

  Future<void> deleteScene(ScenesTableData scene) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(scenesRepositoryProvider).delete(scene);
    });
  }

  Future<void> deleteSceneById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(scenesRepositoryProvider).deleteById(id);
    });
  }
}
