// Implementasi repository fitur log.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/log_repository.dart';

/// Menyediakan [LogRepository] lewat container Riverpod.
final Provider<LogRepository> logRepositoryProvider =
    Provider<LogRepository>((Ref ref) {
  ref.watch(apiClientProvider);
  throw UnimplementedError(
    'Endpoint fitur log belum ada.',
  );
});
