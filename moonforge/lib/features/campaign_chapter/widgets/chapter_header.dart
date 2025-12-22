import 'package:moonforge/core/widgets/hover_editable.dart';
import 'package:moonforge/data/database.dart';
import 'package:moonforge/gen/l10n.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChapterHeader extends StatelessWidget {
  const ChapterHeader({
    super.key,
    required this.chapter,
    this.isLoading = false,
    this.onEditTitle,
    this.onEditDescription,
  });

  final ChaptersTableData? chapter;
  final bool isLoading;
  final VoidCallback? onEditTitle;
  final VoidCallback? onEditDescription;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final title = chapter?.title ?? 'Chapter Title';
    final description =
        chapter?.description ?? 'Add a short summary for this chapter.';
    final updatedAt = chapter == null
        ? null
        : DateTime.tryParse(chapter!.updatedAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HoverEditableRow(
          onEdit: onEditTitle,
          tooltip: 'Edit chapter title',
          child: Text(
            '${l10n.spChapters('singular')} ${chapter?.orderNumber}: $title',
            style: theme.typography.h2,
          ),
        ),
        Gap(AppSpacing.sm),
        Row(
          children: [
            Icon(
              Icons.watch_later,
              size: 16,
              color: theme.colorScheme.mutedForeground,
            ),
            Gap(AppSpacing.xs),
            Text(
              updatedAt == null
                  ? 'Last edited recently'
                  : 'Last edited ${timeago.format(updatedAt)}',
            ).muted(),
          ],
        ),
        Gap(AppSpacing.md),
        HoverEditableRow(
          onEdit: onEditDescription,
          tooltip: 'Edit chapter description',
          child: Text(description).muted(),
        ),
      ],
    ).asSkeleton(enabled: isLoading);
  }
}
