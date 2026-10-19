// Uji render halaman profil.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mailboxh/core/constants/app_strings.dart';
import 'package:mailboxh/core/theme/app_theme.dart';
import 'package:mailboxh/features/profile/data/profile_repository.dart';
import 'package:mailboxh/features/profile/domain/profile_models.dart';
import 'package:mailboxh/features/profile/domain/profile_repository.dart';
import 'package:mailboxh/features/profile/presentation/profile_page.dart';

/// Repository palsu yang mengembalikan data profil siap pakai.
class FakeProfileRepository implements ProfileRepository {
  const FakeProfileRepository();

  @override
  Future<UserProfile> getProfile() async => const UserProfile(
        id: 1,
        name: 'Budi Santoso',
        email: 'budi@mailboxh.id',
        role: 'user',
      );

  @override
  Future<UserStats> getUserStats() async => const UserStats(
        totalWatched: 120,
        totalWatchlist: 35,
        totalDiary: 110,
        totalReviews: 90,
        averageRating: 3.8,
        totalLikes: 45,
        totalLists: 8,
        totalFollowers: 15,
        totalFollowing: 10,
        thisYearCount: 24,
      );

  @override
  Future<ProfileStats> getStats() => getUserStats();

  @override
  Future<List<Movie>> getUserFilms() async => const <Movie>[];

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

  testWidgets('ProfilePage menampilkan profil tanpa error saat data dimuat',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 600));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileRepositoryProvider.overrideWithValue(
            const FakeProfileRepository(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const ProfilePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('120'), findsOneWidget);
    expect(find.text('24'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
    expect(find.text(text.favoriteFilms), findsOneWidget);
    expect(find.text(text.editProfile), findsOneWidget);
  });
}
