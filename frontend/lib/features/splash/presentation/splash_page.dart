// Halaman pembuka yang memulihkan sesi dari token tersimpan.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/app_providers.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/brand_logo.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../catalog/presentation/main_navigation.dart';
import '../../onboarding/presentation/onboarding_page.dart';
import 'welcome_view.dart';

/// Menampilkan logo sambil memeriksa sesi, lalu mengarahkan rute.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  static const AppText text = AppStrings.id;

  bool _sessionChecked = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_restoreSession);
  }

  Future<void> _restoreSession() async {
    bool signedIn = false;
    try {
      signedIn = await ref.read(authProvider.future) != null;
    } catch (_) {
      // Sesi gagal dipulihkan, misalnya tanpa jaringan; tampilkan menu.
    }
    if (!mounted) return;
    if (signedIn) {
      final user = await ref.read(authProvider.future);
      if (!mounted) return;
      if (user != null && user.isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AdminLayout(child: const AdminDashboardPage()),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      }
      return;
    }
    final bool seenOnboarding =
        await ref.read(onboardingStorageProvider).hasSeen();
    if (!mounted) return;
    if (!seenOnboarding) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingPage()),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }

  void _open(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    if (!_sessionChecked) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BrandLogo(),
              SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: AppSizes.avatar,
                height: AppSizes.avatar,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      body: WelcomeView(
        onSignIn: () => _open(const LoginPage()),
        onCreateAccount: () => _open(const RegisterPage()),
        onOpenTour: () => _open(const OnboardingPage()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int index) {
          if (index != 0) _open(const LoginPage());
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.manage_accounts),
            label: text.navProfile,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.video_library_outlined),
            label: text.navFilms,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: text.navSearch,
          ),
        ],
      ),
    );
  }
}
