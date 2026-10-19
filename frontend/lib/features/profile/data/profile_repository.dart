// Implementasi repository fitur profile terhadap endpoint backend.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/app_providers.dart';
import '../domain/profile_models.dart';
import '../domain/profile_repository.dart';

/// Menyediakan [ProfileRepository] lewat container Riverpod.
final Provider<ProfileRepository> profileRepositoryProvider =
    Provider<ProfileRepository>((Ref ref) {
  return ProfileRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});

/// Memanggil endpoint profil dengan token autentikasi.
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({required this.apiClient});

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
  Future<UserProfile> getProfile() => _guard<UserProfile>(
        parse: (dynamic data) => UserProfile.fromJson(
            Map<String, dynamic>.from(data as Map)),
        request: () =>
            apiClient.raw.get<Map<String, dynamic>>('/profile'),
      );

  @override
  Future<UserStats> getUserStats() => _guard<UserStats>(
        parse: (dynamic data) => UserStats.fromJson(
            Map<String, dynamic>.from(data as Map)),
        request: () =>
            apiClient.raw.get<Map<String, dynamic>>('/profile/stats'),
      );

  @override
  Future<ProfileStats> getStats() => getUserStats();

  @override
  Future<List<Movie>> getUserFilms() => _guard<List<Movie>>(
        parse: (dynamic data) {
          final List list = data as List;
          return list.map((dynamic item) {
            final Map<String, dynamic> map =
                Map<String, dynamic>.from(item as Map);
            if (map.containsKey('movie') && map['movie'] is Map) {
              return Movie.fromJson(
                  Map<String, dynamic>.from(map['movie'] as Map));
            }
            return Movie.fromJson(map);
          }).toList();
        },
        request: () =>
            apiClient.raw.get<Map<String, dynamic>>('/watched'),
      );

  @override
  Future<List<FavoriteFilm>> getFavorites() => _guard<List<FavoriteFilm>>(
        parse: (dynamic data) => (data as List)
            .map((dynamic item) => FavoriteFilm.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList(),
        request: () =>
            apiClient.raw.get<Map<String, dynamic>>('/favorites'),
      );

  @override
  Future<List<FavoriteFilm>> getFavoriteFilms() => getFavorites();

  @override
  Future<List<Movie>> getWatchlistMovies() => _guard<List<Movie>>(
        parse: (dynamic data) => (data as List)
            .map((dynamic item) => Movie.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList(),
        request: () =>
            apiClient.raw.get<Map<String, dynamic>>('/watchlist'),
      );

  @override
  Future<List<DiaryEntry>> getDiaryEntries() => _guard<List<DiaryEntry>>(
        parse: (dynamic data) => (data as List)
            .map((dynamic item) => DiaryEntry.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList(),
        request: () =>
            apiClient.raw.get<Map<String, dynamic>>('/diary'),
      );

  @override
  Future<List<ReviewItem>> getRecentReviews() => _guard<List<ReviewItem>>(
        parse: (dynamic data) => (data as List)
            .map((dynamic item) => ReviewItem.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList(),
        request: () => apiClient.raw
            .get<Map<String, dynamic>>('/profile/reviews'),
      );

  @override
  Future<List<UserList>> getUserLists() => _guard<List<UserList>>(
        parse: (dynamic data) => (data as List)
            .map((dynamic item) => UserList.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList(),
        request: () => apiClient.raw.get<Map<String, dynamic>>('/lists'),
      );

  @override
  Future<List<UserBrief>> getFollowing() => _guard<List<UserBrief>>(
        parse: (dynamic data) => (data as List)
            .map((dynamic item) => UserBrief.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList(),
        request: () =>
            apiClient.raw.get<Map<String, dynamic>>('/following'),
      );

  @override
  Future<List<UserBrief>> getFollowers() => _guard<List<UserBrief>>(
        parse: (dynamic data) => (data as List)
            .map((dynamic item) => UserBrief.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList(),
        request: () =>
            apiClient.raw.get<Map<String, dynamic>>('/followers'),
      );

  @override
  Future<List<Tag>> getTags() => _guard<List<Tag>>(
        parse: (dynamic data) => (data as List)
            .map((dynamic item) => Tag.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList(),
        request: () => apiClient.raw.get<Map<String, dynamic>>('/tags'),
      );
}
