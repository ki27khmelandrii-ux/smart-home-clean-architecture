import 'package:flutter_test/flutter_test.dart';
import 'package:smart_home/domain/entities/device.dart';
import 'package:smart_home/domain/entities/home_settings.dart';

void main() {
  group('Device', () {
    test('toggled повертає новий об\'єкт із протилежним станом', () {
      const lamp = Device(name: 'Лампа', isOn: true);
      final toggled = lamp.toggled();

      expect(toggled.isOn, isFalse);
      expect(lamp.isOn, isTrue); // вихідний об'єкт не змінився
    });

    test('пристрої з однаковими даними рівні', () {
      expect(const Device(name: 'ТВ'), const Device(name: 'ТВ'));
    });
  });

  group('HomeSettings', () {
    test('значення за замовчуванням', () {
      const settings = HomeSettings();
      expect(settings.room, 'Вітальня');
      expect(settings.brightnessPercent, 50);
    });

    test('withBrightness обмежує яскравість діапазоном 0–100 %', () {
      const settings = HomeSettings();
      expect(settings.withBrightness(0.8).brightnessPercent, 80);
      expect(settings.withBrightness(1.7).brightness, 1.0);
      expect(settings.withBrightness(-0.3).brightness, 0.0);
    });

    test('withRoom приймає лише кімнати з переліку', () {
      const settings = HomeSettings();
      expect(settings.withRoom('Кухня').room, 'Кухня');
      expect(settings.withRoom('Гараж'), settings); // невідома кімната
    });
  });
}
