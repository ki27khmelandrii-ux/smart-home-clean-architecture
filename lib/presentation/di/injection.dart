import '../../application/usecases/get_devices_use_case.dart';
import '../../application/usecases/get_settings_use_case.dart';
import '../../application/usecases/select_room_use_case.dart';
import '../../application/usecases/set_brightness_use_case.dart';
import '../../application/usecases/toggle_device_use_case.dart';
import '../../config/app_config.dart';
import '../../domain/repositories/device_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../infrastructure/repositories/in_memory_device_repository.dart';
import '../../infrastructure/repositories/in_memory_settings_repository.dart';
import '../state/smart_home_notifier.dart';

/// Composition Root: збирає всі шари через Dependency Injection
/// (залежності передаються через конструктори).
///
/// Репозиторії можна підмінити параметрами — так роблять тести.
/// Use cases і віджети від цього не змінюються.
SmartHomeNotifier createSmartHome({
  DeviceRepository? devices,
  SettingsRepository? settings,
}) {
  final DeviceRepository deviceRepository = devices ?? _createDeviceRepository();
  final SettingsRepository settingsRepository =
      settings ?? InMemorySettingsRepository();

  return SmartHomeNotifier(
    getDevices: GetDevicesUseCase(deviceRepository),
    toggleDevice: ToggleDeviceUseCase(deviceRepository),
    getSettings: GetSettingsUseCase(settingsRepository),
    setBrightness: SetBrightnessUseCase(settingsRepository),
    selectRoom: SelectRoomUseCase(settingsRepository),
  );
}

/// Реалізація сховища обирається конфігурацією (AppConfig.storage).
DeviceRepository _createDeviceRepository() => switch (AppConfig.storage) {
      'memory' => InMemoryDeviceRepository(),
      _ => throw UnsupportedError('Невідоме сховище: ${AppConfig.storage}'),
    };
