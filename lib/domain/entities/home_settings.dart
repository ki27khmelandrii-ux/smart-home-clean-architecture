/// Сутність «Налаштування будинку»: активна кімната та яскравість.
///
/// Бізнес-правила (межі яскравості, допустимі кімнати) зосереджено тут,
/// щоб жоден use case чи віджет не дублював перевірки.
class HomeSettings {
  const HomeSettings({this.room = 'Вітальня', this.brightness = 0.5});

  /// Перелік кімнат будинку.
  static const List<String> rooms = ['Вітальня', 'Спальня', 'Кухня', 'Ванна'];

  /// Активна кімната.
  final String room;

  /// Яскравість освітлення у діапазоні 0.0–1.0.
  final double brightness;

  /// Яскравість у відсотках для відображення.
  int get brightnessPercent => (brightness * 100).round();

  /// Бізнес-правило: яскравість завжди лежить у межах 0.0–1.0.
  HomeSettings withBrightness(double value) =>
      HomeSettings(room: room, brightness: value.clamp(0.0, 1.0).toDouble());

  /// Бізнес-правило: активною може бути лише кімната з переліку [rooms];
  /// невідома кімната ігнорується.
  HomeSettings withRoom(String value) => rooms.contains(value)
      ? HomeSettings(room: value, brightness: brightness)
      : this;

  @override
  bool operator ==(Object other) =>
      other is HomeSettings &&
      other.room == room &&
      other.brightness == brightness;

  @override
  int get hashCode => Object.hash(room, brightness);

  @override
  String toString() => 'HomeSettings($room, $brightnessPercent%)';
}
