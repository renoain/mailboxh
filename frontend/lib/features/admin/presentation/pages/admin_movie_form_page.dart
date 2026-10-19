// Halaman form tambah/ubah film untuk admin.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../admin_provider.dart';

class AdminMovieFormPage extends ConsumerStatefulWidget {
  const AdminMovieFormPage({this.movieId, super.key});

  final int? movieId;

  @override
  ConsumerState<AdminMovieFormPage> createState() =>
      _AdminMovieFormPageState();
}

class _AdminMovieFormPageState extends ConsumerState<AdminMovieFormPage> {
  final _titleController = TextEditingController();
  final _originalTitleController = TextEditingController();
  final _overviewController = TextEditingController();
  final _releaseDateController = TextEditingController();
  final _runtimeController = TextEditingController();
  final _languageController = TextEditingController();
  final _countryController = TextEditingController();
  final _castController = TextEditingController();
  final _crewController = TextEditingController();

  final List<int> _selectedGenreIds = [];
  bool _isFeatured = false;
  File? _posterFile;
  String? _posterPath;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickPoster() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _posterFile = File(picked.path);
        _posterPath = picked.path;
      });
    }
  }

  Future<void> _save() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul wajib diisi')),
      );
      return;
    }

    final notifier = ref.read(adminNotifierProvider.notifier);
    if (widget.movieId == null) {
      await notifier.createMovie(
        title: _titleController.text.trim(),
        originalTitle: _originalTitleController.text.trim().isEmpty
            ? null
            : _originalTitleController.text.trim(),
        overview: _overviewController.text.trim().isEmpty
            ? null
            : _overviewController.text.trim(),
        releaseDate: _parseDate(_releaseDateController.text),
        runtime: int.tryParse(_runtimeController.text),
        language: _languageController.text.trim().isEmpty
            ? null
            : _languageController.text.trim(),
        country: _countryController.text.trim().isEmpty
            ? null
            : _countryController.text.trim(),
        cast: _castController.text.trim().isEmpty
            ? null
            : _castController.text.trim(),
        crew: _crewController.text.trim().isEmpty
            ? null
            : _crewController.text.trim(),
        genreIds: _selectedGenreIds.isEmpty ? null : _selectedGenreIds,
        isFeatured: _isFeatured,
        posterPath: _posterPath,
      );
    } else {
      await notifier.updateMovie(
        id: widget.movieId!,
        title: _titleController.text.trim(),
        originalTitle: _originalTitleController.text.trim().isEmpty
            ? null
            : _originalTitleController.text.trim(),
        overview: _overviewController.text.trim().isEmpty
            ? null
            : _overviewController.text.trim(),
        releaseDate: _parseDate(_releaseDateController.text),
        runtime: int.tryParse(_runtimeController.text),
        language: _languageController.text.trim().isEmpty
            ? null
            : _languageController.text.trim(),
        country: _countryController.text.trim().isEmpty
            ? null
            : _countryController.text.trim(),
        cast: _castController.text.trim().isEmpty
            ? null
            : _castController.text.trim(),
        crew: _crewController.text.trim().isEmpty
            ? null
            : _crewController.text.trim(),
        genreIds: _selectedGenreIds.isEmpty ? null : _selectedGenreIds,
        isFeatured: _isFeatured,
      );
    }

    if (mounted) {
      context.pop();
    }
  }

  DateTime? _parseDate(String value) {
    if (value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  // ignore: invalid_override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminNotifierProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = AppStrings.of(Localizations.localeOf(context).languageCode);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movieId == null ? 'Tambah Film' : 'Ubah Film'),
      ),
      body: state.isLoading
          ? const LoadingIndicator(isFullScreen: true)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _pickPoster,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: scheme.outlineVariant,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: _posterFile != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(AppRadius.lg),
                                  child: Image.file(
                                    _posterFile!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    color: Colors.black54,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _posterFile = null;
                                          _posterPath = null;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo, size: 48),
                                SizedBox(height: AppSpacing.sm),
                                Text('Pilih poster film'),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomTextField(
                    label: text.detailTitle,
                    controller: _titleController,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CustomTextField(
                    label: 'Judul Asli',
                    controller: _originalTitleController,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CustomTextField(
                    label: 'Sinopsis',
                    controller: _overviewController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'Tahun Rilis (YYYY-MM-DD)',
                          controller: _releaseDateController,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: CustomTextField(
                          label: 'Durasi (menit)',
                          controller: _runtimeController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CustomTextField(
                    label: 'Bahasa',
                    controller: _languageController,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CustomTextField(
                    label: 'Negara',
                    controller: _countryController,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CustomTextField(
                    label: 'Cast',
                    controller: _castController,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CustomTextField(
                    label: 'Crew',
                    controller: _crewController,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Genre (ID)',
                        style: AppTypography.labelMd,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: _selectedGenreIds.map((id) {
                          return Chip(
                            label: Text(id.toString()),
                            onDeleted: () {
                              setState(() {
                                _selectedGenreIds.remove(id);
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton(
                        label: 'Tambah Genre ID',
                        variant: AppButtonVariant.plain,
                        onPressed: () {
                          setState(() {
                            _selectedGenreIds.add(_selectedGenreIds.length + 1);
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      const Text('Featured'),
                      const Spacer(),
                      Switch(
                        value: _isFeatured,
                        onChanged: (value) =>
                            setState(() => _isFeatured = value),
                        activeColor: AppColors.primaryLight,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: widget.movieId == null ? 'Simpan Film' : 'Perbarui Film',
                    isLoading: state.isLoading,
                    onPressed: state.isLoading ? null : _save,
                  ),
                ],
              ),
            ),
          );
    }

  @override
  void dispose() {
    _titleController.dispose();
    _originalTitleController.dispose();
    _overviewController.dispose();
    _releaseDateController.dispose();
    _runtimeController.dispose();
    _languageController.dispose();
    _countryController.dispose();
    _castController.dispose();
    _crewController.dispose();
    super.dispose();
  }
}

extension _LanguageCode on BuildContext {
  String get languageCode => Localizations.localeOf(this).languageCode;
}
