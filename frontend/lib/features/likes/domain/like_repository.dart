// Kontrak repository fitur likes.

abstract class LikeRepository {
  const LikeRepository();
  Future<void> like(int movieId);
  Future<void> unlike(int movieId);
}
