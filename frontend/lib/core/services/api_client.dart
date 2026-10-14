// Klien HTTP yang menambah token sesi dan memetakan error backend.

import 'dart:io';

import 'package:dio/dio.dart';

import '../constants/app_env.dart';
import '../constants/app_strings.dart';
import '../error/app_exception.dart';
import '../utils/logger.dart';
import 'token_storage.dart';

/// Satu instance Dio untuk seluruh aplikasi. Widget tidak pernah
/// membuat Dio sendiri.
class ApiClient {
  ApiClient({required this.tokenStorage, Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppEnv.apiBaseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 20),
                sendTimeout: const Duration(seconds: 20),
                headers: const {'Accept': 'application/json'},
              ),
            ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    );
  }

  static const AppText text = AppStrings.id;

  final Dio _dio;
  final TokenStorage tokenStorage;

  Dio get raw => _dio;

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? token = await tokenStorage.read();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final int? status = error.response?.statusCode;
    final dynamic body = error.response?.data;

    AppLogger.warn(
      'Permintaan gagal',
      data: '${error.requestOptions.method} ${error.requestOptions.path}',
    );

    handler.reject(
      DioException(
        requestOptions: error.requestOptions,
        response: error.response,
        type: error.type,
        error: _map(error, status, body),
      ),
    );
  }

  AppException _map(DioException error, int? status, dynamic body) {
    final String message = _messageFrom(body) ?? text.somethingWrong;

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return TimeoutException(message);
    }
    if (error.error is SocketException) {
      return NetworkException(message);
    }

    switch (status) {
      case 401:
        return UnauthorizedException(message);
      case 404:
        return NotFoundException(message);
      case 409:
        return ConflictException(message);
      case 422:
        return ValidationException(
          message,
          errors: _errorsFrom(body),
        );
      case 429:
        return RateLimitException(message);
      default:
        return ApiException(message, statusCode: status, errors: _errorsFrom(body));
    }
  }

  String? _messageFrom(dynamic body) {
    if (body is Map && body['message'] is String) {
      return body['message'] as String;
    }
    return null;
  }

  Map<String, dynamic>? _errorsFrom(dynamic body) {
    if (body is Map && body['errors'] is Map) {
      return Map<String, dynamic>.from(body['errors'] as Map);
    }
    return null;
  }
}