// State fitur diary.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/diary_repository.dart';
import '../domain/diary_models.dart';

/// Riwayat tontonan user yang dikelompokkan per tanggal.
final FutureProvider<List<DiaryDay>> diaryProvider =
    FutureProvider<List<DiaryDay>>(
      (Ref ref) => ref.watch(diaryRepositoryProvider).fetchDiary(),
    );
