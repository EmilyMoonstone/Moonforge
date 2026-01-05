import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ChapterSidebarSection extends StatelessWidget {
  const ChapterSidebarSection({
    super.key,
    required this.title,
    this.actions = const [],
    this.children = const [],
    this.emptyLabel,
  });

  final String title;
  final List<Widget> actions;
  final List<Widget> children;
  final String? emptyLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title).h4),
            if (actions.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: actions
                    .map(
                      (action) => Padding(
                        padding: AppSpacing.horizontalXs,
                        child: action,
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
        Gap(AppSpacing.sm),
        const Divider(),
        Gap(AppSpacing.sm),
        if (children.isEmpty)
          Text(emptyLabel ?? 'Nothing here yet.').muted()
        else
          Column(
            children: [
              for (final child in children) ...[
                child,
                Gap(AppSpacing.sm),
              ],
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
