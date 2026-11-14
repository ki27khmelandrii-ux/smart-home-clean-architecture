import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';

/// Реалізація [DeviceRepository], що зберігає пристрої в пам'яті.
class InMemoryDeviceRepository implements DeviceRepository {
  // LinkedHashMap зберігає порядок додавання пристроїв.
  final Map<String, Device> _devices = {
    'Лампа у вітальні': const Device(name: 'Лампа у вітальні', isOn: true),
    'Кондиціонер': const Device(name: 'Кондиціонер'),
    'Телевізор': const Device(name: 'Телевізор', isOn: true),
    'Розумна колонка': const Device(name: 'Розумна колонка'),
  };

  @override
  Future<List<Device>> getAll() async => List.unmodifiable(_devices.values);

  @override
  Future<Device?> findByName(String name) async => _devices[name];

  @override
  Future<void> save(Device device) async => _devices[device.name] = device;
}
