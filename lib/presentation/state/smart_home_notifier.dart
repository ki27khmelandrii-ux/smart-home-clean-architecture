import 'package:flutter/foundation.dart';

/// Глобальний стан розумного дому (ЛР №4, варіант 22).
///
/// Зберігає стан пристроїв, яскравість освітлення та активну кімнату.
/// Віджети читають стан через публічні геттери, а змінюють лише
/// через методи, які після зміни викликають notifyListeners().
class SmartHomeNotifier extends ChangeNotifier {
  /// Перелік кімнат будинку.
  static const List<String> rooms = ['Вітальня', 'Спальня', 'Кухня', 'Ванна'];

  // ─── 1. Приватні поля стану ─────────────────────────────────
  final Map<String, bool> _devices = {
    'Лампа у вітальні': true,
    'Кондиціонер': false,
    'Телевізор': true,
    'Розумна колонка': false,
  };
  double _brightness = 0.5;
  String _room = rooms.first;

  // ─── 2. Публічні геттери (лише читання) ─────────────────────
  /// Незмінна копія словника: змінити стан в обхід методів неможливо.
  Map<String, bool> get devices => Map.unmodifiable(_devices);

  double get brightness => _brightness;

  int get brightnessPercent => (_brightness * 100).round();

  String get room => _room;

  int get totalCount => _devices.length;

  /// Кількість увімкнених пристроїв.
  int get activeCount => _devices.values.where((isOn) => isOn).length;

  bool isOn(String name) => _devices[name] ?? false;

  // ─── 3. Методи зміни стану ──────────────────────────────────
  /// Перемикає пристрій (увімкнено ↔ вимкнено).
  void toggleDevice(String name) {
    final current = _devices[name];
    if (current == null) return; // невідомий пристрій
    _devices[name] = !current;
    notifyListeners();
  }

  /// Встановлює яскравість у межах 0.0–1.0.
  void setBrightness(double value) {
    final newValue = value.clamp(0.0, 1.0).toDouble();
    if (newValue == _brightness) return; // стан не змінився
    _brightness = newValue;
    notifyListeners();
  }

  /// Робить активною одну з кімнат переліку [rooms].
  void setRoom(String room) {
    if (room == _room || !rooms.contains(room)) return;
    _room = room;
    notifyListeners();
  }
}
