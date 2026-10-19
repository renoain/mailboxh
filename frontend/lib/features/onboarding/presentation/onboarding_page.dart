// Halaman onboarding dengan penanda pemakaian pertama.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/app_providers.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Halaman pengantar yang menandai onboarding selesai lalu ke Login.
class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  static const AppText text = AppStrings.id;

  Future<void> _complete(BuildContext context, WidgetRef ref) async {
    await ref.read(onboardingStorageProvider).markSeen();
    if (!context.mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(text.onboardingTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Center(
          child: Text(
            text.onboardingTitle,
            style: AppTypography.headlineSm,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: FilledButton(
          onPressed: () => _complete(context, ref),
          child: Text(text.nextButton),
        ),
      ),
    );
  }
}
