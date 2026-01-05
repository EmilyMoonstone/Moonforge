// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i16;
import 'package:moonforge/features/auth/views/login_page.dart' as _i14;
import 'package:moonforge/features/campaign/views/campaign_encounters_page.dart'
    as _i1;
import 'package:moonforge/features/campaign/views/campaign_entities_page.dart'
    as _i2;
import 'package:moonforge/features/campaign/views/campaign_layout.dart' as _i3;
import 'package:moonforge/features/campaign/views/campaign_locations_page.dart'
    as _i4;
import 'package:moonforge/features/campaign/views/campaign_maps_page.dart'
    as _i5;
import 'package:moonforge/features/campaign/views/campaign_page.dart' as _i7;
import 'package:moonforge/features/campaign_overview/campaign_overview_page.dart'
    as _i6;
import 'package:moonforge/features/chapter/chapter_page.dart' as _i8;
import 'package:moonforge/features/compendium_page.dart' as _i9;
import 'package:moonforge/features/dashboard/dashboard.dart' as _i10;
import 'package:moonforge/features/groups_page.dart' as _i11;
import 'package:moonforge/features/settings_page.dart' as _i15;
import 'package:moonforge/layout/layout.dart' as _i12;
import 'package:moonforge/routes/app_router.dart' as _i13;
import 'package:shadcn_flutter/shadcn_flutter.dart' as _i17;

/// generated route for
/// [_i1.CampaignEncountersPage]
class CampaignEncountersRoute extends _i16.PageRouteInfo<void> {
  const CampaignEncountersRoute({List<_i16.PageRouteInfo>? children})
    : super(CampaignEncountersRoute.name, initialChildren: children);

  static const String name = 'CampaignEncountersRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i1.CampaignEncountersPage();
    },
  );
}

/// generated route for
/// [_i2.CampaignEntitiesPage]
class CampaignEntitiesRoute extends _i16.PageRouteInfo<void> {
  const CampaignEntitiesRoute({List<_i16.PageRouteInfo>? children})
    : super(CampaignEntitiesRoute.name, initialChildren: children);

  static const String name = 'CampaignEntitiesRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i2.CampaignEntitiesPage();
    },
  );
}

/// generated route for
/// [_i3.CampaignLayout]
class CampaignLayout extends _i16.PageRouteInfo<CampaignLayoutArgs> {
  CampaignLayout({
    _i17.Key? key,
    required _i17.Widget child,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         CampaignLayout.name,
         args: CampaignLayoutArgs(key: key, child: child),
         initialChildren: children,
       );

  static const String name = 'CampaignLayout';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CampaignLayoutArgs>();
      return _i3.CampaignLayout(key: args.key, child: args.child);
    },
  );
}

class CampaignLayoutArgs {
  const CampaignLayoutArgs({this.key, required this.child});

  final _i17.Key? key;

  final _i17.Widget child;

  @override
  String toString() {
    return 'CampaignLayoutArgs{key: $key, child: $child}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CampaignLayoutArgs) return false;
    return key == other.key && child == other.child;
  }

  @override
  int get hashCode => key.hashCode ^ child.hashCode;
}

/// generated route for
/// [_i4.CampaignLocationsPage]
class CampaignLocationsRoute extends _i16.PageRouteInfo<void> {
  const CampaignLocationsRoute({List<_i16.PageRouteInfo>? children})
    : super(CampaignLocationsRoute.name, initialChildren: children);

  static const String name = 'CampaignLocationsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i4.CampaignLocationsPage();
    },
  );
}

/// generated route for
/// [_i5.CampaignMapsPage]
class CampaignMapsRoute extends _i16.PageRouteInfo<void> {
  const CampaignMapsRoute({List<_i16.PageRouteInfo>? children})
    : super(CampaignMapsRoute.name, initialChildren: children);

  static const String name = 'CampaignMapsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i5.CampaignMapsPage();
    },
  );
}

/// generated route for
/// [_i6.CampaignOverviewPage]
class CampaignOverviewRoute extends _i16.PageRouteInfo<void> {
  const CampaignOverviewRoute({List<_i16.PageRouteInfo>? children})
    : super(CampaignOverviewRoute.name, initialChildren: children);

  static const String name = 'CampaignOverviewRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i6.CampaignOverviewPage();
    },
  );
}

/// generated route for
/// [_i7.CampaignPage]
class CampaignRoute extends _i16.PageRouteInfo<void> {
  const CampaignRoute({List<_i16.PageRouteInfo>? children})
    : super(CampaignRoute.name, initialChildren: children);

  static const String name = 'CampaignRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i7.CampaignPage();
    },
  );
}

/// generated route for
/// [_i8.ChapterPage]
class ChapterRoute extends _i16.PageRouteInfo<ChapterRouteArgs> {
  ChapterRoute({
    _i17.Key? key,
    required String chapterId,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         ChapterRoute.name,
         args: ChapterRouteArgs(key: key, chapterId: chapterId),
         initialChildren: children,
       );

  static const String name = 'ChapterRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChapterRouteArgs>();
      return _i8.ChapterPage(key: args.key, chapterId: args.chapterId);
    },
  );
}

class ChapterRouteArgs {
  const ChapterRouteArgs({this.key, required this.chapterId});

  final _i17.Key? key;

  final String chapterId;

  @override
  String toString() {
    return 'ChapterRouteArgs{key: $key, chapterId: $chapterId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChapterRouteArgs) return false;
    return key == other.key && chapterId == other.chapterId;
  }

  @override
  int get hashCode => key.hashCode ^ chapterId.hashCode;
}

/// generated route for
/// [_i9.CompendiumPage]
class CompendiumRoute extends _i16.PageRouteInfo<void> {
  const CompendiumRoute({List<_i16.PageRouteInfo>? children})
    : super(CompendiumRoute.name, initialChildren: children);

  static const String name = 'CompendiumRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i9.CompendiumPage();
    },
  );
}

/// generated route for
/// [_i10.DashboardPage]
class DashboardRoute extends _i16.PageRouteInfo<void> {
  const DashboardRoute({List<_i16.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i10.DashboardPage();
    },
  );
}

/// generated route for
/// [_i11.GroupsPage]
class GroupsRoute extends _i16.PageRouteInfo<void> {
  const GroupsRoute({List<_i16.PageRouteInfo>? children})
    : super(GroupsRoute.name, initialChildren: children);

  static const String name = 'GroupsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i11.GroupsPage();
    },
  );
}

/// generated route for
/// [_i12.LayoutScreen]
class LayoutRoute extends _i16.PageRouteInfo<void> {
  const LayoutRoute({List<_i16.PageRouteInfo>? children})
    : super(LayoutRoute.name, initialChildren: children);

  static const String name = 'LayoutRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i12.LayoutScreen();
    },
  );
}

/// generated route for
/// [_i13.LoggedInContents]
class LoggedInRoot extends _i16.PageRouteInfo<void> {
  const LoggedInRoot({List<_i16.PageRouteInfo>? children})
    : super(LoggedInRoot.name, initialChildren: children);

  static const String name = 'LoggedInRoot';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i13.LoggedInContents();
    },
  );
}

/// generated route for
/// [_i14.LoginPage]
class LoginRoute extends _i16.PageRouteInfo<void> {
  const LoginRoute({List<_i16.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i14.LoginPage();
    },
  );
}

/// generated route for
/// [_i15.SettingsPage]
class SettingsRoute extends _i16.PageRouteInfo<void> {
  const SettingsRoute({List<_i16.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i15.SettingsPage();
    },
  );
}
