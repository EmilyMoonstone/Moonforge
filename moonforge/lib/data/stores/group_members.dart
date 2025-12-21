import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final groupMembersRepositoryProvider = Provider<GroupMembersRepository>((ref) {
  final db = ref.watch(driftDatabase);
  return GroupMembersRepository(db);
});

class GroupMembersRepository {
  GroupMembersRepository(this._db);

  final AppDatabase _db;

  Stream<List<GroupMembersTableData>> watchAll() {
    return _db.select(_db.groupMembersTable).watch();
  }

  Future<int> add(GroupMembersTableData groupMember) {
    return _db.into(_db.groupMembersTable).insert(groupMember);
  }

  Future<bool> update(GroupMembersTableData groupMember) {
    return _db.update(_db.groupMembersTable).replace(groupMember);
  }

  Future<void> upsert(GroupMembersTableData groupMember) async {
    await _db.into(_db.groupMembersTable).insertOnConflictUpdate(groupMember);
  }

  Future<int> delete(GroupMembersTableData groupMember) {
    return _db.delete(_db.groupMembersTable).delete(groupMember);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(_db.groupMembersTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}

class GroupMembersNotifier extends StreamNotifier<List<GroupMembersTableData>> {
  @override
  Stream<List<GroupMembersTableData>> build() {
    return ref.watch(groupMembersRepositoryProvider).watchAll();
  }
}

final groupMembersProvider =
    StreamNotifierProvider<GroupMembersNotifier, List<GroupMembersTableData>>(
      GroupMembersNotifier.new,
    );

final groupMembersCommandsProvider =
    AsyncNotifierProvider<GroupMembersCommands, void>(
      GroupMembersCommands.new,
    );

class GroupMembersCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addGroupMember(GroupMembersTableData groupMember) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(groupMembersRepositoryProvider).add(groupMember);
    });
  }

  Future<void> updateGroupMember(GroupMembersTableData groupMember) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(groupMembersRepositoryProvider).update(groupMember);
    });
  }

  Future<void> upsertGroupMember(GroupMembersTableData groupMember) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(groupMembersRepositoryProvider).upsert(groupMember);
    });
  }

  Future<void> deleteGroupMember(GroupMembersTableData groupMember) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(groupMembersRepositoryProvider).delete(groupMember);
    });
  }

  Future<void> deleteGroupMemberById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(groupMembersRepositoryProvider).deleteById(id);
    });
  }
}
