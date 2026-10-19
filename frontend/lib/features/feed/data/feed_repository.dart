// Implementasi repository fitur feed terhadap endpoint backend.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/feed_repository.dart';

/// Menyediakan [FeedRepository] lewat container Riverpod.
final Provider<FeedRepository> feedRepositoryProvider =
    Provider<FeedRepository>((Ref ref) {
  return FeedRepositoryImpl(ref.watch(apiClientProvider));
});

/// Memanggil endpoint feed dan notifications.
class FeedRepositoryImpl implements FeedRepository {
  const FeedRepositoryImpl(this.apiClient);

  final dynamic apiClient;

  @override
  Future<List<Map<String, dynamic>>> getFeed() async {
    final response = await apiClient.raw.get<Map<String, dynamic>>('/feed');
    final data = response.data?['data'] as List? ?? <dynamic>[];
    return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final response = await apiClient.raw.get<Map<String, dynamic>>('/notifications');
    final data = response.data?['data'] as List? ?? <dynamic>[];
    return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  @override
  Future<void> markNotificationRead(int id) async {
    await apiClient.raw.put<Map<String, dynamic>>('/notifications/$id/read');
  }

  @override
  Future<void> markAllNotificationsRead() async {
    await apiClient.raw.put<Map<String, dynamic>>('/notifications/read-all');
  }
}
