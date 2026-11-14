import 'package:flutter/foundation.dart';

import '../../application/usecases/get_devices_use_case.dart';
import '../../application/usecases/get_settings_use_case.dart';
import '../../application/usecases/select_room_use_case.dart';
import '../../application/usecases/set_brightness_use_case.dart';
import '../../application/usecases/toggle_device_use_case.dart';
import '../../domain/entities/device.dart';
import '../../domain/entities/home_settings.dart';

/// Стан екрана «Розумний дім» (Presentation-шар).
///
/// Notifier не містить бізнес-логіки і не знає, де зберігаються дані:
/// кожну дію він делегує відповідному use case, а результат
/// показує віджетам через notifyListeners().
class SmartHomeNotifier extends ChangeNotifier {
  SmartHomeNotifier({
    required GetDevicesUseCase getDevices,
    required ToggleDeviceUseCase toggleDevice,
    required GetSettingsUseCase getSettings,
    required SetBrightnessUseCase setBrightness,
    required SelectRoomUseCase selectRoom,
  })  : _getDevices = getDevices,
        _toggleDevice = toggleDevice,
        _getSettings = getSettings,
        _setBrightness = setBrightness,
        _selectRoom = selectRoom;

  final GetDevicesUseCase _getDevices;
  final ToggleDeviceUseCase _toggleDevice;
  final GetSettingsUseCase _getSettings;
  final SetBrightnessUseCase _setBrightness;
  final SelectRoomUseCase _selectRoom;

  /// Перелік кімнат береться з Domain-шару.
  static const List<String> rooms = HomeSettings.rooms;

  List<Device> _devices = const [];
  HomeSettings _settings = const HomeSettings();

  // ─── Геттери для віджетів (API не змінився з ЛР №4) ─────────
  Map<String, bool> get devices =>
      Map.unmodifiable({for (final d in _devices) d.name: d.isOn});

  double get brightness => _settings.brightness;

  int get brightnessPercent => _settings.brightnessPercent;

  String get room => _settings.room;

  int get totalCount => _devices.length;

  int get activeCount => _devices.where((d) => d.isOn).length;

  bool isOn(String name) => _devices.any((d) => d.name == name && d.isOn);

  // ─── Дії користувача → use cases ────────────────────────────
  /// Початкове завантаження даних зі сховища.
  Future<void> load() async {
    _devices = await _getDevices();
    _settings = await _getSettings();
    notifyListeners();
  }

  Future<void> toggleDevice(String name) async {
    final updated = await _toggleDevice(name);
    if (updated == null) return; // невідомий пристрій
    _devices = [for (final d in _devices) d.name == name ? updated : d];
    notifyListeners();
  }

  Future<void> setBrightness(double value) async =>
      _applySettings(await _setBrightness(value));

  Future<void> setRoom(String room) async =>
      _applySettings(await _selectRoom(room));

  void _applySettings(HomeSettings settings) {
    if (settings == _settings) return; // стан не змінився
    _settings = settings;
    notifyListeners();
  }
}
