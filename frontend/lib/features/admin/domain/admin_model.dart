// Model data untuk fitur admin.

class DashboardSummary {
  const DashboardSummary({
    required this.totalMovies,
    required this.totalUsers,
    required this.totalReviews,
  });

  final int totalMovies;
  final int totalUsers;
  final int totalReviews;

  factory DashboardSummary.fromJson(Map<String, dynamic> json) =>
      DashboardSummary(
        totalMovies: json['total_movies'] as int? ?? 0,
        totalUsers: json['total_users'] as int? ?? 0,
        totalReviews: json['total_reviews'] as int? ?? 0,
      );
}

class AdminMovie {
  const AdminMovie({
    required this.id,
    required this.title,
    this.originalTitle,
    this.releaseDate,
    this.posterPath,
    this.runtime,
    this.language,
    this.country,
    this.cast,
    this.crew,
    this.isFeatured = false,
    this.genres = const [],
  });

  final int id;
  final String title;
  final String? originalTitle;
  final DateTime? releaseDate;
  final String? posterPath;
  final int? runtime;
  final String? language;
  final String? country;
  final String? cast;
  final String? crew;
  final bool isFeatured;
  final List<String> genres;

  factory AdminMovie.fromJson(Map<String, dynamic> json) => AdminMovie(
        id: json['id'] as int,
        title: json['title'] as String,
        originalTitle: json['original_title'] as String?,
        releaseDate: json['release_date'] != null
            ? DateTime.tryParse(json['release_date'] as String)
            : null,
        posterPath: json['poster_path'] as String?,
        runtime: json['runtime'] as int?,
        language: json['language'] as String?,
        country: json['country'] as String?,
        cast: json['cast'] as String?,
        crew: json['crew'] as String?,
        isFeatured: json['is_featured'] as bool? ?? false,
        genres: (json['genres'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
      );

  int get releaseYear => releaseDate?.year ?? 0;
}

class AdminGenre {
  const AdminGenre({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory AdminGenre.fromJson(Map<String, dynamic> json) => AdminGenre(
        id: json['id'] as int,
        name: json['name'] as String,
      );
}

class AdminUser {
  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  final int id;
  final String name;
  final String email;
  final String role;

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        role: json['role'] as String,
      );
}

class AdminReview {
  const AdminReview({
    required this.id,
    required this.userId,
    required this.userName,
    required this.movieId,
    required this.movieTitle,
    required this.rating,
    this.content,
  });

  final int id;
  final int userId;
  final String userName;
  final int movieId;
  final String movieTitle;
  final int rating;
  final String? content;

  factory AdminReview.fromJson(Map<String, dynamic> json) => AdminReview(
        id: json['id'] as int,
        userId: json['user_id'] as int,
        userName: json['user_name'] as String? ?? '',
        movieId: json['movie_id'] as int,
        movieTitle: json['movie_title'] as String? ?? '',
        rating: json['rating'] as int,
        content: json['content'] as String?,
      );
}

class BatchImportResult {
  const BatchImportResult({
    required this.created,
    this.unmatched = 0,
    this.posterMismatch = 0,
    this.message,
  });

  final int created;
  final int unmatched;
  final int posterMismatch;
  final String? message;

  factory BatchImportResult.fromJson(Map<String, dynamic> json) =>
      BatchImportResult(
        created: json['created'] as int? ?? 0,
        unmatched: json['unmatched'] as int? ?? 0,
        posterMismatch: json['poster_mismatch'] as int? ?? 0,
        message: json['message'] as String?,
      );
}
