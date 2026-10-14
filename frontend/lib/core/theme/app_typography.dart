// Token tipografi aplikasi sesuai docs/DESIGN_SYSTEM.md bagian 3.

import 'package:flutter/material.dart';

/// Font heading memakai Manrope, font body memakai Geist.
abstract final class AppTypography {
  static const String fontHeading = 'Manrope';
  static const String fontBody = 'Geist';

  static const TextStyle headlineXl = TextStyle(
    fontFamily: fontHeading,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
  );

  static const TextStyle headlineLg = TextStyle(
    fontFamily: fontHeading,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
  );

  static const TextStyle headlineMd = TextStyle(
    fontFamily: fontHeading,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
  );

  static const TextStyle headlineSm = TextStyle(
    fontFamily: fontHeading,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontBody,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: fontBody,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: fontBody,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
  );

  static const TextStyle labelLg = TextStyle(
    fontFamily: fontBody,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 20 / 15,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: fontBody,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 18 / 13,
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: fontBody,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 14 / 11,
  );
}