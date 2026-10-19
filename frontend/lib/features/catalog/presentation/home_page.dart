// Halaman beranda ala Letterboxd dengan tab dan grid poster.

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_env.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../domain/movie_models.dart';
import 'catalog_provider.dart';

/// Halaman beranda dengan tab Films, Reviews, Lists, Journal.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const AppText text = AppStrings.id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<HomeData> home = ref.watch(homeProvider);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.letterboxdBg,
        appBar: AppBar(
          backgroundColor: AppColors.letterboxdBg,
          title: Text(
            text.appName,
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
        ),
        body: Column(
          children: [
            TabBar(
              labelColor: AppColors.textPrimaryDark,
              unselectedLabelColor: AppColors.textSecondaryDark,
              indicatorColor: AppColors.primaryDark,
              tabs: const <Tab>[
                Tab(text: 'Films'),
                Tab(text: 'Reviews'),
                Tab(text: 'Lists'),
                Tab(text: 'Journal'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _FilmsTab(home: home, ref: ref),
                  _EmptyTab(message: text.emptyMessage),
                  _EmptyTab(message: text.emptyMessage),
                  _EmptyTab(message: text.emptyMessage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilmsTab extends StatelessWidget {
  const _FilmsTab({required this.home, required this.ref});

  final AsyncValue<HomeData> home;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return home.when(
      loading: () => const LoadingIndicator(isFullScreen: true),
      error: (Object error, StackTrace stackTrace) => AppErrorState(
        onRetry: () => ref.invalidate(homeProvider),
      ),
      data: (HomeData data) {
        final List<Movie> movies = <Movie>[
          ...data.featured,
          ...data.latest,
          ...data.topRated,
          ...data.mostWatched,
          ...data.mostWatchlisted,
          ...data.explore,
        ];
        if (movies.isEmpty) {
          return EmptyState(
            title: HomePage.text.emptyTitle,
            message: HomePage.text.emptyMessage,
            actionLabel: HomePage.text.exploreMembers,
            onAction: () {},
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: <Widget>[
                  Text(
                    'Popular this week',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  const Icon(
                    Icons.arrow_forward,
                    color: AppColors.textPrimaryDark,
                    size: AppSpacing.md + AppSpacing.xs,
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: movies.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisSpacing: AppSpacing.sm,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final Movie movie = movies[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: movie.posterUrl != null
                        ? CachedNetworkImage(
                            imageUrl: AppEnv.assetUrl(movie.posterUrl),
                            fit: BoxFit.cover,
                            placeholder: (BuildContext context, String url) =>
                                Container(color: AppColors.surfaceDimDark),
                            errorBuilder: (BuildContext context, Object error,
                                    StackTrace? stackTrace) =>
                                Container(color: AppColors.surfaceDimDark),
                          )
                        : Container(color: AppColors.surfaceDimDark),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyTab extends StatelessWidget {
  const _EmptyTab({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
