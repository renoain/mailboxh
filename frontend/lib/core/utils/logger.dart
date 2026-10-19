// Logger aplikasi. Hindari print di produksi, jangan log data sensitif.

/// Membungkus log agar satu titik konfigurasi untuk seluruh app.
abstract final class AppLogger {
  static const bool _isDebug = bool.fromEnvironment('dart.vm.product') == false;

  /// Menulis log informasi. Jangan pernah mengirim token, password, atau API key.
  static void info(String message, {Object? data}) {
    if (!_isDebug) return;
    final String extra = data != null ? ' | $data' : '';
    print('[INFO] $message$extra');
  }

  static void debug(String message, {Object? data}) {
    if (!_isDebug) return;
    final String extra = data != null ? ' | $data' : '';
    print('[DEBUG] $message$extra');
  }

  static void warn(String message, {Object? data}) {
    final String extra = data != null ? ' | $data' : '';
    print('[WARN] $message$extra');
  }

  static void error(
    String message, {
    Object? data,
    StackTrace? stackTrace,
  }) {
    final String extra = data != null ? ' | $data' : '';
    print('[ERROR] $message$extra');
    if (stackTrace != null) print(stackTrace);
  }
}
