// Implementasi repository fitur watched.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/watched_repository.dart';

final Provider<WatchedRepository> watchedRepositoryProvider =
    Provider<WatchedRepository>((Ref ref) {
  return WatchedRepositoryImpl(ref.watch(apiClientProvider));
});

class WatchedRepositoryImpl implements WatchedRepository {
  const WatchedRepositoryImpl(this.apiClient);
  final dynamic apiClient;

  @override
  Future<List<Map<String, dynamic>>> getWatched() async {
    final response = await apiClient.raw.get<Map<String, dynamic>>('/watched');
    final data = response.data?['data'] as List? ?? <dynamic>[];
    return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
}
