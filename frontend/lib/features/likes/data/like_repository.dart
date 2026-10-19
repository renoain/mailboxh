// Implementasi repository fitur likes.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/like_repository.dart';

final Provider<LikeRepository> likeRepositoryProvider =
    Provider<LikeRepository>((Ref ref) {
  return LikeRepositoryImpl(ref.watch(apiClientProvider));
});

class LikeRepositoryImpl implements LikeRepository {
  const LikeRepositoryImpl(this.apiClient);
  final dynamic apiClient;

  @override
  Future<void> like(int movieId) async {
    await apiClient.raw.post<Map<String, dynamic>>('/likes', data: {'movie_id': movieId});
  }

  @override
  Future<void> unlike(int movieId) async {
    await apiClient.raw.delete<Map<String, dynamic>>('/likes', data: {'movie_id': movieId});
  }
}
