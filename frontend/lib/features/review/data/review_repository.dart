// Implementasi repository fitur review terhadap endpoint backend.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/app_providers.dart';
import '../domain/review_models.dart';
import '../domain/review_repository.dart';
import 'review_model.dart';

/// Menyediakan [ReviewRepository] lewat container Riverpod.
final Provider<ReviewRepository> reviewRepositoryProvider =
    Provider<ReviewRepository>((Ref ref) {
      return ReviewRepositoryImpl(ref.watch(apiClientProvider));
    });

/// Memanggil endpoint review untuk membuat rating dan ulasan.
class ReviewRepositoryImpl implements ReviewRepository {
  const ReviewRepositoryImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<Review> createReview({
    required int movieId,
    required int rating,
    String? content,
  }) {
    return _guard(() async {
      final Response<Map<String, dynamic>> response = await apiClient.raw
          .post<Map<String, dynamic>>(
            '/reviews',
            data: <String, Object?>{
              'movie_id': movieId,
              'rating': rating,
              'content': content,
            },
          );
      final dynamic data = response.data?['data'];
      return reviewFromJson(Map<String, dynamic>.from(data as Map));
    });
  }

  /// Melempar [AppException] dari pemetaan error [ApiClient].
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      final Object? mapped = error.error;
      if (mapped is AppException) throw mapped;
      rethrow;
    }
  }
}
