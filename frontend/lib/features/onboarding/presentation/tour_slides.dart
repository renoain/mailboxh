// Ilustrasi statis untuk lima slide tur pengenalan.

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

/// Kerangka slide: header bergradasi berisi teks, lalu isi ilustrasi.
class TourSlide extends StatelessWidget {
  const TourSlide({required this.caption, required this.child, super.key});

  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          height: AppSizes.slideHeader,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.slideGradientTop, AppColors.bgDark],
            ),
          ),
          child: Text(
            caption,
            textAlign: TextAlign.center,
            style: AppTypography.headlineSm.copyWith(
              fontWeight: FontWeight.w400,
              color: scheme.onSurface,
            ),
          ),
        ),
        Expanded(
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (Rect bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white, Colors.transparent],
              stops: [0, 0.72, 1],
            ).createShader(bounds),
            child: ClipRect(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: child,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.dotsArea),
      ],
    );
  }
}

class _Heart extends StatelessWidget {
  const _Heart();

  @override
  Widget build(BuildContext context) => const Icon(
        Icons.favorite,
        size: AppSizes.heartIcon,
        color: AppColors.brandOrange,
      );
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return CircleAvatar(
      radius: AppSizes.avatarLarge / 2,
      backgroundColor: AppColors.navBar,
      child: Text(
        name.characters.first,
        style: AppTypography.labelMd.copyWith(color: scheme.onSurface),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(
          color: color == AppColors.brandBlue
              ? AppColors.fieldText
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Slide 1: panel aksi pada satu film.
class LogSlideBody extends StatelessWidget {
  const LogSlideBody({super.key});

  static const AppText text = AppStrings.id;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextStyle rowStyle =
        AppTypography.bodyMd.copyWith(color: scheme.onSurfaceVariant);
    Widget action(IconData icon, Color color, String label) => Column(
          children: [
            Icon(icon, size: AppSizes.logoDiameter * 0.7, color: color),
            const SizedBox(height: AppSpacing.xs),
            Text(label, style: rowStyle),
          ],
        );
    Widget row(String label) => Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.twoXs),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: scheme.outlineVariant)),
          ),
          child: Text(label, textAlign: TextAlign.center, style: rowStyle),
        );
    return Column(
      children: [
        const PosterPlaceholder(
          title: 'TENET',
          width: AppSizes.tourPoster,
          height: AppSizes.tourPosterHeight,
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          decoration: const BoxDecoration(
            color: AppColors.navBar,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    action(Icons.visibility, AppColors.brandGreen,
                        text.tourLogged),
                    action(Icons.favorite, AppColors.brandOrange,
                        text.tourLiked),
                    action(Icons.more_time, scheme.onSurfaceVariant,
                        text.tourWatchlist),
                  ],
                ),
              ),
              row(text.tourRated),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                  5,
                  (int i) => const Icon(
                    Icons.star,
                    size: AppSizes.avatarLarge,
                    color: AppColors.panelDark,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              row(text.tourReviewAgain),
              row(text.tourAddToList),
              row(text.tourGoToFilm),
              row(text.tourShare),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ],
    );
  }
}

/// Slide 2: diary bulanan.
class DiarySlideBody extends StatelessWidget {
  const DiarySlideBody({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.bgAltDark,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Text(
            SampleContent.diaryMonth,
            style: AppTypography.labelMd.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
        for (int i = 0; i < SampleContent.diary.length; i++)
          _DiaryRow(film: SampleContent.diary[i], seed: i),
      ],
    );
  }
}

class _DiaryRow extends StatelessWidget {
  const _DiaryRow({required this.film, required this.seed});

  final SampleFilm film;
  final int seed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.dateBox,
            height: AppSizes.dateBox,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.bgAltDark,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Text(
              '${film.day}',
              style: AppTypography.headlineSm.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          PosterPlaceholder(
            seed: seed,
            width: AppSizes.posterThumb,
            height: AppSizes.posterThumbHeight,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: film.title,
                    style: AppTypography.labelLg.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: '  ${film.year}',
                        style: AppTypography.bodySm.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    StarRow(rating: film.rating),
                    if (film.liked) ...[
                      const SizedBox(width: AppSpacing.sm),
                      const _Heart(),
                    ],
                    if (film.icon != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Icon(film.icon, size: 14, color: scheme.onSurfaceVariant),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Slide 3: satu ulasan panjang.
class ReviewSlideBody extends StatelessWidget {
  const ReviewSlideBody({super.key});

  static const AppText text = AppStrings.id;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const _Avatar(name: SampleContent.tourReviewUser),
                        const SizedBox(width: AppSpacing.sm),
                        Flexible(
                          child: Text(
                            SampleContent.tourReviewUser,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelLg.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _Chip(label: text.tourCrew, color: AppColors.panelDark),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text.rich(
                      TextSpan(
                        text: SampleContent.tourReviewFilm,
                        style: AppTypography.headlineMd.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: '  ${SampleContent.tourReviewYear}',
                            style: AppTypography.bodyMd.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const Row(
                      children: [
                        StarRow(rating: 5),
                        SizedBox(width: AppSpacing.sm),
                        _Heart(),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      SampleContent.tourReviewWatched,
                      style: AppTypography.bodySm
                          .copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const PosterPlaceholder(
                title: SampleContent.tourReviewFilm,
                seed: 1,
                width: AppSizes.tourPoster / 2,
                height: AppSizes.listPosterHeight,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            SampleContent.tourReviewBody,
            style: AppTypography.bodyMd.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Slide 4: feed aktivitas teman.
class ActivitySlideBody extends StatelessWidget {
  const ActivitySlideBody({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextStyle soft =
        AppTypography.bodyMd.copyWith(color: scheme.onSurfaceVariant);
    final TextStyle strong = AppTypography.bodyMd.copyWith(
      color: scheme.onSurface,
      fontWeight: FontWeight.w700,
    );
    const List<String> users = SampleContent.tourActivityUsers;
    final BorderSide line = BorderSide(color: scheme.outlineVariant);
    Widget item({required String user, required Widget body, bool last = false}) =>
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: last ? null : Border(bottom: line),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(name: user),
              const SizedBox(width: AppSpacing.twoXs),
              Expanded(child: body),
            ],
          ),
        );
    Widget age() => Text(
          SampleContent.tourActivityAge,
          style: AppTypography.bodySm.copyWith(color: scheme.onSurfaceVariant),
        );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.fromBorderSide(line),
      ),
      child: Column(
        children: [
          item(
            user: users[0],
            body: Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: '${users[0]} ${SampleContent.tourActivityLiked} ',
                      style: soft,
                      children: [
                        TextSpan(
                          text: SampleContent.tourActivityLikedList,
                          style: strong,
                        ),
                      ],
                    ),
                  ),
                ),
                age(),
              ],
            ),
          ),
          item(
            user: users[1],
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${users[1]} ${SampleContent.tourActivityReviewed}',
                        style: soft,
                      ),
                    ),
                    age(),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text.rich(
                  TextSpan(
                    text: SampleContent.tourActivityFilm.title,
                    style: AppTypography.labelLg.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: '  ${SampleContent.tourActivityFilm.year}',
                        style: AppTypography.bodySm
                            .copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                const StarRow(rating: 4.5, size: 12),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PosterPlaceholder(
                      seed: 2,
                      width: AppSizes.avatarLarge * 1.4,
                      height: AppSizes.listPosterHeight,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(SampleContent.tourActivityReview, style: soft),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl * 2),
              ],
            ),
          ),
          item(
            user: users[2],
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: '${users[2]} ${SampleContent.tourActivityListed} ',
                          style: soft,
                          children: [
                            TextSpan(
                              text: SampleContent.tourActivityOscar,
                              style: strong,
                            ),
                            TextSpan(
                              text: ' ${SampleContent.tourActivityOscarCount}',
                              style: soft,
                            ),
                          ],
                        ),
                      ),
                    ),
                    age(),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: List<Widget>.generate(
                    7,
                    (int i) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.xs),
                        child: PosterPlaceholder(
                          seed: i + 3,
                          height: AppSizes.posterThumbHeight,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          item(
            user: users[3],
            last: true,
            body: Opacity(
              opacity: 0.5,
              child: Text.rich(
                TextSpan(
                  text: '${users[3]} ${SampleContent.tourActivityReviewed}\n',
                  style: soft,
                  children: [
                    TextSpan(
                      text: SampleContent.tourActivityFilmFaded.title,
                      style: strong,
                    ),
                    TextSpan(
                      text: ' ${SampleContent.tourActivityFilmFaded.year}',
                      style: soft,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Slide 5: daftar bernomor dengan grid poster.
class ListSlideBody extends StatelessWidget {
  const ListSlideBody({super.key});

  static const AppText text = AppStrings.id;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _Avatar(name: SampleContent.tourListOwner),
              const SizedBox(width: AppSpacing.sm),
              Text(
                SampleContent.tourListOwner,
                style: AppTypography.bodyLg
                    .copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(width: AppSpacing.sm),
              _Chip(label: text.tourPatron, color: AppColors.brandBlue),
              const Spacer(),
              Icon(Icons.menu, color: scheme.onSurfaceVariant),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            SampleContent.tourListTitle,
            style: AppTypography.headlineMd.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            SampleContent.tourListBody,
            style: AppTypography.bodyMd.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSizes.gridGap,
            crossAxisSpacing: AppSizes.gridGap,
            childAspectRatio: 2 / 3,
            children: [
              for (int i = 0; i < SampleContent.tourListFilms.length; i++)
                PosterPlaceholder(
                  seed: i,
                  title: SampleContent.tourListFilms[i],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
