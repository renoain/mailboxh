// Path aset aplikasi, tidak boleh ditulis langsung di widget.

/// Kumpulan path aset. Poster film tidak termasuk karena diambil dari
/// URL TMDB, bukan dari bundel aplikasi.
abstract final class AppAssets {
  static const String fontsFolder = 'assets/fonts';
  static const String fontManrope = '$fontsFolder/Manrope-Regular.ttf';
  static const String fontGeist = '$fontsFolder/Geist-Regular.ttf';

  static const String imagesFolder = 'assets/images';
  static const String artworkWelcome = '$imagesFolder/artwork_welcome.jpg';
  static const String artworkSignIn = '$imagesFolder/artwork_signin.jpg';
  static const String artworkJoin = '$imagesFolder/artwork_join.jpg';
  static const String tmdbBadge = '$imagesFolder/tmdb_badge.svg';
  static const String emptyFilm = '$imagesFolder/empty_film.svg';

  static const List<String> onboardingSlides = [
    '$imagesFolder/onboarding_1.svg',
    '$imagesFolder/onboarding_2.svg',
    '$imagesFolder/onboarding_3.svg',
  ];
}