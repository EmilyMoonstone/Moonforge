// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
