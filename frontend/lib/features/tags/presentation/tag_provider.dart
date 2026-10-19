// State fitur tag: daftar tag user dan pembuatan tag baru.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../data/tag_repository.dart';
import '../domain/tag_models.dart';

/// Daftar tag milik user.
final FutureProvider<List<Tag>> tagsProvider = FutureProvider<List<Tag>>(
  (Ref ref) => ref.watch(tagRepositoryProvider).fetchTags(),
);

/// Membuat tag baru lalu menyegarkan daftar tag.
class TagCreateController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Membuat tag bernama [name]. Nama yang sudah ada diabaikan.
  Future<void> create(String name) async {
    try {
      await ref.read(tagRepositoryProvider).createTag(name);
    } on ConflictException {
      // Tag sudah ada, pilihan lokal tetap dipakai.
    } on AppException {
      // Gagal membuat tag tidak membatalkan pilihan lokal.
    }
    ref.invalidate(tagsProvider);
  }
}

/// Pembuat tag baru.
final AsyncNotifierProvider<TagCreateController, void> tagCreateProvider =
    AsyncNotifierProvider<TagCreateController, void>(TagCreateController.new);
