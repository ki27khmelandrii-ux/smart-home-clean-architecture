import 'package:material_ui/material_ui.dart';

import 'presentation/app.dart';
import 'presentation/di/injection.dart';

/// Точка входу застосунку (Presentation-шар).
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Composition Root: усі шари збираються в createSmartHome().
  final home = createSmartHome();
  await home.load();

  runApp(SmartHomeApp(home: home));
}
