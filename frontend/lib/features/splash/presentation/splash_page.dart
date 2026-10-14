// Halaman splash untuk memeriksa sesi sebelum mengarahkan route.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/app_providers.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/loading_indicator.dart';

/// Menampilkan logo lalu mengarahkan ke onboarding, login, atau home.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  static const AppText text = AppStrings.id;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirect());
  }

  Future<void> _redirect() async {
    final bool hasToken = await ref.read(sessionProvider.future);
    if (!mounted) return;
    context.go(hasToken ? '/home' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text.appName, style: AppTypography.headlineXl),
            const SizedBox(height: AppSpacing.lg),
            Text(
              text.loading,
              style: AppTypography.bodyMd,
            ),
            const SizedBox(height: AppSpacing.md),
            const LoadingIndicator(),
          ],
        ),
      ),
    );
  }
}