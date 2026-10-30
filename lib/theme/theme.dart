import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 224, 238, 105),
    primary: const Color.fromARGB(255, 229, 190, 60),
    brightness: Brightness.light,
  ),
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF9C2A3A),
    brightness: Brightness.dark,
  ),
);
