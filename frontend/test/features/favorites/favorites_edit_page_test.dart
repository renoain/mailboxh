// Uji render halaman edit favorites.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mailboxh/core/constants/app_strings.dart';
import 'package:mailboxh/core/theme/app_theme.dart';
import 'package:mailboxh/features/favorites/data/favorite_repository.dart';
import 'package:mailboxh/features/favorites/domain/favorite_repository.dart';
import 'package:mailboxh/features/favorites/presentation/favorites_edit_page.dart';
import 'package:mailboxh/features/profile/data/profile_repository.dart';
import 'package:mailboxh/features/profile/domain/profile_models.dart';
import 'package:mailboxh/features/profile/domain/profile_repository.dart';

class FakeFavoriteRepository implements FavoriteRepository {
  const FakeFavoriteRepository();

  @override
  Future<List<FavoriteFilm>> getFavorites() async => const <FavoriteFilm>[
        FavoriteFilm(
          position: 1,
          movie: Movie(id: 1, title: 'Inception'),
        ),
      ];

  @override
  Future<List<FavoriteFilm>> updateFavorites(
          List<Map<String, dynamic>> items) async =>
      const <FavoriteFilm>[];
}

class FakeProfileRepoForFavorites implements ProfileRepository {
  const FakeProfileRepoForFavorites();

  @override
  Future<UserProfile> getProfile() async => const UserProfile(
        id: 1,
        name: 'Budi',
        email: 'budi@mailboxh.id',
      );

  @override
  Future<UserStats> getUserStats() async => const UserStats(
        totalWatched: 10,
        totalWatchlist: 5,
        totalReviews: 2,
      );

  @override
  Future<ProfileStats> getStats() => getUserStats();

  @override
  Future<List<Movie>> getUserFilms() async => const <Movie>[
        Movie(id: 1, title: 'Inception'),
        Movie(id: 2, title: 'Interstellar'),
      ];

  @override
  Future<List<FavoriteFilm>> getFavorites() async => const <FavoriteFilm>[];

  @override
  Future<List<FavoriteFilm>> getFavoriteFilms() => getFavorites();

  @override
  Future<List<Movie>> getWatchlistMovies() async => const <Movie>[];

  @override
  Future<List<DiaryEntry>> getDiaryEntries() async => const <DiaryEntry>[];

  @override
  Future<List<ReviewItem>> getRecentReviews() async => const <ReviewItem>[];

  @override
  Future<List<UserList>> getUserLists() async => const <UserList>[];

  @override
  Future<List<UserBrief>> getFollowing() async => const <UserBrief>[];

  @override
  Future<List<UserBrief>> getFollowers() async => const <UserBrief>[];

  @override
  Future<List<Tag>> getTags() async => const <Tag>[];
}

void main() {
  const AppText text = AppStrings.id;

  testWidgets('FavoritesEditPage menampilkan 4 slot dan judul',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 600));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          favoriteRepositoryProvider.overrideWithValue(
            const FakeFavoriteRepository(),
          ),
          profileRepositoryProvider.overrideWithValue(
            const FakeProfileRepoForFavorites(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const FavoritesEditPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(text.favoritesEditTitle), findsOneWidget);
    expect(find.text(text.save), findsOneWidget);
    expect(find.text('Inception'), findsOneWidget);
    expect(find.text('${text.slotEmptyLabel} 2'), findsOneWidget);
  });
}
