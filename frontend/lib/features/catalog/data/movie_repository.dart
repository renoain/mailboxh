// Implementasi repository fitur catalog terhadap endpoint backend.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/app_providers.dart';
import '../domain/movie_models.dart';
import '../domain/movie_repository.dart';
import 'movie_model.dart';

/// Menyediakan [MovieRepository] lewat container Riverpod.
final Provider<MovieRepository> movieRepositoryProvider =
    Provider<MovieRepository>((Ref ref) {
  return MovieRepositoryImpl(ref.watch(apiClientProvider));
});

/// Memanggil endpoint movies dan home tanpa cache tambahan.
class MovieRepositoryImpl implements MovieRepository {
  const MovieRepositoryImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<HomeData> fetchHome() {
    return _guard(() async {
      final Response<Map<String, dynamic>> response =
          await apiClient.raw.get<Map<String, dynamic>>('/home');
      final Map<String, dynamic> sections =
          Map<String, dynamic>.from(response.data?['data'] as Map);
      return HomeData(
        featured: movieListFrom(sections['featured']),
        latest: movieListFrom(sections['latest']),
        topRated: movieListFrom(sections['top_rated']),
        mostWatched: movieListFrom(sections['most_watched']),
        mostWatchlisted: movieListFrom(sections['most_watchlisted']),
        explore: movieListFrom(sections['explore']),
      );
    });
  }

  @override
  Future<MoviePage> fetchMovies({
    String? query,
    MovieSort sort = MovieSort.latest,
    int page = 1,
  }) {
    return _guard(() async {
      final Map<String, Object?> params = <String, Object?>{'page': page};
      if (query != null && query.isNotEmpty) params['q'] = query;
      final String? sortParam = _sortParam(sort);
      if (sortParam != null) params['sort'] = sortParam;

      final Response<Map<String, dynamic>> response = await apiClient.raw
          .get<Map<String, dynamic>>('/movies', queryParameters: params);
      final Map<String, dynamic> body = response.data ?? <String, dynamic>{};
      final Map<String, dynamic> meta =
          Map<String, dynamic>.from(body['meta'] as Map? ?? <String, dynamic>{});
      return MoviePage(
        movies: movieListFrom(body['data']),
        page: meta['page'] as int? ?? page,
        perPage: meta['per_page'] as int? ?? 20,
        total: meta['total'] as int? ?? 0,
      );
    });
  }

  String? _sortParam(MovieSort sort) => switch (sort) {
        MovieSort.latest => null,
        MovieSort.title => 'title',
        MovieSort.releaseDate => 'release_date',
        MovieSort.rating => 'rating',
      };

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
