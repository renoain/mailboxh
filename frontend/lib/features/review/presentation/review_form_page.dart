// Halaman form untuk memberi rating dan review.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/movie_list_item.dart';
import '../../../core/widgets/rating_stars.dart';
import '../../catalog/domain/movie_models.dart';
import 'review_provider.dart';

/// Form rating dan ulasan satu film.
class ReviewFormPage extends ConsumerStatefulWidget {
  const ReviewFormPage({required this.movie, super.key});

  final Movie movie;

  @override
  ConsumerState<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends ConsumerState<ReviewFormPage> {
  static const AppText text = AppStrings.id;

  final TextEditingController _contentController = TextEditingController();

  int _rating = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    ref.invalidate(reviewFormProvider);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      setState(() => _error = text.reviewRatingRequired);
      return;
    }
    setState(() => _error = null);
    final String content = _contentController.text.trim();
    final dynamic review = await ref
        .read(reviewFormProvider.notifier)
        .submit(
          movieId: widget.movie.id,
          rating: _rating,
          content: content.isEmpty ? null : content,
        );
    if (!mounted) return;
    if (review != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(text.reviewAdded)));
      Navigator.pop(context);
      return;
    }
    final Object? error = ref.read(reviewFormProvider).error;
    final String message = error is AppException
        ? error.message
        : text.somethingWrong;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool isLoading = ref.watch(reviewFormProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(text.reviewTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: <Widget>[
          MovieListItem(
            title: widget.movie.title,
            posterPath: widget.movie.posterUrl,
            releaseDate: widget.movie.releaseDate,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(text.logRatingLabel, style: AppTypography.labelLg),
          const SizedBox(height: AppSpacing.sm),
          RatingStars(
            value: _rating,
            onChanged: (int value) => setState(() => _rating = value),
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            label: text.logReviewLabel,
            controller: _contentController,
            maxLines: 6,
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _error!,
              style: AppTypography.bodyMd.copyWith(color: scheme.error),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: text.save,
            isLoading: isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
