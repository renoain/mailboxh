// Model data murni untuk fitur log tontonan.

/// Data yang dikirim saat mencatat satu tontonan.
class LogDraft {
  const LogDraft({
    required this.movieId,
    this.watchedAt,
    this.note,
    this.rating,
    this.content,
    this.tags = const <String>[],
  });

  final int movieId;
  final DateTime? watchedAt;
  final String? note;
  final int? rating;
  final String? content;
  final List<String> tags;
}
