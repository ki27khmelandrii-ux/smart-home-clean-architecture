import 'package:flutter_test/flutter_test.dart';
import 'package:smart_home/domain/entities/device.dart';
import 'package:smart_home/domain/entities/home_settings.dart';
import 'package:smart_home/infrastructure/repositories/in_memory_device_repository.dart';
import 'package:smart_home/infrastructure/repositories/in_memory_settings_repository.dart';

void main() {
  group('InMemoryDeviceRepository', () {
    test('містить 4 пристрої за замовчуванням', () async {
      final repo = InMemoryDeviceRepository();
      final devices = await repo.getAll();
      expect(devices.length, 4);
      expect(devices.where((d) => d.isOn).length, 2);
    });

    test('save оновлює пристрій, findByName його знаходить', () async {
      final repo = InMemoryDeviceRepository();
      await repo.save(const Device(name: 'Кондиціонер', isOn: true));
      expect((await repo.findByName('Кондиціонер'))!.isOn, isTrue);
      expect(await repo.findByName('Гараж'), isNull);
    });

    test('getAll повертає незмінний список', () async {
      final devices = await InMemoryDeviceRepository().getAll();
      expect(() => devices.clear(), throwsUnsupportedError);
    });

    test('приймає початкові дані через конструктор', () async {
      final repo = InMemoryDeviceRepository([const Device(name: 'Бойлер')]);
      expect((await repo.getAll()).single.name, 'Бойлер');
    });
  });

  test('InMemorySettingsRepository зберігає налаштування', () async {
    final repo = InMemorySettingsRepository();
    expect((await repo.load()).brightnessPercent, 50);

    await repo.save(const HomeSettings(room: 'Кухня', brightness: 0.8));
    expect(await repo.load(), const HomeSettings(room: 'Кухня', brightness: 0.8));
  });
}
