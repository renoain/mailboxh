// Kontrak repository fitur feed.

/// Kontrak akses data untuk fitur feed dan notifikasi.
abstract class FeedRepository {
  const FeedRepository();

  Future<List<Map<String, dynamic>>> getFeed();
  Future<List<Map<String, dynamic>>> getNotifications();
  Future<void> markNotificationRead(int id);
  Future<void> markAllNotificationsRead();
}
