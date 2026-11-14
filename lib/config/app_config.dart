/// Конфігурація застосунку «Розумний дім».
///
/// Значення використовуються під час збирання залежностей у main.dart
/// та в Infrastructure-шарі. Domain-шар про конфігурацію не знає.
class AppConfig {
  AppConfig._();

  /// Назва застосунку.
  static const String appTitle = 'Розумний дім';

  /// Версія застосунку (показується на екрані деталей).
  static const String version = '1.0.0';

  /// Тип сховища даних: 'memory' — InMemory-репозиторії.
  static const String storage = 'memory';

  /// Початкова яскравість освітлення (0.0–1.0).
  static const double initialBrightness = 0.5;
}
