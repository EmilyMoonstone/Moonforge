import 'package:moonforge/layout/design_constants.dart';
import 'package:moonforge/layout/widgets/scroll_view_default.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class TwoPane extends StatelessWidget {
  const TwoPane({
    super.key,
    required this.first,
    required this.second,
    this.secondInitialWidth = kTwoPaneSecondWidth,
    this.equalPanes = false,
    this.scrollFirst = true,
    this.scrollSecond = true,
  });

  final Widget first;
  final Widget second;
  final double secondInitialWidth;
  final bool equalPanes;
  final bool scrollFirst;
  final bool scrollSecond;

  @override
  Widget build(BuildContext context) {
    Widget firstChild = scrollFirst
        ? ScrollViewDefault(
            child: Padding(
              padding: const EdgeInsets.only(right: kTwoPaneSpacing / 2),
              child: first,
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(right: kTwoPaneSpacing / 2),
            child: first,
          );
    Widget secondChild = scrollSecond
        ? ScrollViewDefault(
            child: Padding(
              padding: const EdgeInsets.only(left: kTwoPaneSpacing / 2),
              child: second,
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: kTwoPaneSpacing / 2),
            child: second,
          );

    return Flexible(
      child: ResizablePanel.horizontal(
        optionalDivider: true,
        children: [
          ResizablePane.flex(
            initialFlex: 1,
            minSize: kTwoPaneMinWidth,
            child: firstChild,
          ),
          if (equalPanes)
            ResizablePane.flex(
              initialFlex: 1,
              minSize: kTwoPaneMinWidth,
              child: secondChild,
            )
          else
            ResizablePane(
              initialSize: secondInitialWidth,
              minSize: kTwoPaneMinWidth,
              child: secondChild,
            ),
        ],
      ),
    );
  }
}
