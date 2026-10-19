// Implementasi repository fitur members.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_providers.dart';
import '../domain/member_repository.dart';

final Provider<MemberRepository> memberRepositoryProvider =
    Provider<MemberRepository>((Ref ref) {
  return MemberRepositoryImpl(ref.watch(apiClientProvider));
});

class MemberRepositoryImpl implements MemberRepository {
  const MemberRepositoryImpl(this.apiClient);
  final dynamic apiClient;

  @override
  Future<List<Map<String, dynamic>>> getMembers({String? query}) async {
    final response = await apiClient.raw.get<Map<String, dynamic>>(
      '/members',
      queryParameters: query == null || query.isEmpty ? null : {'q': query},
    );
    final data = response.data?['data'] as List? ?? <dynamic>[];
    return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
}
