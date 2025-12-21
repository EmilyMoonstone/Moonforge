import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final campaignAccessRepositoryProvider = Provider<CampaignAccessRepository>((ref) {
  final db = ref.watch(driftDatabase);
  return CampaignAccessRepository(db);
});

class CampaignAccessRepository {
  CampaignAccessRepository(this._db);

  final AppDatabase _db;

  Stream<List<CampaignAccessTableData>> watchAll() {
    return _db.select(_db.campaignAccessTable).watch();
  }

  Future<int> add(CampaignAccessTableData campaignAccess) {
    return _db.into(_db.campaignAccessTable).insert(campaignAccess);
  }

  Future<bool> update(CampaignAccessTableData campaignAccess) {
    return _db.update(_db.campaignAccessTable).replace(campaignAccess);
  }

  Future<void> upsert(CampaignAccessTableData campaignAccess) async {
    await _db.into(_db.campaignAccessTable).insertOnConflictUpdate(
          campaignAccess,
        );
  }

  Future<int> delete(CampaignAccessTableData campaignAccess) {
    return _db.delete(_db.campaignAccessTable).delete(campaignAccess);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(_db.campaignAccessTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}

class CampaignAccessNotifier
    extends StreamNotifier<List<CampaignAccessTableData>> {
  @override
  Stream<List<CampaignAccessTableData>> build() {
    return ref.watch(campaignAccessRepositoryProvider).watchAll();
  }
}

final campaignAccessProvider = StreamNotifierProvider<CampaignAccessNotifier,
    List<CampaignAccessTableData>>(
  CampaignAccessNotifier.new,
);

final campaignAccessCommandsProvider =
    AsyncNotifierProvider<CampaignAccessCommands, void>(
  CampaignAccessCommands.new,
);

class CampaignAccessCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addCampaignAccess(CampaignAccessTableData campaignAccess) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(campaignAccessRepositoryProvider).add(campaignAccess);
    });
  }

  Future<void> updateCampaignAccess(
    CampaignAccessTableData campaignAccess,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(campaignAccessRepositoryProvider).update(campaignAccess);
    });
  }

  Future<void> upsertCampaignAccess(
    CampaignAccessTableData campaignAccess,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(campaignAccessRepositoryProvider).upsert(campaignAccess);
    });
  }

  Future<void> deleteCampaignAccess(CampaignAccessTableData campaignAccess) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(campaignAccessRepositoryProvider).delete(campaignAccess);
    });
  }

  Future<void> deleteCampaignAccessById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(campaignAccessRepositoryProvider).deleteById(id);
    });
  }
}
