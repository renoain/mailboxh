// Implementasi repository fitur admin terhadap endpoint backend.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/app_providers.dart';
import '../domain/admin_models.dart';
import '../domain/admin_repository.dart';

/// Menyediakan [AdminRepository] lewat container Riverpod.
final Provider<AdminRepository> adminRepositoryProvider =
    Provider<AdminRepository>((Ref ref) {
  return AdminRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});

/// Memanggil endpoint admin dengan token autentikasi.
class AdminRepositoryImpl implements AdminRepository {
  const AdminRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<DashboardSummary> getDashboardSummary() {
    return _guard(() async {
      final Response<Map<String, dynamic>> response =
          await apiClient.raw.get<Map<String, dynamic>>('/admin/dashboard');
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(response.data?['data'] as Map? ?? {});
      return DashboardSummary(
        totalMovies: data['total_movies'] as int? ?? 0,
        totalUsers: data['total_users'] as int? ?? 0,
        totalReviews: data['total_reviews'] as int? ?? 0,
      );
    });
  }

  @override
  Future<List<AdminMovie>> getMovies() {
    return _guard(() async {
      final Response<Map<String, dynamic>> response =
          await apiClient.raw.get<Map<String, dynamic>>('/admin/movies');
      final List<dynamic> list =
          (response.data?['data'] as List? ?? const <dynamic>[]);
      return list.map((dynamic item) {
        final Map<String, dynamic> json = Map<String, dynamic>.from(item as Map);
        return AdminMovie(
          id: json['id'] as int,
          title: json['title'] as String,
          overview: json['overview'] as String?,
          releaseDate: DateTime.tryParse(json['release_date'] as String? ?? ''),
          runtime: json['runtime'] as int?,
          posterUrl: json['poster_url'] as String?,
          backdropUrl: json['backdrop_url'] as String?,
          isFeatured: json['is_featured'] as bool? ?? false,
          genres: (json['genres'] as List? ?? const <dynamic>[])
              .map((dynamic g) => g.toString())
              .toList(),
        );
      }).toList();
    });
  }

  @override
  Future<AdminMovie> createMovie({
    required String title,
    required String overview,
    required int releaseYear,
    required int? runtime,
    required List<int> genreIds,
    required String? posterPath,
  }) {
    return _guard(() async {
      final FormData formData = FormData.fromMap(<String, dynamic>{
        'title': title,
        'overview': overview,
        'release_year': releaseYear,
        if (runtime != null) 'runtime': runtime,
        'genre_ids': genreIds,
        if (posterPath != null && posterPath.isNotEmpty)
          'poster': await MultipartFile.fromFile(posterPath),
      });
      final Response<Map<String, dynamic>> response =
          await apiClient.raw.post<Map<String, dynamic>>(
        '/admin/movies',
        data: formData,
      );
      final Map<String, dynamic> json =
          Map<String, dynamic>.from(response.data?['data'] as Map? ?? {});
      return AdminMovie(
        id: json['id'] as int,
        title: json['title'] as String,
        overview: json['overview'] as String?,
        releaseDate: DateTime.tryParse(json['release_date'] as String? ?? ''),
        runtime: json['runtime'] as int?,
        posterUrl: json['poster_url'] as String?,
        backdropUrl: json['backdrop_url'] as String?,
        isFeatured: json['is_featured'] as bool? ?? false,
        genres: (json['genres'] as List? ?? const <dynamic>[])
            .map((dynamic g) => g.toString())
            .toList(),
      );
    });
  }

  @override
  Future<void> updateMovie({
    required int id,
    required String title,
    required String overview,
    required int releaseYear,
    required int? runtime,
    required List<int> genreIds,
    required String? posterPath,
  }) {
    return _guard(() async {
      final Map<String, dynamic> data = <String, dynamic>{
        'title': title,
        'overview': overview,
        'release_year': releaseYear,
        if (runtime != null) 'runtime': runtime,
        'genre_ids': genreIds,
      };
      if (posterPath != null && posterPath.isNotEmpty) {
        data['poster'] = await MultipartFile.fromFile(posterPath);
      }
      final FormData formData = FormData.fromMap(data);
      await apiClient.raw.put<Map<String, dynamic>>(
        '/admin/movies/$id',
        data: formData,
      );
    });
  }

  @override
  Future<void> deleteMovie({required int id}) {
    return _guard(() async {
      await apiClient.raw.delete<Map<String, dynamic>>('/admin/movies/$id');
    });
  }

  @override
  Future<void> toggleFeature({required int id, required bool featured}) {
    return _guard(() async {
      await apiClient.raw.post<Map<String, dynamic>>(
        '/admin/movies/$id/feature',
      );
    });
  }

  @override
  Future<List<AdminGenre>> getGenres() {
    return _guard(() async {
      final Response<Map<String, dynamic>> response =
          await apiClient.raw.get<Map<String, dynamic>>('/admin/genres');
      final List<dynamic> list =
          (response.data?['data'] as List? ?? const <dynamic>[]);
      return list.map((dynamic item) {
        final Map<String, dynamic> json = Map<String, dynamic>.from(item as Map);
        return AdminGenre(
          id: json['id'] as int,
          name: json['name'] as String,
        );
      }).toList();
    });
  }

  @override
  Future<void> createGenre({required String name}) {
    return _guard(() async {
      await apiClient.raw.post<Map<String, dynamic>>(
        '/admin/genres',
        data: <String, dynamic>{'name': name},
      );
    });
  }

  @override
  Future<void> deleteGenre({required int id}) {
    return _guard(() async {
      await apiClient.raw.delete<Map<String, dynamic>>('/admin/genres/$id');
    });
  }

  @override
  Future<List<AdminUser>> getUsers() {
    return _guard(() async {
      final Response<Map<String, dynamic>> response =
          await apiClient.raw.get<Map<String, dynamic>>('/admin/users');
      final List<dynamic> list =
          (response.data?['data'] as List? ?? const <dynamic>[]);
      return list.map((dynamic item) {
        final Map<String, dynamic> json = Map<String, dynamic>.from(item as Map);
        return AdminUser(
          id: json['id'] as int,
          name: json['name'] as String,
          email: json['email'] as String,
          role: json['role'] as String? ?? 'user',
        );
      }).toList();
    });
  }

  @override
  Future<void> updateUserRole({required int id, required String role}) {
    return _guard(() async {
      await apiClient.raw.put<Map<String, dynamic>>(
        '/admin/users/$id/role',
        data: <String, dynamic>{'role': role},
      );
    });
  }

  @override
  Future<List<AdminReview>> getReviews() {
    return _guard(() async {
      final Response<Map<String, dynamic>> response =
          await apiClient.raw.get<Map<String, dynamic>>('/admin/reviews');
      final List<dynamic> list =
          (response.data?['data'] as List? ?? const <dynamic>[]);
      return list.map((dynamic item) {
        final Map<String, dynamic> json = Map<String, dynamic>.from(item as Map);
        return AdminReview(
          id: json['id'] as int,
          userId: json['user_id'] as int? ?? 0,
          userName: json['user_name'] as String? ?? '',
          movieId: json['movie_id'] as int? ?? 0,
          movieTitle: json['movie_title'] as String? ?? '',
          content: json['content'] as String? ?? '',
          rating: json['rating'] as int? ?? 0,
          createdAt: DateTime.tryParse(json['created_at'] as String? ?? '')
              ?? DateTime.now(),
        );
      }).toList();
    });
  }

  @override
  Future<void> deleteReview({required int id}) {
    return _guard(() async {
      await apiClient.raw.delete<Map<String, dynamic>>('/admin/reviews/$id');
    });
  }

  @override
  Future<BatchImportResult> importMoviesBatch({
    required String zipPath,
  }) {
    return _guard(() async {
      final FormData formData = FormData.fromMap(<String, dynamic>{
        'zip': await MultipartFile.fromFile(zipPath),
      });
      final Response<Map<String, dynamic>> response =
          await apiClient.raw.post<Map<String, dynamic>>(
        '/admin/movies/batch-import',
        data: formData,
      );
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(response.data?['data'] as Map? ?? {});
      return BatchImportResult(
        success: data['success'] as int? ?? 0,
        failed: data['failed'] as int? ?? 0,
        posterMismatch: data['poster_mismatch'] as int? ?? 0,
        total: data['total'] as int? ?? 0,
      );
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
