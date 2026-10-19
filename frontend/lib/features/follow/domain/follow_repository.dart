// Kontrak repository fitur follow.

/// Kontrak akses data untuk fitur follow.
abstract class FollowRepository {
  const FollowRepository();

  Future<List<FollowUser>> getFollowers();

  Future<List<FollowUser>> getFollowing();

  Future<bool> toggleFollow(int userId);
}

/// Data user pada fitur follow.
class FollowUser {
  const FollowUser({
    required this.id,
    required this.name,
    required this.isFollowing,
  });

  final int id;
  final String name;
  final bool isFollowing;
}
