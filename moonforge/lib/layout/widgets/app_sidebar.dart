import 'package:shadcn_flutter/shadcn_flutter.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    this.leading,
    this.trailing,
    this.items = const [],
    this.width = 280,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  });

  final Widget? leading;
  final Widget? trailing;
  final List<Widget> items;
  final double width;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                if (leading != null) Padding(padding: padding, child: leading),
                if (leading != null) const Divider(),
                Expanded(
                  child: ListView(padding: padding, children: items),
                ),
                if (trailing != null) const Divider(),
                if (trailing != null) Padding(padding: padding, child: trailing),
              ],
            ),
          ),
          const VerticalDivider(padding: EdgeInsets.zero),
        ],
      ),
    );
  }
}
