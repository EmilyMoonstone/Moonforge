// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Moonforge';

  @override
  String get your => 'Your';

  @override
  String get newString => 'New';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get sparkWithAI => 'Spark with AI';

  @override
  String get search => 'Search';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get home => 'Home';

  @override
  String get notifications => 'Notifications';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String nGroups(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Groups',
      one: '1 group',
      zero: 'No Groups',
    );
    return '$_temp0';
  }

  @override
  String nCampaigns(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Campaigns',
      one: '1 Campaign',
      zero: 'No Campaigns',
    );
    return '$_temp0';
  }

  @override
  String spCampaigns(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Campaign',
      'other': 'Campaigns',
    });
    return '$_temp0';
  }

  @override
  String nAdventures(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Adventures',
      one: '1 Adventure',
      zero: 'No Adventures',
    );
    return '$_temp0';
  }

  @override
  String spAdventures(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Adventure',
      'other': 'Adventures',
    });
    return '$_temp0';
  }

  @override
  String nChapters(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Chapters',
      one: '1 Chapter',
      zero: 'No Chapters',
    );
    return '$_temp0';
  }

  @override
  String spChapters(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Chapter',
      'other': 'Chapters',
    });
    return '$_temp0';
  }

  @override
  String nScenes(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Scenes',
      one: '1 Scene',
      zero: 'No Scenes',
    );
    return '$_temp0';
  }

  @override
  String spScenes(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Scene',
      'other': 'Scenes',
    });
    return '$_temp0';
  }

  @override
  String nPlayers(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Players',
      one: '1 Player',
      zero: 'No Players',
    );
    return '$_temp0';
  }

  @override
  String spPlayers(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Player',
      'other': 'Players',
    });
    return '$_temp0';
  }

  @override
  String nEntities(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Entities',
      one: '1 Entity',
      zero: 'No Entities',
    );
    return '$_temp0';
  }

  @override
  String spEntities(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Entity',
      'other': 'Entities',
    });
    return '$_temp0';
  }

  @override
  String nItems(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Items',
      one: '1 Item',
      zero: 'No Items',
    );
    return '$_temp0';
  }

  @override
  String spItems(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Item',
      'other': 'Items',
    });
    return '$_temp0';
  }

  @override
  String nLocations(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Locations',
      one: '1 Location',
      zero: 'No Locations',
    );
    return '$_temp0';
  }

  @override
  String spLocations(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Location',
      'other': 'Locations',
    });
    return '$_temp0';
  }

  @override
  String nOrganizations(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Organizations',
      one: '1 Organization',
      zero: 'No Organizations',
    );
    return '$_temp0';
  }

  @override
  String spOrganizations(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Organization',
      'other': 'Organizations',
    });
    return '$_temp0';
  }

  @override
  String nNPCs(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count NPCs',
      one: '1 NPC',
      zero: 'No NPCs',
    );
    return '$_temp0';
  }

  @override
  String spNPCs(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'NPC',
      'other': 'NPCs',
    });
    return '$_temp0';
  }

  @override
  String nCreatures(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Creatures',
      one: '1 Creature',
      zero: 'No Creatures',
    );
    return '$_temp0';
  }

  @override
  String spCreatures(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Creature',
      'other': 'Creatures',
    });
    return '$_temp0';
  }

  @override
  String otherX(Object entity) {
    return 'Other $entity';
  }

  @override
  String get content => 'Content';

  @override
  String createX(Object entity) {
    return 'Create $entity';
  }

  @override
  String sortBy(String sortType) {
    String _temp0 = intl.Intl.selectLogic(sortType, {
      'nameAsc': 'Name (A-Z)',
      'nameDesc': 'Name (Z-A)',
      'dateCreatedAsc': 'Date Created (Oldest First)',
      'dateCreatedDesc': 'Date Created (Newest First)',
      'lastModifiedAsc': 'Last Modified (Oldest First)',
      'lastModifiedDesc': 'Last Modified (Newest First)',
      'other': 'Unknown Sort',
    });
    return '$_temp0';
  }

  @override
  String noXFound(Object entity) {
    return 'No $entity Found';
  }

  @override
  String loadingX(Object entity) {
    return 'Loading $entity...';
  }
}
