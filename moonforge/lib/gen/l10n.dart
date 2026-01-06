import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_de.dart';
import 'l10n_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Moonforge'**
  String get appTitle;

  /// No description provided for @your.
  ///
  /// In en, this message translates to:
  /// **'Your'**
  String get your;

  /// No description provided for @newString.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newString;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @sparkWithAI.
  ///
  /// In en, this message translates to:
  /// **'Spark with AI'**
  String get sparkWithAI;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @createX.
  ///
  /// In en, this message translates to:
  /// **'Create {entity}'**
  String createX(Object entity);

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createdX.
  ///
  /// In en, this message translates to:
  /// **'{entity} created'**
  String createdX(Object entity);

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @otherX.
  ///
  /// In en, this message translates to:
  /// **'Other {entity}'**
  String otherX(Object entity);

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @compendium.
  ///
  /// In en, this message translates to:
  /// **'Compendium'**
  String get compendium;

  /// No description provided for @appNavItem.
  ///
  /// In en, this message translates to:
  /// **'{item, select, dashboard{Dashboard} campaign{Campaign} compendium{Compendium} groups{Groups} other{Unknown}}'**
  String appNavItem(String item);

  /// No description provided for @nGroups.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No Groups} =1 {1 group} other {{count} Groups}}'**
  String nGroups(num count);

  /// No description provided for @spGroups.
  ///
  /// In en, this message translates to:
  /// **'{number, select, singular{Group} other{Groups}}'**
  String spGroups(String number);

  /// No description provided for @nCampaigns.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No Campaigns} =1{1 Campaign} other{{count} Campaigns}}'**
  String nCampaigns(num count);

  /// No description provided for @spCampaigns.
  ///
  /// In en, this message translates to:
  /// **'{number, select, singular{Campaign} other{Campaigns}}'**
  String spCampaigns(String number);

  /// No description provided for @nAdventures.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No Adventures} =1 {1 Adventure} other {{count} Adventures}}'**
  String nAdventures(num count);

  /// No description provided for @spAdventures.
  ///
  /// In en, this message translates to:
  /// **'{number, select, singular{Adventure} other{Adventures}}'**
  String spAdventures(String number);

  /// No description provided for @nChapters.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No Chapters} =1 {1 Chapter} other {{count} Chapters}}'**
  String nChapters(num count);

  /// No description provided for @spChapters.
  ///
  /// In en, this message translates to:
  /// **'{number, select, singular{Chapter} other{Chapters}}'**
  String spChapters(String number);

  /// No description provided for @nScenes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No Scenes} =1 {1 Scene} other {{count} Scenes}}'**
  String nScenes(num count);

  /// No description provided for @spScenes.
  ///
  /// In en, this message translates to:
  /// **'{number, select, singular{Scene} other{Scenes}}'**
  String spScenes(String number);

  /// No description provided for @nPlayers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No Players} =1 {1 Player} other {{count} Players}}'**
  String nPlayers(num count);

  /// No description provided for @spPlayers.
  ///
  /// In en, this message translates to:
  /// **'{number, select, singular{Player} other{Players}}'**
  String spPlayers(String number);

  /// No description provided for @nEntities.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No Entities} =1 {1 Entity} other {{count} Entities}}'**
  String nEntities(num count);

  /// No description provided for @spEntities.
  ///
  /// In en, this message translates to:
  /// **'{number, select, singular{Entity} other{Entities}}'**
  String spEntities(String number);

  /// No description provided for @nItems.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No Items} =1 {1 Item} other {{count} Items}}'**
  String nItems(num count);

  /// No description provided for @spItems.
  ///
  /// In en, this message translates to:
  /// **'{number, select, singular{Item} other{Items}}'**
  String spItems(String number);

  /// No description provided for @nLocations.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No Locations} =1 {1 Location} other {{count} Locations}}'**
  String nLocations(num count);

  /// No description provided for @spLocations.
  ///
  /// In en, this message translates to:
  /// **'{number, select, singular{Location} other{Locations}}'**
  String spLocations(String number);

  /// No description provided for @nOrganizations.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No Organizations} =1 {1 Organization} other {{count} Organizations}}'**
  String nOrganizations(num count);

  /// No description provided for @spOrganizations.
  ///
  /// In en, this message translates to:
  /// **'{number, select, singular{Organization} other{Organizations}}'**
  String spOrganizations(String number);

  /// No description provided for @nNPCs.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No NPCs} =1 {1 NPC} other {{count} NPCs}}'**
  String nNPCs(num count);

  /// No description provided for @spNPCs.
  ///
  /// In en, this message translates to:
  /// **'{number, select, singular{NPC} other{NPCs}}'**
  String spNPCs(String number);

  /// No description provided for @nCreatures.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No Creatures} =1 {1 Creature} other {{count} Creatures}}'**
  String nCreatures(num count);

  /// No description provided for @spCreatures.
  ///
  /// In en, this message translates to:
  /// **'{number, select, singular{Creature} other{Creatures}}'**
  String spCreatures(String number);

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'{sortType, select, nameAsc{Name (A-Z)} nameDesc{Name (Z-A)} dateCreatedAsc{Date Created (Oldest First)} dateCreatedDesc{Date Created (Newest First)} lastModifiedAsc{Last Modified (Oldest First)} lastModifiedDesc{Last Modified (Newest First)} other{Unknown Sort}}'**
  String sortBy(String sortType);

  /// No description provided for @noXFound.
  ///
  /// In en, this message translates to:
  /// **'No {entity} Found'**
  String noXFound(Object entity);

  /// No description provided for @loadingX.
  ///
  /// In en, this message translates to:
  /// **'Loading {entity}...'**
  String loadingX(Object entity);

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @profilePicture.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get profilePicture;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @fileSizeExceeds.
  ///
  /// In en, this message translates to:
  /// **'File size exceeds'**
  String get fileSizeExceeds;

  /// No description provided for @fileSizeExceedsLimit.
  ///
  /// In en, this message translates to:
  /// **'File size exceeds the limit of {size}'**
  String fileSizeExceedsLimit(Object size);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
