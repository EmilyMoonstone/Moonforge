import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/providers/campaign.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/content_view.dart';
import 'package:moonforge/data/ref_extensions.dart';
import 'package:moonforge/core/widgets/breadcrumbs.dart';
import 'package:moonforge/core/widgets/sidebar/sidebar_section.dart';
import 'package:moonforge/core/widgets/sidebar/sidebar_section_item.dart';
import 'package:moonforge/core/widgets/stat_cards.dart';
import 'package:moonforge/data/database.dart';
import 'package:moonforge/data/stores/stores.dart';
import 'package:moonforge/features/chapter/widgets/chapter_content_card.dart';
import 'package:moonforge/features/chapter/widgets/chapter_header.dart';
import 'package:moonforge/gen/assets.gen.dart';
import 'package:moonforge/gen/l10n.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:moonforge/layout/icons.dart';
import 'package:moonforge/layout/widgets/scroll_view_default.dart';
import 'package:moonforge/layout/widgets/two_pane.dart';
import 'package:moonforge/routes/app_router.gr.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:moonforge/data/ref_extensions.dart';

@RoutePage()
class ChapterPage extends ConsumerStatefulWidget {
  const ChapterPage({super.key, required this.chapterId});

  final String chapterId;

  @override
  ConsumerState<ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends ConsumerState<ChapterPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final router = AutoRouter.of(context);
    final String? campaignId = ref.watch(currentCampaignIdProvider);

    if (campaignId == null) {
      return Center(child: const Text('No campaign found.').muted());
    }

    final campaignStream = ref
        .watch(campaignRepositoryProvider)
        .watchAll()
        .map((campaigns) => _findCampaign(campaigns, campaignId));
    final chapterStream = ref
        .watch(chaptersRepositoryProvider)
        .watchAll()
        .map((chapters) => _findChapter(chapters, widget.chapterId));
    final adventuresStream = ref
        .watch(adventuresRepositoryProvider)
        .watchByChapterId(widget.chapterId);
    final locationsStream = ref.watchByScopes(
      chapterId: widget.chapterId,
      watchByScopes: (scopeIds) =>
          ref.watch(locationsRepositoryProvider).watchByScopes(scopeIds),
    );
    final npcsStream = ref.watchByScopes(
      chapterId: widget.chapterId,
      watchByScopes: (scopeIds) => ref
          .watch(creaturesRepositoryProvider)
          .watchByScopes(scopeIds)
          .whereKind('npc'),
    );
    final otherCreaturesStream = ref.watchByScopes(
      chapterId: widget.chapterId,
      watchByScopes: (scopeIds) => ref
          .watch(creaturesRepositoryProvider)
          .watchByScopes(scopeIds)
          .whereNotKind('npc'),
    );
    final organizationsStream = ref.watchByScopes(
      chapterId: widget.chapterId,
      watchByScopes: (scopeIds) =>
          ref.watch(organizationsRepositoryProvider).watchByScopes(scopeIds),
    );
    final itemsStream = ref.watchByScopes(
      chapterId: widget.chapterId,
      watchByScopes: (scopeIds) =>
          ref.watch(itemsRepositoryProvider).watchByScopes(scopeIds),
    );

    return StreamBuilder3<
      CampaignsTableData?,
      ChaptersTableData?,
      List<AdventuresTableData>
    >(
      streams: StreamTuple3(campaignStream, chapterStream, adventuresStream),
      initialData: InitialDataTuple3(null, null, const <AdventuresTableData>[]),
      builder: (context, snapshots) {
        final campaign = snapshots.snapshot1.data;
        final chapter = snapshots.snapshot2.data;
        final chapterAdventures = _filterAdventures(
          snapshots.snapshot3.data,
          widget.chapterId,
        );
        final bool isLoading =
            snapshots.snapshot1.connectionState == ConnectionState.waiting ||
            snapshots.snapshot2.connectionState == ConnectionState.waiting ||
            snapshots.snapshot3.connectionState == ConnectionState.waiting;

        if (snapshots.snapshot1.hasError) {
          return _logAndBuildStreamError(
            label: 'campaignStream',
            error: snapshots.snapshot1.error,
            stackTrace: snapshots.snapshot1.stackTrace,
          );
        }

        if (snapshots.snapshot2.hasError) {
          return _logAndBuildStreamError(
            label: 'chapterStream',
            error: snapshots.snapshot2.error,
            stackTrace: snapshots.snapshot2.stackTrace,
          );
        }

        if (snapshots.snapshot3.hasError) {
          return _logAndBuildStreamError(
            label: 'adventuresStream',
            error: snapshots.snapshot3.error,
            stackTrace: snapshots.snapshot3.stackTrace,
          );
        }

        if (!isLoading && campaign == null) {
          return Center(child: const Text('No campaign found.').muted());
        }

        if (!isLoading && chapter == null) {
          return Center(child: const Text('No chapter found.').muted());
        }

        return StreamBuilder5<
          List<LocationsTableData>,
          List<CreaturesTableData>,
          List<CreaturesTableData>,
          List<OrganizationsTableData>,
          List<ItemsTableData>
        >(
          streams: StreamTuple5(
            locationsStream,
            npcsStream,
            otherCreaturesStream,
            organizationsStream,
            itemsStream,
          ),
          initialData: InitialDataTuple5(
            const <LocationsTableData>[],
            const <CreaturesTableData>[],
            const <CreaturesTableData>[],
            const <OrganizationsTableData>[],
            const <ItemsTableData>[],
          ),
          builder: (context, entitySnapshots) {
            if (entitySnapshots.snapshot1.hasError) {
              return _logAndBuildStreamError(
                label: 'locationsStream',
                error: entitySnapshots.snapshot1.error,
                stackTrace: entitySnapshots.snapshot1.stackTrace,
              );
            }

            if (entitySnapshots.snapshot2.hasError) {
              return _logAndBuildStreamError(
                label: 'npcsStream',
                error: entitySnapshots.snapshot2.error,
                stackTrace: entitySnapshots.snapshot2.stackTrace,
              );
            }

            if (entitySnapshots.snapshot3.hasError) {
              return _logAndBuildStreamError(
                label: 'otherCreaturesStream',
                error: entitySnapshots.snapshot3.error,
                stackTrace: entitySnapshots.snapshot3.stackTrace,
              );
            }

            if (entitySnapshots.snapshot4.hasError) {
              return _logAndBuildStreamError(
                label: 'organizationsStream',
                error: entitySnapshots.snapshot4.error,
                stackTrace: entitySnapshots.snapshot4.stackTrace,
              );
            }

            if (entitySnapshots.snapshot5.hasError) {
              return _logAndBuildStreamError(
                label: 'itemsStream',
                error: entitySnapshots.snapshot5.error,
                stackTrace: entitySnapshots.snapshot5.stackTrace,
              );
            }

            final locations =
                entitySnapshots.snapshot1.data ?? const <LocationsTableData>[];
            final npcs =
                entitySnapshots.snapshot2.data ?? const <CreaturesTableData>[];
            final otherCreatures =
                entitySnapshots.snapshot3.data ?? const <CreaturesTableData>[];
            final organizations =
                entitySnapshots.snapshot4.data ??
                const <OrganizationsTableData>[];
            final items =
                entitySnapshots.snapshot5.data ?? const <ItemsTableData>[];
            final entitiesCount =
                locations.length +
                npcs.length +
                otherCreatures.length +
                organizations.length +
                items.length;
            final bool entitiesLoading =
                entitySnapshots.snapshot1.connectionState ==
                    ConnectionState.waiting ||
                entitySnapshots.snapshot2.connectionState ==
                    ConnectionState.waiting ||
                entitySnapshots.snapshot3.connectionState ==
                    ConnectionState.waiting ||
                entitySnapshots.snapshot4.connectionState ==
                    ConnectionState.waiting ||
                entitySnapshots.snapshot5.connectionState ==
                    ConnectionState.waiting;

            final leftColumn = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Breadcrumbs(
                  items: [
                    BreadcrumbItemData(
                      label: campaign?.title ?? 'Campaign',
                      onTap: () => router.push(const CampaignOverviewRoute()),
                    ),
                    BreadcrumbItemData(label: chapter?.title ?? 'Chapter'),
                  ],
                  isLoading: isLoading,
                ),
                ChapterHeader(
                  chapter: chapter,
                  isLoading: isLoading,
                  onEditTitle: () {},
                  onEditDescription: () {},
                ),
                Gap(AppSpacing.xl),
                Expanded(
                  child: ContentView(
                    document: chapter?.content,
                    onSave: (updatedDocument) {
                      if (chapter != null) {
                        ref.updateChapter(
                          chapter.copyWith(content: updatedDocument),
                        );
                      }
                      return Future.value();
                    },
                  ),
                ),
              ],
            );

            final rightColumn = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    StatCard(
                      data: StateCardData(
                        title: l10n.spAdventures('plural'),
                        value: isLoading
                            ? '...'
                            : chapterAdventures.length.toString(),
                        icon: iconMap,
                        color: Colors.blue,
                      ),
                    ),
                    Gap(AppSpacing.md),
                    StatCard(
                      data: StateCardData(
                        title: l10n.spEntities('plural'),
                        value: entitiesLoading
                            ? '...'
                            : entitiesCount.toString(),
                        icon: iconEntities,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Gap(AppSpacing.lg),
                SidebarSection(
                  title: l10n.spAdventures('plural'),
                  onSparkWithAi: () {},
                  onNew: () {},
                  onNewLabel: l10n.spAdventures('singular'),
                  emptyLabel: l10n.noXFound(l10n.spAdventures('plural')),
                  children: _buildAdventureSidebarItems(
                    chapterAdventures,
                    isLoading,
                  ),
                ),
                Gap(AppSpacing.lg),
                SidebarSection(
                  title: l10n.spLocations('plural'),
                  onSparkWithAi: () {},
                  onNew: () {},
                  onNewLabel: l10n.spLocations('singular'),
                  emptyLabel: l10n.noXFound(l10n.spLocations('plural')),
                  children: _buildLocationSidebarItems(
                    locations,
                    entitiesLoading,
                  ),
                ),
                Gap(AppSpacing.lg),
                SidebarSection(
                  title: l10n.spNPCs('plural'),
                  onSparkWithAi: () {},
                  onNew: () {},
                  onNewLabel: l10n.spNPCs('singular'),
                  emptyLabel: l10n.noXFound(l10n.spNPCs('plural')),
                  children: _buildNpcSidebarItems(npcs, entitiesLoading),
                ),
                Gap(AppSpacing.lg),
                SidebarSection(
                  title: l10n.otherX(l10n.spCreatures('plural')),
                  onSparkWithAi: () {},
                  onNew: () {},
                  onNewLabel: l10n.spCreatures('singular'),
                  emptyLabel: l10n.noXFound(l10n.spCreatures('plural')),
                  children: _buildCreatureSidebarItems(
                    otherCreatures,
                    entitiesLoading,
                  ),
                ),
                Gap(AppSpacing.lg),
                SidebarSection(
                  title: l10n.spOrganizations('plural'),
                  onSparkWithAi: () {},
                  onNew: () {},
                  onNewLabel: l10n.spOrganizations('singular'),
                  emptyLabel: l10n.noXFound(l10n.spOrganizations('plural')),
                  children: _buildOrganizationSidebarItems(
                    organizations,
                    entitiesLoading,
                  ),
                ),
                Gap(AppSpacing.lg),
                SidebarSection(
                  title: l10n.spItems('plural'),
                  onSparkWithAi: () {},
                  onNew: () {},
                  onNewLabel: l10n.spItems('singular'),
                  emptyLabel: l10n.noXFound(l10n.spItems('plural')),
                  children: _buildItemSidebarItems(items, entitiesLoading),
                ),
              ],
            );

            return TwoPane(
              scrollFirst: false,
              first: leftColumn,
              second: rightColumn,
            );
          },
        );
      },
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
          final aOrder = a.orderNumber;
          final bOrder = b.orderNumber;
          return aOrder.compareTo(bOrder);
        });

  return items;
}

List<Widget> _buildAdventureSidebarItems(
  List<AdventuresTableData> adventures,
  bool isLoading,
) {
  if (isLoading) {
    return [
      const SidebarSectionItem(
        title: 'Adventure Title',
        description: 'Adventure summary placeholder.',
      ).asSkeleton(enabled: true),
      const SidebarSectionItem(
        title: 'Adventure Title',
        description: 'Adventure summary placeholder.',
      ).asSkeleton(enabled: true),
    ];
  }

  return adventures
      .map(
        (adventure) => SidebarSectionItem(
          title: '${adventure.orderNumber} ${adventure.title}',
          description: adventure.description ?? 'No description yet.',
          onTap: () {},
        ),
      )
      .toList();
}

List<Widget> _buildLocationSidebarItems(
  List<LocationsTableData> locations,
  bool isLoading,
) {
  if (isLoading) {
    return [
      const SidebarSectionItem(
        title: 'Location Name',
        description: 'Location description placeholder.',
      ).asSkeleton(enabled: true),
      const SidebarSectionItem(
        title: 'Location Name',
        description: 'Location description placeholder.',
      ).asSkeleton(enabled: true),
    ];
  }

  return locations
      .map(
        (location) => SidebarSectionItem(
          title: location.name,
          description: location.description ?? 'No description yet.',
          onTap: () {},
        ),
      )
      .toList();
}

List<Widget> _buildNpcSidebarItems(
  List<CreaturesTableData> npcs,
  bool isLoading,
) {
  if (isLoading) {
    return [
      SidebarSectionItem(
        title: 'NPC Name',
        tags: ['type'],
        description: 'NPC description placeholder.',
        avatarImage: Assets.images.placeholders.avatar1.image().image,
      ).asSkeleton(enabled: true),
      SidebarSectionItem(
        title: 'NPC Name',
        tags: ['type'],
        description: 'NPC description placeholder.',
        avatarImage: Assets.images.placeholders.avatar2.image().image,
      ).asSkeleton(enabled: true),
    ];
  }

  return npcs
      .map(
        (npc) => SidebarSectionItem(
          title: npc.name,
          tags: [npc.creatureType].whereType<String>().toList(),
          description: npc.description ?? 'No description yet.',
          avatarImage: Assets.images.placeholders.avatar1.image().image,
          onTap: () {},
        ),
      )
      .toList();
}

List<Widget> _buildCreatureSidebarItems(
  List<CreaturesTableData> creatures,
  bool isLoading,
) {
  if (isLoading) {
    return [
      SidebarSectionItem(
        title: 'Creature Name',
        tags: ['type'],
        description: 'Creature description placeholder.',
        avatarImage: Assets.images.placeholders.avatar2.image().image,
      ).asSkeleton(enabled: true),
      SidebarSectionItem(
        title: 'Creature Name',
        tags: ['type'],
        description: 'Creature description placeholder.',
        avatarImage: Assets.images.placeholders.avatar2.image().image,
      ).asSkeleton(enabled: true),
    ];
  }

  return creatures
      .map(
        (creature) => SidebarSectionItem(
          title: creature.name,
          tags: [creature.creatureType].whereType<String>().toList(),
          description: creature.description ?? 'No description yet.',
          avatarImage: Assets.images.placeholders.avatar2.image().image,
          onTap: () {},
        ),
      )
      .toList();
}

List<Widget> _buildOrganizationSidebarItems(
  List<OrganizationsTableData> organizations,
  bool isLoading,
) {
  if (isLoading) {
    return [
      const SidebarSectionItem(
        title: 'Organization Name',
        tags: ['type'],
        description: 'Organization description placeholder.',
      ).asSkeleton(enabled: true),
      const SidebarSectionItem(
        title: 'Organization Name',
        tags: ['type'],
        description: 'Organization description placeholder.',
      ).asSkeleton(enabled: true),
    ];
  }

  return organizations
      .map(
        (organization) => SidebarSectionItem(
          title: organization.name,
          tags: [organization.type].whereType<String>().toList(),
          description: organization.description ?? 'No description yet.',
          onTap: () {},
        ),
      )
      .toList();
}

List<Widget> _buildItemSidebarItems(
  List<ItemsTableData> items,
  bool isLoading,
) {
  if (isLoading) {
    return [
      const SidebarSectionItem(
        title: 'Item Name',
        description: 'Item description placeholder.',
      ).asSkeleton(enabled: true),
      const SidebarSectionItem(
        title: 'Item Name',
        description: 'Item description placeholder.',
      ).asSkeleton(enabled: true),
    ];
  }

  return items
      .map(
        (item) => SidebarSectionItem(
          title: item.name,
          subtitle: _buildItemSubtitle(item),
          description: item.description ?? 'No description yet.',
          onTap: () {},
        ),
      )
      .toList();
}

String? _buildItemSubtitle(ItemsTableData item) {
  final parts = <String>[];
  if (item.type?.isNotEmpty ?? false) {
    parts.add(item.type!);
  }
  if (item.rarity?.isNotEmpty ?? false) {
    parts.add(item.rarity!);
  }
  if (parts.isEmpty) {
    return null;
  }

  return parts.join(' / ');
}

CampaignsTableData? _findCampaign(
  List<CampaignsTableData>? campaigns,
  String campaignId,
) {
  if (campaigns == null) {
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

Widget _logAndBuildStreamError({
  required String label,
  required Object? error,
  required StackTrace? stackTrace,
}) {
  logger.e(
    'ChapterPage: $label error',
    error: error,
    stackTrace: stackTrace,
    context: LogContext.ui,
  );

  return Text('Error: $error');
}
