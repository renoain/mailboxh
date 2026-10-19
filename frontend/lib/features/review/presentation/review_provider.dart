// State form review.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../data/review_repository.dart';
import '../domain/review_models.dart';

/// Mengirim form review dan menyimpan status pengirimannya.
class ReviewFormController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Membuat review. Mengembalikan [Review] bila berhasil.
  Future<Review?> submit({
    required int movieId,
    required int rating,
    String? content,
  }) async {
    state = const AsyncLoading();
    try {
      final Review review = await ref
          .read(reviewRepositoryProvider)
          .createReview(movieId: movieId, rating: rating, content: content);
      state = const AsyncData(null);
      return review;
    } on AppException catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return null;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return null;
    }
  }
}

/// Form review untuk satu film.
final AsyncNotifierProvider<ReviewFormController, void> reviewFormProvider =
    AsyncNotifierProvider<ReviewFormController, void>(ReviewFormController.new);
