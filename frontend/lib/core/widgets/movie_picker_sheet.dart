// Bottom sheet untuk memilih film dari hasil pencarian.

import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'empty_state.dart';
import 'loading_indicator.dart';
import 'movie_list_item.dart';

/// Satu pilihan film dari sheet ini.
class MoviePick {
  const MoviePick({required this.tmdbId, required this.title, this.posterPath});

  final int tmdbId;
  final String title;
  final String? posterPath;
}

/// Picker film dipakai bersama oleh Lists dan Four Favourites.
class MoviePickerSheet extends StatefulWidget {
  const MoviePickerSheet({required this.onSearch, this.title, super.key});

  static const AppText text = AppStrings.id;

  /// Callback pencarian. Halaman yang membuka sheet yang memanggil API.
  final Future<List<MoviePick>> Function(String query) onSearch;

  final String? title;

  @override
  State<MoviePickerSheet> createState() => _MoviePickerSheetState();
}

class _MoviePickerSheetState extends State<MoviePickerSheet> {
  List<MoviePick> _results = <MoviePick>[];
  bool _isSearching = false;
  bool _hasQuery = false;

  Future<void> _runSearch(String query) async {
    setState(() {
      _isSearching = true;
      _hasQuery = query.trim().isNotEmpty;
    });

    final List<MoviePick> results =
        query.trim().isEmpty ? <MoviePick>[] : await widget.onSearch(query);

    if (!mounted) return;
    setState(() {
      _results = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        builder: (BuildContext context, ScrollController controller) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppSpacing.twoXl,
                  height: AppSpacing.xs,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SearchBar(
                  hintText: MoviePickerSheet.text.searchHint,
                  onSubmitted: _runSearch,
                  leading: const Icon(Icons.search),
                ),
                const SizedBox(height: AppSpacing.sm),
                Expanded(child: _body()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _body() {
    if (_isSearching) {
      return const LoadingIndicator(isFullScreen: true);
    }
    if (!_hasQuery) {
      return const EmptyState(icon: Icons.search);
    }
    if (_results.isEmpty) {
      return const EmptyState(icon: Icons.movie_outlined);
    }
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (BuildContext context, int index) {
        final MoviePick pick = _results[index];
        return MovieListItem(
          title: pick.title,
          posterPath: pick.posterPath,
          onTap: () => Navigator.of(context).pop(pick),
        );
      },
    );
  }
}

/// Membuka picker film dan mengembalikan pilihan, atau null bila batal.
Future<MoviePick?> showMoviePicker(
  BuildContext context, {
  required Future<List<MoviePick>> Function(String query) onSearch,
  String? title,
}) {
  return showModalBottomSheet<MoviePick>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
    ),
    builder: (BuildContext context) =>
        MoviePickerSheet(onSearch: onSearch, title: title),
  );
}