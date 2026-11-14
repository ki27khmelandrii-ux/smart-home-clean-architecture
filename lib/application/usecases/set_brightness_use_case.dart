import '../../domain/entities/home_settings.dart';
import '../../domain/repositories/settings_repository.dart';

/// Use case: змінити яскравість освітлення.
class SetBrightnessUseCase {
  const SetBrightnessUseCase(this._repository);

  final SettingsRepository _repository;

  Future<HomeSettings> call(double value) async {
    final current = await _repository.load();
    final updated = current.withBrightness(value);
    await _repository.save(updated);
    return updated;
  }
}
