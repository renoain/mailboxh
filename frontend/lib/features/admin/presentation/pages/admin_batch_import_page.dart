// Halaman impor batch film lewat file ZIP.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/theme/app_spacing.dart';
import '../admin_provider.dart';
import '../../domain/admin_models.dart';

/// Halaman upload ZIP dan tampilkan status impor.
class AdminBatchImportPage extends StatefulWidget {
  const AdminBatchImportPage({super.key});

  @override
  State<AdminBatchImportPage> createState() => _AdminBatchImportPageState();
}

class _AdminBatchImportPageState extends State<AdminBatchImportPage> {
  String? _zipPath;
  WidgetRef? _ref;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        _ref = ref;
        final AdminState state = ref.watch(adminProvider);
        final BatchImportResult? result = state.importResult;
        final bool importing = state.importLoading;

        return Scaffold(
          appBar: AppBar(title: const Text('Impor Batch Film')),
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih file ZIP yang berisi data film dan poster.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.folder),
                    label: const Text('Pilih File ZIP'),
                    onPressed: importing ? null : _pickZip,
                  ),
                ),
                if (_zipPath != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text('File: $_zipPath'),
                ],
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: importing || _zipPath == null ? null : _import,
                    child: importing
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Mulai Impor'),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (state.error != null) ...[
                  Text(
                    state.error!.message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                if (result != null) ...[
                  const Text('Hasil Impor',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.md),
                  _ResultRow(
                    label: 'Berhasil',
                    value: '${result.success}',
                    color: Colors.green,
                  ),
                  _ResultRow(
                    label: 'Gagal',
                    value: '${result.failed}',
                    color: Colors.red,
                  ),
                  _ResultRow(
                    label: 'Poster Tidak Cocok',
                    value: '${result.posterMismatch}',
                    color: Colors.orange,
                  ),
                  _ResultRow(
                    label: 'Total',
                    value: '${result.total}',
                    color: Colors.blue,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickZip() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.any,
        allowedExtensions: ['zip'],
      );
      if (result.isNotEmpty) {
        setState(() => _zipPath = result.single.path);
      }
    } catch (_) {
      // File picker tidak tersedia di platform ini
    }
  }

  Future<void> _import() async {
    if (_zipPath == null) return;
    await _ref!.read(adminProvider.notifier).importMoviesBatch(
          zipPath: _zipPath!,
        );
  }
}

/// Baris hasil impor dengan label dan nilai.
class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
