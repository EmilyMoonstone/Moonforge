import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final chaptersRepositoryProvider = Provider<ChaptersRepository>((ref) {
  final db = ref.watch(driftDatabase);
  return ChaptersRepository(db);
});

class ChaptersRepository {
  ChaptersRepository(this._db);

  final AppDatabase _db;

  Stream<List<ChaptersTableData>> watchAll() {
    return _db.select(_db.chaptersTable).watch();
  }

  Stream<List<ChaptersTableData>> watchByCampaignId(String campaignId) {
    return (_db.select(_db.chaptersTable)
          ..where((t) => t.campaignId.equals(campaignId)))
        .watch();
  }

  Future<ChaptersTableData?> getById(String id) async {
    return (_db.select(_db.chaptersTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> add(ChaptersTableData chapter) {
    return _db.into(_db.chaptersTable).insert(chapter);
  }

  Future<bool> update(ChaptersTableData chapter) {
    return _db.update(_db.chaptersTable).replace(chapter);
  }

  Future<void> upsert(ChaptersTableData chapter) async {
    await _db.into(_db.chaptersTable).insertOnConflictUpdate(chapter);
  }

  Future<int> delete(ChaptersTableData chapter) {
    return _db.delete(_db.chaptersTable).delete(chapter);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(_db.chaptersTable)..where((t) => t.id.equals(id))).go();
  }
}

class ChaptersNotifier extends StreamNotifier<List<ChaptersTableData>> {
  @override
  Stream<List<ChaptersTableData>> build() {
    return ref.watch(chaptersRepositoryProvider).watchAll();
  }
}

final chaptersProvider =
    StreamNotifierProvider<ChaptersNotifier, List<ChaptersTableData>>(
      ChaptersNotifier.new,
    );

final chaptersCommandsProvider = AsyncNotifierProvider<ChaptersCommands, void>(
  ChaptersCommands.new,
);

class ChaptersCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addChapter(ChaptersTableData chapter) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(chaptersRepositoryProvider).add(chapter);
    });
  }

  Future<void> updateChapter(ChaptersTableData chapter) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(chaptersRepositoryProvider).update(chapter);
    });
  }

  Future<void> upsertChapter(ChaptersTableData chapter) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(chaptersRepositoryProvider).upsert(chapter);
    });
  }

  Future<void> deleteChapter(ChaptersTableData chapter) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(chaptersRepositoryProvider).delete(chapter);
    });
  }

  Future<void> deleteChapterById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(chaptersRepositoryProvider).deleteById(id);
    });
  }
}
