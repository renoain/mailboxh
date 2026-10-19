// Daftar ulasan terbaru dengan rating, poster, dan komentar.

import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/sample_content.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/poster_placeholder.dart';
import '../../../core/widgets/star_row.dart';

/// Halaman penuh berisi daftar ulasan.
class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  static const AppText text = AppStrings.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(text.tabReviews)),
      body: const ReviewsFeed(),
    );
  }
}

/// Daftar ulasan yang juga dipakai sebagai isi tab beranda.
class ReviewsFeed extends StatelessWidget {
  const ReviewsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: SampleContent.reviews.length,
      itemBuilder: (BuildContext context, int index) =>
          _ReviewTile(review: SampleContent.reviews[index], seed: index),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review, required this.seed});

  final SampleReview review;
  final int seed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: review.film,
                    style: AppTypography.headlineSm.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: '  ${review.year}',
                        style: AppTypography.bodyMd.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                review.user,
                style: AppTypography.bodyMd
                    .copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(width: AppSpacing.sm),
              CircleAvatar(
                radius: AppSizes.avatar / 2,
                backgroundColor: AppColors.navBar,
                child: Text(
                  review.user.characters.first.toUpperCase(),
                  style: AppTypography.labelSm.copyWith(color: scheme.onSurface),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              StarRow(rating: review.rating, size: 16),
              if (review.liked) ...[
                const SizedBox(width: AppSpacing.sm),
                const Icon(
                  Icons.favorite,
                  size: 14,
                  color: AppColors.brandOrange,
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PosterPlaceholder(
                seed: seed,
                width: AppSizes.avatarLarge * 1.7,
                height: AppSizes.listPosterHeight,
                radius: AppRadius.sm,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.body,
                      style: AppTypography.bodyMd.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                    if (review.footnote != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        review.footnote!,
                        style: AppTypography.bodyMd
                            .copyWith(color: scheme.onSurface),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
