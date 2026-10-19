// Daftar route aplikasi dan penjaga route privat.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/pages/admin_batch_import_page.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/admin/presentation/pages/admin_genres_page.dart';
import '../../features/admin/presentation/pages/admin_movie_form_page.dart';
import '../../features/admin/presentation/pages/admin_movies_page.dart';
import '../../features/admin/presentation/pages/admin_reviews_page.dart';
import '../../features/admin/presentation/pages/admin_users_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/catalog/presentation/home_page.dart';
import '../../features/catalog/presentation/search_page.dart';
import '../../features/detail/presentation/movie_detail_page.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../services/app_providers.dart';

/// Nama path sebagai konstanta supaya tidak ada string path di widget.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String search = '/search';

  static const String detail = '/movie/:tmdbId';

  static const String watched = '/watched';
  static const String diary = '/diary';
  static const String lists = '/lists';

  static const String profile = '/profile';
  static const String settings = '/settings';

  // Route admin
  static const String adminDashboard = '/admin/dashboard';
  static const String adminMovies = '/admin/movies';
  static const String adminMovieForm = '/admin/movies/form';
  static const String adminMovieEdit = '/admin/movies/:movieId/edit';
  static const String adminUsers = '/admin/users';
  static const String adminReviews = '/admin/reviews';
  static const String adminGenres = '/admin/genres';
  static const String adminBatchImport = '/admin/batch-import';
}

/// Membangun [GoRouter] aplikasi. Route privat dan admin dijaga di sini,
/// bukan dengan pemeriksaan token di dalam `build`.
GoRouter buildRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (BuildContext context, GoRouterState state) async {
      final session = context.read(sessionProvider);
      final sessionData = session.valueOrNull;
      final hasToken = sessionData?.hasToken ?? false;
      final isAdmin = sessionData?.isAdmin ?? false;
      final isSplash = state.matchedLocation == AppRoutes.splash;

      if (isSplash) {
        if (session.isLoading) return null;
        return hasToken ? AppRoutes.home : AppRoutes.login;
      }

      // Guard route admin: hanya admin yang boleh mengakses.
      final isAdminRoute = state.matchedLocation.startsWith('/admin');
      if (isAdminRoute && (!hasToken || !isAdmin)) {
        return AppRoutes.login;
      }

      final loggingIn = state.matchedLocation == AppRoutes.login;
      final registering = state.matchedLocation == AppRoutes.register;

      if (!hasToken && !loggingIn && !registering && !isSplash) {
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
        path: AppRoutes.detail,
        builder: (BuildContext context, GoRouterState state) {
          final tmdbId = int.tryParse(state.pathParameters['tmdbId'] ?? '') ?? 0;
          return MovieDetailPage(tmdbId: tmdbId);
        },
      ),
      // Route admin
      GoRoute(
        path: AppRoutes.adminDashboard,
        builder: (BuildContext context, GoRouterState state) =>
            const AdminDashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.adminMovies,
        builder: (BuildContext context, GoRouterState state) =>
            const AdminMoviesPage(),
      ),
      GoRoute(
        path: AppRoutes.adminMovieForm,
        builder: (BuildContext context, GoRouterState state) =>
            const AdminMovieFormPage(),
      ),
      GoRoute(
        path: AppRoutes.adminMovieEdit,
        builder: (BuildContext context, GoRouterState state) {
          final movieId = int.tryParse(
            state.pathParameters['movieId'] ?? '',
          ) ?? 0;
          return AdminMovieFormPage(movieId: movieId);
        },
      ),
      GoRoute(
        path: AppRoutes.adminUsers,
        builder: (BuildContext context, GoRouterState state) =>
            const AdminUsersPage(),
      ),
      GoRoute(
        path: AppRoutes.adminReviews,
        builder: (BuildContext context, GoRouterState state) =>
            const AdminReviewsPage(),
      ),
      GoRoute(
        path: AppRoutes.adminGenres,
        builder: (BuildContext context, GoRouterState state) =>
            const AdminGenresPage(),
      ),
      GoRoute(
        path: AppRoutes.adminBatchImport,
        builder: (BuildContext context, GoRouterState state) =>
            const AdminBatchImportPage(),
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) => Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(state.error.toString())),
    ),
  );
}
