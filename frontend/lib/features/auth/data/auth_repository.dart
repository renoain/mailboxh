// Implementasi repository fitur auth.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/app_providers.dart';
import '../domain/auth_repository.dart';

/// Menyediakan [AuthRepository] lewat container Riverpod.
final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>((Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepositoryImpl(apiClient: apiClient);
});

/// Implementasi [AuthRepository] dengan HTTP ke backend Laravel.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  static const String _loginPath = '/api/login';
  static const String _registerPath = '/api/register';

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.raw.post(
        _loginPath,
        data: {'email': email, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String?;

      if (token == null || token.isEmpty) {
        throw const ApiException('Token sesi tidak diterima dari server.');
      }

      final userJson = data['user'] as Map<String, dynamic>?;
      if (userJson == null) {
        throw const ApiException('Data user tidak diterima dari server.');
      }

      final user = UserModel.fromJson(userJson);
      await apiClient.tokenStorage.save(token);
      await apiClient.tokenStorage.saveRole(user.role);

      return AuthResult(
        token: token,
        user: user,
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.raw.post(
        _registerPath,
        data: {'name': name, 'email': email, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String?;

      if (token == null || token.isEmpty) {
        throw const ApiException('Token sesi tidak diterima dari server.');
      }

      final userJson = data['user'] as Map<String, dynamic>?;
      if (userJson == null) {
        throw const ApiException('Data user tidak diterima dari server.');
      }

      final user = UserModel.fromJson(userJson);
      await apiClient.tokenStorage.save(token);
      await apiClient.tokenStorage.saveRole(user.role);

      return AuthResult(
        token: token,
        user: user,
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> logout() async {
    await apiClient.tokenStorage.clear();
  }

  @override
  Future<bool> hasToken() async => apiClient.tokenStorage.hasToken();

  AppException _mapError(DioException e) {
    if (e.error is AppException) {
      return e.error as AppException;
    }
    return ApiException(
      e.message ?? 'Terjadi kesalahan saat memproses respons.',
      statusCode: e.response?.statusCode,
    );
  }
}
