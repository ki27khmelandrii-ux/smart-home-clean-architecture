import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/app_config.dart';
import 'screens/home_screen.dart';
import 'state/smart_home_notifier.dart';
import 'state/theme_notifier.dart';

/// Кореневий віджет: надає зібраний стан через Provider.
class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key, required this.home});

  final SmartHomeNotifier home;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: home),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp перебудовується лише при зміні теми
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
