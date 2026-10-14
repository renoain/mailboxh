// Halaman review.

import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Halaman [ReviewFormPage].
class ReviewFormPage extends StatelessWidget {
  const ReviewFormPage({super.key});

  static const AppText text = AppStrings.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(text.reviewTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Center(
          child: Text(
            text.reviewTitle,
            style: AppTypography.headlineSm,
          ),
        ),
      ),
    );
  }
}
