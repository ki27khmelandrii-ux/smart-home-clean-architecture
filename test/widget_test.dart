import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_home/domain/entities/device.dart';
import 'package:smart_home/infrastructure/repositories/in_memory_device_repository.dart';
import 'package:smart_home/presentation/app.dart';
import 'package:smart_home/presentation/di/injection.dart';
import 'package:smart_home/presentation/state/smart_home_notifier.dart';

/// Ті самі залежності, що й у main(): createSmartHome — єдиний Composition Root.
Future<SmartHomeNotifier> createLoadedHome() async {
  final home = createSmartHome();
  await home.load();
  return home;
}

Widget buildApp(SmartHomeNotifier home) => SmartHomeApp(home: home);

Finder switchOf(String device) => find.descendant(
      of: find.widgetWithText(ListTile, device),
      matching: find.byType(Switch),
    );

void main() {
  group('SmartHomeNotifier (через use cases)', () {
    test('load завантажує дані з репозиторіїв', () async {
      final home = await createLoadedHome();
      expect(home.totalCount, 4);
      expect(home.activeCount, 2);
      expect(home.room, 'Вітальня');
    });

    test('toggleDevice змінює стан і викликає notifyListeners', () async {
      final home = await createLoadedHome();
      var notifications = 0;
      home.addListener(() => notifications++);

      await home.toggleDevice('Кондиціонер');

      expect(home.isOn('Кондиціонер'), isTrue);
      expect(home.activeCount, 3);
      expect(notifications, 1);
    });

    test('setBrightness і setRoom оновлюють стан', () async {
      final home = await createLoadedHome();
      await home.setBrightness(0.8);
      await home.setRoom('Кухня');

      expect(home.brightnessPercent, 80);
      expect(home.room, 'Кухня');
    });

    test('без зміни значення слухачі не сповіщаються', () async {
      final home = await createLoadedHome();
      var notifications = 0;
      home.addListener(() => notifications++);

      await home.setRoom('Вітальня'); // та сама кімната
      await home.setRoom('Гараж'); // кімнати немає у переліку
      await home.toggleDevice('Пральна машина'); // пристрою немає
      await home.setBrightness(0.5); // те саме значення

      expect(notifications, 0);
    });
  });

  testWidgets('Один стан відображається на головному екрані та в деталях',
      (tester) async {
    tester.view.physicalSize = const Size(1000, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final home = await createLoadedHome();
    await tester.pumpWidget(buildApp(home));

    // Початковий стан: увімкнено 2 з 4 пристроїв
    expect(find.text('2 з 4'), findsOneWidget);

    // Вмикаємо кондиціонер на головному екрані
    await tester.tap(switchOf('Кондиціонер'));
    await tester.pumpAndSettle();
    expect(find.text('3 з 4'), findsOneWidget);
    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('3')),
      findsOneWidget,
    );

    // Вибір кімнати оновлює підзаголовок AppBar
    await tester.tap(find.widgetWithText(ChoiceChip, 'Кухня'));
    await tester.pumpAndSettle();
    expect(find.text('Активна кімната: Кухня'), findsOneWidget);

    // Екран деталей показує той самий стан
    await tester.tap(find.byTooltip('Деталі'));
    await tester.pumpAndSettle();
    expect(find.text('Деталі будинку'), findsOneWidget);
    expect(find.text('3 з 4'), findsOneWidget);
    expect(find.text('Версія 1.0.0'), findsOneWidget);

    // Зміна на екрані деталей видна після повернення
    await tester.tap(switchOf('Телевізор'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('2 з 4'), findsOneWidget);
    expect(home.isOn('Телевізор'), isFalse);
  });

  testWidgets('Сховище підмінюється без зміни use cases і віджетів',
      (tester) async {
    // Інший набір даних передається через DI, решта коду та сама
    final home = createSmartHome(
      devices: InMemoryDeviceRepository([
        const Device(name: 'Бойлер', isOn: true),
      ]),
    );
    await home.load();
    await tester.pumpWidget(buildApp(home));

    expect(find.text('Бойлер'), findsOneWidget);
    expect(find.text('1 з 1'), findsOneWidget);
  });
}
