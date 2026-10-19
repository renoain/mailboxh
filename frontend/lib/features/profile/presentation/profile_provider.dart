// State manajemen fitur profile menggunakan Riverpod.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/profile_repository.dart';
import '../domain/profile_models.dart';
import '../domain/profile_repository.dart';

/// Kelola pemuatan profil user beserta statistik ringkasannya.
class ProfileNotifier extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() async {
    final ProfileRepository repository = ref.read(profileRepositoryProvider);
    final results = await Future.wait([
      repository.getProfile(),
      repository.getUserStats(),
    ]);

    final UserProfile profile = results[0] as UserProfile;
    final UserStats stats = results[1] as UserStats;
    return profile.copyWith(stats: stats);
  }

  /// Memuat ulang data profil dan statistik.
  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

/// Provider utama untuk profil dan statistik user.
final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, UserProfile>(ProfileNotifier.new);

/// Provider untuk mengambil daftar film yang sudah ditonton (tab FILMS).
final userFilmsProvider = FutureProvider<List<Movie>>((Ref ref) async {
  final ProfileRepository repository = ref.read(profileRepositoryProvider);
  return repository.getUserFilms();
});

/// Provider untuk mengambil statistik user secara mandiri.
final userStatsProvider = FutureProvider<UserStats>((Ref ref) async {
  final ProfileRepository repository = ref.read(profileRepositoryProvider);
  return repository.getUserStats();
});
