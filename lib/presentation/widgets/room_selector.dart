import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../state/smart_home_notifier.dart';

/// Вибір активної кімнати (ChoiceChip).
class RoomSelector extends StatelessWidget {
  const RoomSelector({super.key});

  @override
  Widget build(BuildContext context) {
    // context.select — підписка лише на назву кімнати
    final activeRoom = context.select<SmartHomeNotifier, String>(
      (home) => home.room,
    );
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Кімнати', style: textTheme.titleLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final room in SmartHomeNotifier.rooms)
              ChoiceChip(
                label: Text(room),
                selected: activeRoom == room,
                // context.read — у обробнику події, без підписки
                onSelected: (_) =>
                    context.read<SmartHomeNotifier>().setRoom(room),
              ),
          ],
        ),
      ],
    );
  }
}
