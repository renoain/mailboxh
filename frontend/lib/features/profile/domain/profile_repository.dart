// Kontrak repository fitur profile.

import 'profile_models.dart';

/// Kontrak akses data untuk fitur profile.
abstract class ProfileRepository {
  const ProfileRepository();

  /// Mengambil profil user yang login.
  Future<UserProfile> getProfile();

  /// Mengambil statistik profil user.
  Future<UserStats> getUserStats();

  /// Mengambil statistik ringkasan profil (kompatibilitas).
  Future<ProfileStats> getStats();

  /// Mengambil film yang sudah ditonton untuk tab Films.
  Future<List<Movie>> getUserFilms();

  /// Mengambil daftar film favorit (four favourites).
  Future<List<FavoriteFilm>> getFavorites();

  /// Mengambil daftar film favorit (kompatibilitas).
  Future<List<FavoriteFilm>> getFavoriteFilms();

  /// Mengambil daftar film watchlist user.
  Future<List<Movie>> getWatchlistMovies();

  /// Mengambil daftar entri diary user.
  Future<List<DiaryEntry>> getDiaryEntries();

  /// Mengambil daftar review terbaru user.
  Future<List<ReviewItem>> getRecentReviews();

  /// Mengambil daftar list milik user.
  Future<List<UserList>> getUserLists();

  /// Mengambil daftar user yang diikuti.
  Future<List<UserBrief>> getFollowing();

  /// Mengambil daftar pengikut user.
  Future<List<UserBrief>> getFollowers();

  /// Mengambil daftar tag user.
  Future<List<Tag>> getTags();
}
