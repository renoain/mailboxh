// State fitur admin.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../data/admin_repository.dart';
import '../domain/admin_model.dart';
import '../domain/admin_repository.dart';

/// Status umum untuk setiap aksi admin.
class AdminState {
  const AdminState({
    this.data,
    this.error,
    this.isLoading = false,
    this.batchResult,
  });

  final dynamic data;
  final AppException? error;
  final bool isLoading;
  final BatchImportResult? batchResult;

  AdminState copyWith({
    dynamic data,
    AppException? error,
    bool? isLoading,
    BatchImportResult? batchResult,
    bool clearBatchResult = false,
  }) {
    return AdminState(
      data: data ?? this.data,
      error: error,
      isLoading: isLoading ?? this.isLoading,
      batchResult: clearBatchResult
          ? null
          : (batchResult ?? this.batchResult),
    );
  }
}

/// Kelola semua state fitur admin melalui [AdminRepository].
class AdminNotifier extends StateNotifier<AdminState> {
  AdminNotifier(this._repository) : super(const AdminState());

  final AdminRepository _repository;

  /// Muat ringkasan dashboard.
  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final summary = await _repository.getDashboardSummary();
      state = state.copyWith(data: summary, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Muat daftar film.
  Future<void> loadMovies() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final movies = await _repository.getMovies();
      state = state.copyWith(data: movies, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Buat film baru.
  Future<void> createMovie({
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
    state = state.copyWith(isLoading: true, error: null);
    try {
      final movie = await _repository.createMovie(
        title: title,
        originalTitle: originalTitle,
        overview: overview,
        releaseDate: releaseDate,
        runtime: runtime,
        language: language,
        country: country,
        cast: cast,
        crew: crew,
        genreIds: genreIds,
        isFeatured: isFeatured,
        posterPath: posterPath,
      );
      final current = state.data as List<AdminMovie>? ?? [];
      state = state.copyWith(
        data: [...current, movie],
        isLoading: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Ubah data film.
  Future<void> updateMovie({
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
    state = state.copyWith(isLoading: true, error: null);
    try {
      final movie = await _repository.updateMovie(
        id: id,
        title: title,
        originalTitle: originalTitle,
        overview: overview,
        releaseDate: releaseDate,
        runtime: runtime,
        language: language,
        country: country,
        cast: cast,
        crew: crew,
        genreIds: genreIds,
        isFeatured: isFeatured,
      );
      final current = state.data as List<AdminMovie>? ?? [];
      final updated = current
          .map((m) => m.id == id ? movie : m)
          .toList();
      state = state.copyWith(
        data: updated,
        isLoading: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Hapus film.
  Future<void> deleteMovie(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteMovie(id);
      final current = state.data as List<AdminMovie>? ?? [];
      state = state.copyWith(
        data: current.where((m) => m.id != id).toList(),
        isLoading: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Aktifkan/nonaktifkan fitur film.
  Future<void> toggleFeature(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.toggleFeature(id);
      final current = state.data as List<AdminMovie>? ?? [];
      final updated = current.map((m) {
        if (m.id == id) {
          return AdminMovie(
            id: m.id,
            title: m.title,
            originalTitle: m.originalTitle,
            releaseDate: m.releaseDate,
            posterPath: m.posterPath,
            runtime: m.runtime,
            language: m.language,
            country: m.country,
            cast: m.cast,
            crew: m.crew,
            isFeatured: !m.isFeatured,
            genres: m.genres,
          );
        }
        return m;
      }).toList();
      state = state.copyWith(
        data: updated,
        isLoading: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Muat daftar genre.
  Future<void> loadGenres() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final genres = await _repository.getGenres();
      state = state.copyWith(data: genres, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Buat genre baru.
  Future<void> createGenre(String name) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final genre = await _repository.createGenre(name);
      final current = state.data as List<AdminGenre>? ?? [];
      state = state.copyWith(
        data: [...current, genre],
        isLoading: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Hapus genre.
  Future<void> deleteGenre(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteGenre(id);
      final current = state.data as List<AdminGenre>? ?? [];
      state = state.copyWith(
        data: current.where((g) => g.id != id).toList(),
        isLoading: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Muat daftar user.
  Future<void> loadUsers() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final users = await _repository.getUsers();
      state = state.copyWith(data: users, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Ubah role user.
  Future<void> updateUserRole(int id, String role) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.updateUserRole(id, role);
      final current = state.data as List<AdminUser>? ?? [];
      final updated = current.map((u) {
        if (u.id == id) return user;
        return u;
      }).toList();
      state = state.copyWith(
        data: updated,
        isLoading: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Muat daftar review untuk moderasi.
  Future<void> loadReviews() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final reviews = await _repository.getReviews();
      state = state.copyWith(data: reviews, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Hapus review.
  Future<void> deleteReview(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteReview(id);
      final current = state.data as List<AdminReview>? ?? [];
      state = state.copyWith(
        data: current.where((r) => r.id != id).toList(),
        isLoading: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Impor film massal lewat file ZIP.
  Future<void> importMoviesBatch(String zipPath) async {
    state = state.copyWith(isLoading: true, error: null, batchResult: null);
    try {
      final result = await _repository.importMoviesBatch(zipPath);
      state = state.copyWith(
        isLoading: false,
        batchResult: result,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Hapus pesan error dari state.
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider [AdminNotifier] untuk halaman admin.
final adminNotifierProvider =
    StateNotifierProvider<AdminNotifier, AdminState>((Ref ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return AdminNotifier(repository);
});
