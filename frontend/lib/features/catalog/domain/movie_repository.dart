// Kontrak repository fitur catalog.

import '../domain/movie.dart';

/// Kontrak akses data untuk fitur catalog.
abstract class MovieRepository {
  const MovieRepository();

  /// Daftar film katalog dengan filter dan pencarian opsional.
  Future<List<Movie>> getMovies({
    String? query,
    int? genreId,
    String? sort,
    int page = 1,
  });

  /// Detail satu film berdasarkan ID.
  Future<Movie> getMovieDetail(int id);
}
