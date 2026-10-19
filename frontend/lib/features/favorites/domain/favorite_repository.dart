import '../../profile/domain/profile_models.dart';

/// Kontrak akses data untuk fitur favorites.
abstract class FavoriteRepository {
  const FavoriteRepository();

  /// Mengambil daftar 4 film favorit user.
  Future<List<FavoriteFilm>> getFavorites();

  /// Memperbarui daftar 4 film favorit user.
  Future<List<FavoriteFilm>> updateFavorites(List<Map<String, dynamic>> items);
}
