import 'package:moonforge/gen/l10n.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SparkWithAiButton extends StatefulWidget {
  const SparkWithAiButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<SparkWithAiButton> createState() => _SparkWithAiButtonState();
}

class _SparkWithAiButtonState extends State<SparkWithAiButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        tooltip: TooltipContainer(child: Text(l10n.sparkWithAI)).call,
        child: IconButton(
          variance: ButtonVariance.ghost,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: Icon(
              Icons.auto_awesome,
              key: ValueKey<bool>(_isHovered),
              color: _isHovered ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
          onPressed: widget.onPressed,
        ),
      ),
    );
  }
}
