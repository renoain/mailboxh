// Implementasi repository fitur favorites.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/favorite_repository.dart';

/// Menyediakan [FavoriteRepository] lewat container Riverpod.
final Provider<FavoriteRepository> favoriteRepositoryProvider =
    Provider<FavoriteRepository>((Ref ref) {
  ref.watch(apiClientProvider);
  throw UnimplementedError(
    'Endpoint fitur favorites belum ada.',
  );
});
