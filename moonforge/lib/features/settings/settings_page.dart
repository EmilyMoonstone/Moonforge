import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/features/settings/widgets/account_tab.dart';
import 'package:moonforge/features/settings/widgets/generell_tab.dart';
import 'package:moonforge/gen/l10n.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:moonforge/layout/app_layout.dart';

@RoutePage()
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key, this.selectedIndex = 0});

  final int selectedIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late int index = widget.selectedIndex;

  NavigationItem buildButton(String text, IconData icon) {
    // Convenience factory for a selectable navigation item with left alignment
    // and a primary icon style when selected.
    return NavigationItem(
      label: Text(text).small,
      alignment: Alignment.centerLeft,
      selectedStyle: const ButtonStyle.primaryIcon(),
      child: Icon(icon),
    );
  }

  NavigationLabel buildLabel(String label) {
    // Section header used to group related navigation items.
    return NavigationLabel(
      alignment: Alignment.centerLeft,
      child: Text(label).semiBold().muted(),
      // padding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppLayout(
      activeItem: null,
      paddingTop: false,
      paddingBottom: false,
      paddingLeft: false,
      paddingRight: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NavigationRail(
            index: index,
            expanded: true,
            labelType: NavigationLabelType.expanded,
            labelPosition: NavigationLabelPosition.end,
            alignment: NavigationRailAlignment.start,
            onSelected: (int value) {
              setState(() {
                index = value;
              });
            },
            children: [
              NavigationLabel(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 150),
                  child: Text(l10n.settings).large().semiBold(),
                ),
              ),
              buildButton(l10n.general, Icons.settings_outlined),
              buildButton(l10n.account, Icons.person_outline),
            ],
          ),
          const VerticalDivider(),
          Expanded(
            child: IndexedStack(
              index: index,
              children: [const GenerellTab(), const AccountTab()],
            ),
          ),
        ],
      ),
    );
  }
}
