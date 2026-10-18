// Kontrak repository fitur auth.

import 'auth_models.dart';

/// Kontrak akses data untuk autentikasi user.
abstract class AuthRepository {
  const AuthRepository();

  /// Masuk dengan email dan kata sandi lalu menyimpan token sesi.
  Future<AuthUser> login({required String email, required String password});

  /// Mendaftarkan user baru, menyimpan token, lalu mengembalikan profil.
  Future<AuthUser> register({
    required String name,
    required String email,
    required String password,
  });

  /// Mengambil profil user dari token sesi yang tersimpan.
  Future<AuthUser> fetchCurrentUser();

  /// Mengakhir sesi di backend dan menghapus token lokal.
  Future<void> logout();
}
