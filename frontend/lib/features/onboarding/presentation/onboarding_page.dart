// Halaman onboarding.

import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Halaman [OnboardingPage].
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static const AppText text = AppStrings.id;

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
