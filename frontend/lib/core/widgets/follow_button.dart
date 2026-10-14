// Tombol Ikuti dan Diikuti untuk relasi antar user.

import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_spacing.dart';

/// Menampilkan aksi follow dan unfollow pada baris user.
class FollowButton extends StatelessWidget {
  const FollowButton({required this.isFollowing, required this.onToggle, super.key});

  static const AppText text = AppStrings.id;

  final bool isFollowing;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.touchTarget - AppSpacing.sm,
      child: isFollowing
          ? OutlinedButton(
              onPressed: onToggle,
              child: Text(text.following),
            )
          : FilledButton(
              onPressed: onToggle,
              child: Text(text.follow),
            ),
    );
  }
}