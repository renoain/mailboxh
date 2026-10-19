// Halaman daftar yang diikuti.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'follow_provider.dart';

/// Halaman [FollowingPage].
class FollowingPage extends ConsumerWidget {
  const FollowingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(followingProvider);
    final text = AppStrings.id;
    return Scaffold(
      appBar: AppBar(title: Text(text.following)),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(text.following)),
        data: (users) {
          if (users.isEmpty) {
            return Center(child: Text(text.following));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: users.length,
            itemBuilder: (context, i) {
              final u = users[i];
              return ListTile(
                title: Text(u.name, style: AppTypography.bodyMd),
                trailing: TextButton(
                  onPressed: () => ref.read(followingProvider.notifier).toggle(u.id),
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
