// Halaman moderasi review untuk admin.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/admin_model.dart';
import '../admin_provider.dart';

class AdminReviewsPage extends ConsumerWidget {
  const AdminReviewsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminNotifierProvider);
    final text = AppStrings.of(Localizations.localeOf(context).languageCode);

    return Scaffold(
      appBar: AppBar(title: const Text('Moderasi Review')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(adminNotifierProvider.notifier).loadReviews();
        },
        child: _buildBody(context, ref, state, text),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AdminState state,
    AppText text,
  ) {
    if (state.isLoading && state.data == null) {
      return const LoadingIndicator(isFullScreen: true);
    }

    if (state.error != null && state.data == null) {
      return AppErrorState(
        message: state.error!.message,
        onRetry: () => ref.read(adminNotifierProvider.notifier).loadReviews(),
      );
    }

    final reviews = state.data as List<AdminReview>? ?? [];

    if (reviews.isEmpty) {
      return const Center(child: Text('Belum ada review.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return _ReviewItem(
          review: review,
          onDelete: () => _confirmDelete(context, ref, review),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AdminReview review,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Review'),
        content: Text('Yakin ingin menghapus review ini?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Batal'),
          ),
          AppButton(
            label: 'Hapus',
            variant: AppButtonVariant.secondary,
            onPressed: () => context.pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(adminNotifierProvider.notifier).deleteReview(review.id);
    }
  }
}

class _ReviewItem extends ConsumerWidget {
  const _ReviewItem({
    required this.review,
    required this.onDelete,
  });

  final AdminReview review;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        title: Text(
          review.movieTitle,
          style: AppTypography.labelLg.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Text(
                  '${review.userName}  ',
                  style: AppTypography.bodySm.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  'Rating: ${review.rating}/5',
                  style: AppTypography.bodySm.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (review.content != null && review.content!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                review.content!,
                style: AppTypography.bodySm.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: AppButton(
          label: 'Hapus',
          variant: AppButtonVariant.plain,
          onPressed: onDelete,
        ),
      ),
    );
  }
}
