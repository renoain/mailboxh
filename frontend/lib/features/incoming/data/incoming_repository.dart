// Implementasi repository fitur incoming.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/incoming_repository.dart';

/// Menyediakan [IncomingRepository] lewat container Riverpod.
final Provider<IncomingRepository> incomingRepositoryProvider =
    Provider<IncomingRepository>((Ref ref) {
  ref.watch(apiClientProvider);
  throw UnimplementedError(
    'Endpoint fitur incoming belum ada.',
  );
});
