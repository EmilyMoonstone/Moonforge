import 'package:moonforge/core/widgets/button_switch.dart';
import 'package:moonforge/core/widgets/powersync_status_icon.dart';
import 'package:moonforge/features/auth/widgets/profile.dart';
import 'package:moonforge/features/command/widgets/search_icon.dart';
import 'package:moonforge/gen/l10n.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:moonforge/layout/design_constants.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:moonforge/layout/widgets/title.dart';
import 'package:moonforge/core/utils/platform.dart';
import 'package:window_manager/window_manager.dart';

enum AppNavItem { dashboard, campaign, compendium, groups }

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.activeItem,
    required this.onNavigate,
  });

  final AppNavItem? activeItem;
  final ValueChanged<AppNavItem> onNavigate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: kAppBarHeight,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          border: Border(bottom: BorderSide(color: theme.colorScheme.border)),
        ),
        child: Stack(
          children: [
            if (isDesktop)
              const Positioned.fill(
                child: DragToMoveArea(child: SizedBox.expand()),
              ),
            Row(
              children: [
                const AppTitle(),
                const Gap(AppSpacing.xl),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ButtonSwitch(
                    highlightStyle: ButtonStyle.secondary(),
                    actions: [
                      for (final item in AppNavItem.values)
                        ButtonSwitchAction(
                          label:
                              l10n.appNavItem(item.name),
                        ),
                    ],
                    index: activeItem != null ? AppNavItem.values.indexOf(activeItem!) : null,
                    onChanged: (index) => onNavigate(AppNavItem.values[index]),
                    onCard: false,
                  ),
                ),
                Spacer(),
                SearchIcon(),
                PowerSyncStatusIcon(),
                Tooltip(
                  key: const Key('notifications_tooltip'),
                  tooltip: (context) =>
                      TooltipContainer(child: Text('Notifications')),
                  child: IconButton(
                    variance: ButtonVariance.ghost,
                    icon: const Icon(Icons.notifications),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
                const Profile(),
                if (isDesktop) const SizedBox(width: 12),
                if (isDesktop) const WindowButtons(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UserBadge extends StatelessWidget {
  const _UserBadge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Dungeon Master', style: theme.typography.large),
            Text('Pro Plan', style: theme.typography.base),
          ],
        ),
        const SizedBox(width: 12),
        Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF5B2CFF), Color(0xFF9D4EDD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          child: const Text(
            'DM',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 138,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
