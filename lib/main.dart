import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presentation/screens/home_screen.dart';
import 'presentation/state/smart_home_notifier.dart';
import 'presentation/state/theme_notifier.dart';

void main() {
  runApp(
    // Провайдери розміщено над MaterialApp, тому стан доступний
    // на всіх екранах (головний екран і екран деталей).
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SmartHomeNotifier()),
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
    // context.select: MaterialApp перебудовується лише при зміні теми,
    // а не при зміні стану пристроїв.
    final themeMode = context.select<ThemeNotifier, ThemeMode>(
      (theme) => theme.themeMode,
    );

    return MaterialApp(
      title: 'Розумний дім',
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
