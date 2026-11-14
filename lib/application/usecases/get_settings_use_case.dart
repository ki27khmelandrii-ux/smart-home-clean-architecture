import '../../domain/entities/home_settings.dart';
import '../../domain/repositories/settings_repository.dart';

/// Use case: отримати поточні налаштування будинку.
class GetSettingsUseCase {
  const GetSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  Future<HomeSettings> call() => _repository.load();
}
