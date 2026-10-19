// Implementasi repository fitur diary terhadap endpoint backend.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/app_providers.dart';
import '../domain/diary_models.dart';
import '../domain/diary_repository.dart';
import 'diary_model.dart';

/// Menyediakan [DiaryRepository] lewat container Riverpod.
final Provider<DiaryRepository> diaryRepositoryProvider =
    Provider<DiaryRepository>((Ref ref) {
      return DiaryRepositoryImpl(ref.watch(apiClientProvider));
    });

/// Memanggil endpoint diary untuk riwayat tontonan.
class DiaryRepositoryImpl implements DiaryRepository {
  const DiaryRepositoryImpl(this.apiClient);

  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  final ApiClient apiClient;

  @override
  Future<List<DiaryDay>> fetchDiary({
    DateTime? from,
    DateTime? to,
    int? tagId,
  }) {
    return _guard(() async {
      final Map<String, Object?> params = <String, Object?>{};
      if (from != null) params['from'] = _dateFormat.format(from);
      if (to != null) params['to'] = _dateFormat.format(to);
      if (tagId != null) params['tag_id'] = tagId;

      final Response<Map<String, dynamic>> response = await apiClient.raw
          .get<Map<String, dynamic>>('/diary', queryParameters: params);
      return diaryDaysFrom(response.data?['data']);
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
