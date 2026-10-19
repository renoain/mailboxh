// Model JSON katalog film dari endpoint movies dan home.

import '../domain/movie_models.dart';

/// Representasi objek genre pada payload film.
class GenreModel {
  const GenreModel({required this.id, required this.name});

  factory GenreModel.fromJson(Map<String, dynamic> json) => GenreModel(
        id: json['id'] as int,
        name: json['name'] as String,
      );

  final int id;
  final String name;

  Genre toEntity() => Genre(id: id, name: name);
}

/// Representasi objek film pada payload movies dan home.
class MovieModel {
  const MovieModel({
    required this.id,
    required this.title,
    this.overview,
    this.releaseDate,
    this.posterUrl,
    this.backdropUrl,
    this.runtime,
    this.genres = const <GenreModel>[],
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        id: json['id'] as int,
        title: json['title'] as String,
        overview: json['overview'] as String?,
        releaseDate: DateTime.tryParse(json['release_date'] as String? ?? ''),
        posterUrl: json['poster_url'] as String?,
        backdropUrl: json['backdrop_url'] as String?,
        runtime: json['runtime'] as int?,
        genres: ((json['genres'] as List?) ?? const <dynamic>[])
            .map(
              (dynamic item) => GenreModel.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList(),
      );

  final int id;
  final String title;
  final String? overview;
  final DateTime? releaseDate;
  final String? posterUrl;
  final String? backdropUrl;
  final int? runtime;
  final List<GenreModel> genres;

  Movie toEntity() => Movie(
        id: id,
        title: title,
        overview: overview,
        releaseDate: releaseDate,
        posterUrl: posterUrl,
        backdropUrl: backdropUrl,
        runtime: runtime,
        genres: genres.map((GenreModel item) => item.toEntity()).toList(),
      );
}

/// Mengubah daftar objek film dari [data] menjadi daftar entity.
List<Movie> movieListFrom(dynamic data) => ((data as List?) ?? const <dynamic>[])
    .map(
      (dynamic item) =>
          MovieModel.fromJson(Map<String, dynamic>.from(item as Map)).toEntity(),
    )
    .toList();
