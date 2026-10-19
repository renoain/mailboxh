// Implementasi repository fitur incoming.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/incoming_repository.dart';

final Provider<IncomingRepository> incomingRepositoryProvider =
    Provider<IncomingRepository>((Ref ref) {
  return IncomingRepositoryImpl(ref.watch(apiClientProvider));
});

class IncomingRepositoryImpl implements IncomingRepository {
  const IncomingRepositoryImpl(this.apiClient);
  final dynamic apiClient;

  @override
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final response = await apiClient.raw.get<Map<String, dynamic>>('/notifications');
    final data = response.data?['data'] as List? ?? <dynamic>[];
    return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  @override
  Future<void> markAllRead() async {
    await apiClient.raw.put<Map<String, dynamic>>('/notifications/read-all');
  }
}
