// Halaman kelola genre admin.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../admin_provider.dart';
import '../../domain/admin_models.dart';

/// Menampilkan daftar genre dengan input tambah dan tombol hapus.
class AdminGenresPage extends StatefulWidget {
  const AdminGenresPage({super.key});

  @override
  State<AdminGenresPage> createState() => _AdminGenresPageState();
}

class _AdminGenresPageState extends State<AdminGenresPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final AdminState state = ref.watch(adminProvider);

        return Scaffold(
          appBar: AppBar(title: const Text('Kelola Genre')),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Nama Genre Baru',
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          FilledButton(
                            onPressed: state.isLoading
                                ? null
                                : () async {
                                    final bool success =
                                        await ref.read(
                                              adminProvider.notifier,
                                            ).createGenre(
                                              name: _nameController.text,
                                            );
                                    if (success && mounted) {
                                      _nameController.clear();
                                    }
                                  },
                            child: const Text('Tambah'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: state.genres.isEmpty
                          ? const Center(child: Text('Belum ada genre.'))
                          : ListView.builder(
                              itemCount: state.genres.length,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                final AdminGenre genre = state.genres[index];
                                return ListTile(
                                  title: Text(genre.name),
                                  trailing: IconButton(
                                    icon: const Icon(
                                        Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      final bool? confirmed =
                                          await showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text(
                                              'Konfirmasi Hapus'),
                                          content: Text(
                                              'Hapus genre "${genre.name}"?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text('Hapus'),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirmed == true &&
                                          context.mounted) {
                                        await ref.read(
                                              adminProvider.notifier,
                                            ).deleteGenre(
                                              id: genre.id,
                                            );
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
      );
    });
  }
}
