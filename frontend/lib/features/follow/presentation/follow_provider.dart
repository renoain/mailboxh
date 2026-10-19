// State fitur follow.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/follow_repository.dart';
import '../domain/follow_repository.dart';

/// State followers.
class FollowersNotifier extends AsyncNotifier<List<FollowUser>> {
  @override
  Future<List<FollowUser>> build() async {
    return ref.watch(followRepositoryProvider).getFollowers();
  }

  Future<void> toggle(int userId) async {
    final repo = ref.read(followRepositoryProvider);
    final result = await repo.toggleFollow(userId);
    state = AsyncData(
      state.value?.map((u) => u.id == userId ? FollowUser(id: u.id, name: u.name, isFollowing: result) : u).toList() ??
          <FollowUser>[],
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(followRepositoryProvider).getFollowers());
  }
}

final AsyncNotifierProvider<FollowersNotifier, List<FollowUser>> followersProvider =
    AsyncNotifierProvider<FollowersNotifier, List<FollowUser>>(FollowersNotifier.new);

/// State following.
class FollowingNotifier extends AsyncNotifier<List<FollowUser>> {
  @override
  Future<List<FollowUser>> build() async {
    return ref.watch(followRepositoryProvider).getFollowing();
  }

  Future<void> toggle(int userId) async {
    final repo = ref.read(followRepositoryProvider);
    final result = await repo.toggleFollow(userId);
    state = AsyncData(
      state.value?.map((u) => u.id == userId ? FollowUser(id: u.id, name: u.name, isFollowing: result) : u).toList() ??
          <FollowUser>[],
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(followRepositoryProvider).getFollowing());
  }
}

final AsyncNotifierProvider<FollowingNotifier, List<FollowUser>> followingProvider =
    AsyncNotifierProvider<FollowingNotifier, List<FollowUser>>(FollowingNotifier.new);
