// Token spacing aplikasi sesuai docs/DESIGN_SYSTEM.md bagian 4.

/// Skala jarak kelipatan 4. Widget tidak boleh menulis angka mentah.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double twoXs = 12;
  static const double threeXs = 20;
  static const double twoXl = 40;
  static const double threeXl = 48;
  static const double fourXl = 64;

  /// Ukuran minimum target sentuh.
  static const double touchTarget = 48;
}