// State fitur auth.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../data/auth_repository.dart';
import '../domain/auth_repository.dart';

/// Status autentikasi user.
class AuthState {
  const AuthState({
    this.isAuthenticated = false,
    this.user,
    this.error,
    this.isLoading = false,
  });

  final bool isAuthenticated;
  final UserModel? user;
  final AppException? error;
  final bool isLoading;

  AuthState copyWith({
    bool? isAuthenticated,
    UserModel? user,
    AppException? error,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Kelola status login, register, dan logout melalui [AuthRepository].
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  /// Login dengan email dan kata sandi.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _repository.login(
        email: email,
        password: password,
      );
      state = AuthState(
        isAuthenticated: true,
        user: result.user,
        isLoading: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Daftarkan akun baru dan langsung login.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _repository.register(
        name: name,
        email: email,
        password: password,
      );
      state = AuthState(
        isAuthenticated: true,
        user: result.user,
        isLoading: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Keluar dari aplikasi dan hapus token sesi.
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _repository.logout();
    state = const AuthState();
  }

  /// Hapus pesan error dari state.
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider [AuthNotifier] untuk halaman autentikasi.
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
