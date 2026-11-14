import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/smart_home_notifier.dart';
import '../state/theme_notifier.dart';
import '../widgets/brightness_card.dart';
import '../widgets/device_list_section.dart';
import '../widgets/room_selector.dart';
import '../widgets/status_panel.dart';
import 'details_screen.dart';

/// Головний екран. Тепер це StatelessWidget: глобальний стан зберігається
/// у SmartHomeNotifier, а кожна частина екрана підписується на нього сама.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DetailsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primaryContainer,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Вітаємо!', style: textTheme.titleMedium),
            // Selector: перебудовується лише цей Text і лише при зміні кімнати
            Selector<SmartHomeNotifier, String>(
              selector: (_, home) => home.room,
              builder: (_, room, _) => Text(
                'Активна кімната: $room',
                style: textTheme.bodySmall,
              ),
            ),
          ],
        ),
        actions: [
          // Consumer: бейдж із кількістю увімкнених пристроїв.
          // Незмінна іконка передається через child і не перебудовується.
          Consumer<SmartHomeNotifier>(
            builder: (context, home, child) => IconButton(
              tooltip: 'Деталі',
              onPressed: () => _openDetails(context),
              icon: Badge(
                label: Text('${home.activeCount}'),
                child: child,
              ),
            ),
            child: const Icon(Icons.devices_other_outlined),
          ),
          IconButton(
            tooltip: 'Змінити тему',
            icon: const Icon(Icons.brightness_4_outlined),
            // context.read — одноразовий доступ в обробнику події
            onPressed: () => context.read<ThemeNotifier>().toggleTheme(),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusPanel(),
            SizedBox(height: 20),
            RoomSelector(),
            SizedBox(height: 20),
            BrightnessCard(),
            SizedBox(height: 20),
            DeviceListSection(),
          ],
        ),
      ),
    );
  }
}
