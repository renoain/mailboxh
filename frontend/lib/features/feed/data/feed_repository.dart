// Implementasi repository fitur feed.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/feed_repository.dart';

/// Menyediakan [FeedRepository] lewat container Riverpod.
final Provider<FeedRepository> feedRepositoryProvider =
    Provider<FeedRepository>((Ref ref) {
  ref.watch(apiClientProvider);
  throw UnimplementedError(
    'Endpoint fitur feed belum ada.',
  );
});
