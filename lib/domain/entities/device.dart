/// Сутність «Пристрій розумного дому».
///
/// Domain-шар не залежить ні від Flutter, ні від способу зберігання даних:
/// це чистий Dart-клас із бізнес-правилами.
class Device {
  const Device({required this.name, this.isOn = false});

  /// Унікальна назва пристрою (використовується як ідентифікатор).
  final String name;

  /// Чи увімкнено пристрій.
  final bool isOn;

  /// Бізнес-правило: перемикання повертає новий стан пристрою,
  /// а не змінює поточний об'єкт (сутність незмінна).
  Device toggled() => Device(name: name, isOn: !isOn);

  @override
  bool operator ==(Object other) =>
      other is Device && other.name == name && other.isOn == isOn;

  @override
  int get hashCode => Object.hash(name, isOn);

  @override
  String toString() => 'Device($name, ${isOn ? 'on' : 'off'})';
}
