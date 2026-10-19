// Kontrak repository fitur review.

import 'review_models.dart';

/// Kontrak akses data untuk rating dan review.
abstract class ReviewRepository {
  const ReviewRepository();

  /// Membuat review baru untuk satu film.
  Future<Review> createReview({
    required int movieId,
    required int rating,
    String? content,
  });
}
