import 'package:flutter/material.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff3f0631),
      surfaceTint: Color(0xff8a4873),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff672953),
      onPrimaryContainer: Color(0xffffc5e5),
      secondary: Color(0xff484b84),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6c6fab),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xffb81f1e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffff6e61),
      onTertiaryContainer: Color(0xff270001),
      error: Color(0xffa0001e),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffe50030),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffff8f9),
      onBackground: Color(0xff201a1d),
      surface: Color(0xfffff8f9),
      onSurface: Color(0xff201a1d),
      surfaceVariant: Color(0xfff1dde6),
      onSurfaceVariant: Color(0xff50434a),
      outline: Color(0xff83737a),
      outlineVariant: Color(0xffd5c1ca),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff352e32),
      inverseOnSurface: Color(0xfffaedf2),
      inversePrimary: Color(0xffffaede),
      primaryFixed: Color(0xffffd8ec),
      onPrimaryFixed: Color(0xff3a022c),
      primaryFixedDim: Color(0xffffaede),
      onPrimaryFixedVariant: Color(0xff6f305a),
      secondaryFixed: Color(0xffe1e0ff),
      onSecondaryFixed: Color(0xff11134c),
      secondaryFixedDim: Color(0xffbfc1ff),
      onSecondaryFixedVariant: Color(0xff3e417a),
      tertiaryFixed: Color(0xffffdad6),
      onTertiaryFixed: Color(0xff410002),
      tertiaryFixedDim: Color(0xffffb4ab),
      onTertiaryFixedVariant: Color(0xff93000a),
      surfaceDim: Color(0xffe3d7db),
      surfaceBright: Color(0xfffff8f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffdf0f4),
      surfaceContainer: Color(0xfff7ebef),
      surfaceContainerHigh: Color(0xfff2e5e9),
      surfaceContainerHighest: Color(0xffecdfe3),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff3f0631),
      surfaceTint: Color(0xff8a4873),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff672953),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3a3d76),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6c6fab),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff8c0009),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffd83831),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8b0019),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffe50030),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffff8f9),
      onBackground: Color(0xff201a1d),
      surface: Color(0xfffff8f9),
      onSurface: Color(0xff201a1d),
      surfaceVariant: Color(0xfff1dde6),
      onSurfaceVariant: Color(0xff4c3f46),
      outline: Color(0xff6a5b62),
      outlineVariant: Color(0xff86767e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff352e32),
      inverseOnSurface: Color(0xfffaedf2),
      inversePrimary: Color(0xffffaede),
      primaryFixed: Color(0xffa45d8a),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff884570),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6c6fab),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff545791),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xffd83831),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xffb41c1b),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe3d7db),
      surfaceBright: Color(0xfffff8f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffdf0f4),
      surfaceContainer: Color(0xfff7ebef),
      surfaceContainerHigh: Color(0xfff2e5e9),
      surfaceContainerHighest: Color(0xffecdfe3),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff3f0631),
      surfaceTint: Color(0xff8a4873),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff672953),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff181b53),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff3a3d76),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4e0003),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8c0009),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4d0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8b0019),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffff8f9),
      onBackground: Color(0xff201a1d),
      surface: Color(0xfffff8f9),
      onSurface: Color(0xff000000),
      surfaceVariant: Color(0xfff1dde6),
      onSurfaceVariant: Color(0xff2c2127),
      outline: Color(0xff4c3f46),
      outlineVariant: Color(0xff4c3f46),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff352e32),
      inverseOnSurface: Color(0xffffffff),
      inversePrimary: Color(0xffffe5f1),
      primaryFixed: Color(0xff6a2c56),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff4f153e),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff3a3d76),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff23265e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff8c0009),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff620004),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe3d7db),
      surfaceBright: Color(0xfffff8f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffdf0f4),
      surfaceContainer: Color(0xfff7ebef),
      surfaceContainerHigh: Color(0xfff2e5e9),
      surfaceContainerHighest: Color(0xffecdfe3),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffaede),
      surfaceTint: Color(0xffffaede),
      onPrimary: Color(0xff541942),
      primaryContainer: Color(0xff4c123b),
      onPrimaryContainer: Color(0xffed9dcd),
      secondary: Color(0xffbfc1ff),
      onSecondary: Color(0xff272a62),
      secondaryContainer: Color(0xff6c6fab),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xffffb4ab),
      onTertiary: Color(0xff690005),
      tertiaryContainer: Color(0xffd83831),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xffffb3b0),
      onError: Color(0xff680010),
      errorContainer: Color(0xffd5002c),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xff171215),
      onBackground: Color(0xffecdfe3),
      surface: Color(0xff171215),
      onSurface: Color(0xffecdfe3),
      surfaceVariant: Color(0xff50434a),
      onSurfaceVariant: Color(0xffd5c1ca),
      outline: Color(0xff9d8c94),
      outlineVariant: Color(0xff50434a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffecdfe3),
      inverseOnSurface: Color(0xff352e32),
      inversePrimary: Color(0xff8a4873),
      primaryFixed: Color(0xffffd8ec),
      onPrimaryFixed: Color(0xff3a022c),
      primaryFixedDim: Color(0xffffaede),
      onPrimaryFixedVariant: Color(0xff6f305a),
      secondaryFixed: Color(0xffe1e0ff),
      onSecondaryFixed: Color(0xff11134c),
      secondaryFixedDim: Color(0xffbfc1ff),
      onSecondaryFixedVariant: Color(0xff3e417a),
      tertiaryFixed: Color(0xffffdad6),
      onTertiaryFixed: Color(0xff410002),
      tertiaryFixedDim: Color(0xffffb4ab),
      onTertiaryFixedVariant: Color(0xff93000a),
      surfaceDim: Color(0xff171215),
      surfaceBright: Color(0xff3e373a),
      surfaceContainerLowest: Color(0xff120d0f),
      surfaceContainerLow: Color(0xff201a1d),
      surfaceContainer: Color(0xff241e21),
      surfaceContainerHigh: Color(0xff2f282b),
      surfaceContainerHighest: Color(0xff3a3336),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb4e0),
      surfaceTint: Color(0xffffaede),
      onPrimary: Color(0xff320025),
      primaryContainer: Color(0xffc479a7),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffc4c6ff),
      onSecondary: Color(0xff0b0d47),
      secondaryContainer: Color(0xff898bca),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffbab1),
      onTertiary: Color(0xff370001),
      tertiaryContainer: Color(0xffff5449),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffb9b6),
      onError: Color(0xff370005),
      errorContainer: Color(0xffff5359),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff171215),
      onBackground: Color(0xffecdfe3),
      surface: Color(0xff171215),
      onSurface: Color(0xfffff9f9),
      surfaceVariant: Color(0xff50434a),
      onSurfaceVariant: Color(0xffd9c6ce),
      outline: Color(0xffb09ea6),
      outlineVariant: Color(0xff8f7f86),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffecdfe3),
      inverseOnSurface: Color(0xff2f282b),
      inversePrimary: Color(0xff70315b),
      primaryFixed: Color(0xffffd8ec),
      onPrimaryFixed: Color(0xff29001e),
      primaryFixedDim: Color(0xffffaede),
      onPrimaryFixedVariant: Color(0xff5b1f48),
      secondaryFixed: Color(0xffe1e0ff),
      onSecondaryFixed: Color(0xff050643),
      secondaryFixedDim: Color(0xffbfc1ff),
      onSecondaryFixedVariant: Color(0xff2d3068),
      tertiaryFixed: Color(0xffffdad6),
      onTertiaryFixed: Color(0xff2d0001),
      tertiaryFixedDim: Color(0xffffb4ab),
      onTertiaryFixedVariant: Color(0xff740006),
      surfaceDim: Color(0xff171215),
      surfaceBright: Color(0xff3e373a),
      surfaceContainerLowest: Color(0xff120d0f),
      surfaceContainerLow: Color(0xff201a1d),
      surfaceContainer: Color(0xff241e21),
      surfaceContainerHigh: Color(0xff2f282b),
      surfaceContainerHighest: Color(0xff3a3336),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff9f9),
      surfaceTint: Color(0xffffaede),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffb4e0),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffdf9ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffc4c6ff),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9f9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffffbab1),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffb9b6),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff171215),
      onBackground: Color(0xffecdfe3),
      surface: Color(0xff171215),
      onSurface: Color(0xffffffff),
      surfaceVariant: Color(0xff50434a),
      onSurfaceVariant: Color(0xfffff9f9),
      outline: Color(0xffd9c6ce),
      outlineVariant: Color(0xffd9c6ce),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffecdfe3),
      inverseOnSurface: Color(0xff000000),
      inversePrimary: Color(0xff4c123b),
      primaryFixed: Color(0xffffdeee),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb4e0),
      onPrimaryFixedVariant: Color(0xff320025),
      secondaryFixed: Color(0xffe6e4ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc4c6ff),
      onSecondaryFixedVariant: Color(0xff0b0d47),
      tertiaryFixed: Color(0xffffe0dc),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffbab1),
      onTertiaryFixedVariant: Color(0xff370001),
      surfaceDim: Color(0xff171215),
      surfaceBright: Color(0xff3e373a),
      surfaceContainerLowest: Color(0xff120d0f),
      surfaceContainerLow: Color(0xff201a1d),
      surfaceContainer: Color(0xff241e21),
      surfaceContainerHigh: Color(0xff2f282b),
      surfaceContainerHighest: Color(0xff3a3336),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
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

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
      background: background,
      onBackground: onBackground,
    );
  }
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
const redLight = Color.fromARGB(255, 241, 217, 218);

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
