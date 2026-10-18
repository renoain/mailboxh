// State sesi autentikasi user.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/services/app_providers.dart';
import '../data/auth_repository.dart';
import '../domain/auth_models.dart';

/// Menyimpan profil user login; null berarti tamu.
class AuthNotifier extends AsyncNotifier<AuthUser?> {
  @override
  Future<AuthUser?> build() async {
    final bool hasToken = await ref.watch(tokenStorageProvider).hasToken();
    if (!hasToken) return null;
    try {
      return await ref.watch(authRepositoryProvider).fetchCurrentUser();
    } on UnauthorizedException {
      await ref.read(tokenStorageProvider).clear();
      return null;
    }
  }

  /// Masuk lalu memperbarui state sesi.
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    final AuthUser user = await ref.read(authRepositoryProvider).login(
          email: email,
          password: password,
        );
    state = AsyncValue.data(user);
    return user;
  }

  /// Mendaftar lalu memperbarui state sesi.
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final AuthUser user = await ref.read(authRepositoryProvider).register(
          name: name,
          email: email,
          password: password,
        );
    state = AsyncValue.data(user);
    return user;
  }

  /// Keluar dan menghapus token sesi.
  Future<void> signOut() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } on AppException {
      // Sesi lokal tetap dihapus walau permintaan gagal.
    }
    state = const AsyncValue<AuthUser?>.data(null);
  }
}

/// Profil user yang sedang login, atau null bila tamu.
final AsyncNotifierProvider<AuthNotifier, AuthUser?> authProvider =
    AsyncNotifierProvider<AuthNotifier, AuthUser?>(AuthNotifier.new);
