// Kontrak repository fitur admin.

import 'admin_model.dart';

/// Kontrak akses data untuk fitur admin.
abstract class AdminRepository {
  const AdminRepository();

  /// Ringkasan dashboard admin.
  Future<DashboardSummary> getDashboardSummary();

  /// Daftar film untuk admin.
  Future<List<AdminMovie>> getMovies();

  /// Buat film baru dengan poster opsional.
  Future<AdminMovie> createMovie({
    required String title,
    String? originalTitle,
    String? overview,
    DateTime? releaseDate,
    int? runtime,
    String? language,
    String? country,
    String? cast,
    String? crew,
    List<int>? genreIds,
    bool? isFeatured,
    String? posterPath,
  });

  /// Ubah data film.
  Future<AdminMovie> updateMovie({
    required int id,
    String? title,
    String? originalTitle,
    String? overview,
    DateTime? releaseDate,
    int? runtime,
    String? language,
    String? country,
    String? cast,
    String? crew,
    List<int>? genreIds,
    bool? isFeatured,
  });

  /// Hapus film.
  Future<void> deleteMovie(int id);

  /// Aktifkan/nonaktifkan fitur film.
  Future<void> toggleFeature(int id);

  /// Daftar genre.
  Future<List<AdminGenre>> getGenres();

  /// Buat genre baru.
  Future<AdminGenre> createGenre(String name);

  /// Hapus genre.
  Future<void> deleteGenre(int id);

  /// Daftar user.
  Future<List<AdminUser>> getUsers();

  /// Ubah role user.
  Future<AdminUser> updateUserRole(int id, String role);

  /// Daftar review untuk moderasi.
  Future<List<AdminReview>> getReviews();

  /// Hapus review.
  Future<void> deleteReview(int id);

  /// Impor film massal lewat file ZIP.
  Future<BatchImportResult> importMoviesBatch(String zipPath);
}
