import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' show InkWell;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/widgets/card.dart';
import 'package:moonforge/core/widgets/hover_editable.dart';
import 'package:moonforge/core/widgets/icon_button.dart';
import 'package:moonforge/core/widgets/spark_with_ai_button.dart';
import 'package:moonforge/data/database.dart';
import 'package:moonforge/data/stores/chapters.dart';
import 'package:moonforge/gen/assets.gen.dart';
import 'package:moonforge/gen/l10n.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:moonforge/layout/widgets/scroll_view_default.dart';
import 'package:moonforge/routes/app_router.gr.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChaptersList extends ConsumerStatefulWidget {
  const ChaptersList({super.key, required this.campaignId});

  final String? campaignId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChaptersListState();
}

class _ChaptersListState extends ConsumerState<ChaptersList> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final Stream<List<ChaptersTableData>>? chapters = widget.campaignId == null
        ? null
        : ref
              .watch(chaptersRepositoryProvider)
              .watchByCampaignId(widget.campaignId!);

    Widget chapterCard({
      Key? key,
      required int? orderNumber,
      required String chapterId,
      required String title,
      required String description,
      required DateTime updatedAt,
      bool isPlaceholder = false,
    }) {
      return SizedBox(
        key: key,
        height: 168,
        child: CardCustom(
          padding: AppSpacing.paddingMd,
          onTap: () {
          AutoRouter.of(
            context,
          ).push(ChapterRoute(chapterId: chapterId));
        },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(theme.radiusMd),
                child: Assets.images.placeholders.campaign.image(
                  width: 140,
                  fit: BoxFit.cover,
                ),
              ),
              Gap(AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HoverEditableRow(
                      onEdit: () {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'CHAPTER $orderNumber',
                                style: theme.typography.small,
                              ).muted(),
                              Gap(AppSpacing.lg),
                              Icon(
                                Icons.watch_later,
                                size: 16,
                                color:
                                    theme.colorScheme.mutedForeground,
                              ),
                              Gap(AppSpacing.xs),
                              Flexible(
                                child: Text(
                                  'Last updated ${timeago.format(updatedAt)}',
                                  overflow: TextOverflow.ellipsis,
                                ).muted(),
                              ),
                            ],
                          ),
                    
                          Gap(AppSpacing.xs),
                          Text(title).h4,
                        ],
                      ),
                    ),
                    Gap(AppSpacing.sm),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ).muted(),
                    Gap(AppSpacing.sm),
                    Divider(),
                    Gap(AppSpacing.sm),
                    Row(
                      children: [
                        Icon(
                          Icons.explore,
                          size: 16,
                          color: theme.colorScheme.mutedForeground,
                        ),
                        Gap(AppSpacing.xs),
                        Text('0 adventures').muted(),
                        Gap(AppSpacing.lg),
                        Icon(
                          Icons.groups,
                          size: 16,
                          color: theme.colorScheme.mutedForeground,
                        ),
                        Gap(AppSpacing.xs),
                        Text('0 entities').muted(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).asSkeleton(enabled: isPlaceholder),
      );
    }

    Widget placeholderList() {
      return Column(
        children: [
          for (var i = 0; i < 3; i++) ...[
            chapterCard(
              key: ValueKey('chapter-placeholder-$i'),
              orderNumber: i + 1,
              chapterId: 'placeholder-$i',
              title: 'Chapter Title',
              description: 'Chapter description placeholder text.',
              updatedAt: DateTime.now().subtract(const Duration(days: 2)),
              isPlaceholder: true,
            ),
            Gap(AppSpacing.lg),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: AppSpacing.lg,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: TextField(
                placeholder: Text(
                  '${l10n.search} ${l10n.spChapters('plural')}...',
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim().toLowerCase();
                  });
                },
                features: [InputFeature.leading(Icon(Icons.search))],
              ),
            ),
            Spacer(),
            ButtonGroup(
              children: [
                SparkWithAiButton(onPressed: () {}, showLabel: false),
                IconButtonCustom(
                  icon: const Icon(Icons.add),
                  label: '${l10n.newString} ${l10n.spChapters('singular')}',
                  variance: ButtonVariance.secondary,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        Gap(AppSpacing.lg),
        ScrollViewDefault(
          child: chapters == null
              ? placeholderList()
              : StreamBuilder<List<ChaptersTableData>>(
                  stream: chapters,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return placeholderList();
                    }
        
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
        
                    final chapterItems =
                        (snapshot.data ?? [])
                            .where(
                              (chapter) =>
                                  chapter.title.toLowerCase().contains(
                                    _searchQuery,
                                  ) ||
                                  (chapter.description ?? '')
                                      .toLowerCase()
                                      .contains(_searchQuery),
                            )
                            .toList()
                          ..sort((a, b) {
                            final aOrder = a.orderNumber;
                            final bOrder = b.orderNumber;
                            return aOrder.compareTo(bOrder);
                          });
        
                    if (chapterItems.isEmpty) {
                      return Center(
                        child: Text(
                          l10n.noXFound(l10n.spChapters('plural')),
                        ).muted(),
                      );
                    }
        
                    return Column(
                      children: [
                        for (final chapter in chapterItems) ...[
                          chapterCard(
                            key: ValueKey('chapter-${chapter.id}'),
                            orderNumber: chapter.orderNumber,
                            chapterId: chapter.id,
                            title: chapter.title,
                            description:
                                chapter.description ?? 'No description yet.',
                            updatedAt: DateTime.parse(chapter.updatedAt),
                          ),
                          Gap(AppSpacing.lg),
                        ],
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}
