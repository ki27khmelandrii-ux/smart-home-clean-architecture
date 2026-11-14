import '../../domain/entities/home_settings.dart';
import '../../domain/repositories/settings_repository.dart';

/// Реалізація [SettingsRepository], що зберігає налаштування в пам'яті.
class InMemorySettingsRepository implements SettingsRepository {
  HomeSettings _settings = const HomeSettings();

  @override
  Future<HomeSettings> load() async => _settings;

  @override
  Future<void> save(HomeSettings settings) async => _settings = settings;
}
