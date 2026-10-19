// Model data murni untuk fitur diary.

import '../../catalog/domain/movie_models.dart';

/// Tag ringkas yang menempel pada satu entri diary.
class DiaryTag {
  const DiaryTag({required this.id, required this.name});

  final int id;
  final String name;
}

/// Satu entri tontonan yang tercatat di diary.
class DiaryEntry {
  const DiaryEntry({
    required this.id,
    required this.movie,
    required this.watchedDate,
    this.note,
    this.rating,
    this.content,
    this.tags = const <DiaryTag>[],
  });

  final int id;
  final Movie movie;
  final DateTime watchedDate;
  final String? note;
  final int? rating;
  final String? content;
  final List<DiaryTag> tags;
}

/// Sekelompok entri diary pada satu tanggal tonton.
class DiaryDay {
  const DiaryDay({required this.date, required this.entries});

  final DateTime date;
  final List<DiaryEntry> entries;
}
