// Baris user dengan avatar inisial dan aksi follow.

import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'follow_button.dart';

/// Menampilkan user di halaman members, followers, following, dan feed.
class UserCard extends StatelessWidget {
  const UserCard({
    required this.name,
    this.followerCount,
    this.isFollowing = false,
    this.isSelf = false,
    this.onTap,
    this.onToggleFollow,
    super.key,
  });

  final String name;
  final int? followerCount;
  final bool isFollowing;
  final bool isSelf;
  final VoidCallback? onTap;
  final VoidCallback? onToggleFollow;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool showFollow = !isSelf && onToggleFollow != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            _initial(scheme),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelMd,
                  ),
                  if (followerCount != null)
                    Text(
                      '${FollowButton.text.followers} $followerCount',
                      style: AppTypography.bodySm
                          .copyWith(color: scheme.onSurfaceVariant),
                    ),
                ],
              ),
            ),
            if (showFollow)
              FollowButton(isFollowing: isFollowing, onToggle: onToggleFollow!),
          ],
        ),
      ),
    );
  }

  Widget _initial(ColorScheme scheme) {
    final String initial = name.trim().isEmpty ? '' : name.trim()[0];
    return CircleAvatar(
      radius: AppSpacing.twoXs + AppSpacing.xs,
      backgroundColor: scheme.primaryContainer,
      child: Text(
        initial.toUpperCase(),
        style: AppTypography.labelLg.copyWith(color: scheme.onPrimaryContainer),
      ),
    );
  }
}