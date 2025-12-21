import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:moonforge/core/services/base_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsService extends BaseService {
  static const String _keyThemeMode = 'settings.themeMode';
  static const String _keyLocale = 'settings.locale';
  static const String _keyNotificationsEnabled =
      'settings.notificationsEnabled';

  ThemeMode _themeMode = ThemeMode.system;
  Locale? _locale;
  bool _notificationsEnabled = true;

  ThemeMode get themeMode => _themeMode;
  Locale? get locale => _locale;
  bool get notificationsEnabled => _notificationsEnabled;

  late final SharedPreferences _prefs;

  AppSettingsService();

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _themeMode = loadThemeMode();
    _locale = loadLocale();
    _notificationsEnabled = loadNotificationsEnabled();
  }

  @override
  LogContext get logContext => LogContext.general;
  @override
  String get serviceName => 'AppSettingsService';

  /// Load theme mode from storage.
  ThemeMode loadThemeMode() {
    return execute(() {
      final value = _prefs.getString(_keyThemeMode);
      if (value == null) return ThemeMode.system;
      return ThemeMode.values.firstWhere(
        (mode) => mode.name == value,
        orElse: () => ThemeMode.system,
      );
    });
  }

  /// Save theme mode to storage.
  Future<void> saveThemeMode(ThemeMode mode) async {
    return executeAsync(() async {
      await _prefs.setString(_keyThemeMode, mode.name);
    }, operationName: 'saveThemeMode');
  }

  /// Load locale from storage. Returns null for system locale.
  Locale? loadLocale() {
    return execute(() {
      final value = _prefs.getString(_keyLocale);
      if (value == null || value.isEmpty) return null;
      return Locale(value);
    });
  }

  /// Save locale to storage. Pass null to use system locale.
  Future<void> saveLocale(Locale? locale) async {
    return executeAsync(() async {
      if (locale == null) {
        await _prefs.remove(_keyLocale);
      } else {
        await _prefs.setString(_keyLocale, locale.languageCode);
      }
    }, operationName: 'saveLocale');
  }

  /// Load notifications enabled state.
  bool loadNotificationsEnabled() {
    return execute(() {
      return _prefs.getBool(_keyNotificationsEnabled) ?? true;
    });
  }

  /// Save notifications enabled state.
  Future<void> saveNotificationsEnabled(bool enabled) async {
    return executeAsync(() async {
      await _prefs.setBool(_keyNotificationsEnabled, enabled);
    }, operationName: 'saveNotificationsEnabled');
  }

  /// Clear all settings and restore defaults.
  Future<void> clearAll() async {
    return executeAsync(() async {
      await _prefs.remove(_keyThemeMode);
      await _prefs.remove(_keyLocale);
      await _prefs.remove(_keyNotificationsEnabled);
    }, operationName: 'clearAll');
  }
}
