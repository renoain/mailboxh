// Uji render halaman diary.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mailboxh/core/constants/app_strings.dart';
import 'package:mailboxh/core/theme/app_theme.dart';
import 'package:mailboxh/features/catalog/domain/movie_models.dart';
import 'package:mailboxh/features/diary/data/diary_repository.dart';
import 'package:mailboxh/features/diary/domain/diary_models.dart';
import 'package:mailboxh/features/diary/presentation/diary_page.dart';

import '../../helpers/fakes.dart';
import '../../helpers/test_locale.dart';

void main() {
  const AppText text = AppStrings.id;

  setUpAll(initializeTestLocale);

  Future<void> pumpPage(
    WidgetTester tester,
    FakeDiaryRepository repository,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [diaryRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(theme: AppTheme.dark, home: const DiaryPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('DiaryPage menampilkan entri per tanggal', (
    WidgetTester tester,
  ) async {
    final FakeDiaryRepository repository = FakeDiaryRepository(
      days: <DiaryDay>[
        DiaryDay(
          date: DateTime(2024, 5, 1),
          entries: <DiaryEntry>[
            DiaryEntry(
              id: 1,
              movie: const Movie(id: 1, title: 'Film Diary'),
              watchedDate: DateTime(2024, 5, 1),
              note: 'Catatan singkat',
              rating: 4,
            ),
          ],
        ),
      ],
    );

    await pumpPage(tester, repository);

    expect(find.text('Film Diary'), findsOneWidget);
    expect(find.text('Catatan singkat'), findsOneWidget);
  });

  testWidgets('DiaryPage menampilkan kosong tanpa entri', (
    WidgetTester tester,
  ) async {
    await pumpPage(tester, FakeDiaryRepository());

    expect(find.text(text.diaryEmpty), findsOneWidget);
  });
}
