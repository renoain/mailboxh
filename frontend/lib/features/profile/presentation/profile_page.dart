// Halaman profil user ala Letterboxd.

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
import '../../auth/domain/auth_models.dart';
import '../../auth/presentation/auth_provider.dart';
import '../domain/profile_models.dart';
import 'profile_provider.dart';

/// Halaman profil pengguna yang sedang login.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  static const AppText text = AppStrings.id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AuthUser?> authAsync = ref.watch(authProvider);

    if (authAsync.value == null) {
      return _buildGuestProfile(context);
    }

    final AsyncValue<UserProfile> profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.letterboxdBg,
        body: Center(child: LoadingIndicator(message: 'Memuat profil')),
      ),
      error: (Object error, StackTrace stackTrace) => Scaffold(
        backgroundColor: AppColors.letterboxdBg,
        body: Center(
          child: AppErrorState(
            message: error.toString(),
            onRetry: () => ref.read(profileProvider.notifier).reload(),
          ),
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
          length: 4,
          child: Scaffold(
            backgroundColor: AppColors.letterboxdBg,
            appBar: AppBar(
              backgroundColor: AppColors.letterboxdBg,
              title: Text(
                profile.name,
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  color: AppColors.textPrimaryDark,
                  onPressed: () {},
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                TabBar(
                  labelColor: AppColors.textPrimaryDark,
                  unselectedLabelColor: AppColors.textSecondaryDark,
                  indicatorColor: AppColors.primaryDark,
                  tabs: const <Tab>[
                    Tab(text: 'Profile'),
                    Tab(text: 'Diary'),
                    Tab(text: 'Lists'),
                    Tab(text: 'Watchlist'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      _ProfileTab(profile: profile, stats: stats, ref: ref),
                      _EmptyTab(message: text.diaryEmpty),
                      _EmptyTab(message: text.profileListsEmpty),
                      _EmptyTab(message: text.watchlistEmpty),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGuestProfile(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.letterboxdBg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.movie_filter_outlined,
                size: AppSpacing.fourXl,
                color: AppColors.textSecondaryDark,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                text.guestProfileMessage,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: <Widget>[
                  Expanded(
                    child: FilledButton(
                      onPressed: () => context.go('/register'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                      ),
                      child: Text(text.createAccount),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go('/login'),
                      child: Text(text.signIn),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTab extends ConsumerWidget {
  const _ProfileTab({
    required this.profile,
    required this.stats,
    required this.ref,
  });

  final UserProfile profile;
  final UserStats stats;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Movie>> filmsAsync = ref.watch(userFilmsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.surfaceDimDark,
              child: Text(
                profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
                style: AppTypography.headlineMd.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'RECENT ACTIVITY',
            style: AppTypography.labelLg.copyWith(
              color: AppColors.textSecondaryDark,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          filmsAsync.when(
            loading: () => const LoadingIndicator(),
            error: (Object error, StackTrace stackTrace) => const SizedBox.shrink(),
            data: (List<Movie> films) {
              if (films.isEmpty) {
                return const SizedBox.shrink();
              }
              return SizedBox(
                height: AppSpacing.twoXl * 5,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: films.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (BuildContext context, int index) {
                    final Movie movie = films[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: AspectRatio(
                        aspectRatio: 2 / 3,
                        child: movie.posterUrl != null
                            ? CachedNetworkImage(
                                imageUrl: AppEnv.assetUrl(movie.posterUrl),
                                fit: BoxFit.cover,
                              )
                            : Container(color: AppColors.surfaceDimDark),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'RATINGS',
            style: AppTypography.labelLg.copyWith(
              color: AppColors.textSecondaryDark,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildStarGraph(stats.averageRating),
          const SizedBox(height: AppSpacing.lg),
          _buildMenu(context, stats),
        ],
      ),
    );
  }

  Widget _buildStarGraph(double rating) {
    final int filled = rating.round().clamp(0, 5);
    return Row(
      children: List<Widget>.generate(5, (int index) {
        return Icon(
          index < filled ? Icons.star : Icons.star_border,
          color: AppColors.primaryDark,
          size: AppSpacing.lg,
        );
      }),
    );
  }

  Widget _buildMenu(BuildContext context, UserStats stats) {
    final List<MapEntry<String, int>> items = <MapEntry<String, int>>[
      MapEntry<String, int>('Films', stats.totalWatched),
      MapEntry<String, int>('Diary', stats.totalDiary),
      MapEntry<String, int>('Reviews', stats.totalReviews),
      MapEntry<String, int>('Watchlist', stats.totalWatchlist),
      MapEntry<String, int>('Lists', stats.totalLists),
      MapEntry<String, int>('Likes', stats.totalLikes),
      MapEntry<String, int>('Tags', 0),
      MapEntry<String, int>('Following', stats.totalFollowing),
      MapEntry<String, int>('Followers', stats.totalFollowers),
    ];

    return Column(
      children: items.map((MapEntry<String, int> item) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            item.key,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
          trailing: Text(
            '${item.value}',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
        );
      }).toList(),
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
