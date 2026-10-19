// Fake bersama untuk test frontend.

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:mailboxh/core/services/onboarding_storage.dart';
import 'package:mailboxh/core/services/token_storage.dart';
import 'package:mailboxh/features/catalog/domain/movie_models.dart';
import 'package:mailboxh/features/catalog/domain/movie_repository.dart';
import 'package:mailboxh/features/diary/domain/diary_models.dart';
import 'package:mailboxh/features/diary/domain/diary_repository.dart';
import 'package:mailboxh/features/log/domain/log_models.dart';
import 'package:mailboxh/features/log/domain/log_repository.dart';
import 'package:mailboxh/features/review/domain/review_models.dart';
import 'package:mailboxh/features/review/domain/review_repository.dart';
import 'package:mailboxh/features/tags/domain/tag_models.dart';
import 'package:mailboxh/features/tags/domain/tag_repository.dart';

/// Token storage palsu berbasis memori untuk test.
class FakeTokenStorage implements TokenStorage {
  String? token;

  @override
  Future<String?> read() async => token;

  @override
  Future<String?> readRefresh() async => null;

  @override
  Future<void> save(String value) async {
    token = value;
  }

  @override
  Future<void> saveRefresh(String value) async {}

  @override
  Future<bool> hasToken() async => token != null;

  @override
  Future<void> clear() async {
    token = null;
  }
}

/// Onboarding storage palsu untuk test.
class FakeOnboardingStorage implements OnboardingStorage {
  bool seen = true;

  @override
  Future<bool> hasSeen() async => seen;

  @override
  Future<void> markSeen() async {
    seen = true;
  }
}

/// Repository katalog palsu untuk widget test.
class FakeMovieRepository implements MovieRepository {
  FakeMovieRepository({HomeData? home, MoviePage? page})
    : home =
          home ??
          const HomeData(
            featured: <Movie>[],
            latest: <Movie>[],
            topRated: <Movie>[],
            mostWatched: <Movie>[],
            mostWatchlisted: <Movie>[],
            explore: <Movie>[],
          ),
      page =
          page ??
          const MoviePage(movies: <Movie>[], page: 1, perPage: 20, total: 0);

  final HomeData home;
  final MoviePage page;

  @override
  Future<HomeData> fetchHome() async => home;

  @override
  Future<MoviePage> fetchMovies({
    String? query,
    MovieSort sort = MovieSort.latest,
    int page = 1,
  }) async => this.page;
}

/// Repository log palsu yang merekam draft terakhir.
class FakeLogRepository implements LogRepository {
  LogDraft? lastDraft;

  @override
  Future<void> submit(LogDraft draft) async {
    lastDraft = draft;
  }
}

/// Repository diary palsu yang mengembalikan daftar hari tetap.
class FakeDiaryRepository implements DiaryRepository {
  FakeDiaryRepository({this.days = const <DiaryDay>[]});

  final List<DiaryDay> days;

  @override
  Future<List<DiaryDay>> fetchDiary({
    DateTime? from,
    DateTime? to,
    int? tagId,
  }) async => days;
}

/// Repository review palsu yang merekam rating terakhir.
class FakeReviewRepository implements ReviewRepository {
  int? lastRating;

  @override
  Future<Review> createReview({
    required int movieId,
    required int rating,
    String? content,
  }) async {
    lastRating = rating;
    return Review(id: 1, movieId: movieId, rating: rating, content: content);
  }
}

/// Repository tag palsu dengan daftar tag dan riwayat pembuatan.
class FakeTagRepository implements TagRepository {
  FakeTagRepository({this.tags = const <Tag>[]});

  final List<Tag> tags;
  final List<String> created = <String>[];

  @override
  Future<List<Tag>> fetchTags() async => tags;

  @override
  Future<Tag> createTag(String name) async {
    created.add(name);
    return Tag(id: created.length, name: name);
  }
}

/// Adapter HTTP palsu yang selalu menjawab dengan [statusCode] dan [body].
class FakeHttpClientAdapter implements HttpClientAdapter {
  FakeHttpClientAdapter(this.body, {this.statusCode = 200});

  final Map<String, dynamic> body;
  final int statusCode;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
