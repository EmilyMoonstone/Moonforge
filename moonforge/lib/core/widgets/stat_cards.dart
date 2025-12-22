import 'package:moonforge/layout/app_spacing.dart';
import 'package:moonforge/layout/theme.dart';
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
      padding: AppSpacing.paddingMd,
      child: IntrinsicWidth(
        child: Column(
          children: [
            Row(
              children: [
                Text(data.value, style: theme.typography.h3),
                Spacer(),
                if (data.icon != null)
                  Icon(data.icon, color: data.color ?? theme.colorScheme.primary),
              ],
            ),
            Text(data.title.toUpperCase(), style: theme.typography.xSmall.trackingWider).muted(),
          ],
        ),
      ),
    );
  }
}
