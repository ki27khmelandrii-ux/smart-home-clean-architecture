import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/smart_home_notifier.dart';

/// Панель стану будинку на головному екрані.
/// Підписана на SmartHomeNotifier через context.watch.
class StatusPanel extends StatelessWidget {
  const StatusPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // context.watch — підписка: панель перебудовується при кожній зміні стану
    final home = context.watch<SmartHomeNotifier>();
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Панель стану', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Metric(
                  icon: Icons.meeting_room_outlined,
                  label: 'Кімната',
                  value: home.room,
                ),
                _Metric(
                  icon: Icons.power_settings_new,
                  label: 'Увімкнено',
                  value: '${home.activeCount} з ${home.totalCount}',
                ),
                _Metric(
                  icon: Icons.brightness_6,
                  label: 'Яскравість',
                  value: '${home.brightnessPercent}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Icon(icon),
        const SizedBox(height: 4),
        Text(value, style: textTheme.titleMedium),
        Text(label, style: textTheme.bodySmall),
      ],
    );
  }
}
