import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonforge/app.dart';
import 'package:moonforge/core/constants/constants.dart';
import 'package:moonforge/core/get_it/get_it.dart';
import 'package:moonforge/core/services/windows_protocol/api.dart';
import 'package:moonforge/core/utils/platform.dart';
import 'package:moonforge/data/supabase.dart';
import 'package:window_manager/window_manager.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _initializeLogger();

  registerProtocolHandler(deepLinkPrefix);

  if (isDesktop) {
    await flutter_acrylic.Window.initialize();
    if (defaultTargetPlatform == TargetPlatform.windows) {
      await flutter_acrylic.Window.hideWindowControls();
    }
    await WindowManager.instance.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(
        TitleBarStyle.hidden,
        windowButtonVisibility: false,
      );
      await windowManager.setMinimumSize(const Size(500, 600));
      await windowManager.show();
      await windowManager.setPreventClose(true);
      await windowManager.setSkipTaskbar(false);
    });
  }

  await setupGetIt();

  await initSupabase();

  timeago.setLocaleMessages('de', timeago.DeMessages());

  runApp(ProviderScope(child: App()));
}

/// Initialize logger and enable contexts based on build mode
/// The logger is a singleton instance defined in lib/core/utils/logger.dart
void _initializeLogger() {
  // In debug mode, enable additional logging contexts for development
  if (kDebugMode) {
    logger.enableContexts([
      LogContext.database,
      LogContext.auth,
      LogContext.navigation,
      LogContext.ui,
    ]);
    logger.i('Logger initialized with contexts: ${logger.enabledContexts}');
  }

  // In release mode, only general context is enabled (default)
  // This reduces log noise in production while keeping errors visible
}
