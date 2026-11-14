import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';

/// Use case: увімкнути / вимкнути пристрій.
class ToggleDeviceUseCase {
  const ToggleDeviceUseCase(this._repository);

  final DeviceRepository _repository;

  /// Повертає оновлений пристрій або `null`, якщо пристрою не існує.
  Future<Device?> call(String name) async {
    final device = await _repository.findByName(name);
    if (device == null) return null;

    final updated = device.toggled(); // бізнес-правило з Domain
    await _repository.save(updated);
    return updated;
  }
}
