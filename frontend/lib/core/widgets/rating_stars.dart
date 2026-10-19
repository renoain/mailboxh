// Bintang rating 1 sampai 5 dalam mode baca dan mode input.

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Menampilkan atau menerima rating 1 sampai 5 bintang.
class RatingStars extends StatelessWidget {
  const RatingStars({
    this.value = 0,
    this.onChanged,
    this.size = AppSpacing.twoXl,
    super.key,
  });

  /// Nilai 0 sampai 5. Nol berarti belum ada rating.
  final int value;

  /// Null berarti mode baca. Isi untuk mode input.
  final ValueChanged<int>? onChanged;

  final double size;

  @override
  Widget build(BuildContext context) {
    final bool isReadOnly = onChanged == null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (int index) {
        final int star = index + 1;
        final bool isFilled = star <= value;
        return Semantics(
          label: '$star dari 5',
          button: !isReadOnly,
          child: InkWell(
            onTap: isReadOnly ? null : () => onChanged!(star),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Icon(
                isFilled ? Icons.star : Icons.star_border,
                size: size,
                color: isFilled
                    ? AppColors.brandGreen
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }),
    );
  }
}