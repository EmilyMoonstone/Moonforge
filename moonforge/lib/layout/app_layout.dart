import 'package:auto_route/auto_route.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:moonforge/layout/widgets/app_top_bar.dart';
import 'package:moonforge/routes/app_router.gr.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({
    super.key,
    required this.child,
    required this.activeItem,
    this.sidebar,
    this.bodyPadding = const EdgeInsets.all(24),
  });

  final Widget child;
  final AppNavItem activeItem;
  final Widget? sidebar;
  final EdgeInsetsGeometry bodyPadding;

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  void _handleNavigate(BuildContext context, AppNavItem item) {
    if (item == widget.activeItem) {
      return;
    }

    final router = AutoRouter.of(context);
    final route = switch (item) {
      AppNavItem.dashboard => const DashboardRoute(),
      AppNavItem.campaign => const CampaignRoute(
        children: [CampaignOverviewRoute()],
      ),
      AppNavItem.compendium => const CompendiumRoute(),
      AppNavItem.groups => const GroupsRoute(),
      AppNavItem.settings => const SettingsRoute(),
    };

    router.push(route);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      loadingProgressIndeterminate: false,
      headers: [
        AppTopBar(
          activeItem: widget.activeItem,
          onNavigate: (item) => _handleNavigate(context, item),
        ),
      
      ],
      child: Expanded(
          child: Row(
            children: [
              if (widget.sidebar != null) widget.sidebar!,
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    padding: AppSpacing.paddingXl,
                    child: widget.child,
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
