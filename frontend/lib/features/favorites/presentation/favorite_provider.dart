// State fitur favorites menggunakan AsyncNotifier Riverpod.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../profile/domain/profile_models.dart';
import '../data/favorite_repository.dart';
import '../domain/favorite_repository.dart';

/// Kelola state 4 film favorit (Four Favourites).
class FavoritesNotifier extends AsyncNotifier<List<FavoriteFilm>> {
  @override
  Future<List<FavoriteFilm>> build() async {
    final FavoriteRepository repository = ref.read(favoriteRepositoryProvider);
    return repository.getFavorites();
  }

  /// Memperbarui daftar 4 film favorit ke backend.
  Future<void> updateFavorites(List<Map<String, dynamic>> items) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final FavoriteRepository repository = ref.read(favoriteRepositoryProvider);
      return repository.updateFavorites(items);
    });
  }

  /// Memuat ulang data film favorit.
  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final FavoriteRepository repository = ref.read(favoriteRepositoryProvider);
      return repository.getFavorites();
    });
  }
}

/// Provider utama untuk Four Favourites.
final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, List<FavoriteFilm>>(
  FavoritesNotifier.new,
);

/// Alias kompatibilitas bila diperlukan.
final favoriteProvider = favoritesProvider;
