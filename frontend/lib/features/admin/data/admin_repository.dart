// Implementasi repository fitur admin.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/app_providers.dart';
import '../domain/admin_model.dart';
import '../domain/admin_repository.dart';

/// Menyediakan [AdminRepository] lewat container Riverpod.
final Provider<AdminRepository> adminRepositoryProvider =
    Provider<AdminRepository>((Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdminRepositoryImpl(apiClient: apiClient);
});

/// Implementasi [AdminRepository] dengan HTTP ke backend Laravel.
class AdminRepositoryImpl implements AdminRepository {
  const AdminRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  static const String _dashboardPath = '/api/admin/dashboard';
  static const String _moviesPath = '/api/admin/movies';
  static const String _genresPath = '/api/admin/genres';
  static const String _usersPath = '/api/admin/users';
  static const String _reviewsPath = '/api/admin/reviews';
  static const String _batchImportPath = '/api/admin/movies/batch-import';

  @override
  Future<DashboardSummary> getDashboardSummary() async {
    try {
      final response = await apiClient.raw.get(_dashboardPath);
      final data = response.data as Map<String, dynamic>;
      return DashboardSummary.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<List<AdminMovie>> getMovies() async {
    try {
      final response = await apiClient.raw.get(_moviesPath);
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> list = data['data'] as List<dynamic>;
      return list
          .map((json) => AdminMovie.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<AdminMovie> createMovie({
    required String title,
    String? originalTitle,
    String? overview,
    DateTime? releaseDate,
    int? runtime,
    String? language,
    String? country,
    String? cast,
    String? crew,
    List<int>? genreIds,
    bool? isFeatured,
    String? posterPath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        if (originalTitle != null) 'original_title': originalTitle,
        if (overview != null) 'overview': overview,
        if (releaseDate != null) 'release_date': releaseDate.toIso8601String(),
        if (runtime != null) 'runtime': runtime,
        if (language != null) 'language': language,
        if (country != null) 'country': country,
        if (cast != null) 'cast': cast,
        if (crew != null) 'crew': crew,
        if (genreIds != null) 'genre_ids': genreIds,
        if (isFeatured != null) 'is_featured': isFeatured,
        if (posterPath != null)
          'poster': await MultipartFile.fromFile(posterPath),
      });

      final response = await apiClient.raw.post(
        _moviesPath,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      final data = response.data as Map<String, dynamic>;
      return AdminMovie.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<AdminMovie> updateMovie({
    required int id,
    String? title,
    String? originalTitle,
    String? overview,
    DateTime? releaseDate,
    int? runtime,
    String? language,
    String? country,
    String? cast,
    String? crew,
    List<int>? genreIds,
    bool? isFeatured,
  }) async {
    try {
      final formData = FormData.fromMap({
        if (title != null) 'title': title,
        if (originalTitle != null) 'original_title': originalTitle,
        if (overview != null) 'overview': overview,
        if (releaseDate != null) 'release_date': releaseDate.toIso8601String(),
        if (runtime != null) 'runtime': runtime,
        if (language != null) 'language': language,
        if (country != null) 'country': country,
        if (cast != null) 'cast': cast,
        if (crew != null) 'crew': crew,
        if (genreIds != null) 'genre_ids': genreIds,
        if (isFeatured != null) 'is_featured': isFeatured,
        '_method': 'PUT',
      });

      final response = await apiClient.raw.post(
        '$_moviesPath/$id',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      final data = response.data as Map<String, dynamic>;
      return AdminMovie.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> deleteMovie(int id) async {
    try {
      await apiClient.raw.delete('$_moviesPath/$id');
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> toggleFeature(int id) async {
    try {
      await apiClient.raw.post('$_moviesPath/$id/feature');
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<List<AdminGenre>> getGenres() async {
    try {
      final response = await apiClient.raw.get(_genresPath);
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> list = data['data'] as List<dynamic>;
      return list
          .map((json) => AdminGenre.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<AdminGenre> createGenre(String name) async {
    try {
      final response = await apiClient.raw.post(
        _genresPath,
        data: {'name': name},
      );
      final data = response.data as Map<String, dynamic>;
      return AdminGenre.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> deleteGenre(int id) async {
    try {
      await apiClient.raw.delete('$_genresPath/$id');
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<List<AdminUser>> getUsers() async {
    try {
      final response = await apiClient.raw.get(_usersPath);
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> list = data['data'] as List<dynamic>;
      return list
          .map((json) => AdminUser.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<AdminUser> updateUserRole(int id, String role) async {
    try {
      final response = await apiClient.raw.put(
        '$_usersPath/$id/role',
        data: {'role': role},
      );
      final data = response.data as Map<String, dynamic>;
      return AdminUser.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<List<AdminReview>> getReviews() async {
    try {
      final response = await apiClient.raw.get(_reviewsPath);
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> list = data['data'] as List<dynamic>;
      return list
          .map((json) => AdminReview.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> deleteReview(int id) async {
    try {
      await apiClient.raw.delete('$_reviewsPath/$id');
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<BatchImportResult> importMoviesBatch(String zipPath) async {
    try {
      final formData = FormData.fromMap({
        'zip': await MultipartFile.fromFile(zipPath),
      });

      final response = await apiClient.raw.post(
        _batchImportPath,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      final data = response.data as Map<String, dynamic>;
      return BatchImportResult.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  AppException _mapError(DioException e) {
    if (e.error is AppException) {
      return e.error as AppException;
    }
    return ApiException(
      e.message ?? 'Terjadi kesalahan saat memproses respons.',
      statusCode: e.response?.statusCode,
    );
  }
}
