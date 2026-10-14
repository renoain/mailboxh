// Kartu poster film untuk grid dan carousel.

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_env.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Menampilkan poster, judul, dan tahun rilis satu film.
class MovieCard extends StatelessWidget {
  const MovieCard({
    required this.title,
    required this.posterPath,
    this.releaseDate,
    this.onTap,
    this.width = AppSpacing.twoXl * 3,
    super.key,
  });

  final String title;
  final String? posterPath;
  final DateTime? releaseDate;
  final VoidCallback? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: _poster(scheme),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelMd,
            ),
            Text(
              _year,
              style: AppTypography.bodySm.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  String get _year => releaseDate?.year.toString() ?? '';

  Widget _poster(ColorScheme scheme) {
    final String url = AppEnv.assetUrl(posterPath);
    if (url.isEmpty) return _fallback(scheme);

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (BuildContext context, String url) =>
          Container(color: scheme.surfaceContainerHighest),
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) =>
          _fallback(scheme),
    );
  }

  Widget _fallback(ColorScheme scheme) {
    return Container(
      color: scheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(Icons.movie_outlined, color: scheme.onSurfaceVariant),
    );
  }
}