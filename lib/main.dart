import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NimithamApp());
}

class NimithamApp extends StatelessWidget {
  const NimithamApp({super.key});

  @override
  Widget build(BuildContext context) {
    const saffron = Color(0xFFD4860A);

    final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: saffron,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFFDF6E3),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: saffron,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF0D0700),
    );

    return MaterialApp(
      title: 'நிமித்தம்',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
