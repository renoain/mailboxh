// Implementasi repository fitur auth.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/auth_repository.dart';

/// Menyediakan [AuthRepository] lewat container Riverpod.
final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>((Ref ref) {
  ref.watch(apiClientProvider);
  throw UnimplementedError(
    'Endpoint fitur auth belum ada.',
  );
});
