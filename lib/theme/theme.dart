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
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 151, 67, 67),
    primary: const Color.fromARGB(255, 101, 12, 160),
    brightness: Brightness.dark,
  ),
);
