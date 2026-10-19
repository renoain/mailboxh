// Halaman daftar film admin dengan aksi edit, hapus, dan featured toggle.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../admin_provider.dart';
import '../../domain/admin_models.dart';

/// Menampilkan daftar film dalam bentuk list dengan aksi admin.
class AdminMoviesPage extends ConsumerWidget {
  const AdminMoviesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppText text = AppStrings.id;
    final AdminState state = ref.watch(adminProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Film')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.movies.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.movie_outlined, size: 64),
                      const SizedBox(height: AppSpacing.md),
                      Text(text.emptyMessage),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: state.movies.length,
                  itemBuilder: (BuildContext context, int index) {
                    final AdminMovie movie = state.movies[index];
                    return _MovieItem(movie: movie);
                  },
                ),
      floatingActionButton: state.isLoading
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/admin/movies/form');
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}

/// Item film dalam daftar admin.
class _MovieItem extends ConsumerWidget {
  const _MovieItem({required this.movie});

  final AdminMovie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: ListTile(
        leading: movie.posterUrl != null
            ? Image.network(
                movie.posterUrl!,
                width: 48,
                height: 72,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.movie, size: 48),
        title: Text(
          movie.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          movie.genres.isNotEmpty ? movie.genres.join(', ') : '-',
        ),
        trailing: Wrap(
          spacing: AppSpacing.sm,
          children: [
            Switch(
              value: movie.isFeatured,
              onChanged: (bool value) {
                ref.read(adminProvider.notifier).toggleFeature(
                      id: movie.id,
                      featured: value,
                    );
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/admin/movies/form',
                  arguments: movie,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final bool? confirmed = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Konfirmasi Hapus'),
                    content: Text('Hapus film "${movie.title}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Hapus'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && context.mounted) {
                  await ref.read(adminProvider.notifier).deleteMovie(
                        id: movie.id,
                      );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
