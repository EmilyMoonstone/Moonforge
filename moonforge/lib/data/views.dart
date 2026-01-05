part of 'database.dart';

abstract class LocationsWithScopes extends View {
  LocationsTable get locations;
  ContentScopesTable get contentScopes;

  @override
  Query as() => select([
    locations.campaignId,
    locations.content,
    locations.createdAt,
    locations.data,
    locations.description,
    locations.id,
    locations.name,
    locations.scopeId,
    locations.updatedAt,
    contentScopes.scopeType,
    contentScopes.chapterId,
    contentScopes.adventureId,
    contentScopes.sceneId,
  ]).from(locations).join([
    innerJoin(contentScopes, contentScopes.id.equalsExp(locations.scopeId)),
  ]);
}

abstract class OrganisationsWithScopes extends View {
  OrganisationsTable get organisations;
  ContentScopesTable get contentScopes;

  @override
  Query as() => select([
    organisations.campaignId,
    organisations.content,
    organisations.createdAt,
    organisations.description,
    organisations.hqLocationId,
    organisations.id,
    organisations.name,
    organisations.scopeId,
    organisations.type,
    organisations.updatedAt,
    contentScopes.scopeType,
    contentScopes.chapterId,
    contentScopes.adventureId,
    contentScopes.sceneId,
  ]).from(organisations).join([
    innerJoin(
      contentScopes,
      contentScopes.id.equalsExp(organisations.scopeId),
    ),
  ]);
}

abstract class ItemsWithScopes extends View {
  ItemsTable get items;
  ContentScopesTable get contentScopes;

  @override
  Query as() => select([
    items.attunement,
    items.campaignId,
    items.content,
    items.createdAt,
    items.data,
    items.description,
    items.id,
    items.name,
    items.rarity,
    items.scopeId,
    items.type,
    items.updatedAt,
    contentScopes.scopeType,
    contentScopes.chapterId,
    contentScopes.adventureId,
    contentScopes.sceneId,
  ]).from(items).join([
    innerJoin(contentScopes, contentScopes.id.equalsExp(items.scopeId)),
  ]);
}

abstract class CreaturesWithScopes extends View {
  CreaturesTable get creatures;
  ContentScopesTable get contentScopes;

  @override
  Query as() => select([
    creatures.abilityScores,
    creatures.actions,
    creatures.alignment,
    creatures.armorClass,
    creatures.campaignId,
    creatures.challengeRating,
    creatures.conditionImmunities,
    creatures.content,
    creatures.createdAt,
    creatures.creatureType,
    creatures.damageImmunities,
    creatures.damageResistances,
    creatures.description,
    creatures.experiencePoints,
    creatures.hitDice,
    creatures.hitPoints,
    creatures.id,
    creatures.kind,
    creatures.languages,
    creatures.legendaryActions,
    creatures.name,
    creatures.organisationId,
    creatures.raw,
    creatures.reactions,
    creatures.savingThrows,
    creatures.scopeId,
    creatures.senses,
    creatures.size,
    creatures.skills,
    creatures.source,
    creatures.speed,
    creatures.spellcasting,
    creatures.subtype,
    creatures.traits,
    creatures.updatedAt,
    contentScopes.scopeType,
    contentScopes.chapterId,
    contentScopes.adventureId,
    contentScopes.sceneId,
  ]).from(creatures).join([
    innerJoin(contentScopes, contentScopes.id.equalsExp(creatures.scopeId)),
  ]);
}

abstract class EncountersWithScopes extends View {
  EncountersTable get encounters;
  ContentScopesTable get contentScopes;

  @override
  Query as() => select([
    encounters.campaignId,
    encounters.content,
    encounters.createdAt,
    encounters.data,
    encounters.description,
    encounters.id,
    encounters.scopeId,
    encounters.title,
    encounters.updatedAt,
    contentScopes.scopeType,
    contentScopes.chapterId,
    contentScopes.adventureId,
    contentScopes.sceneId,
  ]).from(encounters).join([
    innerJoin(contentScopes, contentScopes.id.equalsExp(encounters.scopeId)),
  ]);
}
