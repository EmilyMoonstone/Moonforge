import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ChapterStatCards extends StatelessWidget {
  const ChapterStatCards({
    super.key,
    required this.adventuresCount,
    required this.entitiesCount,
    this.isLoading = false,
  });

  final int adventuresCount;
  final int entitiesCount;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Adventures',
            value: adventuresCount.toString(),
            icon: Icons.map,
          ),
        ),
        Gap(AppSpacing.sm),
        Expanded(
          child: _StatCard(
            label: 'Entities',
            value: entitiesCount.toString(),
            icon: Icons.groups,
          ),
        ),
      ],
    ).asSkeleton(enabled: isLoading);
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            Gap(AppSpacing.sm),
            Text(value, style: theme.typography.h3),
            Text(label, style: theme.typography.small).muted(),
          ],
        ),
      ),
    );
  }
}
