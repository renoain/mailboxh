// Model data fitur profile, dipakai oleh domain dan presentation.

/// Profil user yang login.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.username = '',
    this.bio,
    this.stats,
    this.avatarUrl,
    this.role,
    this.createdAt,
  });

  final int id;
  final String name;
  final String email;
  final String username;
  final String? bio;
  final UserStats? stats;
  final String? avatarUrl;
  final String? role;
  final DateTime? createdAt;

  UserProfile copyWith({
    int? id,
    String? name,
    String? email,
    String? username,
    String? bio,
    UserStats? stats,
    String? avatarUrl,
    String? role,
    DateTime? createdAt,
  }) =>
      UserProfile(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        username: username ?? this.username,
        bio: bio ?? this.bio,
        stats: stats ?? this.stats,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        role: role ?? this.role,
        createdAt: createdAt ?? this.createdAt,
      );

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final String email = json['email'] as String? ?? '';
    final String username = json['username'] as String? ??
        (email.contains('@') ? email.split('@').first : (json['name'] as String? ?? ''));
    return UserProfile(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: email,
      username: username,
      bio: json['bio'] as String?,
      stats: json['stats'] != null
          ? UserStats.fromJson(Map<String, dynamic>.from(json['stats'] as Map))
          : null,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'] as String),
    );
  }
}

/// Statistik ringkasan profil user.
class UserStats {
  const UserStats({
    required this.totalWatched,
    required this.totalWatchlist,
    required this.totalReviews,
    this.totalDiary = 0,
    this.totalLikes = 0,
    this.totalLists = 0,
    this.totalFollowers = 0,
    this.totalFollowing = 0,
    this.averageRating = 0.0,
    this.thisYearCount = 0,
  });

  final int totalWatched;
  final int totalWatchlist;
  final int totalReviews;
  final int totalDiary;
  final int totalLikes;
  final int totalLists;
  final int totalFollowers;
  final int totalFollowing;
  final double averageRating;
  final int thisYearCount;

  factory UserStats.fromJson(Map<String, dynamic> json) => UserStats(
        totalWatched: json['total_watched'] as int? ?? 0,
        totalWatchlist: json['total_watchlist'] as int? ?? 0,
        totalReviews: json['total_reviews'] as int? ?? 0,
        totalDiary: json['total_diary'] as int? ?? 0,
        totalLikes: json['total_likes'] as int? ?? 0,
        totalLists: json['total_lists'] as int? ?? 0,
        totalFollowers: json['total_followers'] as int? ?? 0,
        totalFollowing: json['total_following'] as int? ?? 0,
        averageRating: (json['average_rating'] as num? ?? 0).toDouble(),
        thisYearCount: json['this_year'] as int? ?? 0,
      );
}

/// Alias kompatibilitas untuk statistik profil.
typedef ProfileStats = UserStats;

/// Film dalam four favourites.
class FavoriteFilm {
  const FavoriteFilm({
    required this.position,
    required this.movie,
  });

  final int position;
  final Movie movie;

  factory FavoriteFilm.fromJson(Map<String, dynamic> json) => FavoriteFilm(
        position: json['position'] as int? ?? 0,
        movie: Movie.fromJson(Map<String, dynamic>.from(json['movie'] as Map)),
      );
}

/// Film untuk watchlist, diary, dan daftar terkait.
class Movie {
  const Movie({
    required this.id,
    required this.title,
    this.posterUrl,
    this.backdropUrl,
    this.releaseDate,
    this.runtime,
    this.genres = const <String>[],
  });

  final int id;
  final String title;
  final String? posterUrl;
  final String? backdropUrl;
  final String? releaseDate;
  final int? runtime;
  final List<String> genres;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json['id'] as int? ?? json['movie_id'] as int? ?? 0,
        title: json['title'] as String? ?? '',
        posterUrl: json['poster_url'] as String? ?? json['poster_path'] as String?,
        backdropUrl: json['backdrop_url'] as String? ?? json['backdrop_path'] as String?,
        releaseDate: json['release_date'] as String?,
        runtime: json['runtime'] as int?,
        genres: (json['genres'] as List? ?? const <dynamic>[])
            .map((dynamic g) {
              if (g is Map && g.containsKey('name')) {
                return g['name'].toString();
              }
              return g.toString();
            })
            .toList(),
      );
}

/// Entri diary.
class DiaryEntry {
  const DiaryEntry({
    required this.id,
    required this.movie,
    this.userRating,
    this.userReview,
    this.createdAt,
  });

  final int id;
  final Movie movie;
  final double? userRating;
  final String? userReview;
  final DateTime? createdAt;

  factory DiaryEntry.fromJson(Map<String, dynamic> json) => DiaryEntry(
        id: json['id'] as int? ?? 0,
        movie: Movie.fromJson(
            Map<String, dynamic>.from(json['movie'] as Map? ?? <String, dynamic>{})),
        userRating: json['user_rating'] == null
            ? null
            : (json['user_rating'] as num).toDouble(),
        userReview: json['user_review'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.tryParse(json['created_at'] as String),
      );
}

/// Item review.
class ReviewItem {
  const ReviewItem({
    required this.id,
    required this.movie,
    required this.userName,
    required this.rating,
    this.content,
    this.likesCount = 0,
    this.isLiked = false,
    this.updatedAt,
  });

  final int id;
  final Movie movie;
  final String userName;
  final int rating;
  final String? content;
  final int likesCount;
  final bool isLiked;
  final DateTime? updatedAt;

  factory ReviewItem.fromJson(Map<String, dynamic> json) => ReviewItem(
        id: json['id'] as int,
        movie: Movie.fromJson(
            Map<String, dynamic>.from(json['movie'] as Map? ?? <String, dynamic>{})),
        userName: json['user_name'] as String? ?? '',
        rating: json['rating'] as int? ?? 0,
        content: json['content'] as String?,
        likesCount: json['likes_count'] as int? ?? 0,
        isLiked: json['is_liked'] as bool? ?? false,
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.tryParse(json['updated_at'] as String),
      );
}

/// List milik user.
class UserList {
  const UserList({
    required this.id,
    required this.title,
    this.description,
    required this.itemCount,
    this.likesCount = 0,
    this.isLiked = false,
    this.canEdit = false,
    this.createdAt,
  });

  final int id;
  final String title;
  final String? description;
  final int itemCount;
  final int likesCount;
  final bool isLiked;
  final bool canEdit;
  final DateTime? createdAt;

  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
        itemCount: json['item_count'] as int? ?? 0,
        likesCount: json['likes_count'] as int? ?? 0,
        isLiked: json['is_liked'] as bool? ?? false,
        canEdit: json['can_edit'] as bool? ?? false,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.tryParse(json['created_at'] as String),
      );
}

/// Ringkasan user untuk following / followers.
class UserBrief {
  const UserBrief({
    required this.id,
    required this.name,
    this.isFollowing = false,
  });

  final int id;
  final String name;
  final bool isFollowing;

  factory UserBrief.fromJson(Map<String, dynamic> json) => UserBrief(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        isFollowing: json['is_following'] as bool? ?? false,
      );
}

/// Tag.
class Tag {
  const Tag({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
      );
}
