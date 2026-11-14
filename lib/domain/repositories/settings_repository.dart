import '../entities/home_settings.dart';

/// Абстракція сховища налаштувань будинку (кімната, яскравість).
abstract interface class SettingsRepository {
  Future<HomeSettings> load();

  Future<void> save(HomeSettings settings);
}
