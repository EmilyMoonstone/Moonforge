import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final groupsRepositoryProvider = Provider<GroupsRepository>((ref) {
  final db = ref.watch(driftDatabase);
  return GroupsRepository(db);
});

class GroupsRepository {
  GroupsRepository(this._db);

  final AppDatabase _db;

  Stream<List<GroupsTableData>> watchAll() {
    return _db.select(_db.groupsTable).watch();
  }

  Future<int> add(GroupsTableData group) {
    return _db.into(_db.groupsTable).insert(group);
  }

  Future<bool> update(GroupsTableData group) {
    return _db.update(_db.groupsTable).replace(group);
  }

  Future<void> upsert(GroupsTableData group) async {
    await _db.into(_db.groupsTable).insertOnConflictUpdate(group);
  }

  Future<int> delete(GroupsTableData group) {
    return _db.delete(_db.groupsTable).delete(group);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(_db.groupsTable)..where((t) => t.id.equals(id))).go();
  }
}

class GroupsNotifier extends StreamNotifier<List<GroupsTableData>> {
  @override
  Stream<List<GroupsTableData>> build() {
    return ref.watch(groupsRepositoryProvider).watchAll();
  }
}

final groupsProvider =
    StreamNotifierProvider<GroupsNotifier, List<GroupsTableData>>(
      GroupsNotifier.new,
    );

final groupsCommandsProvider = AsyncNotifierProvider<GroupsCommands, void>(
  GroupsCommands.new,
);

class GroupsCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addGroup(GroupsTableData group) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(groupsRepositoryProvider).add(group);
    });
  }

  Future<void> updateGroup(GroupsTableData group) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(groupsRepositoryProvider).update(group);
    });
  }

  Future<void> upsertGroup(GroupsTableData group) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(groupsRepositoryProvider).upsert(group);
    });
  }

  Future<void> deleteGroup(GroupsTableData group) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(groupsRepositoryProvider).delete(group);
    });
  }

  Future<void> deleteGroupById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(groupsRepositoryProvider).deleteById(id);
    });
  }
}
