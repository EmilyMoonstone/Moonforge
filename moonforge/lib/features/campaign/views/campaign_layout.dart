import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/providers/campaign.dart';
import 'package:moonforge/data/database.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:moonforge/layout/app_layout.dart';
import 'package:moonforge/layout/widgets/app_top_bar.dart';
import 'package:moonforge/routes/app_router.gr.dart';
import 'package:moonforge/features/campaign/widgets/campaign_sidebar.dart';
import 'package:moonforge/data/stores/campaign.dart';

@RoutePage()
class CampaignLayout extends ConsumerStatefulWidget {
  const CampaignLayout({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<CampaignLayout> createState() => _CampaignLayoutState();
}

class _CampaignLayoutState extends ConsumerState<CampaignLayout> {
  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);
    final activeItem = _resolveActiveItem(router);
    final String? campaignId = ref.watch(currentCampaignIdProvider);
    final campaigns = ref.watch(campaignProvider);
    final campaign = _findCampaign(campaigns.value, campaignId);

    return AppLayout(
      activeItem: AppNavItem.campaign,
      sidebar: CampaignSidebar(
        activeItem: activeItem,
        campaign: campaign,
        isCampaignLoading: campaigns.isLoading,
        onNavigate: (item) => _handleNavigate(router, item),
      ),
      bodyPadding: const EdgeInsets.all(16),
      child: widget.child,
    );
  }
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

CampaignNavItem _resolveActiveItem(StackRouter router) {
  return switch (router.current.name) {
    CampaignChapterRoute.name => CampaignNavItem.chapters,
    CampaignMapsRoute.name => CampaignNavItem.maps,
    CampaignEntitiesRoute.name => CampaignNavItem.entities,
    CampaignEncountersRoute.name => CampaignNavItem.encounters,
    _ => CampaignNavItem.overview,
  };
}

void _handleNavigate(StackRouter router, CampaignNavItem item) {
  switch (item) {
    case CampaignNavItem.overview:
      router.push(const CampaignOverviewRoute());
    case CampaignNavItem.chapters:
      router.push(CampaignChapterRoute(chapterId: ''));
    case CampaignNavItem.maps:
      router.push(const CampaignMapsRoute());
    case CampaignNavItem.locations:
      router.push(const CampaignLocationsRoute());
    case CampaignNavItem.entities:
      router.push(const CampaignEntitiesRoute());
    case CampaignNavItem.encounters:
      router.push(const CampaignEncountersRoute());
  }
}
