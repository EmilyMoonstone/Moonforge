import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SidebarItem extends StatelessWidget {
  const SidebarItem({
    super.key,
    required this.label,
    required this.icon,
    this.isSelected = false,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final selectedItem = PrimaryButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 10),
          Text(label),
        ],
      ),
    );

    final unselectedItem = GhostButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 10),
          Text(label),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: isSelected ? selectedItem : unselectedItem,
    );
  }
}
