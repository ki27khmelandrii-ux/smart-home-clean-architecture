import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/smart_home_notifier.dart';

/// Рядок пристрою зі Switch. Використовується на головному екрані
/// та на екрані деталей. Батько передає лише назву пристрою,
/// а стан і обробник плитка отримує з Provider сама.
class DeviceTile extends StatelessWidget {
  const DeviceTile({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    // context.select — плитка перебудовується лише при зміні свого пристрою
    final isOn = context.select<SmartHomeNotifier, bool>(
      (home) => home.isOn(name),
    );

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isOn ? Colors.green.shade100 : Colors.grey.shade300,
          child: Icon(
            isOn ? Icons.power_settings_new : Icons.power_off_outlined,
            color: isOn ? Colors.green : Colors.grey,
          ),
        ),
        title: Text(name),
        subtitle: Text(isOn ? 'Увімкнено' : 'Вимкнено'),
        trailing: Switch(
          value: isOn,
          onChanged: (_) => context.read<SmartHomeNotifier>().toggleDevice(name),
        ),
      ),
    );
  }
}
