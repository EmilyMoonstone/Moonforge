import 'package:auto_route/auto_route.dart';
import 'package:moonforge/core/widgets/sidebar_item.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SidebarTreeNodeData {
  const SidebarTreeNodeData({
    required this.title,
    required this.icon,
    this.route,
    this.noItems,
    this.children,
  });

  final String title;
  final IconData icon;
  final PageRouteInfo? route;
  final String? noItems;
  final List<SidebarTreeNodeData>? children;
}

class SidebarTree extends StatefulWidget {
  const SidebarTree({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    this.onPressed,
    required this.nodesData,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onPressed;
  final List<SidebarTreeNodeData> nodesData;

  @override
  State<SidebarTree> createState() => _SidebarTreeState();
}

class _SidebarTreeState extends State<SidebarTree> {
  late List<TreeNode<SidebarTreeNodeData>> _treeItems;
  late String _nodesSignature;

  @override
  void initState() {
    super.initState();
    _treeItems = _buildTreeItems(widget.nodesData);
    _nodesSignature = _buildSignature(widget.nodesData);
  }

  @override
  void didUpdateWidget(covariant SidebarTree oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextSignature = _buildSignature(widget.nodesData);
    if (_nodesSignature != nextSignature) {
      _treeItems = _buildTreeItems(widget.nodesData);
      _nodesSignature = nextSignature;
    }
  }

  List<TreeNode<SidebarTreeNodeData>> _buildTreeItems(
    List<SidebarTreeNodeData> nodes,
  ) {
    return nodes
        .map(
          (data) => TreeItem<SidebarTreeNodeData>(
            data: data,
            children: data.children == null
                ? const []
                : _buildTreeItems(data.children!),
          ),
        )
        .toList();
  }

  String _buildSignature(List<SidebarTreeNodeData> nodes) {
    final buffer = StringBuffer();

    void walk(List<SidebarTreeNodeData> items, int depth) {
      for (final item in items) {
        buffer.write('$depth:${item.title}|');
        if (item.children != null && item.children!.isNotEmpty) {
          walk(item.children!, depth + 1);
        }
      }
    }

    walk(nodes, 0);
    return buffer.toString();
  }

  void _setTreeItems(List<TreeNode<SidebarTreeNodeData>> items) {
    setState(() {
      _treeItems = items;
    });
  }

  ValueChanged<bool> _expandHandler(TreeItem<SidebarTreeNodeData> node) {
    return TreeView.defaultItemExpandHandler(_treeItems, node, _setTreeItems);
  }

  void _handleNodePressed(
    BuildContext context,
    TreeItem<SidebarTreeNodeData> node,
  ) {
    _setTreeItems(_treeItems.selectNode(node));
    if (node.leaf) {
      final route = node.data.route;
      if (route != null) {
        AutoRouter.of(context).push(route);
      }
      return;
    }

    _expandHandler(node)(!node.expanded);
  }

  @override
  Widget build(BuildContext context) {
    bool hasChildren = false;

    for (var node in widget.nodesData) {
      if (node.children != null && node.children!.isNotEmpty) {
        hasChildren = true;
        break;
      }
    }

    Widget tree = TreeView<SidebarTreeNodeData>(
      shrinkWrap: true,
      nodes: _treeItems,
      branchLine: BranchLine.line,
      builder: (context, node) {
        return TreeItemView(
          onPressed: () => _handleNodePressed(context, node),
          onExpand: node.leaf ? null : _expandHandler(node),
          leading: Icon(node.data.icon, size: 16),
          child: Text(
            node.data.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );

    Widget noTree = IntrinsicHeight(
      child: SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 24),
            const VerticalDivider(),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var node in widget.nodesData)
                    GhostButton(
                      density: ButtonDensity.compact,
                      onPressed: () {
                        final route = node.route;
                        if (route != null) {
                          AutoRouter.of(context).push(route);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        child: Row(
                          children: [
                            Icon(node.icon, size: 16),
                            const SizedBox(width: 10),
                            Text(node.title),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return ComponentTheme<CollapsibleTheme>(
      data: const CollapsibleTheme(
        padding: 0,
        iconCollapsed: Icons.keyboard_arrow_down,
        iconExpanded: Icons.keyboard_arrow_up,
        iconGap: 8,
      ),
      child: Collapsible(
        children: [
          CollapsibleTrigger(
            child: SizedBox(
              width: double.infinity,
              child: SidebarItem(
                label: widget.title,
                icon: widget.icon,
                isSelected: widget.isSelected,
                onPressed: widget.onPressed ?? () {},
              ),
            ),
          ),
          CollapsibleContent(child: hasChildren ? tree : noTree),
        ],
      ),
    );
  }
}
