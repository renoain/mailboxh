// Halaman onboarding pertama kali aplikasi dibuka.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/router/app_router.dart';
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppStrings.of(Localizations.localeOf(context).languageCode);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text.onboardingTitle,
                style: AppTypography.headlineLg,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: text.loginTitle,
                onPressed: () => context.pushNamed(AppRoutes.login),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: text.registerTitle,
                variant: AppButtonVariant.secondary,
                onPressed: () => context.pushNamed(AppRoutes.register),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
