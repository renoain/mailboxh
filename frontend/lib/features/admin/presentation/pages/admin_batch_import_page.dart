// Halaman impor film massal lewat file ZIP untuk admin.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../admin_provider.dart';

class AdminBatchImportPage extends ConsumerStatefulWidget {
  const AdminBatchImportPage({super.key});

  @override
  ConsumerState<AdminBatchImportPage> createState() =>
      _AdminBatchImportPageState();
}

class _AdminBatchImportPageState extends ConsumerState<AdminBatchImportPage> {
  String? _zipPath;

  Future<void> _pickZip() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowedExtensions: ['zip'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _zipPath = result.files.single.path;
      });
    }
  }

  Future<void> _import() async {
    if (_zipPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih file ZIP terlebih dahulu')),
      );
      return;
    }
    await ref.read(adminNotifierProvider.notifier).importMoviesBatch(_zipPath!);
  }

  // ignore: invalid_override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminNotifierProvider);
    final scheme = Theme.of(context).colorScheme;
    final result = state.batchResult;

    return Scaffold(
      appBar: AppBar(title: const Text('Batch Import Film')),
      body: state.isLoading
          ? const LoadingIndicator(isFullScreen: true)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Impor Film Massal',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    'Unggah file ZIP yang berisi data film dan poster.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: scheme.outlineVariant,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _zipPath == null
                              ? Icons.cloud_upload
                              : Icons.check_circle,
                          size: 48,
                          color: scheme.primary,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          _zipPath == null
                              ? 'Pilih file ZIP'
                              : _zipPath!.split('/').last,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppButton(
                          label: 'Pilih File ZIP',
                          onPressed: _pickZip,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: 'Mulai Impor',
                    isLoading: state.isLoading,
                    onPressed: state.isLoading ? null : _import,
                  ),
                  if (result != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    const Text(
                      'Hasil Impor',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _resultRow('Berhasil', result.created.toString(),
                        AppColors.primaryLight),
                    _resultRow('Tidak Cocok', result.unmatched.toString(),
                        AppColors.warningLight),
                    _resultRow(
                        'Poster Tidak Cocok',
                        result.posterMismatch.toString(),
                        AppColors.errorLight),
                    if (result.message != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        result.message!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ],
                ],
              ),
            ),
    );
  }

  Widget _resultRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
