// Implementasi repository fitur follow terhadap endpoint backend.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import '../../../core/services/app_providers.dart';
import '../domain/follow_repository.dart';

/// Menyediakan [FollowRepository] lewat container Riverpod.
final Provider<FollowRepository> followRepositoryProvider =
    Provider<FollowRepository>((Ref ref) {
  return FollowRepositoryImpl(ref.watch(apiClientProvider));
});

/// Memanggil endpoint followers, following, dan toggle follow.
class FollowRepositoryImpl implements FollowRepository {
  const FollowRepositoryImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<List<FollowUser>> getFollowers() async {
    final response = await apiClient.raw.get<Map<String, dynamic>>('/followers');
    final data = response.data?['data'] as List? ?? <dynamic>[];
    return data.map((e) => _map(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<FollowUser>> getFollowing() async {
    final response = await apiClient.raw.get<Map<String, dynamic>>('/following');
    final data = response.data?['data'] as List? ?? <dynamic>[];
    return data.map((e) => _map(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<bool> toggleFollow(int userId) async {
    try {
      await apiClient.raw.post<Map<String, dynamic>>('/follow/$userId');
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) return true;
      if (e.response?.statusCode == 404) {
        await apiClient.raw.delete<Map<String, dynamic>>('/follow/$userId');
        return false;
      }
      rethrow;
    }
  }

  FollowUser _map(Map<String, dynamic> json) {
    return FollowUser(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      isFollowing: json['is_following'] as bool? ?? false,
    );
  }
}
