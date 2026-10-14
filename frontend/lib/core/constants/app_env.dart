// Konfigurasi lingkungan aplikasi, dikirim lewat --dart-define.

/// Membaca konfigurasi build. Tidak ada nilai rahasia di frontend.
abstract final class AppEnv {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api',
  );

  /// Alamat dasar gambar. Harus sama dengan APP_URL di backend.
  static const String assetBaseUrl = String.fromEnvironment(
    'ASSET_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  static const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;
  /// URL lengkap untuk path gambar relatif dari backend.
  ///
  /// Backend sudah mengirim `poster_url` dan `backdrop_url` dalam bentuk
  /// URL penuh. Fungsi ini hanya untuk menyusun ulang path relatif pada
  /// data yang belum diproses.
  static String assetUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '$assetBaseUrl/storage/$path';
  }
}