// Kontrak repository fitur catalog.

import 'movie_models.dart';

/// Kontrak akses data untuk katalog film.
abstract class MovieRepository {
  const MovieRepository();

  /// Mengambil enam section beranda dalam satu permintaan.
  Future<HomeData> fetchHome();

  /// Mengambil daftar film satu halaman untuk list dan pencarian.
  Future<MoviePage> fetchMovies({
    String? query,
    MovieSort sort,
    int page,
  });
}
