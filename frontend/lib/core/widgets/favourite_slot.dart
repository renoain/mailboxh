// Satu slot four favourites yang bisa terisi atau kosong.

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_env.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Menampilkan satu dari empat posisi four favourites.
class FavouriteSlot extends StatelessWidget {
  const FavouriteSlot({
    required this.position,
    this.title,
    this.posterPath,
    this.isEditable = false,
    this.onReplace,
    this.onRemove,
    super.key,
  });

  /// Posisi 1 sampai 4.
  final int position;

  final String? title;
  final String? posterPath;
  final bool isEditable;
  final VoidCallback? onReplace;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool isFilled = title != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: isFilled ? _poster(scheme) : _placeholder(scheme),
              ),
            ),
            Positioned(
              top: AppSpacing.xs,
              left: AppSpacing.xs,
              child: _badge(scheme),
            ),
            if (isEditable && isFilled)
              Positioned(
                top: AppSpacing.xs,
                right: AppSpacing.xs,
                child: IconButton(
                  onPressed: onRemove,
                  iconSize: AppSpacing.md + AppSpacing.xs,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: AppSpacing.threeXs,
          child: Text(
            title ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelMd,
          ),
        ),
        if (isEditable)
          TextButton(
            onPressed: onReplace,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              textStyle: AppTypography.labelSm,
            ),
            child: Text('$position'),
          ),
      ],
    );
  }

  Widget _badge(ColorScheme scheme) {
    return Builder(
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.twoXs,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: scheme.primary,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          '$position',
          style: AppTypography.labelSm.copyWith(color: scheme.onPrimary),
        ),
      ),
    );
  }

  Widget _placeholder(ColorScheme scheme) {
    return Container(
      color: scheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.add,
        color: scheme.onSurfaceVariant,
        size: AppSpacing.twoXl,
      ),
    );
  }

  Widget _poster(ColorScheme scheme) {
    final String url = AppEnv.assetUrl(posterPath);
    if (url.isEmpty) return _placeholder(scheme);
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (BuildContext context, String url) =>
          Container(color: scheme.surfaceContainerHighest),
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) =>
          _placeholder(scheme),
    );
  }
}