// Daftar route aplikasi dan penjaga route privat.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/catalog/presentation/home_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/splash/presentation/splash_page.dart';

/// Nama path sebagai konstanta supaya tidak ada string path di widget.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static const String detail = '/movie/:tmdbId';
  static const String review = '/review/:tmdbId';
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
}

/// Membangun [GoRouter] aplikasi. Route privat dijaga di sini, bukan
/// dengan pemeriksaan token di dalam `build`.
GoRouter buildRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
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
    ],
    errorBuilder: (BuildContext context, GoRouterState state) => Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(state.error.toString())),
    ),
  );
}