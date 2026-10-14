// Tombol hati untuk like film, terpisah dari rating bintang.

import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Menampilkan keadaan like dan jumlah suka pada satu film.
class LikeButton extends StatelessWidget {
  const LikeButton({
    required this.isLiked,
    required this.likeCount,
    required this.onToggle,
    super.key,
  });

  static const AppText text = AppStrings.id;

  final bool isLiked;
  final int likeCount;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color activeColor = scheme.primary;
    final Color idleColor = scheme.onSurfaceVariant;

    return Semantics(
      button: true,
      label: '${text.likes} $likeCount',
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSpacing.touchTarget),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: AppSpacing.md + AppSpacing.sm,
                color: isLiked ? activeColor : idleColor,
              ),
              const SizedBox(width: AppSpacing.xs + AppSpacing.xs),
              Text(
                '$likeCount',
                style: AppTypography.labelMd.copyWith(
                  color: isLiked ? activeColor : idleColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}