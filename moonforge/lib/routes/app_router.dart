import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/supabase.dart';
import 'app_router.gr.dart';

export 'app_router.gr.dart';

@AutoRouterConfig()
final class AppRouter extends RootStackRouter {
  final _AuthGuard _authGuard;

  AppRouter(Ref ref) : _authGuard = _AuthGuard(ref);

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(
        page: LoginRoute.page,
        path: '/auth/login',
        ),
      AutoRoute(
        page: LoggedInRoot.page,
        initial: true,
        guards: [_authGuard],
        children: [
          AutoRoute(initial: true, page: DashboardRoute.page),
          AutoRoute(
            page: CampaignRoute.page,
            children: [
              AutoRoute(initial: true, page: CampaignOverviewRoute.page),
              AutoRoute(page: ChapterRoute.page),
              AutoRoute(page: CampaignMapsRoute.page),
              AutoRoute(page: CampaignEntitiesRoute.page),
              AutoRoute(page: CampaignEncountersRoute.page),
            ],
          ),
          AutoRoute(page: CompendiumRoute.page),
          AutoRoute(page: GroupsRoute.page),
          AutoRoute(page: SettingsRoute.page),
        ],
      ),
    ];
  }

  static CustomRoute _dialogRoute(PageInfo page) {
    return CustomRoute(
      page: page,
      customRouteBuilder: <T>(context, child, page) {
        return DialogRoute(
          context: context,
          builder: (_) => child,
          settings: page,
        );
      },
    );
  }
}

@RoutePage(name: 'LoggedInRoot')
final class LoggedInContents extends StatelessWidget {
  const LoggedInContents({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}

final class _AuthGuard extends AutoRouteGuard {
  final Ref _ref;

  _AuthGuard(this._ref);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_ref.read(isLoggedInProvider)) {
      resolver.next(true);
    } else {
      resolver.redirectUntil(const LoginRoute());
    }
  }
}

final appRouter = Provider((ref) => AppRouter(ref));
