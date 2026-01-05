import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final organizationsRepositoryProvider = Provider<OrganizationsRepository>((
  ref,
) {
  final db = ref.watch(driftDatabase);
  return OrganizationsRepository(db);
});

class OrganizationsRepository {
  OrganizationsRepository(this._db);

  final AppDatabase _db;

  Stream<List<OrganizationsTableData>> watchAll() {
    return _db.select(_db.organizationsTable).watch();
  }

  Stream<List<OrganizationsTableData>> watchByCampaignId(String campaignId) {
    return (_db.select(
      _db.organizationsTable,
    )..where((tbl) => tbl.campaignId.equals(campaignId))).watch();
  }

  Stream<List<OrganizationsTableData>> watchByScopes(List<String> scopeIds) {
    return (_db.select(
      _db.organizationsTable,
    )..where((tbl) => tbl.scopeId.isIn(scopeIds))).watch();
  }

  Stream<List<OrganizationsWithScope>> watchWithScopes() {
    return _db.select(_db.organizationsWithScopes).watch();
  }

  Future<int> add(OrganizationsTableData organization) {
    return _db.into(_db.organizationsTable).insert(organization);
  }

  Future<bool> update(OrganizationsTableData organization) {
    return _db.update(_db.organizationsTable).replace(organization);
  }

  Future<void> upsert(OrganizationsTableData organization) async {
    await _db.into(_db.organizationsTable).insertOnConflictUpdate(organization);
  }

  Future<int> delete(OrganizationsTableData organization) {
    return _db.delete(_db.organizationsTable).delete(organization);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(
      _db.organizationsTable,
    )..where((t) => t.id.equals(id))).go();
  }
}

class OrganizationsNotifier
    extends StreamNotifier<List<OrganizationsTableData>> {
  @override
  Stream<List<OrganizationsTableData>> build() {
    return ref.watch(organizationsRepositoryProvider).watchAll();
  }
}

final organizationsProvider =
    StreamNotifierProvider<OrganizationsNotifier, List<OrganizationsTableData>>(
      OrganizationsNotifier.new,
    );

final organizationsCommandsProvider =
    AsyncNotifierProvider<OrganizationsCommands, void>(
      OrganizationsCommands.new,
    );

class OrganizationsCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addOrganization(OrganizationsTableData organization) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(organizationsRepositoryProvider).add(organization);
    });
  }

  Future<void> updateOrganization(OrganizationsTableData organization) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(organizationsRepositoryProvider).update(organization);
    });
  }

  Future<void> upsertOrganization(OrganizationsTableData organization) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(organizationsRepositoryProvider).upsert(organization);
    });
  }

  Future<void> deleteOrganization(OrganizationsTableData organization) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(organizationsRepositoryProvider).delete(organization);
    });
  }

  Future<void> deleteOrganizationById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(organizationsRepositoryProvider).deleteById(id);
    });
  }
}
