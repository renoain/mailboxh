// Implementasi repository fitur catalog.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/app_providers.dart';
import '../domain/movie.dart';
import '../domain/movie_repository.dart';

/// Menyediakan [MovieRepository] lewat container Riverpod.
final Provider<MovieRepository> movieRepositoryProvider =
    Provider<MovieRepository>((Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MovieRepositoryImpl(apiClient: apiClient);
});

/// Implementasi [MovieRepository] dengan HTTP ke backend Laravel.
class MovieRepositoryImpl implements MovieRepository {
  const MovieRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  static const String _moviesPath = '/api/movies';

  @override
  Future<List<Movie>> getMovies({
    String? query,
    int? genreId,
    String? sort,
    int page = 1,
  }) async {
    try {
      final response = await apiClient.raw.get(
        _moviesPath,
        queryParameters: {
          if (query != null) 'q': query,
          if (genreId != null) 'genre_id': genreId,
          if (sort != null) 'sort': sort,
          'page': page,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final List<dynamic> movieList = data['data'] as List<dynamic>;

      return movieList
          .map((json) => Movie.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Movie> getMovieDetail(int id) async {
    try {
      final response = await apiClient.raw.get('$_moviesPath/$id');

      final data = response.data as Map<String, dynamic>;
      final movieData = data['data'] as Map<String, dynamic>;

      return Movie.fromJson(movieData);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  AppException _mapError(DioException e) {
    if (e.error is AppException) {
      return e.error as AppException;
    }
    return ApiException(
      e.message ?? 'Terjadi kesalahan saat memuat film.',
      statusCode: e.response?.statusCode,
    );
  }
}
