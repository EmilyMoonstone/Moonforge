import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final playingCampaignsRepositoryProvider = Provider<PlayingCampaignsRepository>(
  (ref) {
    final db = ref.watch(driftDatabase);
    return PlayingCampaignsRepository(db);
  },
);

class PlayingCampaignsRepository {
  PlayingCampaignsRepository(this._db);

  final AppDatabase _db;

  Stream<List<PlayingCampaignsTableData>> watchAll() {
    return _db.select(_db.playingCampaignsTable).watch();
  }

  Future<int> add(PlayingCampaignsTableData playingCampaign) {
    return _db.into(_db.playingCampaignsTable).insert(playingCampaign);
  }

  Future<bool> update(PlayingCampaignsTableData playingCampaign) {
    return _db.update(_db.playingCampaignsTable).replace(playingCampaign);
  }

  Future<void> upsert(PlayingCampaignsTableData playingCampaign) async {
    await _db
        .into(_db.playingCampaignsTable)
        .insertOnConflictUpdate(playingCampaign);
  }

  Future<int> delete(PlayingCampaignsTableData playingCampaign) {
    return _db.delete(_db.playingCampaignsTable).delete(playingCampaign);
  }
}

class PlayingCampaignsNotifier
    extends StreamNotifier<List<PlayingCampaignsTableData>> {
  @override
  Stream<List<PlayingCampaignsTableData>> build() {
    return ref.watch(playingCampaignsRepositoryProvider).watchAll();
  }
}

final playingCampaignsProvider =
    StreamNotifierProvider<
      PlayingCampaignsNotifier,
      List<PlayingCampaignsTableData>
    >(PlayingCampaignsNotifier.new);

final playingCampaignsCommandsProvider =
    AsyncNotifierProvider<PlayingCampaignsCommands, void>(
      PlayingCampaignsCommands.new,
    );

class PlayingCampaignsCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addPlayingCampaign(
    PlayingCampaignsTableData playingCampaign,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(playingCampaignsRepositoryProvider).add(playingCampaign);
    });
  }

  Future<void> updatePlayingCampaign(
    PlayingCampaignsTableData playingCampaign,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(playingCampaignsRepositoryProvider)
          .update(playingCampaign);
    });
  }

  Future<void> upsertPlayingCampaign(
    PlayingCampaignsTableData playingCampaign,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(playingCampaignsRepositoryProvider)
          .upsert(playingCampaign);
    });
  }

  Future<void> deletePlayingCampaign(
    PlayingCampaignsTableData playingCampaign,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(playingCampaignsRepositoryProvider)
          .delete(playingCampaign);
    });
  }
}
