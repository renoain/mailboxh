// Tampilan sambutan dengan artwork, logo, dan menu masuk.

import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/artwork_backdrop.dart';
import '../../../core/widgets/artwork_credit.dart';
import '../../../core/widgets/brand_logo.dart';

/// Layar sambutan yang dipakai di splash dan di halaman terakhir tur.
class WelcomeView extends StatelessWidget {
  const WelcomeView({
    required this.onSignIn,
    required this.onCreateAccount,
    required this.onOpenTour,
    super.key,
  });

  static const AppText text = AppStrings.id;

  final VoidCallback onSignIn;
  final VoidCallback onCreateAccount;
  final VoidCallback onOpenTour;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final double height = MediaQuery.sizeOf(context).height;
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ArtworkBackdrop(
                asset: AppAssets.artworkWelcome,
                height: height * 0.52,
              ),
            ),
            Column(
              children: [
                SizedBox(height: height * 0.42),
                const BrandLogo(),
                const SizedBox(height: AppSpacing.md),
                Text(
                  text.appName,
                  style: AppTypography.headlineXl.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _MenuRow(label: text.loginTitle, onTap: onSignIn),
                _MenuRow(label: text.registerTitle, onTap: onCreateAccount),
                _MenuRow(label: text.tourOpen, onTap: onOpenTour),
                SizedBox(height: height * 0.1),
                const ArtworkCredit(film: AppStrings.artworkCreditFilm),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final BorderSide line = BorderSide(
      color: scheme.outlineVariant,
      width: AppSizes.hairline,
    );
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.twoXs,
        ),
        decoration: BoxDecoration(border: Border(top: line, bottom: line)),
        child: Text(
          label,
          style: AppTypography.bodyLg.copyWith(color: scheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
