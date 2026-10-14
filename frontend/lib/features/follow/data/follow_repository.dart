// Implementasi repository fitur follow.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/follow_repository.dart';

/// Menyediakan [FollowRepository] lewat container Riverpod.
final Provider<FollowRepository> followRepositoryProvider =
    Provider<FollowRepository>((Ref ref) {
  ref.watch(apiClientProvider);
  throw UnimplementedError(
    'Endpoint fitur follow belum ada.',
  );
});
