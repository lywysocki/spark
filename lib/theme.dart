import 'package:flutter/material.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3c2765),
      surfaceTint: Color(0xff685394),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff604b8b),
      onPrimaryContainer: Color(0xfffff9ff),
      secondary: Color(0xffad3300),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffff7040),
      onSecondaryContainer: Color(0xff210400),
      tertiary: Color(0xff9d002c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffd72949),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffef7fe),
      onSurface: Color(0xff1d1b1f),
      onSurfaceVariant: Color(0xff49454f),
      outline: Color(0xff7a7580),
      outlineVariant: Color(0xffcbc4d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f34),
      inversePrimary: Color(0xffd3bbff),
      primaryFixed: Color(0xffeaddff),
      onPrimaryFixed: Color(0xff230b4c),
      primaryFixedDim: Color(0xffd3bbff),
      onPrimaryFixedVariant: Color(0xff503b7a),
      secondaryFixed: Color(0xffffdbd0),
      onSecondaryFixed: Color(0xff3a0b00),
      secondaryFixedDim: Color(0xffffb59e),
      onSecondaryFixedVariant: Color(0xff842500),
      tertiaryFixed: Color(0xffffdada),
      onTertiaryFixed: Color(0xff40000c),
      tertiaryFixedDim: Color(0xffffb3b6),
      onTertiaryFixedVariant: Color(0xff920028),
      surfaceDim: Color(0xffded8de),
      surfaceBright: Color(0xfffef7fe),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f2f8),
      surfaceContainer: Color(0xfff2ecf2),
      surfaceContainerHigh: Color(0xffece6ed),
      surfaceContainerHighest: Color(0xffe6e1e7),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3c2765),
      surfaceTint: Color(0xff685394),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff604b8b),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff7d2200),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd34000),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff8a0026),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffd72949),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffef7fe),
      onSurface: Color(0xff1d1b1f),
      onSurfaceVariant: Color(0xff45414b),
      outline: Color(0xff625d68),
      outlineVariant: Color(0xff7e7884),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f34),
      inversePrimary: Color(0xffd3bbff),
      primaryFixed: Color(0xff7f69ac),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff665091),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xffd34000),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xffa93100),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xffdc2d4d),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xffb80836),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffded8de),
      surfaceBright: Color(0xfffef7fe),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f2f8),
      surfaceContainer: Color(0xfff2ecf2),
      surfaceContainerHigh: Color(0xffece6ed),
      surfaceContainerHighest: Color(0xffe6e1e7),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff2a1453),
      surfaceTint: Color(0xff685394),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4c3776),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff450f00),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff7d2200),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4d0011),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8a0026),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffef7fe),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff26222c),
      outline: Color(0xff45414b),
      outlineVariant: Color(0xff45414b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f34),
      inversePrimary: Color(0xfff3e8ff),
      primaryFixed: Color(0xff4c3776),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff35205e),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff7d2200),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff571500),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff8a0026),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff610017),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffded8de),
      surfaceBright: Color(0xfffef7fe),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f2f8),
      surfaceContainer: Color(0xfff2ecf2),
      surfaceContainerHigh: Color(0xffece6ed),
      surfaceContainerHighest: Color(0xffe6e1e7),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd3bbff),
      surfaceTint: Color(0xffd3bbff),
      onPrimary: Color(0xff392462),
      primaryContainer: Color(0xff463170),
      onPrimaryContainer: Color(0xffdcc8ff),
      secondary: Color(0xffffb59e),
      onSecondary: Color(0xff5e1700),
      secondaryContainer: Color(0xffd34000),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xffffb3b6),
      onTertiary: Color(0xff68001a),
      tertiaryContainer: Color(0xffb60435),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff141317),
      onSurface: Color(0xffe6e1e7),
      onSurfaceVariant: Color(0xffcbc4d0),
      outline: Color(0xff948e9a),
      outlineVariant: Color(0xff49454f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e1e7),
      inversePrimary: Color(0xff685394),
      primaryFixed: Color(0xffeaddff),
      onPrimaryFixed: Color(0xff230b4c),
      primaryFixedDim: Color(0xffd3bbff),
      onPrimaryFixedVariant: Color(0xff503b7a),
      secondaryFixed: Color(0xffffdbd0),
      onSecondaryFixed: Color(0xff3a0b00),
      secondaryFixedDim: Color(0xffffb59e),
      onSecondaryFixedVariant: Color(0xff842500),
      tertiaryFixed: Color(0xffffdada),
      onTertiaryFixed: Color(0xff40000c),
      tertiaryFixedDim: Color(0xffffb3b6),
      onTertiaryFixedVariant: Color(0xff920028),
      surfaceDim: Color(0xff141317),
      surfaceBright: Color(0xff3b383d),
      surfaceContainerLowest: Color(0xff0f0d12),
      surfaceContainerLow: Color(0xff1d1b1f),
      surfaceContainer: Color(0xff211f23),
      surfaceContainerHigh: Color(0xff2b292e),
      surfaceContainerHighest: Color(0xff363439),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd6c0ff),
      surfaceTint: Color(0xffd3bbff),
      onPrimary: Color(0xff1e0447),
      primaryContainer: Color(0xff9c85ca),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffbba6),
      onSecondary: Color(0xff300800),
      secondaryContainer: Color(0xffff5717),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffb9bc),
      onTertiary: Color(0xff360009),
      tertiaryContainer: Color(0xffff5168),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff141317),
      onSurface: Color(0xfffff9ff),
      onSurfaceVariant: Color(0xffcfc8d5),
      outline: Color(0xffa7a0ac),
      outlineVariant: Color(0xff87818c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e1e7),
      inversePrimary: Color(0xff513c7b),
      primaryFixed: Color(0xffeaddff),
      onPrimaryFixed: Color(0xff180040),
      primaryFixedDim: Color(0xffd3bbff),
      onPrimaryFixedVariant: Color(0xff3f2a68),
      secondaryFixed: Color(0xffffdbd0),
      onSecondaryFixed: Color(0xff280600),
      secondaryFixedDim: Color(0xffffb59e),
      onSecondaryFixedVariant: Color(0xff681b00),
      tertiaryFixed: Color(0xffffdada),
      onTertiaryFixed: Color(0xff2d0006),
      tertiaryFixedDim: Color(0xffffb3b6),
      onTertiaryFixedVariant: Color(0xff72001d),
      surfaceDim: Color(0xff141317),
      surfaceBright: Color(0xff3b383d),
      surfaceContainerLowest: Color(0xff0f0d12),
      surfaceContainerLow: Color(0xff1d1b1f),
      surfaceContainer: Color(0xff211f23),
      surfaceContainerHigh: Color(0xff2b292e),
      surfaceContainerHighest: Color(0xff363439),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff9ff),
      surfaceTint: Color(0xffd3bbff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffd6c0ff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffff9f8),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffffbba6),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9f9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffffb9bc),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff141317),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffff9ff),
      outline: Color(0xffcfc8d5),
      outlineVariant: Color(0xffcfc8d5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e1e7),
      inversePrimary: Color(0xff321d5b),
      primaryFixed: Color(0xffeee2ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffd6c0ff),
      onPrimaryFixedVariant: Color(0xff1e0447),
      secondaryFixed: Color(0xffffe0d7),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffffbba6),
      onSecondaryFixedVariant: Color(0xff300800),
      tertiaryFixed: Color(0xffffdfe0),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffb9bc),
      onTertiaryFixedVariant: Color(0xff360009),
      surfaceDim: Color(0xff141317),
      surfaceBright: Color(0xff3b383d),
      surfaceContainerLowest: Color(0xff0f0d12),
      surfaceContainerLow: Color(0xff1d1b1f),
      surfaceContainer: Color(0xff211f23),
      surfaceContainerHigh: Color(0xff2b292e),
      surfaceContainerHighest: Color(0xff363439),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}

const redDark = Color.fromARGB(255, 113, 10, 20);
const redLight = Color.fromARGB(255, 255, 233, 233);

const orangeDark = Color(0xffd83831);
const orangeLight = Color.fromARGB(255, 255, 234, 228);

const yellowDark = Color.fromARGB(255, 152, 117, 0);
const yellowLight = Color.fromARGB(255, 246, 236, 208);

const greenDark = Color.fromARGB(255, 14, 43, 1);
const greenLight = Color.fromARGB(255, 221, 238, 211);

const blueDark = Color(0xff272152);
const blueLight = Color.fromARGB(255, 225, 224, 237);

const purpleDark = Color(0xff55235A);
const purpleLight = Color.fromARGB(255, 245, 224, 247);

const pinkOutline = Color.fromARGB(255, 162, 26, 62);
const pinkBackground = Color.fromARGB(255, 255, 219, 229);
