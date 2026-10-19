// Uji repository catalog terhadap respons backend palsu.

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mailboxh/core/services/api_client.dart';
import 'package:mailboxh/features/catalog/data/movie_repository.dart';
import 'package:mailboxh/features/catalog/domain/movie_models.dart';
import 'package:mailboxh/features/catalog/domain/movie_repository.dart';

import '../../helpers/fakes.dart';

Map<String, dynamic> _movieJson() => <String, dynamic>{
      'id': 3,
      'title': 'Judul Film',
      'overview': 'Sinopsis singkat.',
      'release_date': '2024-05-01',
      'poster_url': 'http://localhost/storage/poster.jpg',
      'backdrop_url': null,
      'runtime': 120,
      'genres': <Map<String, dynamic>>[
        <String, dynamic>{'id': 1, 'name': 'Drama'},
      ],
    };

MovieRepository _repository(FakeHttpClientAdapter adapter) {
  final Dio dio = Dio()..httpClientAdapter = adapter;
  return MovieRepositoryImpl(ApiClient(tokenStorage: FakeTokenStorage(), dio: dio));
}

void main() {
  test('fetchMovies mengembalikan daftar film dan paginator', () async {
    final FakeHttpClientAdapter adapter = FakeHttpClientAdapter(
      <String, dynamic>{
        'success': true,
        'data': <dynamic>[_movieJson()],
        'meta': <String, dynamic>{'page': 1, 'per_page': 20, 'total': 45},
      },
    );
    final MovieRepository repository = _repository(adapter);

    final MoviePage result = await repository.fetchMovies(query: 'Judul');

    expect(result.movies, hasLength(1));
    expect(result.movies.first.id, 3);
    expect(result.movies.first.genres.single.name, 'Drama');
    expect(result.hasNextPage, isTrue);
  });

  test('fetchHome mengembalikan enam section beranda', () async {
    final FakeHttpClientAdapter adapter = FakeHttpClientAdapter(
      <String, dynamic>{
        'success': true,
        'data': <String, dynamic>{
          'featured': <dynamic>[_movieJson()],
          'latest': <dynamic>[],
          'top_rated': <dynamic>[_movieJson()],
          'most_watched': <dynamic>[],
          'most_watchlisted': <dynamic>[],
          'explore': <dynamic>[],
        },
      },
    );
    final MovieRepository repository = _repository(adapter);

    final HomeData result = await repository.fetchHome();

    expect(result.featured.single.title, 'Judul Film');
    expect(result.topRated.single.releaseDate, DateTime(2024, 5, 1));
    expect(result.latest, isEmpty);
    expect(result.isEmpty, isFalse);
  });
}
