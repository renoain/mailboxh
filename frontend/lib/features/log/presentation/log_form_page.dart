// Halaman form untuk mencatat tontonan.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/movie_list_item.dart';
import '../../../core/widgets/rating_stars.dart';
import '../../catalog/domain/movie_models.dart';
import '../../tags/presentation/widgets/tag_selector.dart';
import '../domain/log_models.dart';
import 'log_provider.dart';

/// Form log tontonan yang memuat rating, review, dan tag.
class LogFormPage extends ConsumerStatefulWidget {
  const LogFormPage({required this.movie, super.key});

  final Movie movie;

  @override
  ConsumerState<LogFormPage> createState() => _LogFormPageState();
}

class _LogFormPageState extends ConsumerState<LogFormPage> {
  static const AppText text = AppStrings.id;

  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  DateTime _watchedDate = DateTime.now();
  int _rating = 0;
  List<String> _tags = const <String>[];

  @override
  void initState() {
    super.initState();
    ref.invalidate(logFormProvider);
  }

  @override
  void dispose() {
    _noteController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _watchedDate,
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    if (picked == null || !mounted) return;
    setState(() => _watchedDate = picked);
  }

  Future<void> _submit() async {
    final LogDraft draft = LogDraft(
      movieId: widget.movie.id,
      watchedAt: _watchedDate,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      rating: _rating == 0 ? null : _rating,
      content: _reviewController.text.trim().isEmpty
          ? null
          : _reviewController.text.trim(),
      tags: _tags,
    );
    final bool success = await ref.read(logFormProvider.notifier).submit(draft);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(text.logSuccess)));
      Navigator.pop(context);
      return;
    }
    final Object? error = ref.read(logFormProvider).error;
    final String message = error is AppException
        ? error.message
        : text.somethingWrong;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(logFormProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(text.logTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: <Widget>[
          MovieListItem(
            title: widget.movie.title,
            posterPath: widget.movie.posterUrl,
            releaseDate: widget.movie.releaseDate,
          ),
          const SizedBox(height: AppSpacing.md),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(text.logDateLabel, style: AppTypography.labelMd),
            subtitle: Text(
              AppFormatters.dateLong(
                _watchedDate,
                isIndonesian: text.isIndonesian,
              ),
              style: AppTypography.bodyLg,
            ),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: _pickDate,
          ),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          Text(text.logRatingLabel, style: AppTypography.labelLg),
          const SizedBox(height: AppSpacing.sm),
          RatingStars(
            value: _rating,
            onChanged: (int value) => setState(() => _rating = value),
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            label: text.logNoteLabel,
            controller: _noteController,
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            label: text.logReviewLabel,
            controller: _reviewController,
            maxLines: 5,
          ),
          const SizedBox(height: AppSpacing.md),
          TagSelector(
            label: text.logTagsLabel,
            selected: _tags,
            onChanged: (List<String> tags) => setState(() => _tags = tags),
          ),
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
