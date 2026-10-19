// Kontrak repository fitur auth.
/// Hasil autentikasi yang berisi token dan data user.
class AuthResult {
  const AuthResult({required this.token, required this.user});

  final String token;
  final UserModel user;
}

/// Model data user dari backend.
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'user',
  });

  final int id;
  final String name;
  final String email;
  final String role;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        role: json['role'] as String? ?? 'user',
      );
}

/// Kontrak akses data untuk fitur auth.
abstract class AuthRepository {
  const AuthRepository();

  /// Masuk dengan email dan kata sandi.
  Future<AuthResult> login({
    required String email,
    required String password,
  });

  /// Daftarkan akun baru dengan nama, email, dan kata sandi.
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  });

  /// Hapus token sesi dari penyimpanan aman.
  Future<void> logout();

  /// Periksa apakah token sesi tersimpan.
  Future<bool> hasToken();
}
