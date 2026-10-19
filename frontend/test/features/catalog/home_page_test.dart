// Uji render halaman beranda.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mailboxh/core/constants/app_strings.dart';
import 'package:mailboxh/core/theme/app_theme.dart';
import 'package:mailboxh/features/catalog/data/movie_repository.dart';
import 'package:mailboxh/features/catalog/domain/movie_models.dart';
import 'package:mailboxh/features/catalog/presentation/home_page.dart';

import '../../helpers/fakes.dart';

void main() {
  const AppText text = AppStrings.id;

  testWidgets('HomePage menampilkan section dari backend', (
    WidgetTester tester,
  ) async {
    final FakeMovieRepository repository = FakeMovieRepository(
      home: const HomeData(
        featured: <Movie>[],
        latest: <Movie>[
          Movie(id: 1, title: 'Film Pertama'),
        ],
        topRated: <Movie>[],
        mostWatched: <Movie>[],
        mostWatchlisted: <Movie>[],
        explore: <Movie>[],
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [movieRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const HomePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(text.sectionLatest), findsOneWidget);
    expect(find.text('Film Pertama'), findsOneWidget);
  });

  testWidgets('HomePage menampilkan kosong saat katalog tanpa film', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [movieRepositoryProvider.overrideWithValue(FakeMovieRepository())],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const HomePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(text.emptyTitle), findsOneWidget);
    expect(find.text(text.exploreMembers), findsOneWidget);
  });
}
