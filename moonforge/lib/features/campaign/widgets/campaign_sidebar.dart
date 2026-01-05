import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:moonforge/core/providers/campaign.dart';
import 'package:moonforge/core/widgets/sidebar_item.dart';
import 'package:moonforge/core/widgets/sidebar_tree.dart';
import 'package:moonforge/data/database.dart';
import 'package:moonforge/data/stores/adventures.dart';
import 'package:moonforge/data/stores/campaign.dart';
import 'package:moonforge/data/stores/chapters.dart';
import 'package:moonforge/data/stores/scenes.dart';
import 'package:moonforge/features/auth/utils/get_initials.dart';
import 'package:moonforge/layout/widgets/app_sidebar.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:moonforge/layout/app_spacing.dart';

enum CampaignNavItem {
  overview,
  chapters,
  maps,
  entities,
  encounters,
  locations,
}

class CampaignSidebar extends ConsumerStatefulWidget {
  const CampaignSidebar({
    super.key,
    required this.activeItem,
    required this.campaign,
    required this.isCampaignLoading,
    required this.onNavigate,
  });

  final CampaignNavItem activeItem;
  final CampaignsTableData? campaign;
  final bool isCampaignLoading;
  final ValueChanged<CampaignNavItem> onNavigate;

  @override
  ConsumerState<CampaignSidebar> createState() => _CampaignSidebarState();
}

class _CampaignSidebarState extends ConsumerState<CampaignSidebar> {
  ProviderSubscription<String?>? _campaignIdSubscription;

  @override
  void initState() {
    super.initState();
    _campaignIdSubscription = ref.listenManual<String?>(
      currentCampaignIdProvider,
      (previous, next) {
        if (previous != next) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _campaignIdSubscription?.close();
    super.dispose();
  }
  int _compareOrder(int? left, int? right) {
    if (left == null && right == null) {
      return 0;
    } else if (left == null) {
      return 1;
    } else if (right == null) {
      return -1;
    } else {
      return left.compareTo(right);
    }
  }

  List<SidebarTreeNodeData> _buildTreeNodesData({
    required String? campaignId,
    required List<ChaptersTableData> chapters,
    required List<AdventuresTableData> adventures,
    required List<ScenesTableData> scenes,
  }) {
    if (campaignId == null) {
      return const [];
    }

    final campaignChapters =
        chapters.where((chapter) => chapter.campaignId == campaignId).toList()
          ..sort((left, right) {
            final order = _compareOrder(left.orderNumber, right.orderNumber);
            if (order != 0) {
              return order;
            }
            return left.title.compareTo(right.title);
          });

    final adventuresByChapter = <String, List<AdventuresTableData>>{};
    for (final adventure in adventures) {
      if (adventure.campaignId != campaignId) {
        continue;
      }
      adventuresByChapter
          .putIfAbsent(adventure.chapterId, () => [])
          .add(adventure);
    }
    for (final entry in adventuresByChapter.entries) {
      entry.value.sort((left, right) {
        final order = _compareOrder(left.orderNumber, right.orderNumber);
        if (order != 0) {
          return order;
        }
        return left.title.compareTo(right.title);
      });
    }

    final scenesByAdventure = <String, List<ScenesTableData>>{};
    for (final scene in scenes) {
      if (scene.campaignId != campaignId) {
        continue;
      }
      scenesByAdventure.putIfAbsent(scene.adventureId, () => []).add(scene);
    }
    for (final entry in scenesByAdventure.entries) {
      entry.value.sort((left, right) {
        final order = _compareOrder(left.orderNumber, right.orderNumber);
        if (order != 0) {
          return order;
        }
        return left.title.compareTo(right.title);
      });
    }

    return campaignChapters.map((chapter) {
      final adventuresForChapter = adventuresByChapter[chapter.id]?.map((
        adventure,
      ) {
        final scenesForAdventure = scenesByAdventure[adventure.id]?.map((
          scene,
        ) {
          return SidebarTreeNodeData(title: scene.title, icon: Icons.movie);
        }).toList();

        return SidebarTreeNodeData(
          title: adventure.title,
          icon: Icons.explore,
          children: scenesForAdventure,
        );
      }).toList();

      return SidebarTreeNodeData(
        title: chapter.title,
        icon: Icons.bookmarks,
        children: adventuresForChapter,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final activeItem = widget.activeItem;
    final onNavigate = widget.onNavigate;
    final campaignId =
        widget.campaign?.id ?? ref.watch(currentCampaignIdProvider);
    final campaigns =
        ref.watch(campaignProvider).value ?? const <CampaignsTableData>[];
    final chapters =
        ref.watch(chaptersProvider).value ?? const <ChaptersTableData>[];
    final adventures =
        ref.watch(adventuresProvider).value ?? const <AdventuresTableData>[];
    final scenes = ref.watch(scenesProvider).value ?? const <ScenesTableData>[];
    final treeItemsData = _buildTreeNodesData(
      campaignId: campaignId,
      chapters: chapters,
      adventures: adventures,
      scenes: scenes,
    );

    return AppSidebar(
      leading: _CampaignSwitcher(
        campaign: widget.campaign,
        campaigns: campaigns,
        isLoading: widget.isCampaignLoading,
        onSelected: (campaign) {
          ref.read(currentCampaignIdProvider.notifier).set(campaign.id);
        },
      ),
      items: [
        SidebarItem(
          label: 'Overview',
          icon: Icons.dashboard,
          isSelected: activeItem == CampaignNavItem.overview,
          onPressed: () => onNavigate(CampaignNavItem.overview),
        ),
        if (campaignId == null)
          Text('Select a campaign to view chapters.').muted()
        else if (treeItemsData.isEmpty)
          Text('No chapters yet.').muted()
        else
          SidebarTree(
            title: 'Chapters',
            icon: Icons.bookmarks,
            isSelected: activeItem == CampaignNavItem.chapters,
            onPressed: () => onNavigate(CampaignNavItem.chapters),
            nodesData: treeItemsData,
          ),
        SidebarItem(
          label: 'Maps',
          icon: Icons.map,
          isSelected: activeItem == CampaignNavItem.maps,
          onPressed: () => onNavigate(CampaignNavItem.maps),
        ),
        SidebarItem(
          label: 'Locations',
          icon: Icons.location_on,
          isSelected: activeItem == CampaignNavItem.locations,
          onPressed: () => onNavigate(CampaignNavItem.locations),
        ),
        SidebarTree(
          title: "Entities",
          icon: Icons.groups,
          isSelected: activeItem == CampaignNavItem.entities,
          nodesData: [
            SidebarTreeNodeData(
              title: 'NPCs',
              icon: Symbols.person,
              //route: const CampaignEntitiesRoute(),
            ),
            SidebarTreeNodeData(
              title: 'Organizations',
              icon: Symbols.people,
              //route: const CampaignEntitiesRoute(),
            ),

            SidebarTreeNodeData(
              title: 'Items',
              icon: Symbols.inventory_2,
              //route: const CampaignEntitiesRoute(),
            ),

            SidebarTreeNodeData(
              title: 'Monsters',
              icon: Symbols.bug_report,
              //route: const CampaignEntitiesRoute(),
            ),
          ],
        ),
        SidebarItem(
          label: 'Encounters',
          icon: Symbols.swords,
          isSelected: activeItem == CampaignNavItem.encounters,
          onPressed: () => onNavigate(CampaignNavItem.encounters),
        ),
      ],
      trailing: SizedBox(
        width: double.infinity,
        child: Expanded(
          child: OutlineButton(
            onPressed: () {},
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
                SizedBox(width: 8),
                Text('Quick Add'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CampaignSwitcher extends StatelessWidget {
  const _CampaignSwitcher({
    required this.campaign,
    required this.campaigns,
    required this.isLoading,
    required this.onSelected,
  });

  final CampaignsTableData? campaign;
  final List<CampaignsTableData> campaigns;
  final bool isLoading;
  final ValueChanged<CampaignsTableData> onSelected;

  void _showMenu(BuildContext context) {
    if (campaigns.isEmpty) {
      return;
    }

    showDropdown<void>(
      context: context,
      alignment: Alignment.topLeft,
      anchorAlignment: Alignment.bottomLeft,
      builder: (context) {
        return DropdownMenu(
          children: [
            for (final campaign in campaigns)
              MenuButton(
                leading: Avatar(
                  initials: getInitials(campaign.title),
                  size: 28,
                ),
                onPressed: (context) {
                  closeOverlay(context);
                  onSelected(campaign);
                },
                child: Text(campaign.title),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final initials = campaign == null ? '' : getInitials(campaign!.title);

    return OutlineButton(
      onPressed: campaigns.isEmpty ? null : () => _showMenu(context),
      density: ButtonDensity.compact,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5B2CFF), Color(0xFF9D4EDD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                alignment: Alignment.center,
                child: Text(
                  initials.isEmpty ? '?' : initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      campaign?.title ?? 'No Campaign Selected',
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              Gap(AppSpacing.xs),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
      ),
    );
  }
}

