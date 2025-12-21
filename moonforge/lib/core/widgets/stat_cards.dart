import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class StateCardData {
  final String title;
  final String value;
  final IconData? icon;
  final Color? color;

  StateCardData({
    required this.title,
    required this.value,
    this.icon,
    this.color,
  });
}

class StatCards extends StatefulWidget {
  const StatCards({super.key, required this.cards});

  final List<StateCardData> cards;

  @override
  _StatCardsState createState() => _StatCardsState();
}

class _StatCardsState extends State<StatCards> {
  @override
  Widget build(BuildContext context) {
    return Wrap();
  }
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.data});

  final StateCardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      fillColor: data.color?.withValues(alpha: 0.1),
      child: Column(
        children: [
          Row(
            children: [
              if (data.icon != null)
                Icon(data.icon, color: data.color ?? theme.colorScheme.primary),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.title, style: theme.typography.large).muted(),
                ],
              ),
            ],
          ),
          Gap(AppSpacing.md),
          Text(data.value, style: theme.typography.h3),
        ],
      ),
    );
  }
}
