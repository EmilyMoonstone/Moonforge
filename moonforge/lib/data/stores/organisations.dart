import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final organisationsRepositoryProvider =
    Provider<OrganisationsRepository>((ref) {
  final db = ref.watch(driftDatabase);
  return OrganisationsRepository(db);
});

class OrganisationsRepository {
  OrganisationsRepository(this._db);

  final AppDatabase _db;

  Stream<List<OrganisationsTableData>> watchAll() {
    return _db.select(_db.organisationsTable).watch();
  }

  Future<int> add(OrganisationsTableData organisation) {
    return _db.into(_db.organisationsTable).insert(organisation);
  }

  Future<bool> update(OrganisationsTableData organisation) {
    return _db.update(_db.organisationsTable).replace(organisation);
  }

  Future<void> upsert(OrganisationsTableData organisation) async {
    await _db
        .into(_db.organisationsTable)
        .insertOnConflictUpdate(organisation);
  }

  Future<int> delete(OrganisationsTableData organisation) {
    return _db.delete(_db.organisationsTable).delete(organisation);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(_db.organisationsTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}

class OrganisationsNotifier
    extends StreamNotifier<List<OrganisationsTableData>> {
  @override
  Stream<List<OrganisationsTableData>> build() {
    return ref.watch(organisationsRepositoryProvider).watchAll();
  }
}

final organisationsProvider = StreamNotifierProvider<OrganisationsNotifier,
    List<OrganisationsTableData>>(
  OrganisationsNotifier.new,
);

final organisationsCommandsProvider =
    AsyncNotifierProvider<OrganisationsCommands, void>(
  OrganisationsCommands.new,
);

class OrganisationsCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addOrganisation(OrganisationsTableData organisation) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(organisationsRepositoryProvider).add(organisation);
    });
  }

  Future<void> updateOrganisation(OrganisationsTableData organisation) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(organisationsRepositoryProvider).update(organisation);
    });
  }

  Future<void> upsertOrganisation(OrganisationsTableData organisation) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(organisationsRepositoryProvider).upsert(organisation);
    });
  }

  Future<void> deleteOrganisation(OrganisationsTableData organisation) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(organisationsRepositoryProvider).delete(organisation);
    });
  }

  Future<void> deleteOrganisationById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(organisationsRepositoryProvider).deleteById(id);
    });
  }
}
