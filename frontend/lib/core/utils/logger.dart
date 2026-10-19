// Logger aplikasi. Menggantikan print di produksi.

import 'package:logger/logger.dart';

/// Membungkus logger paket agar satu titik konfigurasi untuk seluruh app.
abstract final class AppLogger {
  static final Logger _logger = Logger(
    printer: SimplePrinter(printTime: false, colors: true),
  );

  /// Menulis log. Jangan pernah mengirim token, password, atau API key.
  static void info(String message, {Object? data}) =>
      _logger.i(message, error: data);

  static void debug(String message, {Object? data}) =>
      _logger.d(message, error: data);

  static void warn(String message, {Object? data}) =>
      _logger.w(message, error: data);

  static void error(String message, {Object? data, StackTrace? stackTrace}) =>
      _logger.e(message, error: data, stackTrace: stackTrace);
}