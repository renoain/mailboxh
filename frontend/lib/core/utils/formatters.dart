// Format tanggal, angka, dan teks relatif untuk seluruh aplikasi.

import 'package:intl/intl.dart';

/// Format tampilan tanggal dan angka memakai locale aplikasi.
abstract final class AppFormatters {
  static const String localeId = 'id_ID';
  static const String localeEn = 'en_US';

  static final DateFormat _dateShortId = DateFormat('d MMM yyyy', localeId);
  static final DateFormat _dateShortEn = DateFormat('d MMM yyyy', localeEn);
  static final DateFormat _dateLongId = DateFormat('d MMMM yyyy', localeId);
  static final DateFormat _dateLongEn = DateFormat('d MMMM yyyy', localeEn);
  static final NumberFormat _decimalId = NumberFormat.decimalPattern(localeId);
  static final NumberFormat _decimalEn = NumberFormat.decimalPattern(localeEn);

  static String dateShort(DateTime date, {required bool isIndonesian}) =>
      (isIndonesian ? _dateShortId : _dateShortEn).format(date);

  static String dateLong(DateTime date, {required bool isIndonesian}) =>
      (isIndonesian ? _dateLongId : _dateLongEn).format(date);

  static String decimal(num value, {required bool isIndonesian}) =>
      (isIndonesian ? _decimalId : _decimalEn).format(value);

  /// Tahun rilis film, atau tahun hari ini bila tanggal tidak ada.
  static String releaseYear(DateTime? date) => date?.year.toString() ?? '';

  /// Waktu relatif untuk baris aktivitas, misal 3 jam lalu.
  static String relativeTime(
    DateTime time, {
    required bool isIndonesian,
    DateTime? now,
  }) {
    final DateTime reference = now ?? DateTime.now();
    final Duration diff = reference.difference(time);

    if (diff.inSeconds < 60) return isIndonesian ? 'Baru saja' : 'Just now';
    if (diff.inMinutes < 60) {
      return isIndonesian ? '${diff.inMinutes} menit lalu' : '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return isIndonesian ? '${diff.inHours} jam lalu' : '${diff.inHours}h ago';
    }
    if (diff.inDays < 30) {
      return isIndonesian ? '${diff.inDays} hari lalu' : '${diff.inDays}d ago';
    }
    return dateShort(time, isIndonesian: isIndonesian);
  }

  /// Ringkasan review untuk baris aktivitas.
  static String excerpt(String content, {int maxLength = 120}) {
    final String trimmed = content.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (trimmed.length <= maxLength) return trimmed;
    return '${trimmed.substring(0, maxLength)}...';
  }
}