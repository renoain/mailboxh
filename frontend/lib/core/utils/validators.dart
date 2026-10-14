// Validasi input sisi klien. Backend tetap memvalidasi ulang.

import '../constants/app_strings.dart';
import '../constants/app_values.dart';

/// Validasi form. Hasil akhir dikirim ke backend sebagai teks aman.
abstract final class AppValidators {
  static final RegExp _emailPattern =
      RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  static bool isEmail(String value) => _emailPattern.hasMatch(value.trim());

  static bool isPasswordValid(String value) => value.length >= 8;

  static bool isRequired(String value) => value.trim().isNotEmpty;

  static bool isSearchQueryValid(String value) =>
      value.trim().length >= AppValues.minSearchQueryLength;

  static bool isRatingValid(int rating) =>
      rating >= 1 && rating <= AppValues.maxRating;

  /// Pesan validasi pertama yang gagal, atau null bila valid.
  static String? firstError({
    required AppText text,
    String? name,
    String? email,
    String? password,
  }) {
    if (name != null && !isRequired(name)) return text.name;
    if (email != null && !isEmail(email)) return text.email;
    if (password != null && !isPasswordValid(password)) return text.password;
    return null;
  }

  /// Melempar argumen tidak valid saat dipakai di luar build.
  static void failIf(bool condition, String reason) {
    assert(condition, reason);
    if (!condition) throw ArgumentError(reason);
  }
}