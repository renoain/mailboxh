// Halaman pencarian film dengan urutan dan muat lebih banyak.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/movie_card.dart';
import '../../detail/presentation/movie_detail_page.dart';
import '../domain/movie_models.dart';
import 'catalog_provider.dart';

/// Mencari film berdasarkan judul dan urutan pilihan user.
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  static const AppText text = AppStrings.id;

  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  String _query = '';
  MovieSort _sort = MovieSort.latest;
  final List<Movie> _extra = <Movie>[];
  bool _loadingMore = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() {
        _query = value.trim();
        _extra.clear();
      });
    });
  }

  void _changeSort(MovieSort sort) {
    if (sort == _sort) return;
    setState(() {
      _sort = sort;
      _extra.clear();
    });
  }

  Future<void> _loadMore(MoviePage current) async {
    if (_loadingMore || !current.hasNextPage) return;
    setState(() => _loadingMore = true);
    try {
      final MoviePage next = await ref.read(
        moviesProvider(
          MovieQuery(query: _query, sort: _sort, page: current.page + 1),
        ).future,
      );
      if (!mounted) return;
      setState(() {
        _extra.addAll(next.movies);
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(text.searchHint)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: text.searchHint,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                _SortChip(
                  label: text.sectionLatest,
                  selected: _sort == MovieSort.latest,
                  onSelected: () => _changeSort(MovieSort.latest),
                ),
                const SizedBox(width: AppSpacing.sm),
                _SortChip(
                  label: text.sortTitle,
                  selected: _sort == MovieSort.title,
                  onSelected: () => _changeSort(MovieSort.title),
                ),
                const SizedBox(width: AppSpacing.sm),
                _SortChip(
                  label: text.sortReleaseDate,
                  selected: _sort == MovieSort.releaseDate,
                  onSelected: () => _changeSort(MovieSort.releaseDate),
                ),
                const SizedBox(width: AppSpacing.sm),
                _SortChip(
                  label: text.sortRating,
                  selected: _sort == MovieSort.rating,
                  onSelected: () => _changeSort(MovieSort.rating),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(child: _buildResults(scheme)),
        ],
      ),
    );
  }

  Widget _buildResults(ColorScheme scheme) {
    if (_query.isEmpty) {
      return EmptyState(
        icon: Icons.search,
        message: text.emptyMessage,
      );
    }
    final AsyncValue<MoviePage> result = ref.watch(
      moviesProvider(MovieQuery(query: _query, sort: _sort)),
    );
    return result.when(
      loading: () => const LoadingIndicator(isFullScreen: true),
      error: (Object error, StackTrace stackTrace) => AppErrorState(
        onRetry: () => ref.invalidate(
          moviesProvider(MovieQuery(query: _query, sort: _sort)),
        ),
      ),
      data: (MoviePage page) {
        final List<Movie> movies = <Movie>[...page.movies, ..._extra];
        if (movies.isEmpty) {
          return EmptyState(
            icon: Icons.movie_outlined,
            title: text.moviesNotFound,
            message: text.emptyMessage,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: movies.length + (page.hasNextPage ? 1 : 0),
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: AppSpacing.sm),
          itemBuilder: (BuildContext context, int index) {
            if (index == movies.length) {
              return Center(
                child: _loadingMore
                    ? const Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                        child: OutlinedButton(
                          onPressed: () => _loadMore(page),
                          child: Text(text.loadMore),
                        ),
                      ),
              );
            }
            final Movie movie = movies[index];
            return MovieCard(
              title: movie.title,
              posterPath: movie.posterUrl,
              releaseDate: movie.releaseDate,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailPage(movie: movie),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Chip pemilih urutan daftar hasil.
class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}
