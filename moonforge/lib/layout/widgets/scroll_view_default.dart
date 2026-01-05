import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ScrollViewDefault extends StatelessWidget {
  const ScrollViewDefault({
    super.key,
    required this.child,
    this.paddingLeft = false,
    this.paddingRight = false,
    this.paddingTop = false,
    this.paddingBottom = false,
  });

  final Widget child;
  final bool paddingLeft;
  final bool paddingRight;
  final bool paddingTop;
  final bool paddingBottom;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: paddingLeft ? AppSpacing.xl : 0,
          right: paddingRight ? AppSpacing.xl : 0,
          top: paddingTop ? AppSpacing.xl : 0,
          bottom: paddingBottom ? AppSpacing.xl : 0,
        ),
        //clipBehavior: Clip.antiAliasWithSaveLayer,
        child: child,
      ),
    );
  }
}
