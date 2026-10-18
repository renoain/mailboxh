// Model data murni untuk sesi autentikasi.

/// Profil user yang sedang login, dipakai di layer presentasi.
class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  final int id;
  final String name;
  final String email;
  final String role;

  bool get isAdmin => role == 'admin';
}
