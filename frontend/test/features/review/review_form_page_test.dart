// Uji render dan pengiriman form review.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mailboxh/core/constants/app_strings.dart';
import 'package:mailboxh/core/theme/app_theme.dart';
import 'package:mailboxh/features/catalog/domain/movie_models.dart';
import 'package:mailboxh/features/review/data/review_repository.dart';
import 'package:mailboxh/features/review/presentation/review_form_page.dart';

import '../../helpers/fakes.dart';

void main() {
  const AppText text = AppStrings.id;
  const Movie movie = Movie(id: 9, title: 'Film Review');

  Future<void> pumpForm(
    WidgetTester tester,
    FakeReviewRepository repository,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [reviewRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(theme: AppTheme.dark, home: const Scaffold()),
      ),
    );
    tester
        .state<NavigatorState>(find.byType(Navigator))
        .push(
          MaterialPageRoute<void>(
            builder: (_) => const ReviewFormPage(movie: movie),
          ),
        );
    await tester.pumpAndSettle();
  }

  testWidgets('ReviewFormPage meminta rating sebelum mengirim', (
    WidgetTester tester,
  ) async {
    final FakeReviewRepository repository = FakeReviewRepository();
    await pumpForm(tester, repository);

    final Finder saveButton = find.widgetWithText(FilledButton, text.save);
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text(text.reviewRatingRequired), findsOneWidget);
    expect(repository.lastRating, isNull);
  });

  testWidgets('ReviewFormPage mengirim review dengan rating', (
    WidgetTester tester,
  ) async {
    final FakeReviewRepository repository = FakeReviewRepository();
    await pumpForm(tester, repository);

    await tester.tap(find.byIcon(Icons.star_border).at(2));
    await tester.pump();
    final Finder saveButton = find.widgetWithText(FilledButton, text.save);
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(repository.lastRating, 3);
  });
}
