import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ButtonSwitchAction {
  const ButtonSwitchAction({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;
}

class ButtonSwitch extends ConsumerStatefulWidget {
  const ButtonSwitch({
    super.key,
    required this.actions,
    this.onChanged,
    this.index = 0,
    this.onCard = true,
    this.highlightStyle = const ButtonStyle.primary(),
  });

  final List<ButtonSwitchAction> actions;
  final ValueChanged<int>? onChanged;
  final int? index;
  final bool onCard;
  final AbstractButtonStyle highlightStyle;

  @override
  ConsumerState<ButtonSwitch> createState() => _ButtonSwitchState();
}

class _ButtonSwitchState extends ConsumerState<ButtonSwitch> {
  int index = 0;

  void _onPressed(int newIndex) {
    setState(() {
      index = newIndex;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(newIndex);
    }
    widget.actions[newIndex].onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = widget.index;
    final theme = Theme.of(context);

    Widget buttons = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.xs,
      children: [
        for (var i = 0; i < widget.actions.length; i++)
          Flexible(
            child: Button(
              style: selectedIndex == i
                  ? switch (widget.highlightStyle) {
                      ButtonStyle.primary => ButtonStyle.primary(
                        density: ButtonDensity.dense,
                      ),
                      ButtonStyle.secondary => ButtonStyle.secondary(
                        density: ButtonDensity.dense,
                      ),
                      ButtonStyle.ghost => ButtonStyle.ghost(
                        density: ButtonDensity.dense,
                      ),
                      _ => ButtonStyle.secondary(density: ButtonDensity.dense),
                    }
                  : ButtonStyle.ghost(density: ButtonDensity.dense),
              onPressed: () => _onPressed(i),
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                child: selectedIndex == i
                    ? Text(widget.actions[i].label)
                    : Text(widget.actions[i].label).muted,
              ),
            ),
          ),
      ],
    );

    return widget.onCard
        ? Card(padding: AppSpacing.paddingXs, child: buttons)
        : buttons;
  }
}
