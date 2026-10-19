// Model data murni untuk fitur review.

import '../../catalog/domain/movie_models.dart';

/// Rating dan ulasan satu user untuk satu film.
class Review {
  const Review({
    required this.id,
    required this.movieId,
    required this.rating,
    this.movie,
    this.content,
    this.likesCount = 0,
    this.isLiked = false,
  });

  final int id;
  final int movieId;
  final int rating;
  final Movie? movie;
  final String? content;
  final int likesCount;
  final bool isLiked;
}
