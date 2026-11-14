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
}
