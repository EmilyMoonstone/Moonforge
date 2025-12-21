import 'package:flutter/services.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SearchIcon extends StatelessWidget {
  const SearchIcon({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      tooltip: (context) => TooltipContainer(
        backgroundColor: Theme.of(context).colorScheme.card,
        child: KeyboardDisplay(
          keys: const [
            LogicalKeyboardKey.control,
            LogicalKeyboardKey.keyK,
          ],
        ),
      ),
      child: IconButton(
        variance: ButtonVariance.ghost,
        icon: const Icon(Icons.search),
        onPressed: onPressed,
      ),
    );
  }
}
