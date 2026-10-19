// Komponen form untuk halaman masuk dan daftar di atas panel putih.

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Kolom isian dengan garis bawah tipis di atas latar putih.
class AuthField extends StatelessWidget {
  const AuthField({
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.fieldWhite,
      child: Column(
        children: [
          TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onSubmitted: onSubmitted,
            cursorColor: AppColors.primaryDark,
            style: AppTypography.bodyLg.copyWith(color: AppColors.fieldText),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  AppTypography.bodyLg.copyWith(color: AppColors.fieldHint),
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.twoXs,
              ),
            ),
          ),
          Container(
            height: AppSizes.hairline,
            color: AppColors.fieldHint.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}

/// Baris persetujuan dengan penanda lingkaran di sisi kanan.
class AuthConsentRow extends StatelessWidget {
  const AuthConsentRow({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        color: AppColors.fieldWhite,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.twoXs,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodySm.copyWith(color: AppColors.navBar),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Semantics(
              checked: value,
              child: Container(
                width: AppSizes.radioCircle,
                height: AppSizes.radioCircle,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value ? AppColors.primaryDark : null,
                  border: Border.all(color: AppColors.fieldHint),
                ),
                child: value
                    ? const Icon(
                        Icons.check,
                        size: AppSpacing.md,
                        color: AppColors.fieldWhite,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
