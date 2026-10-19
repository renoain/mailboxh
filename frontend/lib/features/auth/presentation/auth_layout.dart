// Kerangka halaman masuk dan daftar: artwork, logo, form, dan tombol kecil.

import 'package:flutter/material.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/artwork_backdrop.dart';
import '../../../core/widgets/artwork_credit.dart';
import '../../../core/widgets/brand_logo.dart';

/// Menyusun layar auth bergaya artwork penuh dengan form putih.
class AuthLayout extends StatelessWidget {
  const AuthLayout({
    required this.artwork,
    required this.film,
    required this.heading,
    required this.form,
    required this.actions,
    this.error,
    super.key,
  });

  final String artwork;
  final String film;
  final String heading;
  final Widget form;
  final Widget actions;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ArtworkBackdrop(asset: artwork, height: height * 0.7),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.56),
                const BrandLogo(diameter: AppSizes.logoDiameterSmall),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  heading,
                  style: AppTypography.labelLg.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                form,
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      error!,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMd.copyWith(color: scheme.error),
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                actions,
                const SizedBox(height: AppSpacing.md),
                ArtworkCredit(film: film),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close, color: scheme.onSurface),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Barisan tombol kecil di bawah form.
class AuthActions extends StatelessWidget {
  const AuthActions({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: children,
    );
  }
}

/// Tombol kecil huruf kapital: berisi (hijau) atau bergaris.
class AuthSmallButton extends StatelessWidget {
  const AuthSmallButton({
    required this.label,
    required this.onPressed,
    this.filled = false,
    this.loading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool filled;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    const Size size = Size(0, AppSizes.smallButtonHeight + AppSpacing.xs);
    final OutlinedBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.xs),
    );
    final Widget child = loading
        ? const SizedBox(
            width: AppSpacing.md,
            height: AppSpacing.md,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label.toUpperCase());
    if (filled) {
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          minimumSize: size,
          shape: shape,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          textStyle: AppTypography.labelSm,
        ),
        child: child,
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: size,
        shape: shape,
        foregroundColor: scheme.onSurfaceVariant,
        side: BorderSide(color: scheme.outline),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        textStyle: AppTypography.labelSm,
      ),
      child: child,
    );
  }
}
