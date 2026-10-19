// Beranda katalog dengan tab Film, Ulasan, Daftar, dan Jurnal.

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_env.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/poster_placeholder.dart';
import '../../diary/presentation/diary_page.dart';
import '../../lists/presentation/lists_page.dart';
import '../../members/presentation/members_page.dart';
import '../../review/presentation/review_page.dart';
import '../domain/movie_models.dart';
import 'catalog_provider.dart';

/// Header hitam dengan judul dan tab, lalu isi tab di bawahnya.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const AppText text = AppStrings.id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          children: [
            _CatalogHeader(),
            Expanded(
              child: TabBarView(
                children: [
                  _FilmsTab(),
                  ReviewsFeed(),
                  ListsPage(embedded: true),
                  DiaryPage(embedded: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogHeader extends StatelessWidget {
  const _CatalogHeader();

  static const AppText text = AppStrings.id;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      color: AppColors.headerBlack,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text.appName,
              style: AppTypography.headlineXl.copyWith(
                fontWeight: FontWeight.w900,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs / 2),
              decoration: BoxDecoration(
                color: AppColors.tabTrack,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: AppColors.tabSelected,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                labelColor: scheme.onSurface,
                unselectedLabelColor: scheme.onSurfaceVariant,
                labelStyle: AppTypography.labelMd,
                unselectedLabelStyle: AppTypography.labelMd,
                splashFactory: NoSplash.splashFactory,
                tabs: [
                  Tab(height: AppSizes.tabHeight, text: text.tabFilms),
                  Tab(height: AppSizes.tabHeight, text: text.tabReviews),
                  Tab(height: AppSizes.tabHeight, text: text.tabLists),
                  Tab(height: AppSizes.tabHeight, text: text.tabJournal),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilmsTab extends ConsumerWidget {
  const _FilmsTab();

  static const AppText text = AppStrings.id;
  static const int _maxPerSection = 9;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<HomeData> home = ref.watch(homeProvider);
    return home.when(
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
        final List<(String, List<Movie>)> sections = [
          (text.sectionFeatured, data.featured),
          (text.sectionLatest, data.latest),
          (text.sectionTopRated, data.topRated),
          (text.sectionMostWatched, data.mostWatched),
          (text.sectionMostWatchlisted, data.mostWatchlisted),
          (text.sectionExplore, data.explore),
        ];
        return ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          children: [
            for (final (String, List<Movie>) section in sections)
              if (section.$2.isNotEmpty)
                _PosterSection(title: section.$1, movies: section.$2),
          ],
        );
      },
    );
  }
}

class _PosterSection extends StatelessWidget {
  const _PosterSection({required this.title, required this.movies});

  final AsyncValue<HomeData> home;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<Movie> shown = movies.take(_FilmsTab._maxPerSection).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.headlineSm.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSizes.gridGap,
          crossAxisSpacing: AppSizes.gridGap,
          childAspectRatio: 2 / 3,
          children: [
            for (int i = 0; i < shown.length; i++)
              _PosterTile(movie: shown[i], seed: i),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _PosterTile extends StatelessWidget {
  const _PosterTile({required this.movie, required this.seed});

  final Movie movie;
  final int seed;

  @override
  Widget build(BuildContext context) {
    final String url = AppEnv.assetUrl(movie.posterUrl);
    final Widget fallback = PosterPlaceholder(title: movie.title, seed: seed);
    return Semantics(
      label: movie.title,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.panelDark),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: url.isEmpty
              ? fallback
              : CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder: (BuildContext context, String url) =>
                      const ColoredBox(color: AppColors.panelDark),
                  errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) =>
                      fallback,
                ),
        ),
      ),
    );
  }
}
