// Kontrak repository fitur diary.

import 'diary_models.dart';

/// Kontrak akses data untuk riwayat tontonan.
abstract class DiaryRepository {
  const DiaryRepository();

  /// Mengambil entri diary yang dikelompokkan per tanggal tonton.
  Future<List<DiaryDay>> fetchDiary({DateTime? from, DateTime? to, int? tagId});
}
