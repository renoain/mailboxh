// Halaman riwayat tontonan yang dikelompokkan per tanggal.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/movie_list_item.dart';
import '../../../core/widgets/rating_stars.dart';
import '../../../core/widgets/tag_chip.dart';
import '../domain/diary_models.dart';
import 'diary_provider.dart';

/// Menampilkan entri diary yang dikelompokkan per tanggal.
class DiaryPage extends ConsumerWidget {
  const DiaryPage({super.key});

  static const AppText text = AppStrings.id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<DiaryDay>> diary = ref.watch(diaryProvider);
    return Scaffold(
      appBar: AppBar(title: Text(text.diaryTitle)),
      body: diary.when(
        loading: () => const LoadingIndicator(isFullScreen: true),
        error: (Object error, StackTrace stackTrace) =>
            AppErrorState(onRetry: () => ref.invalidate(diaryProvider)),
        data: (List<DiaryDay> days) {
          if (days.isEmpty) {
            return EmptyState(
              icon: Icons.movie_outlined,
              title: text.diaryEmpty,
              message: text.emptyMessage,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: days.length,
            itemBuilder: (BuildContext context, int index) =>
                _DiaryDaySection(day: days[index]),
          );
        },
      ),
    );
  }
}

/// Judul tanggal beserta entri tontonan pada hari itu.
class _DiaryDaySection extends StatelessWidget {
  const _DiaryDaySection({required this.day});

  static const AppText text = AppStrings.id;

  final DiaryDay day;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            AppFormatters.dateLong(day.date, isIndonesian: text.isIndonesian),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        for (final DiaryEntry entry in day.entries)
          _DiaryEntryTile(entry: entry),
      ],
    );
  }
}

/// Satu entri diary dengan poster, rating, catatan, dan tag.
class _DiaryEntryTile extends StatelessWidget {
  const _DiaryEntryTile({required this.entry});

  final DiaryEntry entry;

  @override
  Widget build(BuildContext context) {
    final String? subtitle =
        entry.note ??
        (entry.content == null ? null : AppFormatters.excerpt(entry.content!));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MovieListItem(
          title: entry.movie.title,
          posterPath: entry.movie.posterUrl,
          releaseDate: entry.movie.releaseDate,
          subtitle: subtitle,
          trailing: (entry.rating ?? 0) > 0
              ? RatingStars(value: entry.rating!, size: AppSpacing.md)
              : null,
        ),
        if (entry.tags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.sm,
              bottom: AppSpacing.sm,
            ),
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: <Widget>[
                for (final DiaryTag tag in entry.tags) TagChip(label: tag.name),
              ],
            ),
          ),
      ],
    );
  }
}
