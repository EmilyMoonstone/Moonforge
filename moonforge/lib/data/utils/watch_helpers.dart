import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/providers/campaign.dart';
import 'package:moonforge/data/database.dart';
import 'package:moonforge/data/ref_extensions.dart';
import 'package:moonforge/data/stores/stores.dart';
import 'package:stream_transform/stream_transform.dart';

Stream<CampaignsTableData?> watchCurrentCampaign(WidgetRef ref) {
  final campaignId = ref.watch(currentCampaignIdProvider);
  if (campaignId == null) {
    return Stream.value(null);
  }

  return ref
      .watch(campaignRepositoryProvider)
      .watchAll()
      .map((campaigns) => _findCampaign(campaigns, campaignId));
}

Stream<List<ChaptersTableData>> watchChaptersOfCampaign(WidgetRef ref) {
  final campaignId = ref.watch(currentCampaignIdProvider);
  if (campaignId == null) {
    return Stream.value(const <ChaptersTableData>[]);
  }

  return ref.watch(chaptersRepositoryProvider).watchByCampaignId(campaignId);
}

Stream<ChaptersTableData?> watchChapter(WidgetRef ref, String chapterId) {
  return ref
      .watch(chaptersRepositoryProvider)
      .watchAll()
      .map((chapters) => _findChapter(chapters, chapterId));
}

Stream<List<AdventuresTableData>> watchAdventuresOfCampaign(WidgetRef ref) {
  final campaignId = ref.watch(currentCampaignIdProvider);
  if (campaignId == null) {
    return Stream.value(const <AdventuresTableData>[]);
  }

  return ref
      .watch(adventuresRepositoryProvider)
      .watchAll()
      .map(
        (adventures) => adventures
            .where((adventure) => adventure.campaignId == campaignId)
            .toList(),
      );
}

Stream<List<AdventuresTableData>> watchAdventuresOfChapter(
  WidgetRef ref,
  String chapterId,
) {
  return ref.watch(adventuresRepositoryProvider).watchByChapterId(chapterId);
}

Stream<AdventuresTableData?> watchAdventure(WidgetRef ref, String adventureId) {
  return ref
      .watch(adventuresRepositoryProvider)
      .watchAll()
      .map((adventures) => _findAdventure(adventures, adventureId));
}

Stream<List<ScenesTableData>> watchScenesOfCampaign(WidgetRef ref) {
  final campaignId = ref.watch(currentCampaignIdProvider);
  if (campaignId == null) {
    return Stream.value(const <ScenesTableData>[]);
  }

  return ref
      .watch(scenesRepositoryProvider)
      .watchAll()
      .map(
        (scenes) => scenes
            .where((scene) => scene.campaignId == campaignId)
            .toList(),
      );
}

Stream<List<ScenesTableData>> watchScenesOfChapter(WidgetRef ref, String chapterId) {
  final adventuresStream =
      ref.watch(adventuresRepositoryProvider).watchByChapterId(chapterId);
  final scenesStream = ref.watch(scenesRepositoryProvider).watchAll();

  return adventuresStream.combineLatest(
    scenesStream,
    (adventures, scenes) {
      if (adventures.isEmpty) {
        return const <ScenesTableData>[];
      }

      final adventureIds = adventures.map((adventure) => adventure.id).toSet();
      return scenes
          .where((scene) => adventureIds.contains(scene.adventureId))
          .toList();
    },
  );
}

Stream<List<ScenesTableData>> watchScenesOfAdventure(
  WidgetRef ref,
  String adventureId,
) {
  return ref
      .watch(scenesRepositoryProvider)
      .watchAll()
      .map(
        (scenes) => scenes
            .where((scene) => scene.adventureId == adventureId)
            .toList(),
      );
}

Stream<ScenesTableData?> watchScene(WidgetRef ref, String sceneId) {
  return ref
      .watch(scenesRepositoryProvider)
      .watchAll()
      .map((scenes) => _findScene(scenes, sceneId));
}

Stream<List<CreaturesTableData>> watchCreaturesOfCampaign(WidgetRef ref) {
  final campaignId = ref.watch(currentCampaignIdProvider);
  if (campaignId == null) {
    return Stream.value(const <CreaturesTableData>[]);
  }

  return ref
      .watch(creaturesRepositoryProvider)
      .watchByCampaignId(campaignId);
}

Stream<List<CreaturesTableData>> watchCreaturesOfChapter(
  WidgetRef ref,
  String chapterId,
) {
  return ref.watchByScopes(
    chapterId: chapterId,
    watchByScopes: (scopeIds) =>
        ref.watch(creaturesRepositoryProvider).watchByScopes(scopeIds),
  );
}

Stream<List<CreaturesTableData>> watchCreaturesOfAdventure(
  WidgetRef ref,
  String adventureId,
) {
  return ref.watchByScopes(
    adventureId: adventureId,
    watchByScopes: (scopeIds) =>
        ref.watch(creaturesRepositoryProvider).watchByScopes(scopeIds),
  );
}

Stream<List<CreaturesTableData>> watchCreaturesOfScene(
  WidgetRef ref,
  String sceneId,
) {
  return ref.watchByScopes(
    sceneId: sceneId,
    watchByScopes: (scopeIds) =>
        ref.watch(creaturesRepositoryProvider).watchByScopes(scopeIds),
  );
}

Stream<List<EncountersTableData>> watchEncountersOfCampaign(WidgetRef ref) {
  final campaignId = ref.watch(currentCampaignIdProvider);
  if (campaignId == null) {
    return Stream.value(const <EncountersTableData>[]);
  }

  return ref
      .watch(encountersRepositoryProvider)
      .watchByCampaignId(campaignId);
}

Stream<List<EncountersTableData>> watchEncountersOfChapter(
  WidgetRef ref,
  String chapterId,
) {
  return ref.watchByScopes(
    chapterId: chapterId,
    watchByScopes: (scopeIds) =>
        ref.watch(encountersRepositoryProvider).watchByScopes(scopeIds),
  );
}

Stream<List<EncountersTableData>> watchEncountersOfAdventure(
  WidgetRef ref,
  String adventureId,
) {
  return ref.watchByScopes(
    adventureId: adventureId,
    watchByScopes: (scopeIds) =>
        ref.watch(encountersRepositoryProvider).watchByScopes(scopeIds),
  );
}

Stream<List<EncountersTableData>> watchEncountersOfScene(
  WidgetRef ref,
  String sceneId,
) {
  return ref.watchByScopes(
    sceneId: sceneId,
    watchByScopes: (scopeIds) =>
        ref.watch(encountersRepositoryProvider).watchByScopes(scopeIds),
  );
}

Stream<List<ItemsTableData>> watchItemsOfCampaign(WidgetRef ref) {
  final campaignId = ref.watch(currentCampaignIdProvider);
  if (campaignId == null) {
    return Stream.value(const <ItemsTableData>[]);
  }

  return ref.watch(itemsRepositoryProvider).watchByCampaignId(campaignId);
}

Stream<List<ItemsTableData>> watchItemsOfChapter(WidgetRef ref, String chapterId) {
  return ref.watchByScopes(
    chapterId: chapterId,
    watchByScopes: (scopeIds) =>
        ref.watch(itemsRepositoryProvider).watchByScopes(scopeIds),
  );
}

Stream<List<ItemsTableData>> watchItemsOfAdventure(
  WidgetRef ref,
  String adventureId,
) {
  return ref.watchByScopes(
    adventureId: adventureId,
    watchByScopes: (scopeIds) =>
        ref.watch(itemsRepositoryProvider).watchByScopes(scopeIds),
  );
}

Stream<List<ItemsTableData>> watchItemsOfScene(WidgetRef ref, String sceneId) {
  return ref.watchByScopes(
    sceneId: sceneId,
    watchByScopes: (scopeIds) =>
        ref.watch(itemsRepositoryProvider).watchByScopes(scopeIds),
  );
}

Stream<List<LocationsTableData>> watchLocationsOfCampaign(WidgetRef ref) {
  final campaignId = ref.watch(currentCampaignIdProvider);
  if (campaignId == null) {
    return Stream.value(const <LocationsTableData>[]);
  }

  return ref
      .watch(locationsRepositoryProvider)
      .watchAll()
      .map(
        (locations) => locations
            .where((location) => location.campaignId == campaignId)
            .toList(),
      );
}

Stream<List<LocationsTableData>> watchLocationsOfChapter(
  WidgetRef ref,
  String chapterId,
) {
  return ref.watchByScopes(
    chapterId: chapterId,
    watchByScopes: (scopeIds) =>
        ref.watch(locationsRepositoryProvider).watchByScopes(scopeIds),
  );
}

Stream<List<LocationsTableData>> watchLocationsOfAdventure(
  WidgetRef ref,
  String adventureId,
) {
  return ref.watchByScopes(
    adventureId: adventureId,
    watchByScopes: (scopeIds) =>
        ref.watch(locationsRepositoryProvider).watchByScopes(scopeIds),
  );
}

Stream<List<LocationsTableData>> watchLocationsOfScene(
  WidgetRef ref,
  String sceneId,
) {
  return ref.watchByScopes(
    sceneId: sceneId,
    watchByScopes: (scopeIds) =>
        ref.watch(locationsRepositoryProvider).watchByScopes(scopeIds),
  );
}

Stream<List<MapsTableData>> watchMapsOfCampaign(WidgetRef ref) {
  final campaignId = ref.watch(currentCampaignIdProvider);
  if (campaignId == null) {
    return Stream.value(const <MapsTableData>[]);
  }

  return ref.watch(mapsRepositoryProvider).watchByCampaignId(campaignId);
}

Stream<List<OrganizationsTableData>> watchOrganizationsOfCampaign(WidgetRef ref) {
  final campaignId = ref.watch(currentCampaignIdProvider);
  if (campaignId == null) {
    return Stream.value(const <OrganizationsTableData>[]);
  }

  return ref
      .watch(organizationsRepositoryProvider)
      .watchByCampaignId(campaignId);
}

Stream<List<OrganizationsTableData>> watchOrganizationsOfChapter(
  WidgetRef ref,
  String chapterId,
) {
  return ref.watchByScopes(
    chapterId: chapterId,
    watchByScopes: (scopeIds) =>
        ref.watch(organizationsRepositoryProvider).watchByScopes(scopeIds),
  );
}

Stream<List<OrganizationsTableData>> watchOrganizationsOfAdventure(
  WidgetRef ref,
  String adventureId,
) {
  return ref.watchByScopes(
    adventureId: adventureId,
    watchByScopes: (scopeIds) =>
        ref.watch(organizationsRepositoryProvider).watchByScopes(scopeIds),
  );
}

Stream<List<OrganizationsTableData>> watchOrganizationsOfScene(
  WidgetRef ref,
  String sceneId,
) {
  return ref.watchByScopes(
    sceneId: sceneId,
    watchByScopes: (scopeIds) =>
        ref.watch(organizationsRepositoryProvider).watchByScopes(scopeIds),
  );
}

CampaignsTableData? _findCampaign(
  List<CampaignsTableData> campaigns,
  String campaignId,
) {
  for (final campaign in campaigns) {
    if (campaign.id == campaignId) {
      return campaign;
    }
  }
  return null;
}

ChaptersTableData? _findChapter(
  List<ChaptersTableData> chapters,
  String chapterId,
) {
  for (final chapter in chapters) {
    if (chapter.id == chapterId) {
      return chapter;
    }
  }
  return null;
}

AdventuresTableData? _findAdventure(
  List<AdventuresTableData> adventures,
  String adventureId,
) {
  for (final adventure in adventures) {
    if (adventure.id == adventureId) {
      return adventure;
    }
  }
  return null;
}

ScenesTableData? _findScene(List<ScenesTableData> scenes, String sceneId) {
  for (final scene in scenes) {
    if (scene.id == sceneId) {
      return scene;
    }
  }
  return null;
}
