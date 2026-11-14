import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_config.dart';
import '../state/smart_home_notifier.dart';
import '../widgets/device_tile.dart';

/// Екран деталей. Показує той самий стан, що й головний екран,
/// але отримує його з Provider, а не через конструктор.
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // context.watch — екран перебудовується при кожній зміні стану
    final home = context.watch<SmartHomeNotifier>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Деталі будинку')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.meeting_room_outlined),
              title: const Text('Активна кімната'),
              trailing: Text(home.room, style: textTheme.titleMedium),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Яскравість освітлення'),
              trailing: Text(
                '${home.brightnessPercent}%',
                style: textTheme.titleMedium,
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.power_settings_new),
              title: const Text('Увімкнено пристроїв'),
              trailing: Text(
                '${home.activeCount} з ${home.totalCount}',
                style: textTheme.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Усі пристрої', style: textTheme.titleLarge),
          const SizedBox(height: 8),
          for (final name in home.devices.keys)
            DeviceTile(key: ValueKey(name), name: name),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Версія ${AppConfig.version}',
              style: textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
