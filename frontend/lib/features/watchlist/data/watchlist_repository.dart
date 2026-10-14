// Implementasi repository fitur watchlist.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/watchlist_repository.dart';

/// Menyediakan [WatchlistRepository] lewat container Riverpod.
final Provider<WatchlistRepository> watchlistRepositoryProvider =
    Provider<WatchlistRepository>((Ref ref) {
  ref.watch(apiClientProvider);
  throw UnimplementedError(
    'Endpoint fitur watchlist belum ada.',
  );
});
