// Halaman log.

import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Halaman [LogFormPage].
class LogFormPage extends StatelessWidget {
  const LogFormPage({super.key});

  static const AppText text = AppStrings.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(text.logTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Center(
          child: Text(
            text.logTitle,
            style: AppTypography.headlineSm,
          ),
        ),
      ),
    );
  }
}
