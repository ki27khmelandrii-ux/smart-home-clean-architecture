import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';

/// Use case: отримати перелік пристроїв будинку.
class GetDevicesUseCase {
  const GetDevicesUseCase(this._repository);

  /// Залежність від абстракції Domain-шару, а не від конкретного сховища.
  final DeviceRepository _repository;

  Future<List<Device>> call() => _repository.getAll();
}
