// Halaman feed.

import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Halaman [FeedPage].
class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  static const AppText text = AppStrings.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(text.feedTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Center(
          child: Text(
            text.feedTitle,
            style: AppTypography.headlineSm,
          ),
        ),
      ),
    );
  }
}
