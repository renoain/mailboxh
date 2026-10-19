// Implementasi repository fitur log terhadap endpoint backend.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/app_providers.dart';
import '../domain/log_models.dart';
import '../domain/log_repository.dart';

/// Menyediakan [LogRepository] lewat container Riverpod.
final Provider<LogRepository> logRepositoryProvider = Provider<LogRepository>(
  (Ref ref) => LogRepositoryImpl(ref.watch(apiClientProvider)),
);

/// Mengirim satu tontonan ke endpoint log secara atomik.
class LogRepositoryImpl implements LogRepository {
  const LogRepositoryImpl(this.apiClient);

  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  final ApiClient apiClient;

  @override
  Future<void> submit(LogDraft draft) {
    return _guard(() async {
      final Map<String, Object?> data = <String, Object?>{
        'movie_id': draft.movieId,
        'watched_at': draft.watchedAt == null
            ? null
            : _dateFormat.format(draft.watchedAt!),
        'note': draft.note,
        'rating': draft.rating,
        'content': draft.content,
        if (draft.tags.isNotEmpty) 'tags': draft.tags,
      };
      await apiClient.raw.post<dynamic>('/log', data: data);
    });
  }

  /// Melempar [AppException] dari pemetaan error [ApiClient].
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      final Object? mapped = error.error;
      if (mapped is AppException) throw mapped;
      rethrow;
    }
  }
}
