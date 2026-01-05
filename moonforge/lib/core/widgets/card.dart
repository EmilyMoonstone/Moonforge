import 'package:flutter/material.dart' show Material, InkWell;
import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class CardCustom extends StatefulWidget {
  const CardCustom({
    super.key,
    required this.child,
    this.padding,
    this.fillColor,
    this.borderRadius,
    this.clipBehavior,
    this.borderColor,
    this.borderWidth,
    this.boxShadow,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.duration,
    this.onTap,
  });

  /// The child widget to display within the card.
  final Widget child;

  /// Padding inside the card around the [child].
  ///
  /// If `null`, uses default padding from the theme.
  final EdgeInsetsGeometry? padding;

  /// The background fill color of the card.
  ///
  /// Only applies when [filled] is `true`. If `null`, uses theme default.
  final Color? fillColor;

  /// Border radius for rounded corners on the card.
  ///
  /// If `null`, uses default border radius from the theme.
  final BorderRadiusGeometry? borderRadius;

  /// Color of the card's border.
  ///
  /// If `null`, uses default border color from the theme.
  final Color? borderColor;

  /// Width of the card's border in logical pixels.
  ///
  /// If `null`, uses default border width from the theme.
  final double? borderWidth;

  /// How to clip the card's content.
  ///
  /// Controls overflow clipping behavior. If `null`, uses [Clip.none].
  final Clip? clipBehavior;

  /// Box shadows to apply to the card.
  ///
  /// Creates elevation and depth effects. If `null`, no shadows are applied.
  final List<BoxShadow>? boxShadow;

  /// Opacity of the card's surface effect.
  ///
  /// Controls the transparency of surface overlays. If `null`, uses theme default.
  final double? surfaceOpacity;

  /// Blur amount for the card's surface effect.
  ///
  /// Creates a frosted glass or blur effect. If `null`, no blur is applied.
  final double? surfaceBlur;

  /// Duration for card appearance animations.
  ///
  /// Controls how long transitions take when card properties change. If `null`,
  /// uses default animation duration.
  final Duration? duration;

  /// Callback when the card is tapped.
  ///
  /// If `null`, the card is not tappable.
  final VoidCallback? onTap;

  @override
  _CardCustomState createState() => _CardCustomState();
}

class _CardCustomState extends State<CardCustom> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color _currentFilledColor = widget.fillColor ?? theme.colorScheme.card;
    return Card(
      key: widget.key,
      padding: EdgeInsets.zero,
      fillColor: _currentFilledColor,
      borderRadius: widget.borderRadius,
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
      boxShadow: widget.boxShadow,
      surfaceOpacity: widget.surfaceOpacity,
      surfaceBlur: widget.surfaceBlur,
      duration: widget.duration,
      clipBehavior: widget.clipBehavior,
      child: Material(
        color: Colors.transparent,
        borderRadius: theme.borderRadiusLg,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: theme.borderRadiusLg,
          onTap: widget.onTap,
          child: Padding(
            padding: widget.padding ?? EdgeInsets.all(AppSpacing.sm),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
