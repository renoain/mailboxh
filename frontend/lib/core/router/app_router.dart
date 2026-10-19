// Daftar route aplikasi dan penjaga route privat.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/admin/presentation/admin_layout.dart';
import '../../features/admin/presentation/pages/admin_batch_import_page.dart';
import '../../features/admin/presentation/pages/admin_genres_page.dart';
import '../../features/admin/presentation/pages/admin_movie_form_page.dart';
import '../../features/admin/presentation/pages/admin_movies_page.dart';
import '../../features/admin/presentation/pages/admin_reviews_page.dart';
import '../../features/admin/presentation/pages/admin_users_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/catalog/presentation/home_page.dart';
import '../../features/catalog/presentation/search_page.dart';
import '../../features/diary/presentation/diary_page.dart';
import '../../features/feed/presentation/feed_page.dart';
import '../../features/favorites/presentation/favorites_edit_page.dart';
import '../../features/follow/presentation/followers_page.dart';
import '../../features/follow/presentation/following_page.dart';
import '../../features/incoming/presentation/incoming_page.dart';
import '../../features/lists/presentation/list_detail_page.dart';
import '../../features/lists/presentation/list_form_page.dart';
import '../../features/lists/presentation/lists_page.dart';
import '../../features/log/presentation/log_form_page.dart';
import '../../features/members/presentation/members_page.dart';
import '../../features/members/presentation/member_profile_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/review/presentation/review_form_page.dart';
import '../../features/review/presentation/review_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../../features/watchlist/presentation/watchlist_page.dart';
import '../../features/watched/presentation/watched_page.dart';
import '../../core/services/token_storage.dart';

/// Nama path sebagai konstanta supaya tidak ada string path di widget.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static const String search = '/search';

  static const String detail = '/movie/:tmdbId';
  static const String review = '/review/:tmdbId';
  static const String reviewForm = '/review/form';
  static const String log = '/log';

  static const String watched = '/watched';
  static const String diary = '/diary';
  static const String tags = '/tags';

  static const String lists = '/lists';
  static const String listDetail = '/lists/:listId';
  static const String listNew = '/lists/new';
  static const String listEdit = '/lists/:listId/edit';

  static const String favoritesEdit = '/favorites/edit';

  static const String feed = '/feed';
  static const String incoming = '/activity/incoming';
  static const String members = '/members';

  static const String profile = '/profile';
  static const String publicProfile = '/user/:userId';
  static const String followers = '/followers';
  static const String following = '/following';
  static const String settings = '/settings';

  static const String watchlist = '/watchlist';

  // Rute admin
  static const String admin = '/admin';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminMovies = '/admin/movies';
  static const String adminMovieForm = '/admin/movies/form';
  static const String adminGenres = '/admin/genres';
  static const String adminUsers = '/admin/users';
  static const String adminReviews = '/admin/reviews';
  static const String adminBatchImport = '/admin/batch-import';

  static const List<String> publicPages = [
    splash,
    onboarding,
    login,
    register,
  ];

  static const List<String> authPages = [
    onboarding,
    login,
    register,
  ];
}

/// Membangun [GoRouter] aplikasi. Route privat dijaga di sini, bukan
/// dengan pemeriksaan token di dalam `build`.
GoRouter buildRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (BuildContext context, GoRouterState state) async {
      final hasToken = await TokenStorage().hasToken();
      final isAuthPage = AppRoutes.authPages.contains(state.matchedLocation);
      final isPublicPage = AppRoutes.publicPages.contains(state.matchedLocation);

      if (hasToken && isAuthPage) {
        return AppRoutes.home;
      }

      if (!hasToken && !isPublicPage) {
        return AppRoutes.login;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (BuildContext context, GoRouterState state) =>
            const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (BuildContext context, GoRouterState state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (BuildContext context, GoRouterState state) =>
            const SearchPage(),
      ),
      GoRoute(
        path: AppRoutes.watchlist,
        builder: (BuildContext context, GoRouterState state) =>
            const WatchlistPage(),
      ),
      GoRoute(
        path: AppRoutes.watched,
        builder: (BuildContext context, GoRouterState state) =>
            const WatchedPage(),
      ),
      GoRoute(
        path: AppRoutes.diary,
        builder: (BuildContext context, GoRouterState state) =>
            const DiaryPage(),
      ),
      GoRoute(
        path: AppRoutes.lists,
        builder: (BuildContext context, GoRouterState state) =>
            const ListsPage(),
      ),
      GoRoute(
        path: AppRoutes.listDetail,
        builder: (BuildContext context, GoRouterState state) =>
            const ListDetailPage(),
      ),
      GoRoute(
        path: AppRoutes.listNew,
        builder: (BuildContext context, GoRouterState state) =>
            const ListFormPage(),
      ),
      GoRoute(
        path: AppRoutes.listEdit,
        builder: (BuildContext context, GoRouterState state) =>
            const ListFormPage(),
      ),
      GoRoute(
        path: AppRoutes.favoritesEdit,
        builder: (BuildContext context, GoRouterState state) =>
            const FavoritesEditPage(),
      ),
      GoRoute(
        path: AppRoutes.feed,
        builder: (BuildContext context, GoRouterState state) =>
            const FeedPage(),
      ),
      GoRoute(
        path: AppRoutes.incoming,
        builder: (BuildContext context, GoRouterState state) =>
            const IncomingPage(),
      ),
      GoRoute(
        path: AppRoutes.members,
        builder: (BuildContext context, GoRouterState state) =>
            const MembersPage(),
      ),
      GoRoute(
        path: AppRoutes.publicProfile,
        builder: (BuildContext context, GoRouterState state) {
          final userId = state.pathParameters['userId'] ?? '';
          return MemberProfilePage(memberName: userId);
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (BuildContext context, GoRouterState state) =>
            const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.followers,
        builder: (BuildContext context, GoRouterState state) =>
            const FollowersPage(),
      ),
      GoRoute(
        path: AppRoutes.following,
        builder: (BuildContext context, GoRouterState state) =>
            const FollowingPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.review,
        builder: (BuildContext context, GoRouterState state) =>
            const ReviewPage(),
      ),
      GoRoute(
        path: AppRoutes.reviewForm,
        builder: (BuildContext context, GoRouterState state) =>
            const ReviewFormPage(),
      ),
      GoRoute(
        path: AppRoutes.log,
        builder: (BuildContext context, GoRouterState state) =>
            const LogFormPage(),
      ),

      // Rute admin dilindungi oleh AdminLayout dengan pengecekan role admin.
      GoRoute(
        path: AppRoutes.adminDashboard,
        builder: (BuildContext context, GoRouterState state) =>
            AdminLayout(child: const AdminDashboardPage()),
      ),
      GoRoute(
        path: AppRoutes.adminMovies,
        builder: (BuildContext context, GoRouterState state) =>
            AdminLayout(child: const AdminMoviesPage()),
      ),
      GoRoute(
        path: AppRoutes.adminMovieForm,
        builder: (BuildContext context, GoRouterState state) =>
            AdminLayout(child: const AdminMovieFormPage()),
      ),
      GoRoute(
        path: AppRoutes.adminGenres,
        builder: (BuildContext context, GoRouterState state) =>
            AdminLayout(child: const AdminGenresPage()),
      ),
      GoRoute(
        path: AppRoutes.adminUsers,
        builder: (BuildContext context, GoRouterState state) =>
            AdminLayout(child: const AdminUsersPage()),
      ),
      GoRoute(
        path: AppRoutes.adminReviews,
        builder: (BuildContext context, GoRouterState state) =>
            AdminLayout(child: const AdminReviewsPage()),
      ),
      GoRoute(
        path: AppRoutes.adminBatchImport,
        builder: (BuildContext context, GoRouterState state) =>
            AdminLayout(child: const AdminBatchImportPage()),
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) => Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(state.error.toString())),
    ),
  );
}
