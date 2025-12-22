import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/providers/campaign.dart';
import 'package:moonforge/core/widgets/stat_cards.dart';
import 'package:moonforge/data/database.dart';
import 'package:moonforge/data/stores/campaign.dart';
import 'package:moonforge/features/campaign_overview/widgets/campaign_header.dart';
import 'package:moonforge/features/campaign_overview/widgets/chapters_list.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:moonforge/layout/widgets/scroll_view_default.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

@RoutePage()
class CampaignOverviewPage extends ConsumerStatefulWidget {
  const CampaignOverviewPage({super.key});

  @override
  ConsumerState<CampaignOverviewPage> createState() =>
      _CampaignOverviewPageState();
}

class _CampaignOverviewPageState extends ConsumerState<CampaignOverviewPage> {
  @override
  Widget build(BuildContext context) {
    final String? campaignId = ref.watch(currentCampaignIdProvider);
    final campaigns = ref.watch(campaignProvider);
    final campaign = _findCampaign(campaigns.value, campaignId);

    Widget content(CampaignsTableData? campaignData) {
      return ScrollViewDefault(
        child: Column(
          children: [
            CampaignHeader(campaign: campaignData),
            Gap(AppSpacing.lg),
            StatCards(cards: [
              StateCardData(
                title: 'Chapters',
                value: '12',
                icon: Icons.book,
                color: Colors.blue,
              ),
              StateCardData(
                title: 'Maps',
                value: '5',
                icon: Icons.map,
                color: Colors.green,
              ),
              StateCardData(
                title: 'Entities',
                value: '34',
                icon: Icons.people,
                color: Colors.orange,
              ),
              StateCardData(
                title: 'Encounters',
                value: '48',
                icon: Icons.people,
                color: Colors.purple,
              ),
            ]),
            ChaptersList(campaignId: campaignId),
          ],
        ),
      );
    }

    if (campaigns.hasError) {
      return Text('Error: ${campaigns.error}');
    }

    if (campaignId == null) {
      return Center(child: const Text('No campaign found.').muted());
    }

    if (campaigns.isLoading) {
      return content(null);
    }

    if (campaign == null) {
      return Center(child: const Text('No campaign found.').muted());
    }

    return content(campaign);
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
