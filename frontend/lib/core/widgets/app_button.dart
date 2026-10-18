// Tombol aksi dengan tiga varian sesuai DESIGN_SYSTEM.md bagian 7.

import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Varian tombol yang dipakai di seluruh aplikasi.
enum AppButtonVariant { primary, secondary, plain }

/// Tombol aksi utama dan sekunder dengan ukuran sentuh minimum 48.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    switch (variant) {
      case AppButtonVariant.primary:
        return FilledButton(
          onPressed: isDisabled ? null : onPressed,
          child: _content(),
        );
      case AppButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          child: _content(),
        );
      case AppButtonVariant.plain:
        return TextButton(
          onPressed: isDisabled ? null : onPressed,
          child: _content(),
        );
    }
  }

  Widget _content() {
    if (isLoading) {
      return const SizedBox.square(
        dimension: AppSpacing.md + AppSpacing.xs,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    if (icon == null) return Text(label, style: AppTypography.labelLg);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSpacing.md + AppSpacing.xs),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: AppTypography.labelLg),
      ],
    );
  }
}