// Pemetaan respons endpoint diary ke model domain.

import '../../catalog/data/movie_model.dart';
import '../../catalog/domain/movie_models.dart';
import '../domain/diary_models.dart';

/// Mengubah daftar grup diary dari backend menjadi daftar [DiaryDay].
List<DiaryDay> diaryDaysFrom(dynamic data) {
  return ((data as List?) ?? const <dynamic>[]).map((dynamic group) {
    final Map<String, dynamic> map = Map<String, dynamic>.from(group as Map);
    final DateTime date =
        DateTime.tryParse(map['watched_date'] as String? ?? '') ??
        DateTime.now();
    final List<DiaryEntry> entries =
        ((map['items'] as List?) ?? const <dynamic>[])
            .map(
              (dynamic item) => diaryEntryFromJson(
                Map<String, dynamic>.from(item as Map),
                watchedDate: date,
              ),
            )
            .toList();
    return DiaryDay(date: date, entries: entries);
  }).toList();
}

/// Membaca satu item diary dengan tanggal tonton dari grupnya.
DiaryEntry diaryEntryFromJson(
  Map<String, dynamic> json, {
  required DateTime watchedDate,
}) {
  final dynamic movieJson = json['movie'];
  final Movie movie = movieJson is Map
      ? MovieModel.fromJson(Map<String, dynamic>.from(movieJson)).toEntity()
      : const Movie(id: 0, title: '');
  return DiaryEntry(
    id: json['id'] as int,
    movie: movie,
    watchedDate: watchedDate,
    note: json['note'] as String?,
    rating: (json['rating'] as num?)?.toInt(),
    content: json['content'] as String?,
    tags: ((json['tags'] as List?) ?? const <dynamic>[])
        .map(
          (dynamic item) => DiaryTag(
            id: (item as Map)['id'] as int,
            name: item['name'] as String,
          ),
        )
        .toList(),
  );
}
