// Kotak poster pengganti untuk data contoh tanpa gambar.

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Poster bergradasi dengan judul opsional di bagian bawah.
class PosterPlaceholder extends StatelessWidget {
  const PosterPlaceholder({
    this.title,
    this.seed = 0,
    this.width,
    this.height,
    this.radius = AppRadius.sm,
    super.key,
  });

  final String? title;
  final int seed;
  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final Color tint = AppColors.posterTints[seed % AppColors.posterTints.length];
    return Container(
      width: width,
      height: height,
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.panelDark),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [tint, AppColors.bgDark],
        ),
      ),
      child: title == null
          ? null
          : Text(
              title!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSm.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
    );
  }
}
