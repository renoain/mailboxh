// Kontrak repository fitur watchlist.

abstract class WatchlistRepository {
  const WatchlistRepository();

  Future<List<Map<String, dynamic>>> getWatchlist();
  Future<void> remove(int movieId);
}
