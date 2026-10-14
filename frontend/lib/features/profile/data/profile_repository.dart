// Implementasi repository fitur profile.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/profile_repository.dart';

/// Menyediakan [ProfileRepository] lewat container Riverpod.
final Provider<ProfileRepository> profileRepositoryProvider =
    Provider<ProfileRepository>((Ref ref) {
  ref.watch(apiClientProvider);
  throw UnimplementedError(
    'Endpoint fitur profile belum ada.',
  );
});
