// Halaman diary.

import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Halaman [DiaryPage].
class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  static const AppText text = AppStrings.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(text.diaryTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Center(
          child: Text(
            text.diaryTitle,
            style: AppTypography.headlineSm,
          ),
        ),
      ),
    );
  }
}
