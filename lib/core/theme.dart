import 'package:flutter/material.dart';

/// The app's palette: every color a screen needs, with the value each screen was
/// already using. Widgets should reference these instead of writing literals, so
/// a shade is changed in one place.
abstract final class AppColors {
  // Surfaces.
  static const Color background = Color(0xFFF3F3F7);
  static const Color backgroundMuted = Color(0xFFF3F3F7);
  static const Color surface = Color(0xFFF3F3F7);
  static const Color surfaceDisabled = Color(0xFFF3F3F7);

  // Lines and text.
  static const Color border = Color(0xFFBBBBC0);
  static const Color text = Color(0xFF101018);
  static const Color mutedText = Color(0xFF828288);

  // Accents and feedback.
  static const Color primary = Color(0xFF3863A8);
  static const Color error = Color(0xFFA85838);
  static const Color danger = Color(0xFFA85838);
  static const Color dangerStrong = Color(0xFFA85838);

  // Shadows and scrims.
  static const Color shadow = Color(0x33000000);
  static const Color shadowStrong = Color(0x80000000);
}

/// The family registered in `pubspec.yaml`, declared once so the theme is the
/// only place the UI asks for a font.
const String appFontFamily = 'Estedad';

/// The single theme for the whole app, built once on first use.
///
/// Screens should rely on this for typography instead of styling each `Text`
/// by hand; colors stay available through [AppColors] for the places that
/// intentionally pick one.
final ThemeData appTheme = _buildAppTheme();

ThemeData _buildAppTheme() {
  final ColorScheme colors =
      ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.primary,
        surface: AppColors.surface,
        error: AppColors.error,
      );

  final ThemeData base = ThemeData(
    useMaterial3: true,
    colorScheme: colors,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: appFontFamily,
  );

  return base.copyWith(
    // Default text color follows the app's near-black instead of Material's
    // onSurface tint, so text stays legible on the app background.
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    ),
  );
}
