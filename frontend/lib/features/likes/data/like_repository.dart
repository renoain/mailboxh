// Implementasi repository fitur likes.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/like_repository.dart';

/// Menyediakan [LikeRepository] lewat container Riverpod.
final Provider<LikeRepository> likeRepositoryProvider =
    Provider<LikeRepository>((Ref ref) {
  ref.watch(apiClientProvider);
  throw UnimplementedError(
    'Endpoint fitur likes belum ada.',
  );
});
