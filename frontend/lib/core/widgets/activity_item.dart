// Satu baris aktivitas untuk Feed, Incoming Activity, dan Home.

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_env.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Jenis aktivitas yang disimpan di tabel `activities`.
enum ActivityType { watched, rated, reviewed, liked, listCreated, followed }

/// Menampilkan pelaku, kalimat aktivitas, film terkait, dan jam relatif.
class ActivityItem extends StatelessWidget {
  const ActivityItem({
    required this.actorName,
    required this.activityLabel,
    required this.relativeTime,
    this.filmTitle,
    this.posterPath,
    this.onTap,
    super.key,
  });

  final String actorName;
  final String activityLabel;
  final String relativeTime;
  final String? filmTitle;
  final String? posterPath;
  final VoidCallback? onTap;

  static const double posterWidth = AppSpacing.xl;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: actorName,
                          style: AppTypography.labelMd,
                        ),
                        TextSpan(text: ' $activityLabel'),
                        if (filmTitle != null)
                          TextSpan(
                            text: ' $filmTitle',
                            style: AppTypography.labelMd,
                          ),
                      ],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    relativeTime,
                    style: AppTypography.bodySm
                        .copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            if (posterPath != null) ...[
              const SizedBox(width: AppSpacing.sm),
              _poster(scheme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _poster(ColorScheme scheme) {
    final String url = AppEnv.assetUrl(posterPath);
    if (url.isEmpty) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: SizedBox(
        width: posterWidth,
        height: posterWidth * 1.5,
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (BuildContext context, String url) =>
              Container(color: scheme.surfaceContainerHighest),
          errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
          ) =>
              Container(color: scheme.surfaceContainerHighest),
        ),
      ),
    );
  }
}