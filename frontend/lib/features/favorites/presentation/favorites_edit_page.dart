// Halaman pemilihan dan pengaturan Four Favourites (4 film favorit).

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_env.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../profile/domain/profile_models.dart';
import '../../profile/presentation/profile_provider.dart';
import 'favorite_provider.dart';

/// Halaman untuk memilih dan mengubah 4 film favorit user.
class FavoritesEditPage extends ConsumerStatefulWidget {
  const FavoritesEditPage({super.key});

  static const AppText text = AppStrings.id;

  @override
  ConsumerState<FavoritesEditPage> createState() => _FavoritesEditPageState();
}

class _FavoritesEditPageState extends ConsumerState<FavoritesEditPage> {
  final List<Movie?> _selectedSlots = List<Movie?>.filled(4, null);
  bool _isSaving = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _populateInitialSlots();
  }

  void _populateInitialSlots() {
    final AsyncValue<List<FavoriteFilm>> favState = ref.read(favoritesProvider);
    final List<FavoriteFilm>? list = favState.value;
    if (list != null && list.isNotEmpty) {
      for (final FavoriteFilm fav in list) {
        if (fav.position >= 1 && fav.position <= 4) {
          _selectedSlots[fav.position - 1] = fav.movie;
        }
      }
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    const AppText text = FavoritesEditPage.text;

    // Perbarui slot ketika data favorit selesai dimuat dari backend.
    ref.listen<AsyncValue<List<FavoriteFilm>>>(
      favoritesProvider,
      (AsyncValue<List<FavoriteFilm>>? prev, AsyncValue<List<FavoriteFilm>> next) {
        if (!_isInitialized && next.hasValue) {
          final List<FavoriteFilm> list = next.value ?? <FavoriteFilm>[];
          setState(() {
            for (final FavoriteFilm fav in list) {
              if (fav.position >= 1 && fav.position <= 4) {
                _selectedSlots[fav.position - 1] = fav.movie;
              }
            }
            _isInitialized = true;
          });
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.letterboxdBg,
      appBar: AppBar(
        backgroundColor: AppColors.letterboxdBg,
        title: Text(
          text.favoritesEditTitle,
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimaryDark,
          ),
        ),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Center(
                child: SizedBox(
                  width: AppSpacing.md,
                  height: AppSpacing.md,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveFavorites,
              child: Text(
                text.save,
                style: AppTypography.labelLg.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 2 / 3,
          children: [
            for (int index = 0; index < 4; index++)
              _buildSlotItem(index),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotItem(int index) {
    const AppText text = FavoritesEditPage.text;
    final Movie? movie = _selectedSlots[index];

    if (movie != null) {
      return AspectRatio(
        aspectRatio: 2 / 3,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: CachedNetworkImage(
                  imageUrl: AppEnv.assetUrl(movie.posterUrl),
                  fit: BoxFit.cover,
                  placeholder: (BuildContext context, String url) =>
                      Container(color: AppColors.surfaceDimDark),
                  errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) =>
                      Container(
                    color: AppColors.surfaceDimDark,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Text(
                      movie.title,
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.textPrimaryDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            // Tombol klik untuk mengganti film.
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  onTap: () => _pickMovieForSlot(index),
                ),
              ),
            ),
            // Badge nomor slot.
            Positioned(
              top: AppSpacing.xs,
              left: AppSpacing.xs,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  '${index + 1}',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.textOnPrimaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Tombol hapus slot.
            Positioned(
              top: AppSpacing.xs,
              right: AppSpacing.xs,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.bgDark.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: AppSpacing.md,
                    color: AppColors.textPrimaryDark,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedSlots[index] = null;
                    });
                  },
                ),
              ),
            ),
            // Judul film di bagian bawah.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.bgDark.withValues(alpha: 0.7),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(AppRadius.md),
                  ),
                ),
                child: Text(
                  movie.title,
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 2 / 3,
      child: Material(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: () => _pickMovieForSlot(index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: AppColors.outlineLight.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_circle_outline,
                  size: AppSpacing.xl,
                  color: AppColors.textSecondaryDark,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${text.slotEmptyLabel} ${index + 1}',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickMovieForSlot(int slotIndex) async {
    final Movie? pickedMovie = await showModalBottomSheet<Movie>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      builder: (BuildContext sheetContext) {
        return _WatchedMoviePickerSheet(
          onPick: (Movie movie) {
            Navigator.of(sheetContext).pop(movie);
          },
        );
      },
    );

    if (pickedMovie != null && mounted) {
      setState(() {
        _selectedSlots[slotIndex] = pickedMovie;
      });
    }
  }

  Future<void> _saveFavorites() async {
    const AppText text = FavoritesEditPage.text;
    final List<Map<String, dynamic>> items = <Map<String, dynamic>>[];

    for (int i = 0; i < 4; i++) {
      final Movie? movie = _selectedSlots[i];
      if (movie != null) {
        items.add(<String, dynamic>{
          'position': i + 1,
          'movie_id': movie.id,
        });
      }
    }

    setState(() => _isSaving = true);
    try {
      await ref.read(favoritesProvider.notifier).updateFavorites(items);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text.favoritesUpdated),
        ),
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

/// Modal bottom sheet untuk mencari dan memilih film dari daftar watched.
class _WatchedMoviePickerSheet extends ConsumerStatefulWidget {
  const _WatchedMoviePickerSheet({required this.onPick});

  final ValueChanged<Movie> onPick;

  @override
  ConsumerState<_WatchedMoviePickerSheet> createState() =>
      _WatchedMoviePickerSheetState();
}

class _WatchedMoviePickerSheetState
    extends ConsumerState<_WatchedMoviePickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const AppText text = FavoritesEditPage.text;
    final AsyncValue<List<Movie>> watchedAsync = ref.watch(userFilmsProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (BuildContext context, ScrollController scrollController) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: AppSpacing.xl,
                height: AppSpacing.xs,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDimDark,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  text.selectFromWatched,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: TextField(
                  controller: _searchController,
                  onChanged: (String value) {
                    setState(() {
                      _searchQuery = value.trim();
                    });
                  },
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                  decoration: InputDecoration(
                    hintText: text.searchWatchedHint,
                    hintStyle: AppTypography.bodyMd.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textSecondaryDark,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceDimDark,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: watchedAsync.when(
                  loading: () => const Center(
                    child: LoadingIndicator(message: 'Memuat film'),
                  ),
                  error: (Object error, StackTrace stackTrace) => Center(
                    child: AppErrorState(
                      message: error.toString(),
                      onRetry: () => ref.refresh(userFilmsProvider),
                    ),
                  ),
                  data: (List<Movie> allFilms) {
                    final List<Movie> filtered = _searchQuery.isEmpty
                        ? allFilms
                        : allFilms
                            .where((Movie m) => m.title
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase()))
                            .toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: EmptyState(
                          icon: Icons.movie_outlined,
                          message: text.emptyWatchedFilms,
                        ),
                      );
                    }

                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: filtered.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (BuildContext context, int index) {
                        final Movie film = filtered[index];
                        final String? year = film.releaseDate != null &&
                                film.releaseDate!.isNotEmpty
                            ? film.releaseDate!.split('-').first
                            : null;

                        return InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          onTap: () => widget.onPick(film),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.xs,
                              horizontal: AppSpacing.xs,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: AppSpacing.twoXl,
                                  height: AppSpacing.fourXl,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.sm),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          AppEnv.assetUrl(film.posterUrl),
                                      fit: BoxFit.cover,
                                      placeholder: (BuildContext context,
                                              String url) =>
                                          Container(
                                        color: AppColors.surfaceDimDark,
                                      ),
                                      errorBuilder: (BuildContext context,
                                              Object error,
                                              StackTrace? stackTrace) =>
                                          Container(
                                        color: AppColors.surfaceDimDark,
                                        child: const Icon(
                                          Icons.movie_outlined,
                                          color: AppColors.textSecondaryDark,
                                          size: AppSpacing.md,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        film.title,
                                        style: AppTypography.labelLg.copyWith(
                                          color: AppColors.textPrimaryDark,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (year != null) ...[
                                        const SizedBox(height: AppSpacing.xs),
                                        Text(
                                          year,
                                          style:
                                              AppTypography.labelSm.copyWith(
                                            color: AppColors.textSecondaryDark,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
