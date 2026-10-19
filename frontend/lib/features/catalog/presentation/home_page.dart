// Halaman beranda katalog film.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/movie_card.dart';
import '../presentation/catalog_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogNotifierProvider);
    final text = AppStrings.of(Localizations.localeOf(context).languageCode);

    return Scaffold(
      appBar: AppBar(title: Text(text.navHome)),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(catalogNotifierProvider.notifier).loadMovies(refresh: true);
        },
        child: _buildBody(context, ref, catalogState, text),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(AppRoutes.search),
        child: const Icon(Icons.search),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    CatalogState state,
    AppText text,
  ) {    if (state.isLoading && state.movies.isEmpty) {
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

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.68,
      ),
      itemCount: state.movies.length,
      itemBuilder: (context, index) {
        final movie = state.movies[index];
        return MovieCard(
          title: movie.title,
          posterPath: movie.posterPath,
          releaseDate: movie.releaseDate,
          onTap: () => context.push('/movie/${movie.id}'),
        );
      },
    );
  }
}
