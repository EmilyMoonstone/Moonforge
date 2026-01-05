import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ChapterContentCard extends StatelessWidget {
  const ChapterContentCard({
    super.key,
    this.isLoading = false,
    this.onEdit,
    this.onFocusMode,
  });

  final bool isLoading;
  final VoidCallback? onEdit;
  final VoidCallback? onFocusMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.paddingLg,
            child: Row(
              children: [
                Icon(Icons.menu_book, color: theme.colorScheme.primary),
                Gap(AppSpacing.sm),
                Text('Chapter Chronicles', style: theme.typography.h4),
                const Spacer(),
                Button(
                  style: ButtonStyle.outline(),
                  leading: const Icon(Icons.open_in_full),
                  onPressed: onFocusMode,
                  child: const Text('Focus Mode'),
                ),
                Gap(AppSpacing.sm),
                IconButton(
                  variance: ButtonVariance.ghost,
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: AppSpacing.paddingLg,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 260),
              padding: AppSpacing.paddingLg,
              decoration: BoxDecoration(
                color: theme.colorScheme.muted.withOpacity(0.1),
                borderRadius: BorderRadius.circular(theme.radiusLg),
                border: Border.all(color: theme.colorScheme.border),
              ),
              child: Text(
                'Chapter content editor will live here. Replace this placeholder with the markdown viewer when ready.',
              ).muted(),
            ),
          ),
        ],
      ),
    ).asSkeleton(enabled: isLoading);
  }
}
