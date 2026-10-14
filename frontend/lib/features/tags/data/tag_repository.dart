// Implementasi repository fitur tags.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/tag_repository.dart';

/// Menyediakan [TagRepository] lewat container Riverpod.
final Provider<TagRepository> tagRepositoryProvider =
    Provider<TagRepository>((Ref ref) {
  ref.watch(apiClientProvider);
  throw UnimplementedError(
    'Endpoint fitur tags belum ada.',
  );
});
