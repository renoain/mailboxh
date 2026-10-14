// Implementasi repository fitur members.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/member_repository.dart';

/// Menyediakan [MemberRepository] lewat container Riverpod.
final Provider<MemberRepository> memberRepositoryProvider =
    Provider<MemberRepository>((Ref ref) {
  ref.watch(apiClientProvider);
  throw UnimplementedError(
    'Endpoint fitur members belum ada.',
  );
});
