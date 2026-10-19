// Pemetaan respons endpoint review ke model domain.

import '../../catalog/data/movie_model.dart';
import '../../catalog/domain/movie_models.dart';
import '../domain/review_models.dart';

/// Membaca satu review dari JSON [ReviewResource].
Review reviewFromJson(Map<String, dynamic> json) {
  final dynamic movieJson = json['movie'];
  final Movie? movie = movieJson is Map
      ? MovieModel.fromJson(Map<String, dynamic>.from(movieJson)).toEntity()
      : null;
  return Review(
    id: json['id'] as int,
    movieId: json['movie_id'] as int,
    rating: (json['rating'] as num).toInt(),
    movie: movie,
    content: json['content'] as String?,
    likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
    isLiked: json['is_liked'] as bool? ?? false,
  );
}
