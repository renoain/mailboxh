// Model data murni untuk katalog film.

/// Genre film.
class Genre {
  const Genre({required this.id, required this.name});

  final int id;
  final String name;
}

/// Film dari katalog Mailboxh.
class Movie {
  const Movie({
    required this.id,
    required this.title,
    this.overview,
    this.releaseDate,
    this.posterUrl,
    this.backdropUrl,
    this.runtime,
    this.genres = const <Genre>[],
  });

  final int id;
  final String title;
  final String? overview;
  final DateTime? releaseDate;
  final String? posterUrl;
  final String? backdropUrl;
  final int? runtime;
  final List<Genre> genres;
}

/// Urutan daftar film sesuai dukungan backend.
enum MovieSort { latest, title, releaseDate, rating }

/// Parameter pengambilan daftar film.
class MovieQuery {
  const MovieQuery({
    this.query,
    this.sort = MovieSort.latest,
    this.page = 1,
  });

  final String? query;
  final MovieSort sort;
  final int page;

  @override
  bool operator ==(Object other) =>
      other is MovieQuery &&
      other.query == query &&
      other.sort == sort &&
      other.page == page;

  @override
  int get hashCode => Object.hash(query, sort, page);
}

/// Satu halaman daftar film dari paginator backend.
class MoviePage {
  const MoviePage({
    required this.movies,
    required this.page,
    required this.perPage,
    required this.total,
  });

  final List<Movie> movies;
  final int page;
  final int perPage;
  final int total;

  bool get hasNextPage => page * perPage < total;
}

/// Enam section beranda dalam satu snapshot.
class HomeData {
  const HomeData({
    required this.featured,
    required this.latest,
    required this.topRated,
    required this.mostWatched,
    required this.mostWatchlisted,
    required this.explore,
  });

  final List<Movie> featured;
  final List<Movie> latest;
  final List<Movie> topRated;
  final List<Movie> mostWatched;
  final List<Movie> mostWatchlisted;
  final List<Movie> explore;

  bool get isEmpty =>
      featured.isEmpty &&
      latest.isEmpty &&
      topRated.isEmpty &&
      mostWatched.isEmpty &&
      mostWatchlisted.isEmpty &&
      explore.isEmpty;
}
