// Halaman moderasi review admin.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../admin_provider.dart';
import '../../domain/admin_models.dart';

/// Menampilkan daftar review semua user dengan tombol hapus.
class AdminReviewsPage extends ConsumerWidget {
  const AdminReviewsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AdminState state = ref.watch(adminProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Moderasi Review')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.reviews.isEmpty
              ? const Center(child: Text('Belum ada review.'))
              : ListView.builder(
                  itemCount: state.reviews.length,
                  itemBuilder: (BuildContext context, int index) {
                    final AdminReview review = state.reviews[index];
                    return _ReviewItem(review: review);
                  },
                ),
    );
  }
}

/// Item review dengan tombol hapus.
class _ReviewItem extends ConsumerWidget {
  const _ReviewItem({required this.review});

  final AdminReview review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: ListTile(
        leading: CircleAvatar(child: Text(review.userName[0])),
        title: Text('${review.userName} - ${review.movieTitle}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(review.content),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text('${review.rating}/5'),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            final bool? confirmed = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Konfirmasi Hapus'),
                content: const Text('Hapus review ini?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Hapus'),
                  ),
                ],
              ),
            );
            if (confirmed == true && context.mounted) {
              await ref.read(adminProvider.notifier).deleteReview(
                    id: review.id,
                  );
            }
          },
        ),
      ),
    );
  }
}
