// Implementasi repository fitur lists.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/list_repository.dart';

/// Menyediakan [ListRepository] lewat container Riverpod.
final Provider<ListRepository> listRepositoryProvider =
    Provider<ListRepository>((Ref ref) {
  ref.watch(apiClientProvider);
  throw UnimplementedError(
    'Endpoint fitur lists belum ada.',
  );
});
