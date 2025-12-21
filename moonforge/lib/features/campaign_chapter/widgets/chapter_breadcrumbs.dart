import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ChapterBreadcrumbs extends StatelessWidget {
  const ChapterBreadcrumbs({
    super.key,
    this.rootLabel = 'Campaign',
    required this.campaignLabel,
    required this.chapterLabel,
    this.onRootTap,
    this.onCampaignTap,
    this.isLoading = false,
  });

  final String rootLabel;
  final String campaignLabel;
  final String chapterLabel;
  final VoidCallback? onRootTap;
  final VoidCallback? onCampaignTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _BreadcrumbItem(
          label: rootLabel,
          onTap: onRootTap,
          style: theme.typography.small,
        ),
        Icon(
          Icons.chevron_right,
          size: 16,
          color: theme.colorScheme.mutedForeground,
        ),
        _BreadcrumbItem(
          label: campaignLabel,
          onTap: onCampaignTap,
          style: theme.typography.small,
        ),
        Icon(
          Icons.chevron_right,
          size: 16,
          color: theme.colorScheme.mutedForeground,
        ),
        Text(chapterLabel, style: theme.typography.small),
      ],
    ).asSkeleton(enabled: isLoading);
  }
}

class _BreadcrumbItem extends StatelessWidget {
  const _BreadcrumbItem({
    required this.label,
    required this.style,
    this.onTap,
  });

  final String label;
  final TextStyle style;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = Text(label, style: style).muted();

    if (onTap == null) {
      return child;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(onTap: onTap, child: child),
    );
  }
}
