// Halaman pembuka yang memulihkan sesi dari token tersimpan.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/app_providers.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../admin/presentation/admin_layout.dart';
import '../../admin/presentation/pages/admin_dashboard_page.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../catalog/presentation/main_navigation.dart';
import '../../onboarding/presentation/onboarding_page.dart';

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

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSpacing.fourXl * 6),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  Icon(Icons.mail_outline, size: AppSpacing.fourXl * 2,
                      color: colors.primary),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    text.appName,
                    style: AppTypography.headlineXl.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                  const Spacer(flex: 3),
                  CircularProgressIndicator(color: colors.primary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
