// Implementasi repository fitur favorites terhadap backend Laravel.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/app_providers.dart';
import '../../profile/domain/profile_models.dart';
import '../domain/favorite_repository.dart';

/// Menyediakan [FavoriteRepository] lewat container Riverpod.
final Provider<FavoriteRepository> favoriteRepositoryProvider =
    Provider<FavoriteRepository>((Ref ref) {
  return FavoriteRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});

/// Memanggil endpoint favorites dengan token autentikasi.
class FavoriteRepositoryImpl implements FavoriteRepository {
  const FavoriteRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  Future<T> _guard<T>({
    required T Function(dynamic data) parse,
    required Future<Response<Map<String, dynamic>>> Function() request,
  }) async {
    try {
      final Response<Map<String, dynamic>> response = await request();
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(response.data as Map? ?? <String, dynamic>{});
      if (data['success'] != true) {
        throw ApiException(
          data['message'] as String? ?? 'Permintaan gagal.',
        );
      }
      return parse(data['data']);
    } on DioException catch (error) {
      final Object? mapped = error.error;
      if (mapped is AppException) throw mapped;
      rethrow;
    }
  }

  @override
  Future<List<FavoriteFilm>> getFavorites() => _guard<List<FavoriteFilm>>(
        parse: (dynamic data) => (data as List)
            .map((dynamic item) => FavoriteFilm.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList(),
        request: () => apiClient.raw.get<Map<String, dynamic>>('/favorites'),
      );

  @override
  Future<List<FavoriteFilm>> updateFavorites(
          List<Map<String, dynamic>> items) =>
      _guard<List<FavoriteFilm>>(
        parse: (dynamic data) => (data as List)
            .map((dynamic item) => FavoriteFilm.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList(),
        request: () => apiClient.raw.put<Map<String, dynamic>>(
          '/favorites',
          data: <String, dynamic>{'items': items},
        ),
      );
}
