// Model data murni untuk fitur tag.

/// Tag pribadi milik user untuk menandai entri diary.
class Tag {
  const Tag({required this.id, required this.name, this.usageCount = 0});

  final int id;
  final String name;
  final int usageCount;
}
