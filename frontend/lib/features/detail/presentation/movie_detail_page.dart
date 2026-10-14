// Halaman detail.

import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Halaman [MovieDetailPage].
class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key});

  static const AppText text = AppStrings.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(text.detailTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Center(
          child: Text(
            text.detailTitle,
            style: AppTypography.headlineSm,
          ),
        ),
      ),
    );
  }
}
