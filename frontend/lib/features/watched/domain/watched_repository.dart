// Kontrak repository fitur watched.

abstract class WatchedRepository {
  const WatchedRepository();
  Future<List<Map<String, dynamic>>> getWatched();
}
