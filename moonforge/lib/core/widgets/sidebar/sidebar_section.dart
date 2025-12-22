import 'package:moonforge/core/widgets/spark_with_ai_button.dart';
import 'package:moonforge/gen/l10n.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:moonforge/layout/theme.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SidebarSection extends StatelessWidget {
  const SidebarSection({
    super.key,
    required this.title,
    this.icon,
    this.onSparkWithAi,
    this.onNew,
    this.actions,
    this.children = const [],
    this.emptyLabel,
    this.onNewLabel,
  });

  final String title;
  final IconData? icon;
  final VoidCallback? onSparkWithAi;
  final VoidCallback? onNew;
  final String? onNewLabel;
  final List<Widget>? actions;
  final List<Widget> children;
  final String? emptyLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[Icon(icon, size: 16), Gap(AppSpacing.xs)],
            Expanded(
              child: Text(
                title.toUpperCase(),
                style: theme.typography.small.trackingWider,
              ).muted().bold(),
            ),
            if (actions?.isNotEmpty ?? false)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!
                    .map(
                      (action) => Padding(
                        padding: AppSpacing.horizontalXs,
                        child: action,
                      ),
                    )
                    .toList(),
              ),
            if (onSparkWithAi != null)
              SparkWithAiButton(onPressed: onSparkWithAi!),
            if (onNew != null)
              Tooltip(
                tooltip: TooltipContainer(
                  child: Text('${l10n.newString} ${onNewLabel ?? ''}'),
                ).call,
                child: IconButton(
                  variance: ButtonVariance.ghost,
                  icon: const Icon(Icons.add),
                  onPressed: onNew,
                ),
              ),
          ],
        ),
        const Divider(),
        Gap(AppSpacing.md),
        if (children.isEmpty)
          Text(emptyLabel ?? 'Nothing here yet.').muted()
        else
          Column(
            children: [
              for (final child in children) ...[child, Gap(AppSpacing.sm)],
            ],
          ),
      ],
    );
  }
}

class ChapterListItem extends StatelessWidget {
  const ChapterListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        padding: AppSpacing.paddingSm,
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: theme.colorScheme.primary),
              Gap(AppSpacing.sm),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.typography.base),
                  if (subtitle != null) ...[
                    Gap(AppSpacing.xs),
                    Text(subtitle!).muted(),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: theme.colorScheme.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}
