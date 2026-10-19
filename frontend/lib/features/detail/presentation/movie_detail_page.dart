// Halaman detail film asli dengan aksi log dan review.

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_env.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/tag_chip.dart';
import '../../catalog/domain/movie_models.dart';
import '../../log/presentation/log_form_page.dart';
import '../../review/presentation/review_form_page.dart';

/// Detail film dengan tombol menuju form log dan form review.
class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({required this.movie, super.key});

  static const AppText text = AppStrings.id;

  final Movie movie;

  void _openLog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LogFormPage(movie: movie)),
    );
  }

  void _openReview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ReviewFormPage(movie: movie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String backdrop = AppEnv.assetUrl(
      movie.backdropUrl ?? movie.posterUrl,
    );

    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: backdrop.isEmpty
                ? Container(color: scheme.surfaceContainerHighest)
                : CachedNetworkImage(
                    imageUrl: backdrop,
                    fit: BoxFit.cover,
                    placeholder: (BuildContext context, String url) =>
                        Container(color: scheme.surfaceContainerHighest),
                    errorBuilder: (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) => Container(color: scheme.surfaceContainerHighest),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(movie.title, style: AppTypography.headlineLg),
                if (_meta.isNotEmpty) ...<Widget>[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _meta,
                    style: AppTypography.bodySm.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (movie.genres.isNotEmpty) ...<Widget>[
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: <Widget>[
                      for (final Genre genre in movie.genres)
                        TagChip(label: genre.name),
                    ],
                  ),
                ],
                if (movie.overview != null) ...<Widget>[
                  const SizedBox(height: AppSpacing.md),
                  Text(movie.overview!, style: AppTypography.bodyLg),
                ],
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _openLog(context),
                        icon: const Icon(Icons.playlist_add_check),
                        label: Text(text.logTitle),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _openReview(context),
                        icon: const Icon(Icons.rate_review_outlined),
                        label: Text(text.reviewTitle),
                      ),
                    ),
],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Watchlist action (pending)')),
                    );
                  },
                  icon: const Icon(Icons.add_to_queue),
                  label: Text('Watchlist'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Watched action (pending)')),
                    );
                  },
                  icon: const Icon(Icons.fiber_new),
                  label: Text('Watched'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String get _meta {
    final List<String> parts = <String>[];
    if (movie.releaseDate != null) {
      parts.add(movie.releaseDate!.year.toString());
    }
    if (movie.runtime != null) parts.add('${movie.runtime} min');
    return parts.join(' - ');
  }
}
