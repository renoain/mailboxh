// Tampilan kosong dengan judul, pesan, dan aksi opsional.

import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// State kosong yang seragam untuk setiap halaman.
class EmptyState extends StatelessWidget {
  const EmptyState({
    this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.inbox_outlined,
    super.key,
  });

  static const AppText text = AppStrings.id;

  final String? title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSpacing.twoXl, color: scheme.onSurfaceVariant),
            const SizedBox(height: AppSpacing.md),
            Text(
              title ?? text.emptyTitle,
              style: AppTypography.headlineSm,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message ?? text.emptyMessage,
              style: AppTypography.bodyMd.copyWith(color: scheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}