import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final locationsRepositoryProvider = Provider<LocationsRepository>((ref) {
  final db = ref.watch(driftDatabase);
  return LocationsRepository(db);
});

class LocationsRepository {
  LocationsRepository(this._db);

  final AppDatabase _db;

  Stream<List<LocationsTableData>> watchAll() {
    return _db.select(_db.locationsTable).watch();
  }

  Future<int> add(LocationsTableData location) {
    return _db.into(_db.locationsTable).insert(location);
  }

  Future<bool> update(LocationsTableData location) {
    return _db.update(_db.locationsTable).replace(location);
  }

  Future<void> upsert(LocationsTableData location) async {
    await _db.into(_db.locationsTable).insertOnConflictUpdate(location);
  }

  Future<int> delete(LocationsTableData location) {
    return _db.delete(_db.locationsTable).delete(location);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(_db.locationsTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}

class LocationsNotifier extends StreamNotifier<List<LocationsTableData>> {
  @override
  Stream<List<LocationsTableData>> build() {
    return ref.watch(locationsRepositoryProvider).watchAll();
  }
}

final locationsProvider =
    StreamNotifierProvider<LocationsNotifier, List<LocationsTableData>>(
      LocationsNotifier.new,
    );

final locationsCommandsProvider =
    AsyncNotifierProvider<LocationsCommands, void>(
      LocationsCommands.new,
    );

class LocationsCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addLocation(LocationsTableData location) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(locationsRepositoryProvider).add(location);
    });
  }

  Future<void> updateLocation(LocationsTableData location) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(locationsRepositoryProvider).update(location);
    });
  }

  Future<void> upsertLocation(LocationsTableData location) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(locationsRepositoryProvider).upsert(location);
    });
  }

  Future<void> deleteLocation(LocationsTableData location) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(locationsRepositoryProvider).delete(location);
    });
  }

  Future<void> deleteLocationById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(locationsRepositoryProvider).deleteById(id);
    });
  }
}
