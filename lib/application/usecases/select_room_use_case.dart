import '../../domain/entities/home_settings.dart';
import '../../domain/repositories/settings_repository.dart';

/// Use case: обрати активну кімнату.
class SelectRoomUseCase {
  const SelectRoomUseCase(this._repository);

  final SettingsRepository _repository;

  Future<HomeSettings> call(String room) async {
    final current = await _repository.load();
    final updated = current.withRoom(room);
    if (updated == current) return current; // нічого не змінилось
    await _repository.save(updated);
    return updated;
  }
}
