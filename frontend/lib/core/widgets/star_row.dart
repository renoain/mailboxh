// Deretan bintang hijau dengan dukungan setengah bintang.

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Menampilkan rating baca-saja dalam kelipatan 0,5 dari nol sampai lima.
class StarRow extends StatelessWidget {
  const StarRow({required this.rating, this.size = 14, super.key});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(5, (int index) {
        final double remaining = rating - index;
        if (remaining >= 1) {
          return Icon(Icons.star, size: size, color: AppColors.brandGreen);
        }
        if (remaining >= 0.5) {
          return Icon(Icons.star_half, size: size, color: AppColors.brandGreen);
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
