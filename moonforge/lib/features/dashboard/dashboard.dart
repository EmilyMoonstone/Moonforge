import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' show InkWell;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/providers/campaign.dart';
import 'package:moonforge/core/widgets/spark_with_ai_button.dart';
import 'package:moonforge/data/database.dart';
import 'package:moonforge/data/enums.dart';
import 'package:moonforge/data/stores/campaign.dart';
import 'package:moonforge/features/dashboard/widgets/new_campaign_dialog.dart';
import 'package:moonforge/gen/assets.gen.dart';
import 'package:moonforge/gen/l10n.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:moonforge/layout/design_constants.dart';
import 'package:moonforge/layout/widgets/scroll_view_default.dart';
import 'package:moonforge/routes/app_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:moonforge/layout/app_layout.dart';
import 'package:moonforge/layout/widgets/app_top_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

@RoutePage()
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    SortTypeDataset selectedSortType = SortTypeDataset.lastModifiedAsc;
    final campaigns = ref.watch(campaignProvider);
    final theme = Theme.of(context);

    Widget campaignCard(CampaignsTableData campaign) {
      return InkWell(
        borderRadius: theme.borderRadiusMd,
        onTap: () {
          ref.read(currentCampaignIdProvider.notifier).set(campaign.id);
          AutoRouter.of(context).push(CampaignRoute());
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 200, maxWidth: kCardWidthMax),
          child: Card(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: theme.radiusMdRadius,
                  ),
                  //TODO: implement campaign image with fallback placeholder
                  child: Assets.images.placeholders.campaign.image(
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: AppSpacing.paddingLg,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            OverflowMarquee(child: Text(campaign.title).h4),
                            Row(
                              children: [
                                Icon(
                                  Icons.watch_later,
                                  size: 16,
                                  color: theme.colorScheme.mutedForeground,
                                ),
                                Gap(AppSpacing.sm),
                                Text(
                                  timeago.format(
                                    DateTime.parse(campaign.updatedAt),
                                  ),
                                ).muted(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AppLayout(
      activeItem: AppNavItem.dashboard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('${l10n.your} ${l10n.spCampaigns('plural')}').h1,
              Spacer(),
              SparkWithAiButton(onPressed: () {}, showLabel: true),
              Gap(AppSpacing.lg),
              PrimaryButton(
                leading: Icon(Icons.add),
                child: Text(
                  '${l10n.newString} ${l10n.spCampaigns('singular')}',
                ),
                onPressed: () {
                  showNewCampaignDialog(context);
                },
              ),
            ],
          ),
          Gap(AppSpacing.xl),
          Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: kSearchWidth),
                //TODO: implement search functionality
                child: TextField(
                  placeholder: Text(
                    '${l10n.search} ${l10n.spCampaigns('plural')}...',
                  ),
                  features: [InputFeature.leading(Icon(Icons.search))],
                ),
              ),
              Spacer(),
              //TODO: implement sort functionality
              Select<SortTypeDataset>(
                constraints: BoxConstraints(minWidth: kCardWidthMax),
                itemBuilder: (context, value) => Text(l10n.sortBy(value.name)),
                value: selectedSortType,
                onChanged: (newValue) {
                  setState(() {
                    selectedSortType = newValue!;
                  });
                },
                popup: SelectPopup(
                  items: SelectItemList(
                    children: [
                      ...SortTypeDataset.values.map(
                        (sortType) => SelectItemButton<SortTypeDataset>(
                          value: sortType,
                          child: Text(l10n.sortBy(sortType.name)),
                        ),
                      ),
                    ],
                  ),
                ).call,
              ),
            ],
          ),
          Gap(AppSpacing.xl),
          Builder(
            builder: (context) {
              if (!campaigns.hasValue) {
                return Center(
                  child: Text(
                    l10n.noXFound(l10n.spCampaigns('plural')),
                  ).muted(),
                );
              }

              return ScrollViewDefault(
                child: Wrap(
                  spacing: kCardSpacing,
                  runSpacing: kCardSpacing,
                  children: campaigns.value!
                      .map((campaign) => campaignCard(campaign))
                      .toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
