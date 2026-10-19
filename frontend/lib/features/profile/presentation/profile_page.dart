// Halaman profil user dengan header, statistik, four favourites, dan tab navigasi.

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_env.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../favorites/presentation/favorite_provider.dart';
import '../domain/profile_models.dart';
import 'profile_provider.dart';

/// Halaman profil pengguna yang sedang login.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  static const AppText text = AppStrings.id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserProfile> profileAsync = ref.watch(profileProvider);
    final AsyncValue<List<FavoriteFilm>> favoritesAsync =
        ref.watch(favoritesProvider);
    final AsyncValue<List<Movie>> filmsAsync = ref.watch(userFilmsProvider);

    return Scaffold(
      backgroundColor: AppColors.letterboxdBg,
      appBar: AppBar(
        backgroundColor: AppColors.letterboxdBg,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            color: AppColors.textPrimaryDark,
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(
          child: LoadingIndicator(message: 'Memuat profil'),
        ),
        error: (Object error, StackTrace stackTrace) => Center(
          child: AppErrorState(
            message: error.toString(),
            onRetry: () => ref.read(profileProvider.notifier).reload(),
          ),
        ),
        data: (UserProfile profile) {
          final UserStats stats = profile.stats ??
              const UserStats(
                totalWatched: 0,
                totalWatchlist: 0,
                totalReviews: 0,
              );

          return DefaultTabController(
            length: 5,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileHeader(context, profile),
                          const SizedBox(height: AppSpacing.lg),
                          _buildStatsRow(stats),
                          const SizedBox(height: AppSpacing.lg),
                          _buildFourFavourites(context, favoritesAsync),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _ProfileTabBarDelegate(
                      tabBar: TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelColor: AppColors.primaryDark,
                        unselectedLabelColor: AppColors.textSecondaryDark,
                        indicatorColor: AppColors.primaryDark,
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: [
                          Tab(text: text.tabFilms),
                          Tab(text: text.tabReviews),
                          Tab(text: text.tabDiary),
                          Tab(text: text.tabWatchlist),
                          Tab(text: text.tabLists),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  _buildFilmsTab(context, ref, filmsAsync),
                  _buildEmptyTab(context, text.noReview, Icons.rate_review_outlined),
                  _buildEmptyTab(context, text.diaryEmpty, Icons.calendar_today_outlined),
                  _buildEmptyTab(context, text.watchlistEmpty, Icons.bookmark_border_outlined),
                  _buildEmptyTab(context, text.profileListsEmpty, Icons.list_alt_outlined),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Header profil: avatar 72px, nama, username, tombol edit profile.
  Widget _buildProfileHeader(BuildContext context, UserProfile profile) {
    final String initial =
        profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?';
    final String usernameText = profile.username.isNotEmpty
        ? profile.username
        : profile.name.toLowerCase().replaceAll(' ', '');

    return Row(
      children: [
        SizedBox(
          width: 72,
          height: 72,
          child: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: AppEnv.assetUrl(profile.avatarUrl),
                    fit: BoxFit.cover,
                    placeholder: (BuildContext context, String url) =>
                        Container(color: AppColors.surfaceDimDark),
                    errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) =>
                        CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.surfaceDimDark,
                      child: Text(
                        initial,
                        style: AppTypography.headlineMd.copyWith(
                          color: AppColors.textPrimaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.surfaceDimDark,
                  child: Text(
                    initial,
                    style: AppTypography.headlineMd.copyWith(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name,
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '@$usernameText',
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: () => context.push('/settings'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.outlineLight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                ),
                child: Text(
                  text.editProfile,
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Statistik 3 kolom: X Films, Y This Year, Z Lists.
  Widget _buildStatsRow(UserStats stats) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              '${stats.totalWatched}',
              text.statFilms,
            ),
          ),
          Container(
            width: 1,
            height: AppSpacing.xl,
            color: AppColors.surfaceDimDark,
          ),
          Expanded(
            child: _buildStatItem(
              '${stats.thisYearCount}',
              text.statThisYear,
            ),
          ),
          Container(
            width: 1,
            height: AppSpacing.xl,
            color: AppColors.surfaceDimDark,
          ),
          Expanded(
            child: _buildStatItem(
              '${stats.totalLists}',
              text.statLists,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: AppTypography.headlineSm.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryDark,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.labelSm.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
      ],
    );
  }

  /// Four Favourites (4 slot poster menempel rapat gap 6px).
  Widget _buildFourFavourites(
    BuildContext context,
    AsyncValue<List<FavoriteFilm>> favoritesAsync,
  ) {
    final List<FavoriteFilm> favorites =
        favoritesAsync.value ?? const <FavoriteFilm>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text.favoriteFilms,
              style: AppTypography.labelLg.copyWith(
                color: AppColors.textSecondaryDark,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                size: AppSpacing.md + AppSpacing.xs,
                color: AppColors.textSecondaryDark,
              ),
              onPressed: () => context.push('/favorites/edit'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            for (int pos = 1; pos <= 4; pos++) ...[
              if (pos > 1) const SizedBox(width: AppSpacing.posterGap),
              Expanded(
                child: _buildFavouriteSlot(context, favorites, pos),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildFavouriteSlot(
    BuildContext context,
    List<FavoriteFilm> favorites,
    int position,
  ) {
    FavoriteFilm? film;
    for (final FavoriteFilm item in favorites) {
      if (item.position == position) {
        film = item;
        break;
      }
    }

    return AspectRatio(
      aspectRatio: 2 / 3,
      child: Material(
        color: AppColors.surfaceDimDark,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: InkWell(
          onTap: () => context.push('/favorites/edit'),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: film != null && film.movie.posterUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: CachedNetworkImage(
                    imageUrl: AppEnv.assetUrl(film.movie.posterUrl),
                    fit: BoxFit.cover,
                    placeholder: (BuildContext context, String url) =>
                        Container(color: AppColors.surfaceDimDark),
                    errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) =>
                        const Center(
                      child: Icon(
                        Icons.movie_outlined,
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: Icon(
                    Icons.add,
                    color: AppColors.textSecondaryDark,
                    size: AppSpacing.lg,
                  ),
                ),
        ),
      ),
    );
  }

  /// Tab FILMS: GridView 4 kolom poster film watched.
  Widget _buildFilmsTab(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Movie>> filmsAsync,
  ) {
    return filmsAsync.when(
      loading: () => const Center(
        child: LoadingIndicator(message: 'Memuat film'),
      ),
      error: (Object error, StackTrace stackTrace) => Center(
        child: AppErrorState(
          message: error.toString(),
          onRetry: () => ref.refresh(userFilmsProvider),
        ),
      ),
      data: (List<Movie> films) {
        if (films.isEmpty) {
          return Center(
            child: EmptyState(
              icon: Icons.movie_outlined,
              message: text.watchedEmpty,
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: films.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 2 / 3,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
          ),
          itemBuilder: (BuildContext context, int index) {
            final Movie movie = films[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: CachedNetworkImage(
                imageUrl: AppEnv.assetUrl(movie.posterUrl),
                fit: BoxFit.cover,
                placeholder: (BuildContext context, String url) =>
                    Container(color: AppColors.surfaceDimDark),
                errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) =>
                    Container(
                  color: AppColors.surfaceDimDark,
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  alignment: Alignment.center,
                  child: Text(
                    movie.title,
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Tampilan kosong untuk tab-tab lainnya.
  Widget _buildEmptyTab(BuildContext context, String message, IconData icon) {
    return Center(
      child: EmptyState(
        icon: icon,
        message: message,
      ),
    );
  }
}

/// Persistent header delegate untuk TabBar profil.
class _ProfileTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _ProfileTabBarDelegate({required this.tabBar});

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.letterboxdBg,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _ProfileTabBarDelegate oldDelegate) {
    return oldDelegate.tabBar != tabBar;
  }
}
