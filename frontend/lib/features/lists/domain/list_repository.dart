// Kontrak repository fitur lists.

/// Kontrak akses data untuk fitur lists.
abstract class ListRepository {
  const ListRepository();

  Future<List<Map<String, dynamic>>> getLists();

  Future<Map<String, dynamic>> getListDetail(int id);

  Future<void> createList(String title, String? description);

  Future<void> addMovieToList(int listId, int movieId);

  Future<void> deleteList(int id);
}
