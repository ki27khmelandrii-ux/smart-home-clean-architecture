import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';

/// Реалізація [DeviceRepository], що зберігає пристрої в пам'яті.
class InMemoryDeviceRepository implements DeviceRepository {
  /// Початкові дані можна передати ззовні (наприклад, у тестах);
  /// без параметра використовується набір [defaultDevices].
  InMemoryDeviceRepository([List<Device> initial = defaultDevices])
      : _devices = {for (final device in initial) device.name: device};

  static const List<Device> defaultDevices = [
    Device(name: 'Лампа у вітальні', isOn: true),
    Device(name: 'Кондиціонер'),
    Device(name: 'Телевізор', isOn: true),
    Device(name: 'Розумна колонка'),
  ];

  // LinkedHashMap зберігає порядок додавання пристроїв.
  final Map<String, Device> _devices;

  @override
  Future<List<Device>> getAll() async => List.unmodifiable(_devices.values);

  @override
  Future<Device?> findByName(String name) async => _devices[name];

  @override
  Future<void> save(Device device) async => _devices[device.name] = device;
}
