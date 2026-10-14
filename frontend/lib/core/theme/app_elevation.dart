// Token elevasi aplikasi sesuai docs/DESIGN_SYSTEM.md bagian 6.

import 'package:flutter/material.dart';

/// Bayangan memakai warna netral di mode dark, bukan warna primary.
abstract final class AppElevation {
  static const List<BoxShadow> lightOne = [
    BoxShadow(color: Color(0x0D1F6F5C), blurRadius: 20, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> lightTwo = [
    BoxShadow(color: Color(0x1F1F6F5C), blurRadius: 30, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> lightThree = [
    BoxShadow(color: Color(0x401F6F5C), blurRadius: 24, offset: Offset(0, 12)),
  ];

  static const List<BoxShadow> darkOne = [
    BoxShadow(color: Color(0x66000000), blurRadius: 20, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> darkTwo = [
    BoxShadow(color: Color(0x80000000), blurRadius: 30, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> darkThree = [
    BoxShadow(color: Color(0x99000000), blurRadius: 24, offset: Offset(0, 12)),
  ];

  static List<BoxShadow> of(Brightness brightness, int level) {
    final bool isDark = brightness == Brightness.dark;
    if (level >= 3) return isDark ? darkThree : lightThree;
    if (level == 2) return isDark ? darkTwo : lightTwo;
    return isDark ? darkOne : lightOne;
  }
}