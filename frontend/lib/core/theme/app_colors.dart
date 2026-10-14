// Token warna aplikasi sesuai docs/DESIGN_SYSTEM.md bagian 2.

import 'package:flutter/material.dart';

/// Menyediakan token warna light dan dark dari DESIGN_SYSTEM.md.
abstract final class AppColors {
  static const Color primaryLight = Color(0xFF1F6F5C);
  static const Color primaryLightHover = Color(0xFF2E8B72);
  static const Color primaryLightPressed = Color(0xFF0F4A3C);

  static const Color secondaryLight = Color(0xFFE8B44A);
  static const Color secondaryLightHover = Color(0xFFF2C97A);

  static const Color bgLight = Color(0xFFF6F7F5);
  static const Color bgAltLight = Color(0xFFECEFEA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDimLight = Color(0xFFE3E7E0);

  static const Color textPrimaryLight = Color(0xFF1A1F1C);
  static const Color textSecondaryLight = Color(0xFF5A635C);
  static const Color textDisabledLight = Color(0xFF9AA39C);
  static const Color textOnPrimaryLight = Color(0xFFFFFFFF);

  static const Color successLight = Color(0xFF2E8B72);
  static const Color warningLight = Color(0xFFE8B44A);
  static const Color errorLight = Color(0xFFBA1A1A);
  static const Color infoLight = Color(0xFF4A90E2);

  static const Color borderLight = Color(0xFFD6DCD3);
  static const Color borderLightSoft = Color(0xFFE6EBE3);
  static const Color outlineLight = Color(0xFF717973);

  static const Color primaryDark = Color(0xFF4FBFA3);
  static const Color primaryDarkHover = Color(0xFF6FD4B8);
  static const Color primaryDarkPressed = Color(0xFF2C7D68);

  static const Color secondaryDark = Color(0xFFF0C05E);
  static const Color secondaryDarkHover = Color(0xFFF7D58C);

  static const Color bgDark = Color(0xFF101412);
  static const Color bgAltDark = Color(0xFF171C1A);
  static const Color surfaceDark = Color(0xFF1A211E);
  static const Color surfaceDimDark = Color(0xFF232B27);

  static const Color textPrimaryDark = Color(0xFFE8EDEA);
  static const Color textSecondaryDark = Color(0xFFA0ABA5);
  static const Color textDisabledDark = Color(0xFF6E7873);
  static const Color textOnPrimaryDark = Color(0xFF06201A);

  static const Color successDark = Color(0xFF5FBF9E);
  static const Color warningDark = Color(0xFFF0C05E);
  static const Color errorDark = Color(0xFFF2726B);

  /// Menerjemahkan set token ke [ColorScheme] Flutter.
  static ColorScheme toColorScheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    return ColorScheme(
      brightness: brightness,
      primary: isDark ? primaryDark : primaryLight,
      onPrimary: isDark ? textOnPrimaryDark : textOnPrimaryLight,
      primaryContainer: isDark ? primaryDarkPressed : primaryLightPressed,
      onPrimaryContainer: isDark ? textOnPrimaryDark : textOnPrimaryLight,
      secondary: isDark ? secondaryDark : secondaryLight,
      onSecondary: isDark ? textOnPrimaryDark : textOnPrimaryLight,
      error: isDark ? errorDark : errorLight,
      onError: isDark ? textOnPrimaryDark : textOnPrimaryLight,
      surface: isDark ? surfaceDark : surfaceLight,
      onSurface: isDark ? textPrimaryDark : textPrimaryLight,
      surfaceContainerHighest: isDark ? surfaceDimDark : surfaceDimLight,
      outline: isDark ? const Color(0xFF6E7873) : outlineLight,
      outlineVariant: isDark ? const Color(0xFF2C3531) : borderLightSoft,
    );
  }
}