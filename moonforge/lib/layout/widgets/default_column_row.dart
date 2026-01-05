import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class DefaultColumn extends StatelessWidget {
  const DefaultColumn({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.lg,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class DefaultRow extends StatelessWidget {
  const DefaultRow({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.lg,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
