import 'package:flutter/material.dart';

final sparkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _lightColorScheme,
  textTheme: _lightTextTheme,
  navigationBarTheme: const NavigationBarThemeData(
    iconTheme: WidgetStatePropertyAll(
      IconThemeData(color: accentBlue),
    ),
    labelTextStyle:
        WidgetStatePropertyAll(TextStyle(fontSize: 12, color: accentBlue)),
  ),
  iconTheme: const IconThemeData(color: accentBlue),
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStatePropertyAll(accentBlue),
    ),
  ),
  listTileTheme: const ListTileThemeData(iconColor: accentBlue),
  cardTheme: const CardTheme(
    color: transAccentBlue,
    shape: OutlineInputBorder(
      borderSide: BorderSide(color: accentBlue),
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
);

const accentPurple = Color(0xFF55235A);
const accentBlue = Color(0xFF272152);
const transAccentBlue =
    Color.fromARGB(255, 220, 219, 232); //Color.fromARGB(255, 217, 216, 227);

final _lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFFDB2C42),
  primary: const Color(0xFFFF7447),
  secondary: const Color(0xFFDB2C42),
  tertiary: const Color(0xFF8A1C3B),
  surface: const Color(0xFFFCF8F8),
);

// I don't think this is working
const TextTheme _lightTextTheme = TextTheme(
  titleSmall: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: accentBlue,
  ),
  titleMedium: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: accentBlue,
  ),
  titleLarge: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: accentBlue,
  ),
  bodySmall: TextStyle(fontSize: 14, color: accentBlue),
  bodyMedium: TextStyle(fontSize: 18, color: accentBlue),
);

//const TextTheme().copyWith(
//   bodySmall: const TextStyle(color: accentBlue),
//   bodyMedium: const TextStyle(color: accentBlue),
//   bodyLarge: const TextStyle(color: accentBlue),
//   labelSmall: const TextStyle(color: accentBlue),
//   labelMedium: const TextStyle(color: accentBlue),
//   labelLarge: const TextStyle(color: accentBlue),
//   displaySmall: const TextStyle(color: accentBlue),
//   displayMedium: const TextStyle(color: accentBlue),
//   displayLarge: const TextStyle(color: accentBlue),
//   headlineLarge: const TextStyle(color: accentBlue),
//   headlineMedium: const TextStyle(color: accentBlue),
//   headlineSmall: const TextStyle(color: accentBlue),
//   titleLarge: const TextStyle(color: accentBlue),
//   titleMedium: const TextStyle(color: accentBlue),
//   titleSmall: const TextStyle(color: accentBlue),
// );