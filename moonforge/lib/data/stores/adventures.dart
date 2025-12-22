import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final adventuresRepositoryProvider = Provider<AdventuresRepository>((ref) {
  final db = ref.watch(driftDatabase);
  return AdventuresRepository(db);
});

class AdventuresRepository {
  AdventuresRepository(this._db);

  final AppDatabase _db;

  Stream<List<AdventuresTableData>> watchAll() {
    return _db.select(_db.adventuresTable).watch();
  }

  Stream<List<AdventuresTableData>> watchByChapterId(String chapterId) {
    return (_db.select(_db.adventuresTable)
          ..where((t) => t.chapterId.equals(chapterId)))
        .watch();
  }

  Future<int> add(AdventuresTableData adventure) {
    return _db.into(_db.adventuresTable).insert(adventure);
  }

  Future<bool> update(AdventuresTableData adventure) {
    return _db.update(_db.adventuresTable).replace(adventure);
  }

  Future<void> upsert(AdventuresTableData adventure) async {
    await _db.into(_db.adventuresTable).insertOnConflictUpdate(adventure);
  }

  Future<int> delete(AdventuresTableData adventure) {
    return _db.delete(_db.adventuresTable).delete(adventure);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(_db.adventuresTable)..where((t) => t.id.equals(id))).go();
  }
}

class AdventuresNotifier extends StreamNotifier<List<AdventuresTableData>> {
  @override
  Stream<List<AdventuresTableData>> build() {
    return ref.watch(adventuresRepositoryProvider).watchAll();
  }
}

final adventuresProvider =
    StreamNotifierProvider<AdventuresNotifier, List<AdventuresTableData>>(
      AdventuresNotifier.new,
    );

final adventuresCommandsProvider =
    AsyncNotifierProvider<AdventuresCommands, void>(
      AdventuresCommands.new,
    );

class AdventuresCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addAdventure(AdventuresTableData adventure) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(adventuresRepositoryProvider).add(adventure);
    });
  }

  Future<void> updateAdventure(AdventuresTableData adventure) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(adventuresRepositoryProvider).update(adventure);
    });
  }

  Future<void> upsertAdventure(AdventuresTableData adventure) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(adventuresRepositoryProvider).upsert(adventure);
    });
  }

  Future<void> deleteAdventure(AdventuresTableData adventure) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(adventuresRepositoryProvider).delete(adventure);
    });
  }

  Future<void> deleteAdventureById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(adventuresRepositoryProvider).deleteById(id);
    });
  }
}
