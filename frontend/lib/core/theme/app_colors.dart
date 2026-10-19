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

  static const Color primaryDark = Color(0xFF00C032);
  static const Color primaryDarkHover = Color(0xFF00E054);
  static const Color primaryDarkPressed = Color(0xFF008F26);

  static const Color secondaryDark = Color(0xFFFF8000);
  static const Color secondaryDarkHover = Color(0xFFFFA04D);

  static const Color bgDark = Color(0xFF181B20);
  static const Color bgAltDark = Color(0xFF1F262E);
  static const Color surfaceDark = Color(0xFF20272F);
  static const Color surfaceDimDark = Color(0xFF2C3440);

  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF99AABB);
  static const Color textDisabledDark = Color(0xFF667788);
  static const Color textOnPrimaryDark = Color(0xFFFFFFFF);

  static const Color successDark = Color(0xFF5FBF9E);
  static const Color warningDark = Color(0xFFF0C05E);
  static const Color errorDark = Color(0xFFF2726B);

  static const Color brandOrange = Color(0xFFFF8000);
  static const Color brandGreen = Color(0xFF00E054);
  static const Color brandBlue = Color(0xFF40BCF4);
  static const Color headerBlack = Color(0xFF000000);
  static const Color navBar = Color(0xFF445566);
  static const Color tabTrack = Color(0xFF1F262E);
  static const Color tabSelected = Color(0xFF445566);
  static const Color panelDark = Color(0xFF2C3440);
  static const Color fieldWhite = Color(0xFFFFFFFF);
  static const Color fieldHint = Color(0xFFB0BAC4);
  static const Color fieldText = Color(0xFF14181C);
  static const List<Color> posterTints = [
    Color(0xFF3B5B7A),
    Color(0xFF7A3B4B),
    Color(0xFF4B6A3B),
    Color(0xFF7A6A3B),
    Color(0xFF5A3B7A),
    Color(0xFF3B7A74),
  ];
  static const Color slideGradientTop = Color(0xFF445565);

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
      onSurfaceVariant: isDark ? textSecondaryDark : textSecondaryLight,
      onSurface: isDark ? textPrimaryDark : textPrimaryLight,
      surfaceContainerHighest: isDark ? surfaceDimDark : surfaceDimLight,
      outline: isDark ? textDisabledDark : outlineLight,
      outlineVariant: isDark ? panelDark : borderLightSoft,
    );
  }
}