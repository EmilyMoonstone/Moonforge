import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

/// Repository (all DB operations live here)
final campaignRepositoryProvider = Provider<CampaignRepository>((ref) {
  final db = ref.watch(driftDatabase);
  return CampaignRepository(db);
});

class CampaignRepository {
  CampaignRepository(this._db);

  final AppDatabase _db;

  Stream<List<CampaignsTableData>> watchAll() {
    return _db.select(_db.campaignsTable).watch();
  }

  Future<CampaignsTableData?> getById(String id) async {
    return (_db.select(_db.campaignsTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> add(CampaignsTableData campaign) {
    return _db.into(_db.campaignsTable).insert(campaign);
  }

  Future<bool> update(CampaignsTableData campaign) {
    return _db.update(_db.campaignsTable).replace(campaign);
  }

  Future<void> upsert(CampaignsTableData campaign) async {
    await _db.into(_db.campaignsTable).insertOnConflictUpdate(campaign);
  }

  Future<int> delete(CampaignsTableData campaign) {
    return _db.delete(_db.campaignsTable).delete(campaign);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(_db.campaignsTable)..where((t) => t.id.equals(id))).go();
  }
}

/// Read side: streams all campaigns
class CampaignNotifier extends StreamNotifier<List<CampaignsTableData>> {
  @override
  Stream<List<CampaignsTableData>> build() {
    return ref.watch(campaignRepositoryProvider).watchAll();
  }
}

final campaignProvider =
    StreamNotifierProvider<CampaignNotifier, List<CampaignsTableData>>(
      CampaignNotifier.new,
    );

/// Write side: exposes mutations + gives loading/error state to the UI
final campaignCommandsProvider = AsyncNotifierProvider<CampaignCommands, void>(
  CampaignCommands.new,
);

class CampaignCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addCampaign(CampaignsTableData campaign) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(campaignRepositoryProvider).add(campaign);
    });
  }

  Future<void> updateCampaign(CampaignsTableData campaign) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(campaignRepositoryProvider).update(campaign);
    });
  }

  Future<void> upsertCampaign(CampaignsTableData campaign) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(campaignRepositoryProvider).upsert(campaign);
    });
  }

  Future<void> deleteCampaign(CampaignsTableData campaign) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(campaignRepositoryProvider).delete(campaign);
    });
  }

  Future<void> deleteCampaignById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(campaignRepositoryProvider).deleteById(id);
    });
  }
}

/*
USAGE:

// Watch list
final campaigns = ref.watch(campaignProvider);

// Call DB ops
// import 'package:moonforge/core/providers/ref_extensions.dart';
ref.addCampaign(campaign);
ref.updateCampaign(campaign);
ref.deleteCampaignById(id);

// Show loading/error for writes
final writeState = ref.watch(campaignCommandsProvider);
*/
