import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';
import 'package:moonforge/data/stores/adventures.dart';
import 'package:moonforge/data/stores/campaign.dart';
import 'package:moonforge/data/stores/campaign_access.dart';
import 'package:moonforge/data/stores/chapters.dart';
import 'package:moonforge/data/stores/characters.dart';
import 'package:moonforge/data/stores/content_scopes.dart';
import 'package:moonforge/data/stores/creatures.dart';
import 'package:moonforge/data/stores/encounter_creatures.dart';
import 'package:moonforge/data/stores/encounters.dart';
import 'package:moonforge/data/stores/group_members.dart';
import 'package:moonforge/data/stores/groups.dart';
import 'package:moonforge/data/stores/items.dart';
import 'package:moonforge/data/stores/locations.dart';
import 'package:moonforge/data/stores/maps.dart';
import 'package:moonforge/data/stores/organizations.dart';
import 'package:moonforge/data/stores/playing_campaigns.dart';
import 'package:moonforge/data/stores/scenes.dart';
import 'package:moonforge/data/stores/session_logs.dart';
import 'package:moonforge/data/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Stream<List<T>> _watchByScopesInternal<T>(
  Future<Iterable<ContentScopesTableData>> scopeFuture,
  Stream<List<T>> Function(List<String> scopeIds) watchByScopes,
) async* {
  final scopes = await scopeFuture;
  final scopeIds = scopes.map((scope) => scope.id).toList();
  if (scopeIds.isEmpty) {
    yield <T>[];
    return;
  }

  yield* watchByScopes(scopeIds);
}

Future<Iterable<ContentScopesTableData>> _wrapSingleScopeFuture(
  Future<ContentScopesTableData?> scopeFuture,
) async {
  final scope = await scopeFuture;
  if (scope == null) {
    return const <ContentScopesTableData>[];
  }

  return <ContentScopesTableData>[scope];
}

extension AdventuresRef on WidgetRef {
  AdventuresRepository get adventuresRepository {
    return read(adventuresRepositoryProvider);
  }

  Future<void> addAdventure(AdventuresTableData adventure) {
    return read(adventuresCommandsProvider.notifier).addAdventure(adventure);
  }

  Future<void> updateAdventure(AdventuresTableData adventure) {
    return read(adventuresCommandsProvider.notifier).updateAdventure(adventure);
  }

  Future<void> upsertAdventure(AdventuresTableData adventure) {
    return read(adventuresCommandsProvider.notifier).upsertAdventure(adventure);
  }

  Future<void> deleteAdventure(AdventuresTableData adventure) {
    return read(adventuresCommandsProvider.notifier).deleteAdventure(adventure);
  }

  Future<void> deleteAdventureById(String id) {
    return read(adventuresCommandsProvider.notifier).deleteAdventureById(id);
  }
}

extension CampaignAccessRef on WidgetRef {
  CampaignAccessRepository get campaignAccessRepository {
    return read(campaignAccessRepositoryProvider);
  }

  Future<void> addCampaignAccess(CampaignAccessTableData campaignAccess) {
    return read(
      campaignAccessCommandsProvider.notifier,
    ).addCampaignAccess(campaignAccess);
  }

  Future<void> updateCampaignAccess(CampaignAccessTableData campaignAccess) {
    return read(
      campaignAccessCommandsProvider.notifier,
    ).updateCampaignAccess(campaignAccess);
  }

  Future<void> upsertCampaignAccess(CampaignAccessTableData campaignAccess) {
    return read(
      campaignAccessCommandsProvider.notifier,
    ).upsertCampaignAccess(campaignAccess);
  }

  Future<void> deleteCampaignAccess(CampaignAccessTableData campaignAccess) {
    return read(
      campaignAccessCommandsProvider.notifier,
    ).deleteCampaignAccess(campaignAccess);
  }

  Future<void> deleteCampaignAccessById(String id) {
    return read(
      campaignAccessCommandsProvider.notifier,
    ).deleteCampaignAccessById(id);
  }
}

extension CampaignRef on WidgetRef {
  CampaignRepository get campaignRepository {
    return read(campaignRepositoryProvider);
  }

  Future<CampaignsTableData?> getCampaignById(String id) {
    return read(campaignRepositoryProvider).getById(id);
  }

  Future<void> addCampaign(CampaignsTableData campaign) {
    return read(campaignCommandsProvider.notifier).addCampaign(campaign);
  }

  Future<void> updateCampaign(CampaignsTableData campaign) {
    return read(campaignCommandsProvider.notifier).updateCampaign(campaign);
  }

  Future<void> upsertCampaign(CampaignsTableData campaign) {
    return read(campaignCommandsProvider.notifier).upsertCampaign(campaign);
  }

  Future<void> deleteCampaign(CampaignsTableData campaign) {
    return read(campaignCommandsProvider.notifier).deleteCampaign(campaign);
  }

  Future<void> deleteCampaignById(String id) {
    return read(campaignCommandsProvider.notifier).deleteCampaignById(id);
  }
}

extension ChaptersRef on WidgetRef {
  ChaptersRepository get chaptersRepository {
    return read(chaptersRepositoryProvider);
  }

  Future<void> addChapter(ChaptersTableData chapter) {
    return read(chaptersCommandsProvider.notifier).addChapter(chapter);
  }

  Future<void> updateChapter(ChaptersTableData chapter) {
    return read(chaptersCommandsProvider.notifier).updateChapter(chapter);
  }

  Future<void> upsertChapter(ChaptersTableData chapter) {
    return read(chaptersCommandsProvider.notifier).upsertChapter(chapter);
  }

  Future<void> deleteChapter(ChaptersTableData chapter) {
    return read(chaptersCommandsProvider.notifier).deleteChapter(chapter);
  }

  Future<void> deleteChapterById(String id) {
    return read(chaptersCommandsProvider.notifier).deleteChapterById(id);
  }
}

extension CharactersRef on WidgetRef {
  CharactersRepository get charactersRepository {
    return read(charactersRepositoryProvider);
  }

  Future<void> addCharacter(CharactersTableData character) {
    return read(charactersCommandsProvider.notifier).addCharacter(character);
  }

  Future<void> updateCharacter(CharactersTableData character) {
    return read(charactersCommandsProvider.notifier).updateCharacter(character);
  }

  Future<void> upsertCharacter(CharactersTableData character) {
    return read(charactersCommandsProvider.notifier).upsertCharacter(character);
  }

  Future<void> deleteCharacter(CharactersTableData character) {
    return read(charactersCommandsProvider.notifier).deleteCharacter(character);
  }

  Future<void> deleteCharacterById(String id) {
    return read(charactersCommandsProvider.notifier).deleteCharacterById(id);
  }
}

extension ContentScopesRef on WidgetRef {
  ContentScopesRepository get contentScopesRepository {
    return read(contentScopesRepositoryProvider);
  }

  Future<void> addContentScope(ContentScopesTableData contentScope) {
    return read(
      contentScopesCommandsProvider.notifier,
    ).addContentScope(contentScope);
  }

  Future<void> updateContentScope(ContentScopesTableData contentScope) {
    return read(
      contentScopesCommandsProvider.notifier,
    ).updateContentScope(contentScope);
  }

  Future<void> upsertContentScope(ContentScopesTableData contentScope) {
    return read(
      contentScopesCommandsProvider.notifier,
    ).upsertContentScope(contentScope);
  }

  Future<void> deleteContentScope(ContentScopesTableData contentScope) {
    return read(
      contentScopesCommandsProvider.notifier,
    ).deleteContentScope(contentScope);
  }

  Future<void> deleteContentScopeById(String id) {
    return read(
      contentScopesCommandsProvider.notifier,
    ).deleteContentScopeById(id);
  }
}

extension ScopedStreamsRef on Ref {
  Stream<List<T>> watchByScopes<T>({
    String? campaignId,
    String? chapterId,
    String? adventureId,
    String? sceneId,
    required Stream<List<T>> Function(List<String> scopeIds) watchByScopes,
  }) {
    final providedScopeIds = [
      campaignId,
      chapterId,
      adventureId,
      sceneId,
    ].whereType<String>().toList();
    if (providedScopeIds.length != 1) {
      return Stream.error(ArgumentError('Provide exactly one scope id.'));
    }

    final scopeFuture = campaignId != null
        ? read(contentScopesRepositoryProvider).getByCampaignId(campaignId)
        : chapterId != null
        ? read(contentScopesRepositoryProvider).getByChapterId(chapterId)
        : adventureId != null
        ? read(contentScopesRepositoryProvider).getByAdventureId(adventureId)
        : _wrapSingleScopeFuture(
            read(contentScopesRepositoryProvider).getBySceneId(sceneId!),
          );

    return _watchByScopesInternal(scopeFuture, watchByScopes);
  }

  Stream<List<T>> watchByScopesOnly<T>({
    String? campaignId,
    String? chapterId,
    String? adventureId,
    String? sceneId,
    required Stream<List<T>> Function(List<String> scopeIds) watchByScopes,
  }) {
    final providedScopeIds = [
      campaignId,
      chapterId,
      adventureId,
      sceneId,
    ].whereType<String>().toList();
    if (providedScopeIds.length != 1) {
      return Stream.error(ArgumentError('Provide exactly one scope id.'));
    }

    final scopeFuture = campaignId != null
        ? _wrapSingleScopeFuture(
            read(
              contentScopesRepositoryProvider,
            ).getOnlyByCampaignId(campaignId),
          )
        : chapterId != null
        ? _wrapSingleScopeFuture(
            read(
              contentScopesRepositoryProvider,
            ).getOnlyByChapterId(chapterId),
          )
        : adventureId != null
        ? _wrapSingleScopeFuture(
            read(
              contentScopesRepositoryProvider,
            ).getOnlyByAdventureId(adventureId),
          )
        : _wrapSingleScopeFuture(
            read(contentScopesRepositoryProvider).getBySceneId(sceneId!),
          );

    return _watchByScopesInternal(scopeFuture, watchByScopes);
  }
}

extension ScopedStreamsWidgetRef on WidgetRef {
  Stream<List<T>> watchByScopes<T>({
    String? campaignId,
    String? chapterId,
    String? adventureId,
    String? sceneId,
    required Stream<List<T>> Function(List<String> scopeIds) watchByScopes,
  }) {
    final providedScopeIds = [
      campaignId,
      chapterId,
      adventureId,
      sceneId,
    ].whereType<String>().toList();
    if (providedScopeIds.length != 1) {
      return Stream.error(ArgumentError('Provide exactly one scope id.'));
    }

    final scopeFuture = campaignId != null
        ? read(contentScopesRepositoryProvider).getByCampaignId(campaignId)
        : chapterId != null
        ? read(contentScopesRepositoryProvider).getByChapterId(chapterId)
        : adventureId != null
        ? read(contentScopesRepositoryProvider).getByAdventureId(adventureId)
        : _wrapSingleScopeFuture(
            read(contentScopesRepositoryProvider).getBySceneId(sceneId!),
          );

    return _watchByScopesInternal(scopeFuture, watchByScopes);
  }

  Stream<List<T>> watchByScopesOnly<T>({
    String? campaignId,
    String? chapterId,
    String? adventureId,
    String? sceneId,
    required Stream<List<T>> Function(List<String> scopeIds) watchByScopes,
  }) {
    final providedScopeIds = [
      campaignId,
      chapterId,
      adventureId,
      sceneId,
    ].whereType<String>().toList();
    if (providedScopeIds.length != 1) {
      return Stream.error(ArgumentError('Provide exactly one scope id.'));
    }

    final scopeFuture = campaignId != null
        ? _wrapSingleScopeFuture(
            read(
              contentScopesRepositoryProvider,
            ).getOnlyByCampaignId(campaignId),
          )
        : chapterId != null
        ? _wrapSingleScopeFuture(
            read(
              contentScopesRepositoryProvider,
            ).getOnlyByChapterId(chapterId),
          )
        : adventureId != null
        ? _wrapSingleScopeFuture(
            read(
              contentScopesRepositoryProvider,
            ).getOnlyByAdventureId(adventureId),
          )
        : _wrapSingleScopeFuture(
            read(contentScopesRepositoryProvider).getBySceneId(sceneId!),
          );

    return _watchByScopesInternal(scopeFuture, watchByScopes);
  }

}

extension CreaturesRef on WidgetRef {
  CreaturesRepository get creaturesRepository {
    return read(creaturesRepositoryProvider);
  }

  Future<void> addCreature(CreaturesTableData creature) {
    return read(creaturesCommandsProvider.notifier).addCreature(creature);
  }

  Future<void> updateCreature(CreaturesTableData creature) {
    return read(creaturesCommandsProvider.notifier).updateCreature(creature);
  }

  Future<void> upsertCreature(CreaturesTableData creature) {
    return read(creaturesCommandsProvider.notifier).upsertCreature(creature);
  }

  Future<void> deleteCreature(CreaturesTableData creature) {
    return read(creaturesCommandsProvider.notifier).deleteCreature(creature);
  }

  Future<void> deleteCreatureById(String id) {
    return read(creaturesCommandsProvider.notifier).deleteCreatureById(id);
  }
}

extension EncounterCreaturesRef on WidgetRef {
  EncounterCreaturesRepository get encounterCreaturesRepository {
    return read(encounterCreaturesRepositoryProvider);
  }

  Future<void> addEncounterCreature(
    EncounterCreaturesTableData encounterCreature,
  ) {
    return read(
      encounterCreaturesCommandsProvider.notifier,
    ).addEncounterCreature(encounterCreature);
  }

  Future<void> updateEncounterCreature(
    EncounterCreaturesTableData encounterCreature,
  ) {
    return read(
      encounterCreaturesCommandsProvider.notifier,
    ).updateEncounterCreature(encounterCreature);
  }

  Future<void> upsertEncounterCreature(
    EncounterCreaturesTableData encounterCreature,
  ) {
    return read(
      encounterCreaturesCommandsProvider.notifier,
    ).upsertEncounterCreature(encounterCreature);
  }

  Future<void> deleteEncounterCreature(
    EncounterCreaturesTableData encounterCreature,
  ) {
    return read(
      encounterCreaturesCommandsProvider.notifier,
    ).deleteEncounterCreature(encounterCreature);
  }

  Future<void> deleteEncounterCreatureById(String id) {
    return read(
      encounterCreaturesCommandsProvider.notifier,
    ).deleteEncounterCreatureById(id);
  }
}

extension EncountersRef on WidgetRef {
  EncountersRepository get encountersRepository {
    return read(encountersRepositoryProvider);
  }

  Future<void> addEncounter(EncountersTableData encounter) {
    return read(encountersCommandsProvider.notifier).addEncounter(encounter);
  }

  Future<void> updateEncounter(EncountersTableData encounter) {
    return read(encountersCommandsProvider.notifier).updateEncounter(encounter);
  }

  Future<void> upsertEncounter(EncountersTableData encounter) {
    return read(encountersCommandsProvider.notifier).upsertEncounter(encounter);
  }

  Future<void> deleteEncounter(EncountersTableData encounter) {
    return read(encountersCommandsProvider.notifier).deleteEncounter(encounter);
  }

  Future<void> deleteEncounterById(String id) {
    return read(encountersCommandsProvider.notifier).deleteEncounterById(id);
  }
}

extension GroupMembersRef on WidgetRef {
  GroupMembersRepository get groupMembersRepository {
    return read(groupMembersRepositoryProvider);
  }

  Future<void> addGroupMember(GroupMembersTableData groupMember) {
    return read(
      groupMembersCommandsProvider.notifier,
    ).addGroupMember(groupMember);
  }

  Future<void> updateGroupMember(GroupMembersTableData groupMember) {
    return read(
      groupMembersCommandsProvider.notifier,
    ).updateGroupMember(groupMember);
  }

  Future<void> upsertGroupMember(GroupMembersTableData groupMember) {
    return read(
      groupMembersCommandsProvider.notifier,
    ).upsertGroupMember(groupMember);
  }

  Future<void> deleteGroupMember(GroupMembersTableData groupMember) {
    return read(
      groupMembersCommandsProvider.notifier,
    ).deleteGroupMember(groupMember);
  }

  Future<void> deleteGroupMemberById(String id) {
    return read(
      groupMembersCommandsProvider.notifier,
    ).deleteGroupMemberById(id);
  }
}

extension GroupsRef on WidgetRef {
  GroupsRepository get groupsRepository {
    return read(groupsRepositoryProvider);
  }

  Future<void> addGroup(GroupsTableData group) {
    return read(groupsCommandsProvider.notifier).addGroup(group);
  }

  Future<void> updateGroup(GroupsTableData group) {
    return read(groupsCommandsProvider.notifier).updateGroup(group);
  }

  Future<void> upsertGroup(GroupsTableData group) {
    return read(groupsCommandsProvider.notifier).upsertGroup(group);
  }

  Future<void> deleteGroup(GroupsTableData group) {
    return read(groupsCommandsProvider.notifier).deleteGroup(group);
  }

  Future<void> deleteGroupById(String id) {
    return read(groupsCommandsProvider.notifier).deleteGroupById(id);
  }
}

extension ItemsRef on WidgetRef {
  ItemsRepository get itemsRepository {
    return read(itemsRepositoryProvider);
  }

  Future<void> addItem(ItemsTableData item) {
    return read(itemsCommandsProvider.notifier).addItem(item);
  }

  Future<void> updateItem(ItemsTableData item) {
    return read(itemsCommandsProvider.notifier).updateItem(item);
  }

  Future<void> upsertItem(ItemsTableData item) {
    return read(itemsCommandsProvider.notifier).upsertItem(item);
  }

  Future<void> deleteItem(ItemsTableData item) {
    return read(itemsCommandsProvider.notifier).deleteItem(item);
  }

  Future<void> deleteItemById(String id) {
    return read(itemsCommandsProvider.notifier).deleteItemById(id);
  }
}

extension LocationsRef on WidgetRef {
  LocationsRepository get locationsRepository {
    return read(locationsRepositoryProvider);
  }

  Future<void> addLocation(LocationsTableData location) {
    return read(locationsCommandsProvider.notifier).addLocation(location);
  }

  Future<void> updateLocation(LocationsTableData location) {
    return read(locationsCommandsProvider.notifier).updateLocation(location);
  }

  Future<void> upsertLocation(LocationsTableData location) {
    return read(locationsCommandsProvider.notifier).upsertLocation(location);
  }

  Future<void> deleteLocation(LocationsTableData location) {
    return read(locationsCommandsProvider.notifier).deleteLocation(location);
  }

  Future<void> deleteLocationById(String id) {
    return read(locationsCommandsProvider.notifier).deleteLocationById(id);
  }
}

extension MapsRef on WidgetRef {
  MapsRepository get mapsRepository {
    return read(mapsRepositoryProvider);
  }

  Future<void> addMap(MapsTableData map) {
    return read(mapsCommandsProvider.notifier).addMap(map);
  }

  Future<void> updateMap(MapsTableData map) {
    return read(mapsCommandsProvider.notifier).updateMap(map);
  }

  Future<void> upsertMap(MapsTableData map) {
    return read(mapsCommandsProvider.notifier).upsertMap(map);
  }

  Future<void> deleteMap(MapsTableData map) {
    return read(mapsCommandsProvider.notifier).deleteMap(map);
  }

  Future<void> deleteMapById(String id) {
    return read(mapsCommandsProvider.notifier).deleteMapById(id);
  }
}

extension OrganizationsRef on WidgetRef {
  OrganizationsRepository get organizationsRepository {
    return read(organizationsRepositoryProvider);
  }

  Future<void> addOrganization(OrganizationsTableData organization) {
    return read(
      organizationsCommandsProvider.notifier,
    ).addOrganization(organization);
  }

  Future<void> updateOrganization(OrganizationsTableData organization) {
    return read(
      organizationsCommandsProvider.notifier,
    ).updateOrganization(organization);
  }

  Future<void> upsertOrganization(OrganizationsTableData organization) {
    return read(
      organizationsCommandsProvider.notifier,
    ).upsertOrganization(organization);
  }

  Future<void> deleteOrganization(OrganizationsTableData organization) {
    return read(
      organizationsCommandsProvider.notifier,
    ).deleteOrganization(organization);
  }

  Future<void> deleteOrganizationById(String id) {
    return read(
      organizationsCommandsProvider.notifier,
    ).deleteOrganizationById(id);
  }
}

extension PlayingCampaignsRef on WidgetRef {
  PlayingCampaignsRepository get playingCampaignsRepository {
    return read(playingCampaignsRepositoryProvider);
  }

  Future<void> addPlayingCampaign(PlayingCampaignsTableData playingCampaign) {
    return read(
      playingCampaignsCommandsProvider.notifier,
    ).addPlayingCampaign(playingCampaign);
  }

  Future<void> updatePlayingCampaign(
    PlayingCampaignsTableData playingCampaign,
  ) {
    return read(
      playingCampaignsCommandsProvider.notifier,
    ).updatePlayingCampaign(playingCampaign);
  }

  Future<void> upsertPlayingCampaign(
    PlayingCampaignsTableData playingCampaign,
  ) {
    return read(
      playingCampaignsCommandsProvider.notifier,
    ).upsertPlayingCampaign(playingCampaign);
  }

  Future<void> deletePlayingCampaign(
    PlayingCampaignsTableData playingCampaign,
  ) {
    return read(
      playingCampaignsCommandsProvider.notifier,
    ).deletePlayingCampaign(playingCampaign);
  }
}

extension ScenesRef on WidgetRef {
  ScenesRepository get scenesRepository {
    return read(scenesRepositoryProvider);
  }

  Future<void> addScene(ScenesTableData scene) {
    return read(scenesCommandsProvider.notifier).addScene(scene);
  }

  Future<void> updateScene(ScenesTableData scene) {
    return read(scenesCommandsProvider.notifier).updateScene(scene);
  }

  Future<void> upsertScene(ScenesTableData scene) {
    return read(scenesCommandsProvider.notifier).upsertScene(scene);
  }

  Future<void> deleteScene(ScenesTableData scene) {
    return read(scenesCommandsProvider.notifier).deleteScene(scene);
  }

  Future<void> deleteSceneById(String id) {
    return read(scenesCommandsProvider.notifier).deleteSceneById(id);
  }
}

extension SessionLogsRef on WidgetRef {
  SessionLogsRepository get sessionLogsRepository {
    return read(sessionLogsRepositoryProvider);
  }

  Future<void> addSessionLog(SessionLogsTableData sessionLog) {
    return read(sessionLogsCommandsProvider.notifier).addSessionLog(sessionLog);
  }

  Future<void> updateSessionLog(SessionLogsTableData sessionLog) {
    return read(
      sessionLogsCommandsProvider.notifier,
    ).updateSessionLog(sessionLog);
  }

  Future<void> upsertSessionLog(SessionLogsTableData sessionLog) {
    return read(
      sessionLogsCommandsProvider.notifier,
    ).upsertSessionLog(sessionLog);
  }

  Future<void> deleteSessionLog(SessionLogsTableData sessionLog) {
    return read(
      sessionLogsCommandsProvider.notifier,
    ).deleteSessionLog(sessionLog);
  }

  Future<void> deleteSessionLogById(String id) {
    return read(sessionLogsCommandsProvider.notifier).deleteSessionLogById(id);
  }
}

extension SupabaseAuthRef on WidgetRef {
  AuthNotifier get authNotifier {
    return read(authProvider.notifier);
  }

  Future<void> login(String email, String password) {
    return read(authProvider.notifier).login(email, password);
  }

  Future<void> signup(String email, String password) {
    return read(authProvider.notifier).signup(email, password);
  }

  Future<void> signOut() {
    return read(authProvider.notifier).signOut();
  }

  String? get userId {
    return read(userIdProvider);
  }

  bool get isLoggedIn {
    return read(isLoggedInProvider);
  }

  User? get user {
    return read(userProvider);
  }

  Future<void> updateUserMetadata(Map<String, dynamic> data) {
    return read(authProvider.notifier).updateUserMetadata(data);
  }

  Future<void> deleteUserMetadata(List<String> keys) {
    return read(authProvider.notifier).deleteUserMetadata(keys);
  }

  Future<void> updateUser(UserAttributes attributes) {
    return read(authProvider.notifier).updateUser(attributes);
  }
}