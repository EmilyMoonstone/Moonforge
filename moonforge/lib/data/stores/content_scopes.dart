import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final contentScopesRepositoryProvider = Provider<ContentScopesRepository>((
  ref,
) {
  final db = ref.watch(driftDatabase);
  return ContentScopesRepository(db);
});

class ContentScopesRepository {
  ContentScopesRepository(this._db);

  final AppDatabase _db;

  Stream<List<ContentScopesTableData>> watchAll() {
    return _db.select(_db.contentScopesTable).watch();
  }

  Stream<List<ContentScopesTableData>> watchByCampaignId(String campaignId) {
    return (_db.select(
      _db.contentScopesTable,
    )..where((tbl) => tbl.campaignId.equals(campaignId))).watch();
  }

    Future<List<ContentScopesTableData>> getByCampaignId(String campaignId) {
    return (_db.select(
      _db.contentScopesTable,
    )..where((tbl) => tbl.campaignId.equals(campaignId))).get();
  }

  Stream<ContentScopesTableData?> watchOnlyByCampaignId(
    String campaignId,
  ) {
    return (_db.select(_db.contentScopesTable)
          ..where((tbl) => tbl.campaignId.equals(campaignId))
          ..where((tbl) => tbl.chapterId.isNull())
          ..where((tbl) => tbl.adventureId.isNull())
          ..where((tbl) => tbl.sceneId.isNull()))
        .watchSingleOrNull();
  }

  Future<ContentScopesTableData?> getOnlyByCampaignId(
    String campaignId,
  ) {
    return (_db.select(_db.contentScopesTable)
          ..where((tbl) => tbl.campaignId.equals(campaignId))
          ..where((tbl) => tbl.chapterId.isNull())
          ..where((tbl) => tbl.adventureId.isNull())
          ..where((tbl) => tbl.sceneId.isNull()))
        .getSingleOrNull();
  }

  Stream<List<ContentScopesTableData>> watchByChapterId(
    String chapterId,
  ) {
    return (_db.select(
      _db.contentScopesTable,
    )..where((tbl) => tbl.chapterId.equals(chapterId))).watch();
  }

  Future<List<ContentScopesTableData>> getByChapterId(String chapterId) {
    return (_db.select(
      _db.contentScopesTable,
    )..where((tbl) => tbl.chapterId.equals(chapterId))).get();
  }

  Stream<ContentScopesTableData?> watchOnlyByChapterId(
    String chapterId,
  ) {
    return (_db.select(_db.contentScopesTable)
          ..where((tbl) => tbl.chapterId.equals(chapterId))
          ..where((tbl) => tbl.adventureId.isNull())
          ..where((tbl) => tbl.sceneId.isNull()))
        .watchSingleOrNull();
  }

  Future<ContentScopesTableData?> getOnlyByChapterId(
    String chapterId,
  ) {
    return (_db.select(_db.contentScopesTable)
          ..where((tbl) => tbl.chapterId.equals(chapterId))
          ..where((tbl) => tbl.adventureId.isNull())
          ..where((tbl) => tbl.sceneId.isNull()))
        .getSingleOrNull();
  }

  Stream<List<ContentScopesTableData>> watchByAdventureId(
    String adventureId,
  ) {
    return (_db.select(_db.contentScopesTable)
          ..where((tbl) => tbl.adventureId.equals(adventureId)))
        .watch();
  }

  Future<List<ContentScopesTableData>> getByAdventureId(
    String adventureId,
  ) {
    return (_db.select(_db.contentScopesTable)
          ..where((tbl) => tbl.adventureId.equals(adventureId)))
        .get();
  }

  Stream<ContentScopesTableData?> watchOnlyByAdventureId(
    String adventureId,
  ) {
    return (_db.select(_db.contentScopesTable)
          ..where((tbl) => tbl.adventureId.equals(adventureId))
          ..where((tbl) => tbl.sceneId.isNull()))
        .watchSingleOrNull();
  }

  Future<ContentScopesTableData?> getOnlyByAdventureId(
    String adventureId,
  ) {
    return (_db.select(_db.contentScopesTable)
          ..where((tbl) => tbl.adventureId.equals(adventureId))
          ..where((tbl) => tbl.sceneId.isNull()))
        .getSingleOrNull();
  }

  Stream<ContentScopesTableData?> watchBySceneId(
    String sceneId,
  ) {
    return (_db.select(_db.contentScopesTable)
          ..where((tbl) => tbl.sceneId.equals(sceneId)))
        .watchSingleOrNull();
  }

  Future<ContentScopesTableData?> getBySceneId(
    String sceneId,
  ) {
    return (_db.select(_db.contentScopesTable)
          ..where((tbl) => tbl.sceneId.equals(sceneId)))
        .getSingleOrNull();
  }

  Future<int> add(ContentScopesTableData contentScope) {
    return _db.into(_db.contentScopesTable).insert(contentScope);
  }

  Future<bool> update(ContentScopesTableData contentScope) {
    return _db.update(_db.contentScopesTable).replace(contentScope);
  }

  Future<void> upsert(ContentScopesTableData contentScope) async {
    await _db.into(_db.contentScopesTable).insertOnConflictUpdate(contentScope);
  }

  Future<int> delete(ContentScopesTableData contentScope) {
    return _db.delete(_db.contentScopesTable).delete(contentScope);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(
      _db.contentScopesTable,
    )..where((t) => t.id.equals(id))).go();
  }
}

class ContentScopesNotifier
    extends StreamNotifier<List<ContentScopesTableData>> {
  @override
  Stream<List<ContentScopesTableData>> build() {
    return ref.watch(contentScopesRepositoryProvider).watchAll();
  }
}

final contentScopesProvider =
    StreamNotifierProvider<ContentScopesNotifier, List<ContentScopesTableData>>(
      ContentScopesNotifier.new,
    );

final contentScopesCommandsProvider =
    AsyncNotifierProvider<ContentScopesCommands, void>(
      ContentScopesCommands.new,
    );

class ContentScopesCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addContentScope(ContentScopesTableData contentScope) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(contentScopesRepositoryProvider).add(contentScope);
    });
  }

  Future<void> updateContentScope(ContentScopesTableData contentScope) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(contentScopesRepositoryProvider).update(contentScope);
    });
  }

  Future<void> upsertContentScope(ContentScopesTableData contentScope) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(contentScopesRepositoryProvider).upsert(contentScope);
    });
  }

  Future<void> deleteContentScope(ContentScopesTableData contentScope) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(contentScopesRepositoryProvider).delete(contentScope);
    });
  }

  Future<void> deleteContentScopeById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(contentScopesRepositoryProvider).deleteById(id);
    });
  }
}
