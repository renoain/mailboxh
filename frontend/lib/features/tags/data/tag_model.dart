// Pemetaan respons endpoint tag ke model domain.

import '../domain/tag_models.dart';

/// Membaca satu tag dari JSON [TagResource].
Tag tagFromJson(Map<String, dynamic> json) {
  return Tag(
    id: json['id'] as int,
    name: json['name'] as String,
    usageCount: (json['usage_count'] as num?)?.toInt() ?? 0,
  );
}

/// Membaca daftar tag dari respons backend.
List<Tag> tagListFrom(dynamic data) {
  return ((data as List?) ?? const <dynamic>[])
      .map(
        (dynamic item) => tagFromJson(Map<String, dynamic>.from(item as Map)),
      )
      .toList();
}
