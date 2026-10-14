// Tampilan error dengan aksi coba lagi.

import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// State error yang seragam untuk setiap halaman.
class AppErrorState extends StatelessWidget {
  const AppErrorState({this.message, this.onRetry, super.key});

  static const AppText text = AppStrings.id;

  /// Pesan dari server. Null memakai pesan bawaan dari AppStrings.
  final String? message;

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: AppSpacing.twoXl, color: scheme.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              text.errorTitle,
              style: AppTypography.headlineSm,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message ?? text.errorMessage,
              style: AppTypography.bodyMd.copyWith(color: scheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton(
                onPressed: onRetry,
                child: Text(text.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}