import 'package:shadcn_flutter/shadcn_flutter.dart';

class IconButtonCustom extends StatelessWidget {
  const IconButtonCustom({
    super.key,
    required this.icon,
    this.label,
    required this.variance,
    this.onPressed,
    this.enabled,
    this.leading,
    this.trailing,
    this.alignment,
    this.size = ButtonSize.normal,
    this.density = ButtonDensity.icon,
    this.shape = ButtonShape.rectangle,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
    this.enableFeedback,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onTertiaryTapDown,
    this.onTertiaryTapUp,
    this.onTertiaryTapCancel,
    this.onLongPressStart,
    this.onLongPressUp,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.onSecondaryLongPress,
    this.onTertiaryLongPress,
  });

  /// The icon widget to display in the button.
  final Widget icon;

  /// Called when the button is pressed. If `null`, the button is disabled.
  final VoidCallback? onPressed;

  /// Label for tooltips and accessibility.
  final String? label;

  /// Whether the button is enabled. Overrides the `onPressed` check if provided.
  final bool? enabled;

  /// Widget displayed before the [icon].
  final Widget? leading;

  /// Widget displayed after the [icon].
  final Widget? trailing;

  /// Alignment of the button's content.
  final AlignmentGeometry? alignment;

  /// Size variant of the button (defaults to [ButtonSize.normal]).
  final ButtonSize size;

  /// Density variant affecting spacing (defaults to [ButtonDensity.icon]).
  final ButtonDensity density;

  /// Shape of the button (defaults to [ButtonShape.rectangle]).
  final ButtonShape shape;

  /// Focus node for keyboard focus management.
  final FocusNode? focusNode;

  /// Whether to disable style transition animations (defaults to `false`).
  final bool disableTransition;

  /// Called when hover state changes.
  final ValueChanged<bool>? onHover;

  /// Called when focus state changes.
  final ValueChanged<bool>? onFocus;

  /// Whether to enable haptic/audio feedback.
  final bool? enableFeedback;

  /// Called when primary tap down occurs.
  final GestureTapDownCallback? onTapDown;

  /// Called when primary tap up occurs.
  final GestureTapUpCallback? onTapUp;

  /// Called when primary tap is cancelled.
  final GestureTapCancelCallback? onTapCancel;

  /// Called when secondary tap down occurs.
  final GestureTapDownCallback? onSecondaryTapDown;

  /// Called when secondary tap up occurs.
  final GestureTapUpCallback? onSecondaryTapUp;

  /// Called when secondary tap is cancelled.
  final GestureTapCancelCallback? onSecondaryTapCancel;

  /// Called when tertiary tap down occurs.
  final GestureTapDownCallback? onTertiaryTapDown;

  /// Called when tertiary tap up occurs.
  final GestureTapUpCallback? onTertiaryTapUp;

  /// Called when tertiary tap is cancelled.
  final GestureTapCancelCallback? onTertiaryTapCancel;

  /// Called when long press starts.
  final GestureLongPressStartCallback? onLongPressStart;

  /// Called when long press is released.
  final GestureLongPressUpCallback? onLongPressUp;

  /// Called when long press moves.
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;

  /// Called when long press ends.
  final GestureLongPressEndCallback? onLongPressEnd;

  /// Called when secondary long press completes.
  final GestureLongPressUpCallback? onSecondaryLongPress;

  /// Called when tertiary long press completes.
  final GestureLongPressUpCallback? onTertiaryLongPress;

  /// The button style variant to apply.
  final AbstractButtonStyle variance;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      tooltip: TooltipContainer(child: Text(label ?? 'Action button')).call,
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
        enabled: enabled,
        leading: leading,
        trailing: trailing,
        alignment: alignment,
        size: size,
        density: density,
        shape: shape,
        focusNode: focusNode,
        disableTransition: disableTransition,
        onHover: onHover,
        onFocus: onFocus,
        enableFeedback: enableFeedback,
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTapCancel: onTapCancel,
        onSecondaryTapDown: onSecondaryTapDown,
        onSecondaryTapUp: onSecondaryTapUp,
        onSecondaryTapCancel: onSecondaryTapCancel,
        onTertiaryTapDown: onTertiaryTapDown,
        onTertiaryTapUp: onTertiaryTapUp,
        onTertiaryTapCancel: onTertiaryTapCancel,
        onLongPressStart: onLongPressStart,
        onLongPressUp: onLongPressUp,
        onLongPressMoveUpdate: onLongPressMoveUpdate,
        onLongPressEnd: onLongPressEnd,
        onSecondaryLongPress: onSecondaryLongPress,
        onTertiaryLongPress: onTertiaryLongPress,
        variance: variance,
      ),
    );
  }
}
