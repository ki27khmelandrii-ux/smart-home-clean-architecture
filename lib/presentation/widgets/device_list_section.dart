import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../state/smart_home_notifier.dart';
import 'device_tile.dart';

/// Пошук і список пристроїв на головному екрані.
///
/// Контролер поля пошуку — локальний стан: він потрібен лише цьому
/// віджету, тому залишається у State разом із dispose().
class DeviceListSection extends StatefulWidget {
  const DeviceListSection({super.key});

  @override
  State<DeviceListSection> createState() => _DeviceListSectionState();
}

class _DeviceListSectionState extends State<DeviceListSection> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose(); // звільняємо локальний контролер
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // context.watch — список перебудовується при зміні стану пристроїв
    final devices = context.watch<SmartHomeNotifier>().devices;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchCtrl,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            labelText: 'Пошук пристрою',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        // Фільтр оновлюється через ValueListenableBuilder без setState:
        // TextEditingController сам є ValueListenable<TextEditingValue>.
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _searchCtrl,
          builder: (context, value, _) {
            final query = value.text.toLowerCase();
            final names = devices.keys
                .where((name) => name.toLowerCase().contains(query))
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Пристрої', style: textTheme.titleLarge),
                    Text('${names.length} шт.', style: textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: names.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => DeviceTile(
                    key: ValueKey(names[index]),
                    name: names[index],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
