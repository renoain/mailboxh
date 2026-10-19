// Halaman pembuka yang memulihkan sesi dari token tersimpan.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/app_providers.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../auth/presentation/login_page.dart';
import '../../auth/presentation/register_page.dart';
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
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
    setState(() => _sessionChecked = true);
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
                  if (!_sessionChecked) ...[
                    CircularProgressIndicator(color: colors.primary),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        ),
                        child: Text(text.loginTitle),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterPage(),
                          ),
                        ),
                        child: Text(text.registerTitle),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      text.artworkCredit,
                      style: AppTypography.bodySm.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
