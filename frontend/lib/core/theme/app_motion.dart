// Token gerak aplikasi sesuai docs/DESIGN_SYSTEM.md bagian 7.

import 'package:flutter/material.dart';

/// Durasi transisi standar. Widget tidak menulis durasi mentah.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  static const Curve standard = Curves.easeOut;
  static const Curve emphasized = Curves.easeInOutCubic;
}