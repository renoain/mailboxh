// Uji render untuk widget global.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mailboxh/core/constants/app_strings.dart';
import 'package:mailboxh/core/theme/app_theme.dart';
import 'package:mailboxh/core/widgets/app_button.dart';
import 'package:mailboxh/core/widgets/empty_state.dart';
import 'package:mailboxh/core/widgets/movie_list_item.dart';
import 'package:mailboxh/core/widgets/rating_stars.dart';
import 'package:mailboxh/core/widgets/tag_chip.dart';

Widget wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: child),
  );
}

void main() {
  const AppText text = AppStrings.id;

  testWidgets('AppButton merender label dan menerima tap', (
    WidgetTester tester,
  ) async {
    bool tapped = false;

    await tester.pumpWidget(
      wrap(
        AppButton(label: text.save, onPressed: () => tapped = true),
      ),
    );

    expect(find.text(text.save), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    expect(tapped, isTrue);
  });

  testWidgets('EmptyState menampilkan judul, pesan, dan aksi', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        EmptyState(
          title: text.emptyTitle,
          message: text.emptyMessage,
          actionLabel: text.retry,
          onAction: () {},
        ),
      ),
    );

    expect(find.text(text.emptyTitle), findsOneWidget);
    expect(find.text(text.emptyMessage), findsOneWidget);
    expect(find.text(text.retry), findsOneWidget);
  });

  testWidgets('RatingStars mode baca tidak bisa diubah', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(const RatingStars(value: 3)));

    expect(find.byIcon(Icons.star), findsNWidgets(3));
    expect(find.byIcon(Icons.star_border), findsNWidgets(2));
  });

  testWidgets('MovieListItem merender judul tanpa poster', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const MovieListItem(title: 'Judul Film', posterPath: null),
      ),
    );

    expect(find.text('Judul Film'), findsOneWidget);
  });

  testWidgets('TagChip menampilkan nama tag', (WidgetTester tester) async {
    await tester.pumpWidget(wrap(const TagChip(label: 'rewatch')));

    expect(find.text('rewatch'), findsOneWidget);
  });
}