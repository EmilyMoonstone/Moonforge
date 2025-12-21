import 'package:moonforge/data/database.dart';
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
    final title = chapter?.title ?? 'Chapter Title';
    final description =
        chapter?.description ?? 'Add a short summary for this chapter.';
    final updatedAt =
        chapter == null ? null : DateTime.tryParse(chapter!.updatedAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HoverEditableRow(
          onEdit: onEditTitle,
          tooltip: 'Edit chapter title',
          child: Text(title, style: theme.typography.h2),
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

class HoverEditableRow extends StatefulWidget {
  const HoverEditableRow({
    super.key,
    required this.child,
    this.onEdit,
    this.tooltip,
  });

  final Widget child;
  final VoidCallback? onEdit;
  final String? tooltip;

  @override
  State<HoverEditableRow> createState() => _HoverEditableRowState();
}

class _HoverEditableRowState extends State<HoverEditableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: widget.child),
          AnimatedOpacity(
            opacity: _isHovered ? 1 : 0,
            duration: const Duration(milliseconds: 150),
            child: IgnorePointer(
              ignoring: !_isHovered,
              child: Tooltip(
                tooltip: TooltipContainer(child: Text(widget.tooltip ?? 'Edit')).call,
                child: IconButton(
                  variance: ButtonVariance.ghost,
                  icon: const Icon(Icons.edit),
                  onPressed: widget.onEdit,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
