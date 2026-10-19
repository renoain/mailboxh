// Implementasi repository fitur tag terhadap endpoint backend.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/app_providers.dart';
import '../domain/tag_models.dart';
import '../domain/tag_repository.dart';
import 'tag_model.dart';

/// Menyediakan [TagRepository] lewat container Riverpod.
final Provider<TagRepository> tagRepositoryProvider = Provider<TagRepository>(
  (Ref ref) => TagRepositoryImpl(ref.watch(apiClientProvider)),
);

/// Memanggil endpoint tag untuk daftar dan pembuatan tag.
class TagRepositoryImpl implements TagRepository {
  const TagRepositoryImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<List<Tag>> fetchTags() {
    return _guard(() async {
      final Response<Map<String, dynamic>> response = await apiClient.raw
          .get<Map<String, dynamic>>('/tags');
      return tagListFrom(response.data?['data']);
    });
  }

  @override
  Future<Tag> createTag(String name) {
    return _guard(() async {
      final Response<Map<String, dynamic>> response = await apiClient.raw
          .post<Map<String, dynamic>>(
            '/tags',
            data: <String, Object>{'name': name},
          );
      final dynamic data = response.data?['data'];
      return tagFromJson(Map<String, dynamic>.from(data as Map));
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
