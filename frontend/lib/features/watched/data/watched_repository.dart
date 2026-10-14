// Implementasi repository fitur watched.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/watched_repository.dart';

/// Menyediakan [WatchedRepository] lewat container Riverpod.
final Provider<WatchedRepository> watchedRepositoryProvider =
    Provider<WatchedRepository>((Ref ref) {
  ref.watch(apiClientProvider);
  throw UnimplementedError(
    'Endpoint fitur watched belum ada.',
  );
});
