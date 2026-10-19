// State fitur admin: loading, data, dan error per operasi.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../data/admin_repository.dart';
import '../domain/admin_models.dart';
import '../domain/admin_repository.dart';

/// State hasil pemuatan data admin.
class AdminState {
  const AdminState({
    this.dashboard,
    this.movies = const <AdminMovie>[],
    this.genres = const <AdminGenre>[],
    this.users = const <AdminUser>[],
    this.reviews = const <AdminReview>[],
    this.error,
    this.isLoading = false,
    this.importResult,
    this.importLoading = false,
  });

  final DashboardSummary? dashboard;
  final List<AdminMovie> movies;
  final List<AdminGenre> genres;
  final List<AdminUser> users;
  final List<AdminReview> reviews;
  final AppException? error;
  final bool isLoading;
  final BatchImportResult? importResult;
  final bool importLoading;

  AdminState copyWith({
    DashboardSummary? dashboard,
    List<AdminMovie>? movies,
    List<AdminGenre>? genres,
    List<AdminUser>? users,
    List<AdminReview>? reviews,
    AppException? error,
    bool? isLoading,
    BatchImportResult? importResult,
    bool? importLoading,
    bool clearError = false,
  }) {
    return AdminState(
      dashboard: dashboard ?? this.dashboard,
      movies: movies ?? this.movies,
      genres: genres ?? this.genres,
      users: users ?? this.users,
      reviews: reviews ?? this.reviews,
      error: clearError ? null : (error ?? this.error),
      isLoading: isLoading ?? this.isLoading,
      importResult: importResult ?? this.importResult,
      importLoading: importLoading ?? this.importLoading,
    );
  }
}

/// Kelola state fitur admin melalui repository.
class AdminNotifier extends Notifier<AdminState> {
  @override
  AdminState build() {
    return const AdminState();
  }

  AdminRepository get _repository => ref.read(adminRepositoryProvider);

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final DashboardSummary summary = await _repository.getDashboardSummary();
      state = state.copyWith(dashboard: summary, isLoading: false);
    } on AppException catch (error) {
      state = state.copyWith(error: error, isLoading: false);
    }
  }

  Future<void> loadMovies() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final List<AdminMovie> movies = await _repository.getMovies();
      state = state.copyWith(movies: movies, isLoading: false);
    } on AppException catch (error) {
      state = state.copyWith(error: error, isLoading: false);
    }
  }

  Future<void> loadGenres() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final List<AdminGenre> genres = await _repository.getGenres();
      state = state.copyWith(genres: genres, isLoading: false);
    } on AppException catch (error) {
      state = state.copyWith(error: error, isLoading: false);
    }
  }

  Future<void> loadUsers() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final List<AdminUser> users = await _repository.getUsers();
      state = state.copyWith(users: users, isLoading: false);
    } on AppException catch (error) {
      state = state.copyWith(error: error, isLoading: false);
    }
  }

  Future<void> loadReviews() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final List<AdminReview> reviews = await _repository.getReviews();
      state = state.copyWith(reviews: reviews, isLoading: false);
    } on AppException catch (error) {
      state = state.copyWith(error: error, isLoading: false);
    }
  }

  Future<AdminMovie?> createMovie({
    required String title,
    required String overview,
    required int releaseYear,
    required int? runtime,
    required List<int> genreIds,
    required String? posterPath,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final AdminMovie movie = await _repository.createMovie(
        title: title,
        overview: overview,
        releaseYear: releaseYear,
        runtime: runtime,
        genreIds: genreIds,
        posterPath: posterPath,
      );
      state = state.copyWith(
        movies: [...state.movies, movie],
        isLoading: false,
      );
      return movie;
    } on AppException catch (error) {
      state = state.copyWith(error: error, isLoading: false);
      return null;
    }
  }

  Future<bool> updateMovie({
    required int id,
    required String title,
    required String overview,
    required int releaseYear,
    required int? runtime,
    required List<int> genreIds,
    required String? posterPath,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.updateMovie(
        id: id,
        title: title,
        overview: overview,
        releaseYear: releaseYear,
        runtime: runtime,
        genreIds: genreIds,
        posterPath: posterPath,
      );
      await loadMovies();
      return true;
    } on AppException catch (error) {
      state = state.copyWith(error: error, isLoading: false);
      return false;
    }
  }

  Future<bool> deleteMovie({required int id}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.deleteMovie(id: id);
      state = state.copyWith(
        movies: state.movies.where((m) => m.id != id).toList(),
        isLoading: false,
      );
      return true;
    } on AppException catch (error) {
      state = state.copyWith(error: error, isLoading: false);
      return false;
    }
  }

  Future<bool> toggleFeature({required int id, required bool featured}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.toggleFeature(id: id, featured: featured);
      state = state.copyWith(
        movies: state.movies.map((m) {
          if (m.id == id) {
            return AdminMovie(
              id: m.id,
              title: m.title,
              overview: m.overview,
              releaseDate: m.releaseDate,
              runtime: m.runtime,
              posterUrl: m.posterUrl,
              backdropUrl: m.backdropUrl,
              isFeatured: featured,
              genres: m.genres,
            );
          }
          return m;
        }).toList(),
        isLoading: false,
      );
      return true;
    } on AppException catch (error) {
      state = state.copyWith(error: error, isLoading: false);
      return false;
    }
  }

  Future<bool> createGenre({required String name}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.createGenre(name: name);
      await loadGenres();
      return true;
    } on AppException catch (error) {
      state = state.copyWith(error: error, isLoading: false);
      return false;
    }
  }

  Future<bool> deleteGenre({required int id}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.deleteGenre(id: id);
      state = state.copyWith(
        genres: state.genres.where((g) => g.id != id).toList(),
        isLoading: false,
      );
      return true;
    } on AppException catch (error) {
      state = state.copyWith(error: error, isLoading: false);
      return false;
    }
  }

  Future<bool> updateUserRole({required int id, required String role}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.updateUserRole(id: id, role: role);
      await loadUsers();
      return true;
    } on AppException catch (error) {
      state = state.copyWith(error: error, isLoading: false);
      return false;
    }
  }

  Future<bool> deleteReview({required int id}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.deleteReview(id: id);
      state = state.copyWith(
        reviews: state.reviews.where((r) => r.id != id).toList(),
        isLoading: false,
      );
      return true;
    } on AppException catch (error) {
      state = state.copyWith(error: error, isLoading: false);
      return false;
    }
  }

  Future<BatchImportResult?> importMoviesBatch({
    required String zipPath,
  }) async {
    state = state.copyWith(importLoading: true, clearError: true);
    try {
      final BatchImportResult result =
          await _repository.importMoviesBatch(zipPath: zipPath);
      state = state.copyWith(
        importResult: result,
        importLoading: false,
      );
      await loadMovies();
      return result;
    } on AppException catch (error) {
      state = state.copyWith(error: error, importLoading: false);
      return null;
    }
  }
}

/// Provider notifier untuk state admin.
final adminProvider = NotifierProvider<AdminNotifier, AdminState>(AdminNotifier.new);
