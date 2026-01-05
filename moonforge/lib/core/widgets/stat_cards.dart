import 'package:moonforge/layout/app_spacing.dart';
import 'package:moonforge/layout/design_constants.dart';
import 'package:moonforge/layout/theme.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

enum StateCardAlignment { vertical, horizontal, wrap }

class StateCardData {
  final String title;
  final String value;
  final IconData? icon;
  final Color? color;
  final bool isLoading;

  StateCardData({
    required this.title,
    required this.value,
    this.icon,
    this.color,
    this.isLoading = false,
  });
}

class StatCards extends StatefulWidget {
  const StatCards({
    super.key,
    required this.cards,
    this.minWidth,
    this.stretch = false,
    this.alignment = StateCardAlignment.wrap,
    this.columnsRows = 1,
  });

  final List<StateCardData> cards;
  final double? minWidth;
  final bool stretch;
  final StateCardAlignment alignment;
  final int columnsRows;

  @override
  _StatCardsState createState() => _StatCardsState();
}

class _StatCardsState extends State<StatCards> {
  @override
  Widget build(BuildContext context) {
    if (widget.alignment == StateCardAlignment.vertical) {
      if (widget.columnsRows > 1) {
        // Multi-column layout
        final rows = (widget.cards.length / widget.columnsRows).ceil();
        return Column(
          spacing: AppSpacing.md,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(rows, (rowIndex) {
            final start = rowIndex * widget.columnsRows;
            final end = (start + widget.columnsRows).clamp(
              0,
              widget.cards.length,
            );
            final rowCards = widget.cards.sublist(start, end);
            return Row(
              spacing: AppSpacing.md,
              children: rowCards
                  .map(
                    (cardData) => Expanded(
                      child: StatCard(
                        data: cardData,
                        minWidth: widget.minWidth ?? kStateCardMinWidth,
                        stretch: widget.stretch,
                      ),
                    ),
                  )
                  .toList(),
            );
          }),
        );
      }
      // Single column layout
      return Column(
        spacing: AppSpacing.md,
        mainAxisSize: MainAxisSize.min,
        children: widget.cards
            .map(
              (cardData) => StatCard(
                data: cardData,
                minWidth: widget.minWidth ?? kStateCardMinWidth,
                stretch: widget.stretch,
              ),
            )
            .toList(),
      );
    }
    if (widget.alignment == StateCardAlignment.horizontal) {
      if (widget.columnsRows > 1) {
        // Multi-column layout
        final columns = (widget.cards.length / widget.columnsRows).ceil();
        return Row(
          spacing: AppSpacing.md,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(columns, (rowIndex) {
            final start = rowIndex * widget.columnsRows;
            final end = (start + widget.columnsRows).clamp(
              0,
              widget.cards.length,
            );
            final rowCards = widget.cards.sublist(start, end);
            return Column(
              spacing: AppSpacing.md,
              children: rowCards
                  .map(
                    (cardData) => Expanded(
                      child: StatCard(
                        data: cardData,
                        minWidth: widget.minWidth ?? kStateCardMinWidth,
                        stretch: widget.stretch,
                      ),
                    ),
                  )
                  .toList(),
            );
          }),
        );
      }
      // Single column layout
      return Column(
        spacing: AppSpacing.md,
        mainAxisSize: MainAxisSize.min,
        children: widget.cards
            .map(
              (cardData) => StatCard(
                data: cardData,
                minWidth: widget.minWidth ?? kStateCardMinWidth,
                stretch: widget.stretch,
              ),
            )
            .toList(),
      );
    }
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: widget.cards
          .map(
            (cardData) => StatCard(
              data: cardData,
              minWidth: widget.minWidth ?? kStateCardMinWidth,
            ),
          )
          .toList(),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.data,
    this.minWidth = kStateCardMinWidth,
    this.stretch = false,
  });

  final StateCardData data;
  final double minWidth;
  final bool stretch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (stretch) {
      return Card(
        fillColor: data.color?.withValues(alpha: 0.1),
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(data.value, style: theme.typography.h3),
                Gap(AppSpacing.md),
                if (data.icon != null)
                  Icon(
                    data.icon,
                    color: data.color ?? theme.colorScheme.primary,
                  ),
              ],
            ),
            Text(
              data.title.toUpperCase(),
              style: theme.typography.xSmall.trackingWider,
            ).muted(),
          ],
        ),
      ).asSkeleton(enabled: data.isLoading);
    }

    return Card(
      fillColor: data.color?.withValues(alpha: 0.1),
      padding: AppSpacing.paddingMd,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(data.value, style: theme.typography.h3),
                  Spacer(),
                  if (data.icon != null)
                    Icon(
                      data.icon,
                      color: data.color ?? theme.colorScheme.primary,
                    ),
                ],
              ),
              Text(
                data.title.toUpperCase(),
                style: theme.typography.xSmall.trackingWider,
              ).muted(),
            ],
          ),
        ),
      ),
    ).asSkeleton(enabled: data.isLoading);
  }
}
