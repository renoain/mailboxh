// Halaman daftar pengikut.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'follow_provider.dart';

/// Halaman [FollowersPage].
class FollowersPage extends ConsumerWidget {
  const FollowersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(followersProvider);
    final text = AppStrings.id;
    return Scaffold(
      appBar: AppBar(title: Text(text.followers)),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(text.followers)),
        data: (users) {
          if (users.isEmpty) {
            return Center(child: Text(text.followers));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: users.length,
            itemBuilder: (context, i) {
              final u = users[i];
              return ListTile(
                title: Text(u.name, style: AppTypography.bodyMd),
                trailing: TextButton(
                  onPressed: () => ref.read(followersProvider.notifier).toggle(u.id),
                  child: Text(u.isFollowing ? text.following : text.follow),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
