// Uji render halaman pencarian.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mailboxh/core/constants/app_strings.dart';
import 'package:mailboxh/core/theme/app_theme.dart';
import 'package:mailboxh/features/catalog/data/movie_repository.dart';
import 'package:mailboxh/features/catalog/presentation/search_page.dart';

import '../../helpers/fakes.dart';

void main() {
  const AppText text = AppStrings.id;

  testWidgets('SearchPage menampilkan pesan sebelum ada query', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [movieRepositoryProvider.overrideWithValue(FakeMovieRepository())],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const SearchPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(text.searchHint), findsWidgets);
    expect(find.text(text.sectionLatest), findsOneWidget);
    expect(find.text(text.sortRating), findsOneWidget);
  });
}
