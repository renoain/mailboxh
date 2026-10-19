// Halaman form tambah film admin dengan upload poster.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_spacing.dart';
import '../admin_provider.dart';
import '../../domain/admin_models.dart';

/// Form input film dengan fitur upload poster lewat galeri.
class AdminMovieFormPage extends StatefulWidget {
  const AdminMovieFormPage({super.key});

  @override
  State<AdminMovieFormPage> createState() => _AdminMovieFormPageState();
}

class _AdminMovieFormPageState extends State<AdminMovieFormPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _overviewController = TextEditingController();
  final TextEditingController _releaseYearController =
      TextEditingController();
  final TextEditingController _runtimeController = TextEditingController();
  final TextEditingController _genreIdsController = TextEditingController();

  File? _posterFile;
  WidgetRef? _ref;

  @override
  void dispose() {
    _titleController.dispose();
    _overviewController.dispose();
    _releaseYearController.dispose();
    _runtimeController.dispose();
    _genreIdsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        _ref = ref;
        final AdminState state = ref.watch(adminProvider);

        return Scaffold(
          appBar: AppBar(title: const Text('Tambah Film')),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration:
                            const InputDecoration(labelText: 'Judul Film'),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextField(
                        controller: _overviewController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Sinopsis',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _releaseYearController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Tahun Rilis',
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: TextField(
                              controller: _runtimeController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Durasi (menit)',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextField(
                        controller: _genreIdsController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Genre IDs (pisah koma)',
                          hintText: 'Contoh: 1,2,3',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Text('Pilih Poster'),
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.image),
                          label: const Text('Pilih dari Galeri'),
                          onPressed: _pickImage,
                        ),
                      ),
                      if (_posterFile != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Image.file(
                          _posterFile!,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ],
                      if (state.error != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          state.error!.message,
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: state.isLoading ? null : _submit,
                          child: state.isLoading
                              ? const SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                )
                              : const Text('Simpan'),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final XFile? picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (picked != null && mounted) {
      setState(() => _posterFile = File(picked.path));
    }
  }

  Future<void> _submit() async {
    final List<int> genreIds = _genreIdsController.text
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .map((s) => int.tryParse(s.trim()) ?? 0)
        .where((id) => id > 0)
        .toList();

    final AdminMovie? movie =
        await _ref!.read(adminProvider.notifier).createMovie(
              title: _titleController.text,
              overview: _overviewController.text,
              releaseYear:
                  int.tryParse(_releaseYearController.text) ?? 0,
              runtime: int.tryParse(_runtimeController.text),
              genreIds: genreIds,
              posterPath: _posterFile?.path,
            );

    if (movie != null && mounted) {
      Navigator.pop(context);
    }
  }
}
