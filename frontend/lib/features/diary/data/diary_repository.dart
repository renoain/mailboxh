// Implementasi repository fitur diary.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/diary_repository.dart';

/// Menyediakan [DiaryRepository] lewat container Riverpod.
final Provider<DiaryRepository> diaryRepositoryProvider =
    Provider<DiaryRepository>((Ref ref) {
  ref.watch(apiClientProvider);
  throw UnimplementedError(
    'Endpoint fitur diary belum ada.',
  );
});
