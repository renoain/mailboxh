// Implementasi repository fitur watchlist.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/watchlist_repository.dart';

final Provider<WatchlistRepository> watchlistRepositoryProvider =
    Provider<WatchlistRepository>((Ref ref) {
  return WatchlistRepositoryImpl(ref.watch(apiClientProvider));
});

class WatchlistRepositoryImpl implements WatchlistRepository {
  const WatchlistRepositoryImpl(this.apiClient);
  final dynamic apiClient;

  @override
  Future<List<Map<String, dynamic>>> getWatchlist() async {
    final response = await apiClient.raw.get<Map<String, dynamic>>('/watchlist');
    final data = response.data?['data'] as List? ?? <dynamic>[];
    return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  @override
  Future<void> remove(int movieId) async {
    await apiClient.raw.delete<Map<String, dynamic>>('/watchlist/$movieId');
  }
}
