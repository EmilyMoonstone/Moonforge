import 'package:shadcn_flutter/shadcn_flutter.dart';

class HoverEditableRow extends StatefulWidget {
  const HoverEditableRow({
    super.key,
    required this.child,
    this.onEdit,
    this.tooltip,
    this.editOpacity = 0.25,
  });

  final Widget child;
  final VoidCallback? onEdit;
  final String? tooltip;
  final double editOpacity;

  @override
  State<HoverEditableRow> createState() => _HoverEditableRowState();
}

class _HoverEditableRowState extends State<HoverEditableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: widget.child),
          AnimatedOpacity(
            opacity: _isHovered ? 1 : widget.editOpacity,
            duration: const Duration(milliseconds: 150),
            child: IgnorePointer(
              ignoring: !_isHovered,
              child: Tooltip(
                tooltip: TooltipContainer(
                  child: Text(widget.tooltip ?? 'Edit'),
                ).call,
                child: IconButton(
                  variance: ButtonVariance.ghost,
                  icon: const Icon(Icons.edit),
                  onPressed: widget.onEdit,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
