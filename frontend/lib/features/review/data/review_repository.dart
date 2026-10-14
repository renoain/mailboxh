// Implementasi repository fitur review.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/review_repository.dart';

/// Menyediakan [ReviewRepository] lewat container Riverpod.
final Provider<ReviewRepository> reviewRepositoryProvider =
    Provider<ReviewRepository>((Ref ref) {
  ref.watch(apiClientProvider);
  throw UnimplementedError(
    'Endpoint fitur review belum ada.',
  );
});
