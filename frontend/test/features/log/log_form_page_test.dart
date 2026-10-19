// Uji render dan pengiriman form log tontonan.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mailboxh/core/constants/app_strings.dart';
import 'package:mailboxh/core/theme/app_theme.dart';
import 'package:mailboxh/features/catalog/domain/movie_models.dart';
import 'package:mailboxh/features/log/data/log_repository.dart';
import 'package:mailboxh/features/log/presentation/log_form_page.dart';
import 'package:mailboxh/features/tags/data/tag_repository.dart';

import '../../helpers/fakes.dart';
import '../../helpers/test_locale.dart';

void main() {
  const AppText text = AppStrings.id;
  const Movie movie = Movie(id: 7, title: 'Film Uji');

  setUpAll(initializeTestLocale);

  Future<void> pumpForm(
    WidgetTester tester, {
    required FakeLogRepository logRepository,
    FakeTagRepository? tagRepository,
  }) async {
    await tester.binding.setSurfaceSize(const Size(1000, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          logRepositoryProvider.overrideWithValue(logRepository),
          tagRepositoryProvider
              .overrideWithValue(tagRepository ?? FakeTagRepository()),
        ],
        child: MaterialApp(theme: AppTheme.dark, home: const Scaffold()),
      ),
    );
    tester.state<NavigatorState>(find.byType(Navigator)).push(
          MaterialPageRoute<void>(
            builder: (_) => const LogFormPage(movie: movie),
          ),
        );
    await tester.pumpAndSettle();
  }

  testWidgets('LogFormPage menampilkan film dan formulir', (
    WidgetTester tester,
  ) async {
    await pumpForm(tester, logRepository: FakeLogRepository());

    expect(find.text('Film Uji'), findsOneWidget);
    expect(find.text(text.logDateLabel), findsOneWidget);
    expect(find.text(text.logRatingLabel), findsOneWidget);
    expect(find.text(text.logTagsLabel), findsOneWidget);
  });

  testWidgets('LogFormPage mengirim draft saat simpan ditekan', (
    WidgetTester tester,
  ) async {
    final FakeLogRepository repository = FakeLogRepository();
    await pumpForm(tester, logRepository: repository);

    await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, text.save));
    await tester.pumpAndSettle();

    expect(repository.lastDraft, isNotNull);
    expect(repository.lastDraft!.movieId, 7);
    expect(repository.lastDraft!.rating, 1);
  });
}
