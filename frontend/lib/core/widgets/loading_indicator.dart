// Indikator memuat dengan pesan opsional.

import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// State loading yang seragam untuk setiap halaman.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({this.message, this.isFullScreen = false, super.key});

  static const AppText text = AppStrings.id;

  final String? message;
  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
    final Widget indicator = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(strokeWidth: 2),
        if (message != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(message!, style: AppTypography.bodyMd),
        ],
      ],
    );

    if (!isFullScreen) return indicator;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: indicator,
      ),
    );
  }
}