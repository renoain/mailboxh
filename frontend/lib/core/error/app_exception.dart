// Exception terstruktur untuk layer data dan domain.

/// Basis untuk semua error yang ditangani aplikasi.
sealed class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  /// Pesan aman untuk ditampilkan ke user.
  final String message;

  /// Status HTTP dari backend, null bila error arose dari sisi klien.
  final int? statusCode;

  @override
  String toString() => '$runtimeType: $message';
}

/// Backend menjawab dengan status di luar 2xx.
class ApiException extends AppException {
  const ApiException(super.message, {super.statusCode, this.errors});

  /// Isi field `errors` dari backend, bila ada.
  final Map<String, dynamic>? errors;
}

/// Token tidak ada, sudah kedaluwarsa, atau ditolak backend.
class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message) : super(statusCode: 401);
}

/// Jaringan tidak bisa dijangkau.
class NetworkException extends AppException {
  const NetworkException(super.message);
}

/// Percakapan gagal melebihi batas waktu.
class TimeoutException extends AppException {
  const TimeoutException(super.message);
}

/// Validasi dari backend ditolak.
class ValidationException extends AppException {
  const ValidationException(super.message, {this.errors}) : super(statusCode: 422);

  final Map<String, dynamic>? errors;
}

/// Data yang diminta tidak ada.
class NotFoundException extends AppException {
  const NotFoundException(super.message) : super(statusCode: 404);
}

/// Permintaan bertabrakan dengan data yang sudah ada.
class ConflictException extends AppException {
  const ConflictException(super.message) : super(statusCode: 409);
}

/// Backend sedang membatasi laju request.
class RateLimitException extends AppException {
  const RateLimitException(super.message) : super(statusCode: 429);
}