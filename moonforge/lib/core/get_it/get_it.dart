import 'package:get_it/get_it.dart';
import 'package:moonforge/core/services/app_settings_service.dart';

final GetIt getIt = GetIt.instance;

void initGetIt() {
  // Services
  getIt.registerSingletonAsync<AppSettingsService>(() async {
    final appSettings = AppSettingsService();
    await appSettings.initialize();
    return appSettings;
  });
}

Future<void> setupGetIt() async {
  initGetIt();
  await getIt.allReady();
}