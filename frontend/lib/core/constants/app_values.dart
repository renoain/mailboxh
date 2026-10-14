// Nilai konstanta aplikasi yang dipakai lintas fitur.

/// Batas dan angka tetap yang tidak boleh ditulis langsung di widget.
abstract final class AppValues {
  static const int maxRating = 5;
  static const int favouriteSlots = 4;
  static const int maxListTitleLength = 120;
  static const int maxListDescriptionLength = 1000;
  static const int maxListItemNoteLength = 500;
  static const int maxTagNameLength = 40;
  static const int maxNoteLength = 1000;
  static const int maxReviewLength = 5000;
  static const int maxTagsPerLog = 10;
  static const int minSearchQueryLength = 2;
  static const int feedPageSize = 20;
  static const int memberPageSize = 20;
  static const int incomingPageSize = 30;
  static const int posterCacheWidth = 500;

  /// Nama flag lokal yang disimpan di shared_preferences.
  static const String onboardingFlagKey = 'has_seen_onboarding';
  static const String languageFlagKey = 'app_language';

  /// Umur cache film di sisi klien. Server yang menentukan umur cache
  /// authoritative, nilai ini hanya untuk permintaan ulang di klien.
  static const Duration clientCacheTtl = Duration(hours: 6);
}