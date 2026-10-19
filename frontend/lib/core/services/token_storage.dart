// Penyimpanan token sesi di secure storage.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Satu-satunya kelas yang menyentuh token sesi.
class TokenStorage {
  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _tokenKey = 'session_token';
  static const String _refreshKey = 'refresh_token';
  static const String _roleKey = 'user_role';

  final FlutterSecureStorage _storage;

  Future<String?> read() => _storage.read(key: _tokenKey);

  Future<String?> readRefresh() => _storage.read(key: _refreshKey);

  Future<void> save(String token) => _storage.write(key: _tokenKey, value: token);

  Future<void> saveRefresh(String token) =>
      _storage.write(key: _refreshKey, value: token);

  Future<bool> hasToken() async => (await read()) != null;

  /// Baca role user yang tersimpan.
  Future<String?> readRole() => _storage.read(key: _roleKey);

  /// Simpan role user.
  Future<void> saveRole(String role) =>
      _storage.write(key: _roleKey, value: role);

  /// Periksa apakah user memiliki role admin.
  Future<bool> isAdmin() async => (await readRole()) == 'admin';

  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshKey);
    await _storage.delete(key: _roleKey);
  }
}