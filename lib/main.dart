import 'package:coctail_world/screens/cocktail_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coctail World',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const CoctailScreen(),
    );
  }
}

ThemeData _buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: Colors.deepOrange, // zmień tu, żeby zmienić cały wygląd
    brightness: brightness,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      centerTitle: true,
    ),
  );
}
