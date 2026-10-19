// Kontrak repository fitur tag.

import 'tag_models.dart';

/// Kontrak akses data untuk tag pribadi user.
abstract class TagRepository {
  const TagRepository();

  /// Mengambil seluruh tag milik user.
  Future<List<Tag>> fetchTags();

  /// Membuat tag baru. Nama yang sudah ada ditolak backend.
  Future<Tag> createTag(String name);
}
