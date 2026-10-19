// Uji render halaman splash.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mailboxh/core/constants/app_strings.dart';
import 'package:mailboxh/core/services/app_providers.dart';
import 'package:mailboxh/core/theme/app_theme.dart';
import 'package:mailboxh/features/onboarding/presentation/onboarding_page.dart';
import 'package:mailboxh/features/splash/presentation/splash_page.dart';

import '../../helpers/fakes.dart';

void main() {
  const AppText text = AppStrings.id;

  Future<void> pumpSplash(
    WidgetTester tester, {
    required FakeTokenStorage storage,
    required FakeOnboardingStorage onboarding,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tokenStorageProvider.overrideWithValue(storage),
          onboardingStorageProvider.overrideWithValue(onboarding),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const SplashPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SplashPage menampilkan menu saat onboarding sudah selesai', (
    WidgetTester tester,
  ) async {
    await pumpSplash(
      tester,
      storage: FakeTokenStorage(),
      onboarding: FakeOnboardingStorage()..seen = true,
    );

    expect(find.text(text.appName), findsOneWidget);
    expect(find.text(text.loginTitle), findsOneWidget);
    expect(find.text(text.registerTitle), findsOneWidget);
    expect(find.text(text.artworkCredit), findsOneWidget);
  });

  testWidgets('SplashPage mengarahkan ke Onboarding pada pemakaian pertama', (
    WidgetTester tester,
  ) async {
    await pumpSplash(
      tester,
      storage: FakeTokenStorage(),
      onboarding: FakeOnboardingStorage()..seen = false,
    );

    expect(find.byType(OnboardingPage), findsOneWidget);
    expect(find.text(text.nextButton), findsOneWidget);
  });
}
