import 'package:flutter_test/flutter_test.dart';
import 'package:smart_home/application/usecases/get_devices_use_case.dart';
import 'package:smart_home/application/usecases/get_settings_use_case.dart';
import 'package:smart_home/application/usecases/select_room_use_case.dart';
import 'package:smart_home/application/usecases/set_brightness_use_case.dart';
import 'package:smart_home/application/usecases/toggle_device_use_case.dart';
import 'package:smart_home/domain/entities/device.dart';
import 'package:smart_home/domain/entities/home_settings.dart';
import 'package:smart_home/domain/repositories/device_repository.dart';
import 'package:smart_home/domain/repositories/settings_repository.dart';

/// Фейкові репозиторії: use cases тестуються без Infrastructure-шару,
/// бо залежать лише від інтерфейсів Domain.
class FakeDeviceRepository implements DeviceRepository {
  final Map<String, Device> items = {
    'Лампа': const Device(name: 'Лампа', isOn: true),
    'ТВ': const Device(name: 'ТВ'),
  };

  @override
  Future<List<Device>> getAll() async => items.values.toList();

  @override
  Future<Device?> findByName(String name) async => items[name];

  @override
  Future<void> save(Device device) async => items[device.name] = device;
}

class FakeSettingsRepository implements SettingsRepository {
  HomeSettings stored = const HomeSettings();
  int saves = 0;

  @override
  Future<HomeSettings> load() async => stored;

  @override
  Future<void> save(HomeSettings settings) async {
    stored = settings;
    saves++;
  }
}

void main() {
  late FakeDeviceRepository devices;
  late FakeSettingsRepository settings;

  setUp(() {
    devices = FakeDeviceRepository();
    settings = FakeSettingsRepository();
  });

  test('GetDevicesUseCase повертає всі пристрої', () async {
    final result = await GetDevicesUseCase(devices)();
    expect(result.map((d) => d.name), ['Лампа', 'ТВ']);
  });

  test('ToggleDeviceUseCase перемикає та зберігає пристрій', () async {
    final updated = await ToggleDeviceUseCase(devices)('ТВ');
    expect(updated?.isOn, isTrue);
    expect(devices.items['ТВ']!.isOn, isTrue);
  });

  test('ToggleDeviceUseCase повертає null для невідомого пристрою', () async {
    expect(await ToggleDeviceUseCase(devices)('Пральна машина'), isNull);
  });

  test('GetSettingsUseCase читає налаштування', () async {
    expect(await GetSettingsUseCase(settings)(), const HomeSettings());
  });

  test('SetBrightnessUseCase застосовує правило меж яскравості', () async {
    final result = await SetBrightnessUseCase(settings)(1.5);
    expect(result.brightness, 1.0);
    expect(settings.stored.brightness, 1.0);
  });

  test('SelectRoomUseCase змінює кімнату', () async {
    final result = await SelectRoomUseCase(settings)('Кухня');
    expect(result.room, 'Кухня');
    expect(settings.stored.room, 'Кухня');
  });
}
