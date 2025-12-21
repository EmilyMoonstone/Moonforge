import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final mapsRepositoryProvider = Provider<MapsRepository>((ref) {
  final db = ref.watch(driftDatabase);
  return MapsRepository(db);
});

class MapsRepository {
  MapsRepository(this._db);

  final AppDatabase _db;

  Stream<List<MapsTableData>> watchAll() {
    return _db.select(_db.mapsTable).watch();
  }

  Future<int> add(MapsTableData map) {
    return _db.into(_db.mapsTable).insert(map);
  }

  Future<bool> update(MapsTableData map) {
    return _db.update(_db.mapsTable).replace(map);
  }

  Future<void> upsert(MapsTableData map) async {
    await _db.into(_db.mapsTable).insertOnConflictUpdate(map);
  }

  Future<int> delete(MapsTableData map) {
    return _db.delete(_db.mapsTable).delete(map);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(_db.mapsTable)..where((t) => t.id.equals(id))).go();
  }
}

class MapsNotifier extends StreamNotifier<List<MapsTableData>> {
  @override
  Stream<List<MapsTableData>> build() {
    return ref.watch(mapsRepositoryProvider).watchAll();
  }
}

final mapsProvider = StreamNotifierProvider<MapsNotifier, List<MapsTableData>>(
  MapsNotifier.new,
);

final mapsCommandsProvider = AsyncNotifierProvider<MapsCommands, void>(
  MapsCommands.new,
);

class MapsCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addMap(MapsTableData map) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(mapsRepositoryProvider).add(map);
    });
  }

  Future<void> updateMap(MapsTableData map) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(mapsRepositoryProvider).update(map);
    });
  }

  Future<void> upsertMap(MapsTableData map) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(mapsRepositoryProvider).upsert(map);
    });
  }

  Future<void> deleteMap(MapsTableData map) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(mapsRepositoryProvider).delete(map);
    });
  }

  Future<void> deleteMapById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(mapsRepositoryProvider).deleteById(id);
    });
  }
}
