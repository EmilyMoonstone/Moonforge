import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ScrollViewDefault extends StatelessWidget {
  const ScrollViewDefault({
    super.key,
    required this.child,
    this.paddingLeft = true,
    this.paddingRight = true,
    this.paddingTop = true,
    this.paddingBottom = true,
  });

  final Widget child;
  final bool paddingLeft;
  final bool paddingRight;
  final bool paddingTop;
  final bool paddingBottom;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: paddingLeft ? AppSpacing.xl : 0,
        right: paddingRight ? AppSpacing.xl : 0,
        top: paddingTop ? AppSpacing.xl : 0,
        bottom: paddingBottom ? AppSpacing.xl : 0,
      ),
      child: child,
    );
  }
}
