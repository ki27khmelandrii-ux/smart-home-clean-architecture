/// Сутність «Налаштування будинку»: активна кімната та яскравість.
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

  HomeSettings copyWith({String? room, double? brightness}) => HomeSettings(
        room: room ?? this.room,
        brightness: brightness ?? this.brightness,
      );

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
