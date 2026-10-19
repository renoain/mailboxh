// Kontrak repository fitur incoming.

abstract class IncomingRepository {
  const IncomingRepository();
  Future<List<Map<String, dynamic>>> getNotifications();
  Future<void> markAllRead();
}
