import 'package:auto_route/auto_route.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:moonforge/layout/app_layout.dart';
import 'package:moonforge/layout/widgets/app_top_bar.dart';

@RoutePage()
class CompendiumPage extends StatelessWidget {
  const CompendiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      activeItem: AppNavItem.compendium,
      child: Center(child: Text('Compendium')),
    );
  }
}
