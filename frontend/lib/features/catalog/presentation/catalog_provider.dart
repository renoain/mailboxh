// State fitur catalog.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../data/movie_repository.dart';
import '../domain/movie.dart';
import '../domain/movie_repository.dart';

/// Status pemuatan katalog film.
class CatalogState {
  const CatalogState({
    this.movies = const [],
    this.error,
    this.isLoading = false,
    this.hasMore = true,
    this.page = 1,
  });

  final List<Movie> movies;
  final AppException? error;
  final bool isLoading;
  final bool hasMore;
  final int page;

  CatalogState copyWith({
    List<Movie>? movies,
    AppException? error,
    bool? isLoading,
    bool? hasMore,
    int? page,
  }) {
    return CatalogState(
      movies: movies ?? this.movies,
      error: error,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}

/// Kelola status katalog film melalui [MovieRepository].
class CatalogNotifier extends StateNotifier<CatalogState> {
  CatalogNotifier(this._repository) : super(const CatalogState());

  final MovieRepository _repository;

  /// Muat daftar film, opsional dengan pencarian dan filter.
  Future<void> loadMovies({
    String? query,
    int? genreId,
    String? sort,
    bool refresh = false,
  }) async {
    if (refresh) {
      state = state.copyWith(movies: [], page: 1, hasMore: true, error: null);
    }
    if (!state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final movies = await _repository.getMovies(
        query: query,
        genreId: genreId,
        sort: sort,
        page: state.page,
      );
      state = state.copyWith(
        movies: refresh ? movies : [...state.movies, ...movies],
        isLoading: false,
        hasMore: movies.isNotEmpty,
        page: state.page + 1,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Hapus error dari state.
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider [CatalogNotifier] untuk halaman katalog.
final catalogNotifierProvider =
    StateNotifierProvider<CatalogNotifier, CatalogState>((Ref ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return CatalogNotifier(repository);
});

/// Provider untuk memicu pemuatan ulang katalog.
final catalogRefreshProvider = Provider((Ref ref) {
  ref.watch(catalogNotifierProvider.notifier);
});
