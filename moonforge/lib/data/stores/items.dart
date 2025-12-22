import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final itemsRepositoryProvider = Provider<ItemsRepository>((ref) {
  final db = ref.watch(driftDatabase);
  return ItemsRepository(db);
});

class ItemsRepository {
  ItemsRepository(this._db);

  final AppDatabase _db;

  Stream<List<ItemsTableData>> watchAll() {
    return _db.select(_db.itemsTable).watch();
  }

  Stream<List<ItemsTableData>> watchByCampaignId(String campaignId) {
    return (_db.select(
      _db.itemsTable,
    )..where((tbl) => tbl.campaignId.equals(campaignId))).watch();
  }

  Stream<List<ItemsTableData>> watchByScopes(List<String> scopeIds) {
    return (_db.select(_db.itemsTable)
          ..where((tbl) => tbl.scopeId.isIn(scopeIds)))
        .watch();
  }

  Stream<List<ItemsWithScope>> watchWithScopes() {
    return _db.select(_db.itemsWithScopes).watch();
  }

  Future<int> add(ItemsTableData item) {
    return _db.into(_db.itemsTable).insert(item);
  }

  Future<bool> update(ItemsTableData item) {
    return _db.update(_db.itemsTable).replace(item);
  }

  Future<void> upsert(ItemsTableData item) async {
    await _db.into(_db.itemsTable).insertOnConflictUpdate(item);
  }

  Future<int> delete(ItemsTableData item) {
    return _db.delete(_db.itemsTable).delete(item);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(_db.itemsTable)..where((t) => t.id.equals(id))).go();
  }
}

class ItemsNotifier extends StreamNotifier<List<ItemsTableData>> {
  @override
  Stream<List<ItemsTableData>> build() {
    return ref.watch(itemsRepositoryProvider).watchAll();
  }
}

final itemsProvider =
    StreamNotifierProvider<ItemsNotifier, List<ItemsTableData>>(
      ItemsNotifier.new,
    );

final itemsCommandsProvider = AsyncNotifierProvider<ItemsCommands, void>(
  ItemsCommands.new,
);

class ItemsCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addItem(ItemsTableData item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(itemsRepositoryProvider).add(item);
    });
  }

  Future<void> updateItem(ItemsTableData item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(itemsRepositoryProvider).update(item);
    });
  }

  Future<void> upsertItem(ItemsTableData item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(itemsRepositoryProvider).upsert(item);
    });
  }

  Future<void> deleteItem(ItemsTableData item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(itemsRepositoryProvider).delete(item);
    });
  }

  Future<void> deleteItemById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(itemsRepositoryProvider).deleteById(id);
    });
  }
}
