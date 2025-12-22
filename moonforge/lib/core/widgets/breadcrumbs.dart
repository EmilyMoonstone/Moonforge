import 'package:flutter/material.dart' show InkWell;
import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class BreadcrumbItemData {
  final String label;
  final VoidCallback? onTap;

  BreadcrumbItemData({required this.label, this.onTap});
}

class Breadcrumbs extends StatelessWidget {
  const Breadcrumbs({
    super.key,
    required this.items,
    this.isLoading = false,
    this.padding = const EdgeInsetsGeometry.only(
      left: 0,
      right: 0,
      top: 0,
      bottom: AppSpacing.lg,
    ),
  });

  final List<BreadcrumbItemData> items;
  final bool isLoading;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = _resolveLayout(context, constraints.maxWidth);
          final children = <Widget>[];

          void addSegment(Widget segment) {
            if (children.isNotEmpty) {
              children.add(const SizedBox(width: AppSpacing.sm));
            }
            children.add(segment);
          }

          void addSeparator() {
            addSegment(Text('/').muted());
          }

          if (!layout.hasOverflow) {
            for (var i = 0; i < items.length; i++) {
              addSegment(
                _BreadcrumbItem(
                  label: items[i].label,
                  lastItem: i == items.length - 1,
                  onTap: items[i].onTap,
                ),
              );
              if (i < items.length - 1) {
                addSeparator();
              }
            }
          } else {
            final overflowStart = layout.overflowStart ?? 1;
            final hiddenItems = items.sublist(1, overflowStart);

            addSegment(
              _BreadcrumbItem(
                label: items.first.label,
                lastItem: false,
                onTap: items.first.onTap,
              ),
            );
            addSeparator();
            addSegment(_BreadcrumbOverflowButton(hiddenItems: hiddenItems));
            addSeparator();

            for (var i = overflowStart; i < items.length; i++) {
              addSegment(
                _BreadcrumbItem(
                  label: items[i].label,
                  lastItem: i == items.length - 1,
                  onTap: items[i].onTap,
                ),
              );
              if (i < items.length - 1) {
                addSeparator();
              }
            }
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          );
        },
      ).asSkeleton(enabled: isLoading),
    );
  }

  _BreadcrumbLayout _resolveLayout(BuildContext context, double maxWidth) {
    if (items.length <= 2 || maxWidth.isInfinite || maxWidth <= 0) {
      return const _BreadcrumbLayout();
    }

    final textStyle = DefaultTextStyle.of(context).style;
    final textDirection = Directionality.of(context);
    final itemWidths = [
      for (final item in items)
        _measureTextWidth(item.label, textStyle, textDirection),
    ];
    final separatorWidth = _measureTextWidth('/', textStyle, textDirection);
    final ellipsisWidth = _measureTextWidth('...', textStyle, textDirection);
    final segmentsCount = items.length + (items.length - 1);
    final fullWidth =
        _sumWidths(itemWidths) +
        (separatorWidth * (items.length - 1)) +
        (AppSpacing.sm * (segmentsCount - 1));

    if (fullWidth <= maxWidth) {
      return const _BreadcrumbLayout();
    }

    var tailStart = items.length - 1;
    for (var candidate = items.length - 2; candidate >= 1; candidate--) {
      final candidateWidth = _collapsedWidth(
        tailStart: candidate,
        itemWidths: itemWidths,
        separatorWidth: separatorWidth,
        ellipsisWidth: ellipsisWidth,
        gap: AppSpacing.sm,
      );
      if (candidateWidth <= maxWidth) {
        tailStart = candidate;
      } else {
        break;
      }
    }

    return _BreadcrumbLayout(overflowStart: tailStart);
  }
}

class _BreadcrumbItem extends StatelessWidget {
  const _BreadcrumbItem({
    required this.label,
    this.lastItem = false,
    this.onTap,
  });

  final String label;
  final bool lastItem;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: lastItem ? Text(label) : Text(label).muted(),
    );
  }
}

class _BreadcrumbOverflowButton extends StatelessWidget {
  const _BreadcrumbOverflowButton({required this.hiddenItems});

  final List<BreadcrumbItemData> hiddenItems;

  void _showOverflow(BuildContext context) {
    if (hiddenItems.isEmpty) {
      return;
    }

    final theme = Theme.of(context);
    showPopover(
      context: context,
      alignment: Alignment.topCenter,
      offset: const Offset(0, 8),
      overlayBarrier: OverlayBarrier(borderRadius: theme.borderRadiusLg),
      builder: (context) {
        return ModalContainer(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 200, maxWidth: 320),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final item in hiddenItems)
                  GhostButton(
                    density: ButtonDensity.compact,
                    onPressed: item.onTap == null
                        ? null
                        : () {
                            closeOverlay(context);
                            item.onTap?.call();
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      child: Text(item.label),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (hiddenItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () => _showOverflow(context),
      child: Text('...').muted(),
    );
  }
}

class _BreadcrumbLayout {
  const _BreadcrumbLayout({this.overflowStart});

  final int? overflowStart;

  bool get hasOverflow => overflowStart != null;
}

double _collapsedWidth({
  required int tailStart,
  required List<double> itemWidths,
  required double separatorWidth,
  required double ellipsisWidth,
  required double gap,
}) {
  final tailCount = itemWidths.length - tailStart;
  final segmentsCount = 3 + (2 * tailCount);
  final separatorsWidth = separatorWidth * (tailCount + 1);

  return itemWidths.first +
      ellipsisWidth +
      _sumWidths(itemWidths.sublist(tailStart)) +
      separatorsWidth +
      (gap * (segmentsCount - 1));
}

double _sumWidths(Iterable<double> widths) {
  return widths.fold(0.0, (total, value) => total + value);
}

double _measureTextWidth(
  String text,
  TextStyle style,
  TextDirection textDirection,
) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: textDirection,
    maxLines: 1,
  )..layout();

  return painter.width;
}
