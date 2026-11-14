import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:smart_home/main.dart';
import 'package:smart_home/presentation/state/smart_home_notifier.dart';
import 'package:smart_home/presentation/state/theme_notifier.dart';

/// Застосунок із тими самими провайдерами, що й у main().
Widget buildApp(SmartHomeNotifier home) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<SmartHomeNotifier>.value(value: home),
      ChangeNotifierProvider(create: (_) => ThemeNotifier()),
    ],
    child: const MyApp(),
  );
}

Finder switchOf(String device) => find.descendant(
      of: find.widgetWithText(ListTile, device),
      matching: find.byType(Switch),
    );

void main() {
  group('SmartHomeNotifier', () {
    test('toggleDevice змінює стан і викликає notifyListeners', () {
      final home = SmartHomeNotifier();
      var notifications = 0;
      home.addListener(() => notifications++);

      expect(home.isOn('Кондиціонер'), isFalse);
      home.toggleDevice('Кондиціонер');

      expect(home.isOn('Кондиціонер'), isTrue);
      expect(home.activeCount, 3);
      expect(notifications, 1);
    });

    test('setBrightness і setRoom оновлюють стан', () {
      final home = SmartHomeNotifier();
      home.setBrightness(0.8);
      home.setRoom('Кухня');

      expect(home.brightnessPercent, 80);
      expect(home.room, 'Кухня');
    });

    test('без зміни значення слухачі не сповіщаються', () {
      final home = SmartHomeNotifier();
      var notifications = 0;
      home.addListener(() => notifications++);

      home.setRoom('Вітальня'); // та сама кімната
      home.setRoom('Гараж'); // кімнати немає у переліку
      home.toggleDevice('Пральна машина'); // пристрою немає
      home.setBrightness(0.5); // те саме значення

      expect(notifications, 0);
    });

    test('devices повертає незмінну копію', () {
      final home = SmartHomeNotifier();
      expect(() => home.devices['Телевізор'] = false, throwsUnsupportedError);
    });
  });

  testWidgets('Один стан відображається на головному екрані та в деталях',
      (tester) async {
    tester.view.physicalSize = const Size(1000, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final home = SmartHomeNotifier();
    await tester.pumpWidget(buildApp(home));

    // Початковий стан: увімкнено 2 з 4 пристроїв
    expect(find.text('2 з 4'), findsOneWidget);
    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('2')),
      findsOneWidget,
    );

    // Вмикаємо кондиціонер на головному екрані
    await tester.tap(switchOf('Кондиціонер'));
    await tester.pump();
    expect(find.text('3 з 4'), findsOneWidget); // панель стану
    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('3')),
      findsOneWidget,
    ); // бейдж в AppBar

    // Вибір кімнати оновлює підзаголовок AppBar (Selector)
    await tester.tap(find.widgetWithText(ChoiceChip, 'Кухня'));
    await tester.pump();
    expect(find.text('Активна кімната: Кухня'), findsOneWidget);

    // Екран деталей показує той самий стан
    await tester.tap(find.byTooltip('Деталі'));
    await tester.pumpAndSettle();
    expect(find.text('Деталі будинку'), findsOneWidget);
    expect(find.text('3 з 4'), findsOneWidget);

    // Зміна на екрані деталей видна після повернення на головний екран
    await tester.tap(switchOf('Телевізор'));
    await tester.pump();
    expect(find.text('2 з 4'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('2 з 4'), findsOneWidget);
    expect(home.isOn('Телевізор'), isFalse);
  });
}
