// Halaman pencarian film.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_env.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../presentation/catalog_provider.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogNotifierProvider);
    final text = AppStrings.of(Localizations.localeOf(context).languageCode);

    return Scaffold(
      appBar: AppBar(title: Text(text.navSearch)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: CustomTextField(
              label: text.searchHint,
              onSubmitted: (value) {
                ref
                    .read(catalogNotifierProvider.notifier)
                    .loadMovies(query: value, refresh: true);
              },
            ),
          ),
          Expanded(
            child: _buildBody(context, ref, catalogState, text),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    CatalogState state,
    AppText text,
  ) {
    if (state.isLoading && state.movies.isEmpty) {
      return const LoadingIndicator(isFullScreen: true);
    }

    if (state.error != null && state.movies.isEmpty) {
      return AppErrorState(
        message: state.error!.message,
        onRetry: () => ref
            .read(catalogNotifierProvider.notifier)
            .loadMovies(refresh: true),
      );
    }

    if (state.movies.isEmpty) {
      return EmptyState(
        title: text.emptyTitle,
        message: text.emptyMessage,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: state.movies.length,
      itemBuilder: (context, index) {
        final movie = state.movies[index];
        return ListTile(
          leading: movie.posterPath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: Image.network(
                    AppEnv.assetUrl(movie.posterPath),
                    width: 50,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(Icons.movie_outlined),
          title: Text(movie.title),
          subtitle: movie.releaseDate != null
              ? Text('${movie.releaseYear}',
                  style: AppTypography.bodySm.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ))
              : null,
          trailing: movie.likeCount != null
              ? Text('${movie.likeCount}',
                  style: AppTypography.bodySm.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ))
              : null,
          onTap: () => context.push('/movie/${movie.id}'),
        );
      },
    );
  }
}
