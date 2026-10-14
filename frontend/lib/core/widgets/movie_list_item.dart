// Baris film dengan poster kecil untuk daftar dan hasil pencarian.

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_env.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Menampilkan poster kecil, judul, tahun, dan subjudul opsional.
class MovieListItem extends StatelessWidget {
  const MovieListItem({
    required this.title,
    required this.posterPath,
    this.releaseDate,
    this.subtitle,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;
  final String? posterPath;
  final DateTime? releaseDate;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  static const double posterWidth = AppSpacing.xl + AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.sm,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: SizedBox(
                width: posterWidth,
                height: posterWidth * 1.5,
                child: _poster(scheme),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelMd,
                  ),
                  if (releaseDate != null)
                    Text(
                      releaseDate!.year.toString(),
                      style: AppTypography.bodySm
                          .copyWith(color: scheme.onSurfaceVariant),
                    ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySm
                          .copyWith(color: scheme.onSurfaceVariant),
                    ),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }

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