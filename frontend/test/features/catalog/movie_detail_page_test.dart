// Uji render dan navigasi halaman detail film.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mailboxh/core/constants/app_strings.dart';
import 'package:mailboxh/core/theme/app_theme.dart';
import 'package:mailboxh/features/catalog/domain/movie_models.dart';
import 'package:mailboxh/features/detail/presentation/movie_detail_page.dart';
import 'package:mailboxh/features/log/data/log_repository.dart';
import 'package:mailboxh/features/log/presentation/log_form_page.dart';
import 'package:mailboxh/features/tags/data/tag_repository.dart';

import '../../helpers/fakes.dart';
import '../../helpers/test_locale.dart';

void main() {
  const AppText text = AppStrings.id;
  const Movie movie = Movie(id: 3, title: 'Film Detail');

  setUpAll(initializeTestLocale);

  testWidgets('MovieDetailPage menampilkan judul dan aksi', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1000, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const MovieDetailPage(movie: movie),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Film Detail'), findsWidgets);
    expect(find.text(text.logTitle), findsOneWidget);
    expect(find.text(text.reviewTitle), findsOneWidget);
  });

  testWidgets('MovieDetailPage membuka form log', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          logRepositoryProvider.overrideWithValue(FakeLogRepository()),
          tagRepositoryProvider.overrideWithValue(FakeTagRepository()),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const MovieDetailPage(movie: movie),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, text.logTitle));
    await tester.pumpAndSettle();

    expect(find.byType(LogFormPage), findsOneWidget);
  });
}
