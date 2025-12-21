import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/providers/campaign.dart';
import 'package:moonforge/data/database.dart';
import 'package:moonforge/data/stores/adventures.dart';
import 'package:moonforge/data/stores/campaign.dart';
import 'package:moonforge/data/stores/chapters.dart';
import 'package:moonforge/features/campaign_chapter/widgets/adventure_card.dart';
import 'package:moonforge/features/campaign_chapter/widgets/chapter_breadcrumbs.dart';
import 'package:moonforge/features/campaign_chapter/widgets/chapter_content_card.dart';
import 'package:moonforge/features/campaign_chapter/widgets/chapter_header.dart';
import 'package:moonforge/features/campaign_chapter/widgets/chapter_sidebar_section.dart';
import 'package:moonforge/features/campaign_chapter/widgets/chapter_stat_cards.dart';
import 'package:moonforge/gen/l10n.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:moonforge/routes/app_router.gr.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

@RoutePage()
class CampaignChapterPage extends ConsumerStatefulWidget {
  const CampaignChapterPage({super.key, required this.chapterId});

  final String chapterId;

  @override
  ConsumerState<CampaignChapterPage> createState() =>
      _CampaignChapterPageState();
}

class _CampaignChapterPageState extends ConsumerState<CampaignChapterPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final router = AutoRouter.of(context);
    final String? campaignId = ref.watch(currentCampaignIdProvider);
    final campaigns = ref.watch(campaignProvider);
    final chapters = ref.watch(chaptersProvider);
    final adventures = ref.watch(adventuresProvider);
    final chapter = _findChapter(chapters.value, widget.chapterId);
    final campaign = _findCampaign(campaigns.value, campaignId);
    final chapterAdventures = _filterAdventures(
      adventures.value,
      widget.chapterId,
    );
    final bool isLoading =
        campaigns.isLoading || chapters.isLoading || adventures.isLoading;

    if (campaigns.hasError) {
      return Text('Error: ${campaigns.error}');
    }

    if (chapters.hasError) {
      return Text('Error: ${chapters.error}');
    }

    if (adventures.hasError) {
      return Text('Error: ${adventures.error}');
    }

    if (campaignId == null) {
      return Center(child: const Text('No campaign found.').muted());
    }

    if (!isLoading && campaign == null) {
      return Center(child: const Text('No campaign found.').muted());
    }

    if (!isLoading && chapter == null) {
      return Center(child: const Text('No chapter found.').muted());
    }

    final leftColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChapterHeader(
          chapter: chapter,
          isLoading: isLoading,
          onEditTitle: () {},
          onEditDescription: () {},
        ),
        Gap(AppSpacing.xl),
        ChapterContentCard(
          isLoading: isLoading,
          onEdit: () {},
          onFocusMode: () {},
        ),
      ],
    );

    final rightColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChapterStatCards(
          adventuresCount: chapterAdventures.length,
          entitiesCount: 0,
          isLoading: isLoading,
        ),
        Gap(AppSpacing.lg),
        ChapterSidebarSection(
          title: l10n.spAdventures('plural'),
          actions: [
            Tooltip(
              tooltip: TooltipContainer(child: Text(l10n.sparkWithAI)).call,
              child: IconButton(
                variance: ButtonVariance.ghost,
                icon: const Icon(Icons.auto_awesome),
                onPressed: () {},
              ),
            ),
            Tooltip(
              tooltip: TooltipContainer(
                child: Text(
                  '${l10n.newString} ${l10n.spAdventures('singular')}',
                ),
              ).call,
              child: IconButton(
                variance: ButtonVariance.ghost,
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
            ),
          ],
          emptyLabel: l10n.noXFound(l10n.spAdventures('plural')),
          children: _buildAdventureCards(
            chapterAdventures,
            isLoading,
          ),
        ),
        Gap(AppSpacing.lg),
        ChapterSidebarSection(
          title: 'Locations',
          actions: [
            Tooltip(
              tooltip: TooltipContainer(child: Text(l10n.sparkWithAI)).call,
              child: IconButton(
                variance: ButtonVariance.ghost,
                icon: const Icon(Icons.auto_awesome),
                onPressed: () {},
              ),
            ),
            Tooltip(
              tooltip:
                  TooltipContainer(child: Text('${l10n.newString} Location'))
                      .call,
              child: IconButton(
                variance: ButtonVariance.ghost,
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
            ),
          ],
          emptyLabel: 'No locations linked yet.',
          children: _buildPlaceholderItems(
            isLoading,
            icon: Icons.location_on,
          ),
        ),
        Gap(AppSpacing.lg),
        ChapterSidebarSection(
          title: 'NPCs',
          actions: [
            Tooltip(
              tooltip: TooltipContainer(child: Text(l10n.sparkWithAI)).call,
              child: IconButton(
                variance: ButtonVariance.ghost,
                icon: const Icon(Icons.auto_awesome),
                onPressed: () {},
              ),
            ),
            Tooltip(
              tooltip: TooltipContainer(child: Text('${l10n.newString} NPC'))
                  .call,
              child: IconButton(
                variance: ButtonVariance.ghost,
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
            ),
          ],
          emptyLabel: 'No NPCs linked yet.',
          children: _buildPlaceholderItems(
            isLoading,
            icon: Icons.person,
          ),
        ),
        Gap(AppSpacing.lg),
        ChapterSidebarSection(
          title: 'Organizations',
          actions: [
            Tooltip(
              tooltip: TooltipContainer(child: Text(l10n.sparkWithAI)).call,
              child: IconButton(
                variance: ButtonVariance.ghost,
                icon: const Icon(Icons.auto_awesome),
                onPressed: () {},
              ),
            ),
            Tooltip(
              tooltip:
                  TooltipContainer(
                    child: Text('${l10n.newString} Organization'),
                  ).call,
              child: IconButton(
                variance: ButtonVariance.ghost,
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
            ),
          ],
          emptyLabel: 'No organizations linked yet.',
          children: _buildPlaceholderItems(
            isLoading,
            icon: Icons.apartment,
          ),
        ),
        Gap(AppSpacing.lg),
        ChapterSidebarSection(
          title: 'Other Content',
          actions: [
            Tooltip(
              tooltip: TooltipContainer(child: Text(l10n.sparkWithAI)).call,
              child: IconButton(
                variance: ButtonVariance.ghost,
                icon: const Icon(Icons.auto_awesome),
                onPressed: () {},
              ),
            ),
            Tooltip(
              tooltip: TooltipContainer(child: Text('${l10n.newString} Content'))
                  .call,
              child: IconButton(
                variance: ButtonVariance.ghost,
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
            ),
          ],
          emptyLabel: 'No content linked yet.',
          children: _buildPlaceholderItems(
            isLoading,
            icon: Icons.extension,
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChapterBreadcrumbs(
          rootLabel: l10n.spCampaigns('plural'),
          campaignLabel: campaign?.title ?? 'Campaign',
          chapterLabel: chapter?.title ?? 'Chapter',
          onRootTap: () => router.push(const DashboardRoute()),
          onCampaignTap: () => router.push(const CampaignOverviewRoute()),
          isLoading: isLoading,
        ),
        Gap(AppSpacing.lg),
        LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 1100;
            if (isCompact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  leftColumn,
                  Gap(AppSpacing.xl),
                  rightColumn,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: leftColumn),
                Gap(AppSpacing.xl),
                SizedBox(width: 360, child: rightColumn),
              ],
            );
          },
        ),
      ],
    );
  }
}

List<AdventuresTableData> _filterAdventures(
  List<AdventuresTableData>? adventures,
  String chapterId,
) {
  if (adventures == null) {
    return [];
  }

  final items =
      adventures.where((adventure) => adventure.chapterId == chapterId).toList()
        ..sort((a, b) {
          final aOrder = int.tryParse(a.orderNumber) ?? 0;
          final bOrder = int.tryParse(b.orderNumber) ?? 0;
          return aOrder.compareTo(bOrder);
        });

  return items;
}

List<Widget> _buildAdventureCards(
  List<AdventuresTableData> adventures,
  bool isLoading,
) {
  if (isLoading) {
    return [
      const AdventureCard(
        title: 'Adventure Title',
        orderNumber: '1',
        description: 'Adventure summary placeholder.',
      ).asSkeleton(enabled: true),
      const AdventureCard(
        title: 'Adventure Title',
        orderNumber: '2',
        description: 'Adventure summary placeholder.',
      ).asSkeleton(enabled: true),
    ];
  }

  return adventures
      .map(
        (adventure) => AdventureCard(
          title: adventure.title,
          orderNumber: adventure.orderNumber,
          description: adventure.description ?? 'No description yet.',
          updatedAt: DateTime.tryParse(adventure.updatedAt),
          onTap: () {},
        ),
      )
      .toList();
}

List<Widget> _buildPlaceholderItems(
  bool isLoading, {
  required IconData icon,
}) {
  if (isLoading) {
    return [
      ChapterListItem(
        title: 'Loading...',
        subtitle: 'Fetching linked content.',
        icon: icon,
      ).asSkeleton(enabled: true),
    ];
  }

  return [];
}

CampaignsTableData? _findCampaign(
  List<CampaignsTableData>? campaigns,
  String? campaignId,
) {
  if (campaignId == null || campaigns == null) {
    return null;
  }

  for (final campaign in campaigns) {
    if (campaign.id == campaignId) {
      return campaign;
    }
  }

  return null;
}

ChaptersTableData? _findChapter(
  List<ChaptersTableData>? chapters,
  String chapterId,
) {
  if (chapters == null) {
    return null;
  }

  for (final chapter in chapters) {
    if (chapter.id == chapterId) {
      return chapter;
    }
  }

  return null;
}
