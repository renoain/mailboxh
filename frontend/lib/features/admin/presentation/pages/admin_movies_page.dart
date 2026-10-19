// Halaman daftar film untuk admin (bentuk list).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/admin_model.dart';
import '../admin_provider.dart';

class AdminMoviesPage extends ConsumerWidget {
  const AdminMoviesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminNotifierProvider);
    final text = AppStrings.of(Localizations.localeOf(context).languageCode);

    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Film')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(adminNotifierProvider.notifier).loadMovies();
        },
        child: _buildBody(context, ref, state, text),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(AppRoutes.adminMovieForm),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AdminState state,
    AppText text,
  ) {
    if (state.isLoading && state.data == null) {
      return const LoadingIndicator(isFullScreen: true);
    }

    if (state.error != null && state.data == null) {
      return AppErrorState(
        message: state.error!.message,
        onRetry: () => ref.read(adminNotifierProvider.notifier).loadMovies(),
      );
    }

    final movies = state.data as List<AdminMovie>? ?? [];

    if (movies.isEmpty) {
      return EmptyState(
        title: text.emptyTitle,
        message: 'Belum ada film yang tersedia.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _MovieItem(
          movie: movie,
          onEdit: () => context.push('/admin/movies/${movie.id}/edit'),
          onDelete: () => _confirmDelete(context, ref, movie),
          onToggleFeature: (value) =>
              ref.read(adminNotifierProvider.notifier).toggleFeature(movie.id),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AdminMovie movie,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Film'),
        content: Text('Yakin ingin menghapus "${movie.title}"?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Batal'),
          ),
          AppButton(
            label: 'Hapus',
            variant: AppButtonVariant.secondary,
            onPressed: () => context.pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(adminNotifierProvider.notifier).deleteMovie(movie.id);
    }
  }
}

class _MovieItem extends ConsumerWidget {
  const _MovieItem({
    required this.movie,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleFeature,
  });

  final AdminMovie movie;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggleFeature;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        title: Text(
          movie.title,
          style: AppTypography.labelLg.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${movie.releaseYear}  ${movie.genres.join(', ')}',
          style: AppTypography.bodySm.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: movie.isFeatured,
              onChanged: onToggleFeature,
              activeColor: AppColors.primaryLight,
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: onEdit,
                  color: scheme.primary,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: onDelete,
                  color: scheme.error,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension _LanguageCode on BuildContext {
  String get languageCode => Localizations.localeOf(this).languageCode;
}
