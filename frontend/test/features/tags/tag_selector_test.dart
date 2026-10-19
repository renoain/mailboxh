// Uji perilaku pemilih tag.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mailboxh/core/theme/app_theme.dart';
import 'package:mailboxh/features/tags/data/tag_repository.dart';
import 'package:mailboxh/features/tags/domain/tag_models.dart';
import 'package:mailboxh/features/tags/presentation/widgets/tag_selector.dart';

import '../../helpers/fakes.dart';

void main() {
  Future<void> pumpSelector(
    WidgetTester tester,
    FakeTagRepository repository,
    ValueChanged<List<String>> onChanged,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [tagRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: Scaffold(
            body: TagSelector(
              label: 'Tag',
              selected: const <String>[],
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('TagSelector memilih tag dari saran', (
    WidgetTester tester,
  ) async {
    final FakeTagRepository repository = FakeTagRepository(
      tags: <Tag>[const Tag(id: 1, name: 'klasik')],
    );
    List<String> selected = <String>[];

    await pumpSelector(
      tester,
      repository,
      (List<String> value) => selected = value,
    );
    await tester.tap(find.text('klasik'));
    await tester.pump();

    expect(selected, contains('klasik'));
  });

  testWidgets('TagSelector membuat tag baru dari input', (
    WidgetTester tester,
  ) async {
    final FakeTagRepository repository = FakeTagRepository();
    List<String> selected = <String>[];

    await pumpSelector(
      tester,
      repository,
      (List<String> value) => selected = value,
    );
    await tester.enterText(find.byType(TextField), 'baru');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(selected, contains('baru'));
    expect(repository.created, contains('baru'));
  });
}
