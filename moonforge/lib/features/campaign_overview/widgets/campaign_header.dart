import 'package:moonforge/data/database.dart';
import 'package:moonforge/gen/assets.gen.dart';
import 'package:moonforge/gen/l10n.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class CampaignHeader extends StatefulWidget {
  const CampaignHeader({super.key, this.campaign, this.height = 220});

  final CampaignsTableData? campaign;
  final double height;

  @override
  _CampaignHeaderState createState() => _CampaignHeaderState();
}

class _CampaignHeaderState extends State<CampaignHeader> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bool isLoading = widget.campaign == null;
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(theme.radiusXl),
                topRight: Radius.circular(theme.radiusXl),
              ),
              child: ShaderMask(
                shaderCallback: (rect) => LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [theme.colorScheme.background, Colors.transparent],
                ).createShader(rect),
                blendMode: BlendMode.darken,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Assets.images.placeholders.campaign.image().image,
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withAlpha(45),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: AppSpacing.paddingXxxl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlineBadge(
                      child: Row(
                        children: [
                          Icon(
                            Icons.watch_later,
                            size: 16,
                            color: theme.colorScheme.foreground,
                          ),
                          Gap(AppSpacing.sm),
                          Text(
                            widget.campaign == null
                                ? 'some time ago'
                                : timeago.format(
                                    DateTime.parse(widget.campaign!.updatedAt),
                                  ),
                          ).foreground(fontSize: 14),
                        ],
                      ),
                    ),
                    Gap(AppSpacing.md),
                    Text(
                      widget.campaign?.title ?? 'Campaign Title',
                      style: theme.typography.h2,
                    ),
                    Gap(AppSpacing.md),
                    Text(widget.campaign?.description ?? 'A very detailed description of the campaign. We hope you enjoy it!').muted(),
                  ],
                ),
                SecondaryButton(
                  onPressed: () {},
                  leading: const Icon(Icons.edit),
                  child: Text('${l10n.edit} ${l10n.spCampaigns('singular')}'),
                ),
              ],
            ),
          ),
        ],
      ),
    ).asSkeleton(enabled: isLoading);
  }
}
