import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/database.dart';

const _creatureKinds = {'npc', 'monster', 'creature'};
const _organizationKinds = {'organization', 'organisation', 'group'};
const _locationKinds = {'location', 'place'};
const _itemKinds = {'item'};
const _mapKinds = {'map'};
const _chapterKinds = {'chapter'};
const _adventureKinds = {'adventure'};
const _sceneKinds = {'scene'};
const _encounterKinds = {'encounter'};

class MentionEntity {
  const MentionEntity({
    required this.id,
    required this.name,
    required this.kind,
    this.summary,
  });

  final String id;
  final String name;
  final String kind;
  final String? summary;
}

final entityMentionServiceProvider = Provider<EntityMentionService>((ref) {
  final db = ref.watch(driftDatabase);
  return EntityMentionService(db: db);
});

/// Service for fetching entities for mention autocomplete.
class EntityMentionService {
  EntityMentionService({required AppDatabase db}) : _db = db;

  final AppDatabase _db;

  /// Search entities by kind and query string.
  ///
  /// [campaignId] - The campaign ID to search entities in
  /// [kinds] - Comma-separated list of entity kinds (e.g., "creature,organisation")
  /// [query] - Search query to filter by entity name
  /// [limit] - Maximum number of results to return (default: 10)
  Future<List<MentionEntity>> searchEntities({
    required String campaignId,
    required String kinds,
    String query = '',
    int limit = 10,
  }) async {
    try {
      if (limit <= 0) {
        return [];
      }

      final normalizedKinds = _normalizeKinds(kinds);
      final includeAll = normalizedKinds.isEmpty;
      final includeAllCreatureKinds =
          includeAll || normalizedKinds.contains('creature');
      final normalizedQuery = query.trim().toLowerCase();
      final results = <MentionEntity>[];

      final includeCreatures =
          includeAll || normalizedKinds.any(_creatureKinds.contains);
      if (includeCreatures) {
        final creatures = await (_db.select(_db.creaturesTable)
              ..where((tbl) => tbl.campaignId.equals(campaignId)))
            .get();
        for (final creature in creatures) {
          if (!_matchesQuery(creature.name, normalizedQuery)) {
            continue;
          }

          final creatureKind = _normalizeCreatureKind(creature.kind);
          if (!includeAllCreatureKinds) {
            if (creatureKind == 'npc' && !normalizedKinds.contains('npc')) {
              continue;
            }
            if (creatureKind == 'monster' &&
                !normalizedKinds.contains('monster')) {
              continue;
            }
            if (creatureKind == 'creature' &&
                !normalizedKinds.contains('creature')) {
              continue;
            }
          }

          results.add(
            MentionEntity(
              id: creature.id,
              name: creature.name,
              kind: creatureKind,
              summary: _firstNonEmpty(
                creature.description,
                creature.creatureType,
                creature.kind,
              ),
            ),
          );
        }
      }

      final includeOrganizations =
          includeAll || normalizedKinds.any(_organizationKinds.contains);
      if (includeOrganizations) {
        final organizations = await (_db.select(_db.organizationsTable)
              ..where((tbl) => tbl.campaignId.equals(campaignId)))
            .get();
        for (final organization in organizations) {
          if (!_matchesQuery(organization.name, normalizedQuery)) {
            continue;
          }

          results.add(
            MentionEntity(
              id: organization.id,
              name: organization.name,
              kind: 'organization',
              summary: _firstNonEmpty(
                organization.description,
                organization.type,
              ),
            ),
          );
        }
      }

      final includeLocations =
          includeAll || normalizedKinds.any(_locationKinds.contains);
      if (includeLocations) {
        final locations = await (_db.select(_db.locationsTable)
              ..where((tbl) => tbl.campaignId.equals(campaignId)))
            .get();
        for (final location in locations) {
          if (!_matchesQuery(location.name, normalizedQuery)) {
            continue;
          }

          results.add(
            MentionEntity(
              id: location.id,
              name: location.name,
              kind: 'location',
              summary: location.description,
            ),
          );
        }
      }

      final includeItems =
          includeAll || normalizedKinds.any(_itemKinds.contains);
      if (includeItems) {
        final items = await (_db.select(_db.itemsTable)
              ..where((tbl) => tbl.campaignId.equals(campaignId)))
            .get();
        for (final item in items) {
          if (!_matchesQuery(item.name, normalizedQuery)) {
            continue;
          }

          results.add(
            MentionEntity(
              id: item.id,
              name: item.name,
              kind: 'item',
              summary: _firstNonEmpty(
                item.description,
                _buildItemSummary(item),
              ),
            ),
          );
        }
      }

      final includeMaps =
          includeAll || normalizedKinds.any(_mapKinds.contains);
      if (includeMaps) {
        final maps = await (_db.select(_db.mapsTable)
              ..where((tbl) => tbl.campaignId.equals(campaignId)))
            .get();
        for (final map in maps) {
          if (!_matchesQuery(map.title, normalizedQuery)) {
            continue;
          }

          results.add(
            MentionEntity(
              id: map.id,
              name: map.title,
              kind: 'map',
              summary: map.description,
            ),
          );
        }
      }

      final includeChapters =
          includeAll || normalizedKinds.any(_chapterKinds.contains);
      if (includeChapters) {
        final chapters = await (_db.select(_db.chaptersTable)
              ..where((tbl) => tbl.campaignId.equals(campaignId)))
            .get();
        for (final chapter in chapters) {
          if (!_matchesQuery(chapter.title, normalizedQuery)) {
            continue;
          }

          results.add(
            MentionEntity(
              id: chapter.id,
              name: chapter.title,
              kind: 'chapter',
              summary: chapter.description,
            ),
          );
        }
      }

      final includeAdventures =
          includeAll || normalizedKinds.any(_adventureKinds.contains);
      if (includeAdventures) {
        final adventures = await (_db.select(_db.adventuresTable)
              ..where((tbl) => tbl.campaignId.equals(campaignId)))
            .get();
        for (final adventure in adventures) {
          if (!_matchesQuery(adventure.title, normalizedQuery)) {
            continue;
          }

          results.add(
            MentionEntity(
              id: adventure.id,
              name: adventure.title,
              kind: 'adventure',
              summary: adventure.description,
            ),
          );
        }
      }

      final includeScenes =
          includeAll || normalizedKinds.any(_sceneKinds.contains);
      if (includeScenes) {
        final scenes = await (_db.select(_db.scenesTable)
              ..where((tbl) => tbl.campaignId.equals(campaignId)))
            .get();
        for (final scene in scenes) {
          if (!_matchesQuery(scene.title, normalizedQuery)) {
            continue;
          }

          results.add(
            MentionEntity(
              id: scene.id,
              name: scene.title,
              kind: 'scene',
              summary: scene.description,
            ),
          );
        }
      }

      final includeEncounters =
          includeAll || normalizedKinds.any(_encounterKinds.contains);
      if (includeEncounters) {
        final encounters = await (_db.select(_db.encountersTable)
              ..where((tbl) => tbl.campaignId.equals(campaignId)))
            .get();
        for (final encounter in encounters) {
          if (!_matchesQuery(encounter.title, normalizedQuery)) {
            continue;
          }

          results.add(
            MentionEntity(
              id: encounter.id,
              name: encounter.title,
              kind: 'encounter',
              summary: encounter.description,
            ),
          );
        }
      }

      results.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

      if (results.length > limit) {
        return results.sublist(0, limit);
      }

      return results;
    } catch (e) {
      logger.e('Error searching entities: $e');
      return [];
    }
  }

  /// Get a single entity by ID.
  ///
  /// [campaignId] - The campaign ID
  /// [entityId] - The entity ID
  Future<MentionEntity?> getEntityById({
    required String campaignId,
    required String entityId,
  }) async {
    try {
      final creature = await (_db.select(_db.creaturesTable)
            ..where((tbl) => tbl.campaignId.equals(campaignId))
            ..where((tbl) => tbl.id.equals(entityId)))
          .getSingleOrNull();
      if (creature != null) {
        final creatureKind = _normalizeCreatureKind(creature.kind);
        return MentionEntity(
          id: creature.id,
          name: creature.name,
          kind: creatureKind,
          summary: _firstNonEmpty(
            creature.description,
            creature.creatureType,
            creature.kind,
          ),
        );
      }

      final organization = await (_db.select(_db.organizationsTable)
            ..where((tbl) => tbl.campaignId.equals(campaignId))
            ..where((tbl) => tbl.id.equals(entityId)))
          .getSingleOrNull();
      if (organization != null) {
        return MentionEntity(
          id: organization.id,
          name: organization.name,
          kind: 'organization',
          summary: _firstNonEmpty(
            organization.description,
            organization.type,
          ),
        );
      }

      final location = await (_db.select(_db.locationsTable)
            ..where((tbl) => tbl.campaignId.equals(campaignId))
            ..where((tbl) => tbl.id.equals(entityId)))
          .getSingleOrNull();
      if (location != null) {
        return MentionEntity(
          id: location.id,
          name: location.name,
          kind: 'location',
          summary: location.description,
        );
      }

      final item = await (_db.select(_db.itemsTable)
            ..where((tbl) => tbl.campaignId.equals(campaignId))
            ..where((tbl) => tbl.id.equals(entityId)))
          .getSingleOrNull();
      if (item != null) {
        return MentionEntity(
          id: item.id,
          name: item.name,
          kind: 'item',
          summary: _firstNonEmpty(
            item.description,
            _buildItemSummary(item),
          ),
        );
      }

      final map = await (_db.select(_db.mapsTable)
            ..where((tbl) => tbl.campaignId.equals(campaignId))
            ..where((tbl) => tbl.id.equals(entityId)))
          .getSingleOrNull();
      if (map != null) {
        return MentionEntity(
          id: map.id,
          name: map.title,
          kind: 'map',
          summary: map.description,
        );
      }

      final chapter = await (_db.select(_db.chaptersTable)
            ..where((tbl) => tbl.campaignId.equals(campaignId))
            ..where((tbl) => tbl.id.equals(entityId)))
          .getSingleOrNull();
      if (chapter != null) {
        return MentionEntity(
          id: chapter.id,
          name: chapter.title,
          kind: 'chapter',
          summary: chapter.description,
        );
      }

      final adventure = await (_db.select(_db.adventuresTable)
            ..where((tbl) => tbl.campaignId.equals(campaignId))
            ..where((tbl) => tbl.id.equals(entityId)))
          .getSingleOrNull();
      if (adventure != null) {
        return MentionEntity(
          id: adventure.id,
          name: adventure.title,
          kind: 'adventure',
          summary: adventure.description,
        );
      }

      final scene = await (_db.select(_db.scenesTable)
            ..where((tbl) => tbl.campaignId.equals(campaignId))
            ..where((tbl) => tbl.id.equals(entityId)))
          .getSingleOrNull();
      if (scene != null) {
        return MentionEntity(
          id: scene.id,
          name: scene.title,
          kind: 'scene',
          summary: scene.description,
        );
      }

      final encounter = await (_db.select(_db.encountersTable)
            ..where((tbl) => tbl.campaignId.equals(campaignId))
            ..where((tbl) => tbl.id.equals(entityId)))
          .getSingleOrNull();
      if (encounter != null) {
        return MentionEntity(
          id: encounter.id,
          name: encounter.title,
          kind: 'encounter',
          summary: encounter.description,
        );
      }
    } catch (e) {
      logger.e('Error getting entity by ID: $e');
    }

    return null;
  }
}

Set<String> _normalizeKinds(String kinds) {
  return kinds
      .split(',')
      .map((kind) => kind.trim().toLowerCase())
      .where((kind) => kind.isNotEmpty)
      .toSet();
}

bool _matchesQuery(String text, String query) {
  if (query.isEmpty) {
    return true;
  }

  return text.toLowerCase().contains(query);
}

String _normalizeCreatureKind(String kind) {
  final normalized = kind.trim().toLowerCase();
  if (normalized == 'npc') {
    return 'npc';
  }
  if (normalized == 'monster') {
    return 'monster';
  }
  return 'creature';
}

String? _firstNonEmpty(String? primary, [String? secondary, String? fallback]) {
  if (primary != null && primary.trim().isNotEmpty) {
    return primary;
  }
  if (secondary != null && secondary.trim().isNotEmpty) {
    return secondary;
  }
  if (fallback != null && fallback.trim().isNotEmpty) {
    return fallback;
  }

  return null;
}

String? _buildItemSummary(ItemsTableData item) {
  final parts = <String>[];
  if (item.type?.isNotEmpty ?? false) {
    parts.add(item.type!);
  }
  if (item.rarity?.isNotEmpty ?? false) {
    parts.add(item.rarity!);
  }
  if (parts.isEmpty) {
    return null;
  }

  return parts.join(' / ');
}
