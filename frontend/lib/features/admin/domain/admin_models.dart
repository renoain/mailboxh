// Model data murni untuk fitur admin.

/// Ringkasan statistik dashboard admin.
class DashboardSummary {
  const DashboardSummary({
    required this.totalMovies,
    required this.totalUsers,
    required this.totalReviews,
  });

  final int totalMovies;
  final int totalUsers;
  final int totalReviews;
}

/// Film dalam konteks admin.
class AdminMovie {
  const AdminMovie({
    required this.id,
    required this.title,
    this.overview,
    this.releaseDate,
    this.runtime,
    this.posterUrl,
    this.backdropUrl,
    this.isFeatured = false,
    this.genres = const <String>[],
  });

  final int id;
  final String title;
  final String? overview;
  final DateTime? releaseDate;
  final int? runtime;
  final String? posterUrl;
  final String? backdropUrl;
  final bool isFeatured;
  final List<String> genres;
}

/// Genre dalam konteks admin.
class AdminGenre {
  const AdminGenre({required this.id, required this.name});

  final int id;
  final String name;
}

/// User dalam konteks admin.
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

  bool get isAdmin => role == 'admin';
}

/// Review dalam konteks moderasi admin.
class AdminReview {
  const AdminReview({
    required this.id,
    required this.userId,
    required this.userName,
    required this.movieId,
    required this.movieTitle,
    required this.content,
    required this.rating,
    required this.createdAt,
  });

  final int id;
  final int userId;
  final String userName;
  final int movieId;
  final String movieTitle;
  final String content;
  final int rating;
  final DateTime createdAt;
}

/// Hasil impor batch film.
class BatchImportResult {
  const BatchImportResult({
    required this.success,
    required this.failed,
    required this.posterMismatch,
    required this.total,
  });

  final int success;
  final int failed;
  final int posterMismatch;
  final int total;
}
