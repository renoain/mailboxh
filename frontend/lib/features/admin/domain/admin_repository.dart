// Kontrak repository fitur admin.

import 'admin_models.dart';

/// Kontrak akses data untuk operasi admin (film, genre, user, review).
abstract class AdminRepository {
  const AdminRepository();

  /// Mengambil ringkasan statistik dashboard admin.
  Future<DashboardSummary> getDashboardSummary();

  /// Mengambil daftar semua film untuk dikelola admin.
  Future<List<AdminMovie>> getMovies();

  /// Membuat film baru dengan data dan file poster.
  Future<AdminMovie> createMovie({
    required String title,
    required String overview,
    required int releaseYear,
    required int? runtime,
    required List<int> genreIds,
    required String? posterPath,
  });

  /// Memperbarui data film yang sudah ada.
  Future<void> updateMovie({
    required int id,
    required String title,
    required String overview,
    required int releaseYear,
    required int? runtime,
    required List<int> genreIds,
    required String? posterPath,
  });

  /// Menghapus film berdasarkan ID.
  Future<void> deleteMovie({required int id});

  /// Mengaktifkan atau menonaktifkan status featured film.
  Future<void> toggleFeature({required int id, required bool featured});

  /// Mengambil daftar semua genre.
  Future<List<AdminGenre>> getGenres();

  /// Membuat genre baru.
  Future<void> createGenre({required String name});

  /// Menghapus genre berdasarkan ID.
  Future<void> deleteGenre({required int id});

  /// Mengambil daftar semua user.
  Future<List<AdminUser>> getUsers();

  /// Mengubah role user (admin atau user).
  Future<void> updateUserRole({required int id, required String role});

  /// Mengambil daftar semua review untuk moderasi.
  Future<List<AdminReview>> getReviews();

  /// Menghapus review berdasarkan ID.
  Future<void> deleteReview({required int id});

  /// Mengimpor film secara batch dari file ZIP.
  Future<BatchImportResult> importMoviesBatch({required String zipPath});
}
