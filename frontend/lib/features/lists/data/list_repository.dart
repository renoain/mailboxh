// Implementasi repository fitur lists terhadap endpoint backend.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import '../../../core/services/app_providers.dart';
import '../domain/list_repository.dart';

/// Menyediakan [ListRepository] lewat container Riverpod.
final Provider<ListRepository> listRepositoryProvider =
    Provider<ListRepository>((Ref ref) {
  return ListRepositoryImpl(ref.watch(apiClientProvider));
});

/// Memanggil endpoint lists.
class ListRepositoryImpl implements ListRepository {
  const ListRepositoryImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<List<Map<String, dynamic>>> getLists() async {
    final response = await apiClient.raw.get<Map<String, dynamic>>('/lists');
    final data = response.data?['data'] as List? ?? <dynamic>[];
    return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  @override
  Future<Map<String, dynamic>> getListDetail(int id) async {
    final response = await apiClient.raw.get<Map<String, dynamic>>('/lists/$id');
    return Map<String, dynamic>.from(response.data?['data'] as Map? ?? <String, dynamic>{});
  }

  @override
  Future<void> createList(String title, String? description) async {
    await apiClient.raw.post<Map<String, dynamic>>('/lists', data: {
      'title': title,
      if (description != null) 'description': description,
    });
  }

  @override
  Future<void> addMovieToList(int listId, int movieId) async {
    await apiClient.raw.post<Map<String, dynamic>>('/lists/$listId/items', data: {
      'movie_id': movieId,
    });
  }

  @override
  Future<void> deleteList(int id) async {
    await apiClient.raw.delete<Map<String, dynamic>>('/lists/$id');
  }
}
