import 'package:shadcn_flutter/shadcn_flutter.dart';

class HoverEditableRow extends StatefulWidget {
  const HoverEditableRow({
    super.key,
    required this.child,
    this.onEdit,
    this.tooltip,
    this.editOpacity = 0.25,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.spacing = 0.0,
  });

  final Widget child;
  final VoidCallback? onEdit;
  final String? tooltip;
  final double editOpacity;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final hasBoundedWidth = constraints.hasBoundedWidth;
          return Row(
            mainAxisSize: hasBoundedWidth ? MainAxisSize.max : MainAxisSize.min,
            crossAxisAlignment: widget.crossAxisAlignment,
            spacing: widget.spacing,
            children: [
              if (hasBoundedWidth)
                Flexible(child: widget.child)
              else
                widget.child,
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
          );
        },
      ),
    );
  }
}

/// A widget that shows an edit icon centered over its child when hovered.
class HoverEditableAbove extends StatefulWidget {
  const HoverEditableAbove({
    super.key,
    required this.child,
    this.onEdit,
    this.tooltip,
    this.editOpacity = 0.25,
    this.alignment = Alignment.center,
    this.isLoading = false,
  });

  final Widget child;
  final VoidCallback? onEdit;
  final String? tooltip;
  final double editOpacity;
  final AlignmentGeometry alignment;
  final bool isLoading;

  @override
  State<HoverEditableAbove> createState() => _HoverEditableAboveState();
}

class _HoverEditableAboveState extends State<HoverEditableAbove> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Stack(
        alignment: widget.alignment,
        children: [
          widget.child,
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
          if (widget.isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
