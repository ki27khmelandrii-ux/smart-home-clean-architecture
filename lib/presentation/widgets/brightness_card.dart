import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../state/smart_home_notifier.dart';

/// Картка яскравості освітлення.
class BrightnessCard extends StatelessWidget {
  const BrightnessCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        // Selector: вміст картки перебудовується лише при зміні яскравості
        child: Selector<SmartHomeNotifier, double>(
          selector: (_, home) => home.brightness,
          builder: (context, brightness, _) => Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.brightness_6),
                  const SizedBox(width: 8),
                  Text('Яскравість', style: textTheme.titleMedium),
                  const Spacer(),
                  Text('${(brightness * 100).round()}%'),
                ],
              ),
              Slider(
                value: brightness,
                onChanged: (value) =>
                    context.read<SmartHomeNotifier>().setBrightness(value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
