import '../entities/device.dart';

/// Абстракція сховища пристроїв.
///
/// Інтерфейс оголошено в Domain-шарі, а реалізацію (InMemory, JSON, SQLite)
/// розміщено в Infrastructure. Use cases залежать лише від цієї абстракції —
/// це і є принцип інверсії залежностей (DIP).
abstract interface class DeviceRepository {
  /// Усі пристрої будинку в порядку додавання.
  Future<List<Device>> getAll();

  /// Пристрій за назвою або `null`, якщо такого немає.
  Future<Device?> findByName(String name);

  /// Зберігає (оновлює) стан пристрою.
  Future<void> save(Device device);
}
