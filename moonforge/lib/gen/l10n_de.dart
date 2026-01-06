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
  String get your => 'Deine';

  @override
  String get newString => 'Neu';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get delete => 'Löschen';

  @override
  String get sparkWithAI => 'Spark with AI';

  @override
  String get search => 'Suchen';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get close => 'Schließen';

  @override
  String get home => 'Start';

  @override
  String createX(Object entity) {
    return '$entity erstellen';
  }

  @override
  String get create => 'Erstellen';

  @override
  String createdX(Object entity) {
    return '$entity erstellt';
  }

  @override
  String get created => 'Erstellt';

  @override
  String otherX(Object entity) {
    return 'Andere $entity';
  }

  @override
  String get enter => 'Eingeben';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get profile => 'Profil';

  @override
  String get general => 'Allgemein';

  @override
  String get account => 'Konto';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get compendium => 'Kompendium';

  @override
  String appNavItem(String item) {
    String _temp0 = intl.Intl.selectLogic(item, {
      'dashboard': 'Dashboard',
      'campaign': 'Kampagne',
      'compendium': 'Kompendium',
      'groups': 'Gruppen',
      'other': 'Unbekannt',
    });
    return '$_temp0';
  }

  @override
  String nGroups(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gruppen',
      one: '1 Gruppe',
      zero: 'Keine Gruppen',
    );
    return '$_temp0';
  }

  @override
  String spGroups(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Gruppe',
      'other': 'Gruppen',
    });
    return '$_temp0';
  }

  @override
  String nCampaigns(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kampagnen',
      one: '1 Kampagne',
      zero: 'Keine Kampagnen',
    );
    return '$_temp0';
  }

  @override
  String spCampaigns(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Kampagne',
      'other': 'Kampagnen',
    });
    return '$_temp0';
  }

  @override
  String nAdventures(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Abenteuer',
      one: '1 Abenteuer',
      zero: 'Keine Abenteuer',
    );
    return '$_temp0';
  }

  @override
  String spAdventures(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Abenteuer',
      'other': 'Abenteuer',
    });
    return '$_temp0';
  }

  @override
  String nChapters(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kapitel',
      one: '1 Kapitel',
      zero: 'Keine Kapitel',
    );
    return '$_temp0';
  }

  @override
  String spChapters(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Kapitel',
      'other': 'Kapitel',
    });
    return '$_temp0';
  }

  @override
  String nScenes(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Szenen',
      one: '1 Szene',
      zero: 'Keine Szenen',
    );
    return '$_temp0';
  }

  @override
  String spScenes(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Szene',
      'other': 'Szenen',
    });
    return '$_temp0';
  }

  @override
  String nPlayers(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Spieler:innen',
      one: '1 Spieler:in',
      zero: 'Keine Spieler:innen',
    );
    return '$_temp0';
  }

  @override
  String spPlayers(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Spieler:in',
      'other': 'Spieler:innen',
    });
    return '$_temp0';
  }

  @override
  String nEntities(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Entitäten',
      one: '1 Entität',
      zero: 'Keine Entitäten',
    );
    return '$_temp0';
  }

  @override
  String spEntities(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Entität',
      'other': 'Entitäten',
    });
    return '$_temp0';
  }

  @override
  String nItems(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gegenstände',
      one: '1 Gegenstand',
      zero: 'Keine Gegenstände',
    );
    return '$_temp0';
  }

  @override
  String spItems(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Gegenstand',
      'other': 'Gegenstände',
    });
    return '$_temp0';
  }

  @override
  String nLocations(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Orte',
      one: '1 Ort',
      zero: 'Keine Orte',
    );
    return '$_temp0';
  }

  @override
  String spLocations(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Ort',
      'other': 'Orte',
    });
    return '$_temp0';
  }

  @override
  String nOrganizations(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Organisationen',
      one: '1 Organisation',
      zero: 'Keine Organisationen',
    );
    return '$_temp0';
  }

  @override
  String spOrganizations(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Organisation',
      'other': 'Organisationen',
    });
    return '$_temp0';
  }

  @override
  String nNPCs(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count NSCs',
      one: '1 NSC',
      zero: 'Keine NSCs',
    );
    return '$_temp0';
  }

  @override
  String spNPCs(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'NSC',
      'other': 'NSCs',
    });
    return '$_temp0';
  }

  @override
  String nCreatures(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kreaturen',
      one: '1 Kreatur',
      zero: 'Keine Kreaturen',
    );
    return '$_temp0';
  }

  @override
  String spCreatures(String number) {
    String _temp0 = intl.Intl.selectLogic(number, {
      'singular': 'Kreatur',
      'other': 'Kreaturen',
    });
    return '$_temp0';
  }

  @override
  String sortBy(String sortType) {
    String _temp0 = intl.Intl.selectLogic(sortType, {
      'nameAsc': 'Name (A-Z)',
      'nameDesc': 'Name (Z-A)',
      'createdAsc': 'Erstellt (Älteste zuerst)',
      'createdDesc': 'Erstellt (Neueste zuerst)',
      'lastModifiedAsc': 'Zuletzt geändert (Älteste zuerst)',
      'lastModifiedDesc': 'Zuletzt geändert (Neueste zuerst)',
      'other': 'Unbekannte Sortierung',
    });
    return '$_temp0';
  }

  @override
  String noXFound(Object entity) {
    return 'Keine $entity gefunden';
  }

  @override
  String loadingX(Object entity) {
    return 'Lade $entity...';
  }

  @override
  String get success => 'Erfolg';

  @override
  String get error => 'Fehler';

  @override
  String get title => 'Titel';

  @override
  String get description => 'Beschreibung';

  @override
  String get content => 'Inhalt';

  @override
  String get username => 'Benutzername';

  @override
  String get password => 'Passwort';

  @override
  String get email => 'E-Mail';

  @override
  String get language => 'Sprache';

  @override
  String get profilePicture => 'Profilbild';

  @override
  String get logout => 'Abmelden';

  @override
  String get fileSizeExceeds => 'Dateigröße überschritten';

  @override
  String fileSizeExceedsLimit(Object size) {
    return 'Dateigröße überschreitet das Limit von $size';
  }
}
