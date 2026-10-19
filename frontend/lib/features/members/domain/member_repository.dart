// Kontrak repository fitur members.

abstract class MemberRepository {
  const MemberRepository();
  Future<List<Map<String, dynamic>>> getMembers({String? query});
}
