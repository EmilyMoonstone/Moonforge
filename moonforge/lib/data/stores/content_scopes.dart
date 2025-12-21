import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final contentScopesRepositoryProvider = Provider<ContentScopesRepository>((ref) {
  final db = ref.watch(driftDatabase);
  return ContentScopesRepository(db);
});

class ContentScopesRepository {
  ContentScopesRepository(this._db);

  final AppDatabase _db;

  Stream<List<ContentScopesTableData>> watchAll() {
    return _db.select(_db.contentScopesTable).watch();
  }

  Future<int> add(ContentScopesTableData contentScope) {
    return _db.into(_db.contentScopesTable).insert(contentScope);
  }

  Future<bool> update(ContentScopesTableData contentScope) {
    return _db.update(_db.contentScopesTable).replace(contentScope);
  }

  Future<void> upsert(ContentScopesTableData contentScope) async {
    await _db
        .into(_db.contentScopesTable)
        .insertOnConflictUpdate(contentScope);
  }

  Future<int> delete(ContentScopesTableData contentScope) {
    return _db.delete(_db.contentScopesTable).delete(contentScope);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(_db.contentScopesTable)
          ..where((t) => t.id.equals(id)))
        .go();
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
