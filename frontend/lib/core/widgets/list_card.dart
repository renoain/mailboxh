// Kartu ringkasan satu list kurasi.

import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Menampilkan judul list, deskripsi ringkas, jumlah film, dan privasi.
class ListCard extends StatelessWidget {
  const ListCard({
    required this.title,
    required this.itemCount,
    this.description,
    this.isPublic = true,
    this.onTap,
    super.key,
  });

  final String title;
  final int itemCount;
  final String? description;
  final bool isPublic;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelLg,
                    ),
                  ),
                  Icon(
                    isPublic ? Icons.public : Icons.lock_outline,
                    size: AppSpacing.twoXs,
                    color: scheme.onSurfaceVariant,
                  ),
                ],
              ),
              if (description != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySm
                      .copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              Text(
                '$itemCount',
                style: AppTypography.labelSm.copyWith(color: scheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}