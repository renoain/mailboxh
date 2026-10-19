// Halaman kelola genre untuk admin.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/admin_model.dart';
import '../admin_provider.dart';

class AdminGenresPage extends ConsumerStatefulWidget {
  const AdminGenresPage({super.key});

  @override
  ConsumerState<AdminGenresPage> createState() => _AdminGenresPageState();
}

class _AdminGenresPageState extends ConsumerState<AdminGenresPage> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createGenre() async {
    if (_nameController.text.isEmpty) return;
    await ref.read(adminNotifierProvider.notifier).createGenre(
      _nameController.text.trim(),
    );
    _nameController.clear();
  }

  Future<void> _deleteGenre(int id) async {
    await ref.read(adminNotifierProvider.notifier).deleteGenre(id);
  }

  // ignore: invalid_override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminNotifierProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Genre')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(adminNotifierProvider.notifier).loadGenres();
        },
        child: Column(
          children: [
            // Form tambah genre
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Nama Genre',
                      controller: _nameController,
                      onSubmitted: (_) => _createGenre(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  AppButton(
                    label: 'Tambah',
                    onPressed: _createGenre,
                  ),
                ],
              ),
            ),
            // Daftar genre
            Expanded(
              child: _buildList(context, ref, state, scheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    AdminState state,
    ColorScheme scheme,
  ) {
    if (state.isLoading && state.data == null) {
      return const LoadingIndicator(isFullScreen: true);
    }

    if (state.error != null && state.data == null) {
      return Center(
        child: Text(state.error!.message),
      );
    }

    final genres = state.data as List<AdminGenre>? ?? [];

    if (genres.isEmpty) {
      return const Center(child: Text('Belum ada genre.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: genres.length,
      itemBuilder: (context, index) {
        final genre = genres[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          title: Text(
            genre.name,
            style: AppTypography.labelLg.copyWith(
              color: scheme.onSurface,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, size: 20),
            onPressed: () => _deleteGenre(genre.id),
            color: scheme.error,
          ),
        );
      },
    );
  }
}
