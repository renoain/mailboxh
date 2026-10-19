// Format tanggal, angka, dan teks relatif untuk seluruh aplikasi.

/// Format tampilan tanggal dan angka memakai locale aplikasi.
abstract final class AppFormatters {
  static const String localeId = 'id_ID';
  static const String localeEn = 'en_US';

  static String dateShort(DateTime date, {required bool isIndonesian}) {
    final List<String> monthsId = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    final List<String> monthsEn = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final months = isIndonesian ? monthsId : monthsEn;
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  static String dateLong(DateTime date, {required bool isIndonesian}) {
    final List<String> monthsId = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    final List<String> monthsEn = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final months = isIndonesian ? monthsId : monthsEn;
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  static String decimal(num value, {required bool isIndonesian}) {
    final String sep = isIndonesian ? '.' : ',';
    final String abs = value.abs().toStringAsFixed(0);
    final List<String> groups = [];
    var remaining = abs;
    while (remaining.length > 3) {
      groups.insert(0, remaining.substring(remaining.length - 3));
      remaining = remaining.substring(0, remaining.length - 3);
    }
    groups.insert(0, remaining);
    final String formatted = groups.join(sep);
    return value.isNegative ? '-$formatted' : formatted;
  }

  /// Tahun rilis film, atau kosong bila tanggal tidak ada.
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
      return isIndonesian
          ? '${diff.inMinutes} menit lalu'
          : '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return isIndonesian
          ? '${diff.inHours} jam lalu'
          : '${diff.inHours}h ago';
    }
    if (diff.inDays < 30) {
      return isIndonesian
          ? '${diff.inDays} hari lalu'
          : '${diff.inDays}d ago';
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
