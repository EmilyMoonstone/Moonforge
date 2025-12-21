import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:moonforge/gen/assets.gen.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
      child: Image.asset(
        Assets.logo.moonforgeLogoPurple.moonforgeLogoPurple256.path,
        height: 36,
      ),
    );
  }
}
