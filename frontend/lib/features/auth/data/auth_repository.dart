// Implementasi repository fitur auth terhadap endpoint Sanctum.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/app_providers.dart';
import '../../../core/services/token_storage.dart';
import '../domain/auth_models.dart';
import '../domain/auth_repository.dart';
import 'user_model.dart';

/// Menyediakan [AuthRepository] lewat container Riverpod.
final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>((Ref ref) {
  return AuthRepositoryImpl(
    apiClient: ref.watch(apiClientProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
});

/// Memanggil endpoint auth lalu menyimpan token sesi di secure storage.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this.apiClient,
    required this.tokenStorage,
  });

  final ApiClient apiClient;
  final TokenStorage tokenStorage;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final Response<Map<String, dynamic>> response = await apiClient.raw
          .post<Map<String, dynamic>>(
        '/login',
        data: <String, Object>{'email': email, 'password': password},
      );
      return _saveSession(response.data);
    });
  }

  @override
  Future<AuthUser> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final Response<Map<String, dynamic>> response = await apiClient.raw
          .post<Map<String, dynamic>>(
        '/register',
        data: <String, Object>{
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
      );
      return _saveSession(response.data);
    });
  }

  @override
  Future<AuthUser> fetchCurrentUser() {
    return _guard(() async {
      final Response<Map<String, dynamic>> response =
          await apiClient.raw.get<Map<String, dynamic>>('/me');
      final dynamic data = response.data?['data'];
      return UserModel.fromJson(Map<String, dynamic>.from(data as Map))
          .toEntity();
    });
  }

  @override
  Future<void> logout() async {
    try {
      await _guard(() => apiClient.raw.post<dynamic>('/logout'));
    } on AppException {
      // Token tetap dihapus lokal walau revoke di backend gagal.
    } finally {
      await tokenStorage.clear();
    }
  }

  /// Menyimpan token dari respons auth lalu mengembalikan profil user.
  Future<AuthUser> _saveSession(Map<String, dynamic>? body) async {
    final dynamic data = body?['data'];
    final String token = (data as Map)['token'] as String;
    await tokenStorage.save(token);
    return UserModel.fromJson(Map<String, dynamic>.from(data['user'] as Map))
        .toEntity();
  }

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
