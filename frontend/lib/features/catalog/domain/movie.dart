// Model data film dari backend.

class Movie {
  const Movie({
    required this.id,
    required this.title,
    this.originalTitle,
    this.overview,
    this.releaseDate,
    this.posterPath,
    this.backdropPath,
    this.runtime,
    this.language,
    this.country,
    this.cast,
    this.crew,
    this.isFeatured = false,
    this.averageRating,
    this.reviewCount,
    this.watchedCount,
    this.watchlistCount,
    this.likeCount,
    this.isLiked,
    this.inWatchlist,
    this.watchedAt,
  });

  final int id;
  final String title;
  final String? originalTitle;
  final String? overview;
  final DateTime? releaseDate;
  final String? posterPath;
  final String? backdropPath;
  final int? runtime;
  final String? language;
  final String? country;
  final String? cast;
  final String? crew;
  final bool isFeatured;
  final double? averageRating;
  final int? reviewCount;
  final int? watchedCount;
  final int? watchlistCount;
  final int? likeCount;
  final bool? isLiked;
  final bool? inWatchlist;
  final DateTime? watchedAt;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json['id'] as int,
        title: json['title'] as String,
        originalTitle: json['original_title'] as String?,
        overview: json['overview'] as String?,
        releaseDate: json['release_date'] != null
            ? DateTime.tryParse(json['release_date'] as String)
            : null,
        posterPath: json['poster_path'] as String?,
        backdropPath: json['backdrop_path'] as String?,
        runtime: json['runtime'] as int?,
        language: json['language'] as String?,
        country: json['country'] as String?,
        cast: json['cast'] as String?,
        crew: json['crew'] as String?,
        isFeatured: json['is_featured'] as bool? ?? false,
        averageRating: (json['average_rating'] as num?)?.toDouble(),
        reviewCount: json['review_count'] as int?,
        watchedCount: json['watched_count'] as int?,
        watchlistCount: json['watchlist_count'] as int?,
        likeCount: json['like_count'] as int?,
        isLiked: json['liked'] as bool?,
        inWatchlist: json['in_watchlist'] as bool?,
        watchedAt: json['watched_at'] != null
            ? DateTime.tryParse(json['watched_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'original_title': originalTitle,
        'overview': overview,
        'release_date': releaseDate?.toIso8601String(),
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        'runtime': runtime,
        'language': language,
        'country': country,
        'cast': cast,
        'crew': crew,
        'is_featured': isFeatured,
      };

  int get releaseYear => releaseDate?.year ?? 0;
}
