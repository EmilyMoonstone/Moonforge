import 'package:auto_route/auto_route.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:moonforge/layout/app_layout.dart';
import 'package:moonforge/layout/widgets/app_top_bar.dart';

@RoutePage()
class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      activeItem: AppNavItem.groups,
      child: Center(child: Text('Groups')),
    );
  }
}
