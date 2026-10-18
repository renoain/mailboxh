// Uji render halaman pengaturan.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mailboxh/core/constants/app_strings.dart';
import 'package:mailboxh/features/settings/presentation/settings_page.dart';

void main() {
  const AppText text = AppStrings.id;

  testWidgets('SettingsPage menampilkan teks dari AppStrings', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

    expect(find.text(text.settingsTitle), findsOneWidget);
    expect(find.text(text.darkMode), findsOneWidget);
    expect(find.text(text.privacyPolicy), findsOneWidget);
  });
}
