import 'package:flutter/material.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xffa4001c),
      surfaceTint: Color(0xffbb1627),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffdb313b),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff854a78),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffca87b9),
      onSecondaryContainer: Color(0xff23001e),
      tertiary: Color(0xff9e421b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffff9b75),
      onTertiaryContainer: Color(0xff4e1600),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff271717),
      onSurfaceVariant: Color(0xff5b403e),
      outline: Color(0xff8f6f6d),
      outlineVariant: Color(0xffe4bebb),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3e2c2b),
      inversePrimary: Color(0xffffb3af),
      primaryFixed: Color(0xffffdad7),
      onPrimaryFixed: Color(0xff410005),
      primaryFixedDim: Color(0xffffb3af),
      onPrimaryFixedVariant: Color(0xff930018),
      secondaryFixed: Color(0xffffd7f1),
      onSecondaryFixed: Color(0xff370431),
      secondaryFixedDim: Color(0xfff8b0e4),
      onSecondaryFixedVariant: Color(0xff6a335f),
      tertiaryFixed: Color(0xffffdbce),
      onTertiaryFixed: Color(0xff380d00),
      tertiaryFixedDim: Color(0xffffb59a),
      onTertiaryFixedVariant: Color(0xff7e2c04),
      surfaceDim: Color(0xfff1d3d1),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ef),
      surfaceContainer: Color(0xffffe9e7),
      surfaceContainerHigh: Color(0xffffe1df),
      surfaceContainerHighest: Color(0xfff9dcda),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff8b0016),
      surfaceTint: Color(0xffbb1627),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffdb313b),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff662f5b),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff9e608f),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff792801),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffba572f),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff271717),
      onSurfaceVariant: Color(0xff573c3b),
      outline: Color(0xff765856),
      outlineVariant: Color(0xff937371),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3e2c2b),
      inversePrimary: Color(0xffffb3af),
      primaryFixed: Color(0xffdb313b),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xffb71225),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff9e608f),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff824875),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xffba572f),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff9b4019),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xfff1d3d1),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ef),
      surfaceContainer: Color(0xffffe9e7),
      surfaceContainerHigh: Color(0xffffe1df),
      surfaceContainerHighest: Color(0xfff9dcda),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff4d0008),
      surfaceTint: Color(0xffbb1627),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff8b0016),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3f0c38),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff662f5b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff431200),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff792801),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff351e1d),
      outline: Color(0xff573c3b),
      outlineVariant: Color(0xff573c3b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3e2c2b),
      inversePrimary: Color(0xffffe7e5),
      primaryFixed: Color(0xff8b0016),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff61000c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff662f5b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4c1843),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff792801),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff541900),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xfff1d3d1),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ef),
      surfaceContainer: Color(0xffffe9e7),
      surfaceContainerHigh: Color(0xffffe1df),
      surfaceContainerHighest: Color(0xfff9dcda),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb3af),
      surfaceTint: Color(0xffffb3af),
      onPrimary: Color(0xff68000e),
      primaryContainer: Color(0xffd82f39),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xfff8b0e4),
      onSecondary: Color(0xff501c47),
      secondaryContainer: Color(0xff9e608f),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xffffbfa8),
      onTertiary: Color(0xff5b1b00),
      tertiaryContainer: Color(0xfff78659),
      onTertiaryContainer: Color(0xff350c00),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1e0f0f),
      onSurface: Color(0xfff9dcda),
      onSurfaceVariant: Color(0xffe4bebb),
      outline: Color(0xffab8986),
      outlineVariant: Color(0xff5b403e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff9dcda),
      inversePrimary: Color(0xffbb1627),
      primaryFixed: Color(0xffffdad7),
      onPrimaryFixed: Color(0xff410005),
      primaryFixedDim: Color(0xffffb3af),
      onPrimaryFixedVariant: Color(0xff930018),
      secondaryFixed: Color(0xffffd7f1),
      onSecondaryFixed: Color(0xff370431),
      secondaryFixedDim: Color(0xfff8b0e4),
      onSecondaryFixedVariant: Color(0xff6a335f),
      tertiaryFixed: Color(0xffffdbce),
      onTertiaryFixed: Color(0xff380d00),
      tertiaryFixedDim: Color(0xffffb59a),
      onTertiaryFixedVariant: Color(0xff7e2c04),
      surfaceDim: Color(0xff1e0f0f),
      surfaceBright: Color(0xff473533),
      surfaceContainerLowest: Color(0xff180a0a),
      surfaceContainerLow: Color(0xff271717),
      surfaceContainer: Color(0xff2c1b1b),
      surfaceContainerHigh: Color(0xff372625),
      surfaceContainerHighest: Color(0xff43302f),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb9b5),
      surfaceTint: Color(0xffffb3af),
      onPrimary: Color(0xff370004),
      primaryContainer: Color(0xffff5356),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffdb4e9),
      onSecondary: Color(0xff30002b),
      secondaryContainer: Color(0xffbd7bac),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffbfa8),
      onTertiary: Color(0xff340c00),
      tertiaryContainer: Color(0xfff78659),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1e0f0f),
      onSurface: Color(0xfffff9f9),
      onSurfaceVariant: Color(0xffe8c2bf),
      outline: Color(0xffbe9a98),
      outlineVariant: Color(0xff9c7b79),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff9dcda),
      inversePrimary: Color(0xff950019),
      primaryFixed: Color(0xffffdad7),
      onPrimaryFixed: Color(0xff2d0003),
      primaryFixedDim: Color(0xffffb3af),
      onPrimaryFixedVariant: Color(0xff730011),
      secondaryFixed: Color(0xffffd7f1),
      onSecondaryFixed: Color(0xff280023),
      secondaryFixedDim: Color(0xfff8b0e4),
      onSecondaryFixedVariant: Color(0xff57224d),
      tertiaryFixed: Color(0xffffdbce),
      onTertiaryFixed: Color(0xff260700),
      tertiaryFixedDim: Color(0xffffb59a),
      onTertiaryFixedVariant: Color(0xff641f00),
      surfaceDim: Color(0xff1e0f0f),
      surfaceBright: Color(0xff473533),
      surfaceContainerLowest: Color(0xff180a0a),
      surfaceContainerLow: Color(0xff271717),
      surfaceContainer: Color(0xff2c1b1b),
      surfaceContainerHigh: Color(0xff372625),
      surfaceContainerHighest: Color(0xff43302f),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff9f9),
      surfaceTint: Color(0xffffb3af),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffb9b5),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffff9f9),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xfffdb4e9),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9f8),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffffbba2),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1e0f0f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffff9f9),
      outline: Color(0xffe8c2bf),
      outlineVariant: Color(0xffe8c2bf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff9dcda),
      inversePrimary: Color(0xff5c000b),
      primaryFixed: Color(0xffffe0dd),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb9b5),
      onPrimaryFixedVariant: Color(0xff370004),
      secondaryFixed: Color(0xffffddf2),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xfffdb4e9),
      onSecondaryFixedVariant: Color(0xff30002b),
      tertiaryFixed: Color(0xffffe0d6),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffbba2),
      onTertiaryFixedVariant: Color(0xff2f0a00),
      surfaceDim: Color(0xff1e0f0f),
      surfaceBright: Color(0xff473533),
      surfaceContainerLowest: Color(0xff180a0a),
      surfaceContainerLow: Color(0xff271717),
      surfaceContainer: Color(0xff2c1b1b),
      surfaceContainerHigh: Color(0xff372625),
      surfaceContainerHighest: Color(0xff43302f),
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

  /// Custom Color 1
  static const customColor1 = ExtendedColor(
    seed: Color(0xffa0aad2),
    value: Color(0xffa0aad2),
    light: ColorFamily(
      color: Color(0xff535d81),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffaab4dd),
      onColorContainer: Color(0xff1e2849),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff535d81),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffaab4dd),
      onColorContainer: Color(0xff1e2849),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff535d81),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffaab4dd),
      onColorContainer: Color(0xff1e2849),
    ),
    dark: ColorFamily(
      color: Color(0xffc2ccf5),
      onColor: Color(0xff252f50),
      colorContainer: Color(0xff99a3cb),
      onColorContainer: Color(0xff0c1737),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffc2ccf5),
      onColor: Color(0xff252f50),
      colorContainer: Color(0xff99a3cb),
      onColorContainer: Color(0xff0c1737),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffc2ccf5),
      onColor: Color(0xff252f50),
      colorContainer: Color(0xff99a3cb),
      onColorContainer: Color(0xff0c1737),
    ),
  );

  List<ExtendedColor> get extendedColors => [
        customColor1,
      ];
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

const redDark = Color(0xff8c0009);
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
