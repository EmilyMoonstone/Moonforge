import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class AdventureCard extends StatelessWidget {
  const AdventureCard({
    super.key,
    required this.title,
    required this.orderNumber,
    this.description,
    this.updatedAt,
    this.onTap,
  });

  final String title;
  final String orderNumber;
  final String? description;
  final DateTime? updatedAt;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: theme.typography.h4)),
                Icon(
                  Icons.more_horiz,
                  size: 18,
                  color: theme.colorScheme.mutedForeground,
                ),
              ],
            ),
            Gap(AppSpacing.xs),
            Text('Adventure $orderNumber').muted(),
            if (description != null) ...[
              Gap(AppSpacing.sm),
              Text(
                description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ).muted(),
            ],
            if (updatedAt != null) ...[
              Gap(AppSpacing.sm),
              Row(
                children: [
                  Icon(
                    Icons.watch_later,
                    size: 14,
                    color: theme.colorScheme.mutedForeground,
                  ),
                  Gap(AppSpacing.xs),
                  Text('Updated ${timeago.format(updatedAt!)}').muted(),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
