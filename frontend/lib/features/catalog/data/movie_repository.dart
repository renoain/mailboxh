// Implementasi repository fitur catalog.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/movie_repository.dart';

/// Menyediakan [MovieRepository] lewat container Riverpod.
final Provider<MovieRepository> movieRepositoryProvider =
    Provider<MovieRepository>((Ref ref) {
  ref.watch(apiClientProvider);
  throw UnimplementedError(
    'Endpoint fitur catalog belum ada.',
  );
});
