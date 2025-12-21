import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:moonforge/core/get_it/get_it.dart';
import 'package:moonforge/core/services/app_settings_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timeago/timeago.dart' as timeago;
part 'app_settings.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    final appSettings = getIt<AppSettingsService>();
    return appSettings.themeMode;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final appSettings = getIt<AppSettingsService>();
    state = mode;
    await appSettings.saveThemeMode(mode);
  }
}

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale? build() {
    final appSettings = getIt<AppSettingsService>();
    return appSettings.locale;
  }

  Future<void> setLocale(Locale? locale) async {
    final appSettings = getIt<AppSettingsService>();
    state = locale;
    timeago.setDefaultLocale( locale?.languageCode ?? 'en' );
    await appSettings.saveLocale(locale);
  }
}

@riverpod
class NotificationsEnabledNotifier extends _$NotificationsEnabledNotifier {
  @override
  bool build() {
    final appSettings = getIt<AppSettingsService>();
    return appSettings.notificationsEnabled;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final appSettings = getIt<AppSettingsService>();
    state = enabled;
    await appSettings.saveNotificationsEnabled(enabled);
  }
}
