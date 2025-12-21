import 'package:auto_route/auto_route.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:moonforge/features/campaign/views/campaign_layout.dart';

@RoutePage()
class CampaignPage extends StatelessWidget {
  const CampaignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoRouter(
      builder: (context, child) => CampaignLayout(child: child),
    );
  }
}
