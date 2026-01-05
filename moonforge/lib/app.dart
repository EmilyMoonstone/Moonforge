import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonforge/data/supabase.dart';
import 'package:moonforge/gen/l10n.dart';
import 'package:moonforge/layout/theme.dart';
import 'package:moonforge/routes/app_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/providers/app_settings.dart';
import 'core/providers/root_context_provider.dart';

final _appTheme = AppTheme();

class App extends StatefulHookConsumerWidget {
  const App({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();

    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  Future<void> initDeepLinks() async {
    // Handle links
    _linkSubscription = AppLinks().uriLinkStream.listen((uri) {
      logger.i('Received app link: $uri', context: LogContext.navigation);
      openAppLink(uri);
    });
  }

  Future<void> openAppLink(Uri uri) async {
    final router = ref.read(appRouter);
    if (uri.scheme == 'moonforge' &&
        uri.host == 'auth' &&
        uri.path == '/callback') {
      try {
        await Supabase.instance.client.auth.getSessionFromUrl(uri);
      } catch (e, s) {
        logger.w(
          'Failed to exchange auth code: $e',
          error: e,
          stackTrace: s,
          context: LogContext.navigation,
        );
      }
      router.replaceAll([const LoggedInRoot()]);
      return;
    }
    if (uri.fragment.isNotEmpty) {
      router.pushPath(uri.fragment);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Bridge riverpod session provider to the listenable that auto_route wants
    // to re-evaluate route guards.
    final sessionNotifier = useValueNotifier(ref.read(isLoggedInProvider));
    ref.listen(isLoggedInProvider, (prev, now) {
      if (sessionNotifier.value != now) {
        // Using Timer.run() here to work around an issue with auto_route during
        // initialization.
        Timer.run(() {
          sessionNotifier.value = now;
        });
      }
    });

    return ChangeNotifierProvider.value(
      value: _appTheme,
      builder: (final context, final child) {
        final appTheme = context.watch<AppTheme>();
        final locale = ref.watch(localeProvider);
        final router = ref.watch(appRouter);

        return ShadcnApp.router(
          debugShowCheckedModeBanner: false,
          /*           color: appTheme.color.accent, */
          themeMode: ThemeMode.dark,
          theme: appTheme.theme,
          routerConfig: router.config(),
          locale: locale,
          localizationsDelegates: [
            ...AppLocalizations.localizationsDelegates,
            ShadcnLocalizationsDelegate.delegate,
            FlutterQuillLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) {
            ref.read(rootContextProvider.notifier).setBuildContext(context);
            return child!;
          },
        );
      },
    );
  }
}
