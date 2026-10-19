// Halaman beranda dengan enam section katalog dari backend.

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/movie_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../detail/presentation/movie_detail_page.dart';
import '../../members/presentation/members_page.dart';
import '../../settings/presentation/settings_page.dart';
import '../domain/movie_models.dart';
import 'catalog_provider.dart';
import 'search_page.dart';

/// Menampilkan pencarian, featured, dan lima section film.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const AppText text = AppStrings.id;

  void _openSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchPage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<HomeData> home = ref.watch(homeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(text.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: text.searchHint,
            onPressed: () => _openSearch(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: text.settingsTitle,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: home.when(
        loading: () => const LoadingIndicator(isFullScreen: true),
        error: (Object error, StackTrace stackTrace) => AppErrorState(
          onRetry: () => ref.invalidate(homeProvider),
        ),
        data: (HomeData data) {
          if (data.isEmpty) {
            return EmptyState(
              title: text.emptyTitle,
              message: text.emptyMessage,
              actionLabel: text.exploreMembers,
              onAction: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MembersPage()),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            children: [
              if (data.featured.isNotEmpty) ...[
                SectionHeader(title: text.sectionFeatured),
                _FeaturedList(movies: data.featured),
              ],
              _MovieRow(title: text.sectionLatest, movies: data.latest),
              _MovieRow(title: text.sectionTopRated, movies: data.topRated),
              _MovieRow(
                title: text.sectionMostWatched,
                movies: data.mostWatched,
              ),
              _MovieRow(
                title: text.sectionMostWatchlisted,
                movies: data.mostWatchlisted,
              ),
              _MovieRow(title: text.sectionExplore, movies: data.explore),
            ],
          );
        },
      ),
    );
  }
}

/// Baris poster horizontal dengan judul section dan pesan saat kosong.
class _MovieRow extends StatelessWidget {
  const _MovieRow({required this.title, required this.movies});

  static const AppText text = AppStrings.id;

  final String title;
  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        if (movies.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              text.emptyMessage,
              style: AppTypography.bodySm.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          )
        else
          SizedBox(
            height: AppSpacing.twoXl * 6,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: movies.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: AppSpacing.sm),
              itemBuilder: (BuildContext context, int index) =>
                  _MovieTile(movie: movies[index]),
            ),
          ),
      ],
    );
  }
}

/// Kartu film yang membuka halaman detail saat ditap.
class _MovieTile extends StatelessWidget {
  const _MovieTile({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
            return MovieCard(
              title: movie.title,
              posterPath: movie.posterUrl,
              releaseDate: movie.releaseDate,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailPage(movie: movie),
                ),
              ),
            );
  }
}

/// Banner besar film unggulan admin.
class _FeaturedList extends StatelessWidget {
  const _FeaturedList({required this.movies});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: AppSpacing.twoXl * 5,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: movies.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (BuildContext context, int index) {
          final Movie movie = movies[index];
          return InkWell(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailPage(movie: movie),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: SizedBox(
                width: AppSpacing.twoXl * 6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (movie.backdropUrl != null)
                      CachedNetworkImage(
                        imageUrl: movie.backdropUrl!,
                        fit: BoxFit.cover,
                        placeholder: (BuildContext context, String url) =>
                            Container(color: scheme.surfaceContainerHighest),
                        errorBuilder:
                            (BuildContext context, Object error,
                                    StackTrace? stackTrace) =>
                                Container(color: scheme.surfaceContainerHighest),
                      )
                    else
                      Container(color: scheme.surfaceContainerHighest),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        color: scheme.surface.withValues(alpha: 0.75),
                        child: Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.headlineSm.copyWith(
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
