import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'application/usecases/get_devices_use_case.dart';
import 'application/usecases/get_settings_use_case.dart';
import 'application/usecases/select_room_use_case.dart';
import 'application/usecases/set_brightness_use_case.dart';
import 'application/usecases/toggle_device_use_case.dart';
import 'config/app_config.dart';
import 'domain/repositories/device_repository.dart';
import 'domain/repositories/settings_repository.dart';
import 'infrastructure/repositories/in_memory_device_repository.dart';
import 'infrastructure/repositories/in_memory_settings_repository.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/state/smart_home_notifier.dart';
import 'presentation/state/theme_notifier.dart';

/// Точка входу (Presentation-шар) — Composition Root.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ─── Збирання шарів через Dependency Injection ──────────────
  final DeviceRepository deviceRepository = InMemoryDeviceRepository();
  final SettingsRepository settingsRepository = InMemorySettingsRepository();

  final home = SmartHomeNotifier(
    getDevices: GetDevicesUseCase(deviceRepository),
    toggleDevice: ToggleDeviceUseCase(deviceRepository),
    getSettings: GetSettingsUseCase(settingsRepository),
    setBrightness: SetBrightnessUseCase(settingsRepository),
    selectRoom: SelectRoomUseCase(settingsRepository),
  );
  await home.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: home),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<ThemeNotifier, ThemeMode>(
      (theme) => theme.themeMode,
    );

    return MaterialApp(
      title: AppConfig.appTitle,
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: themeMode,
      home: const HomeScreen(),
    );
  }

  static ThemeData _buildTheme(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6750A4),
        brightness: brightness,
      ),
    );
  }
}
