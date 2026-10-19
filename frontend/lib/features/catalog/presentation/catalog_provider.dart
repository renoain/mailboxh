// State fitur catalog.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/movie_repository.dart';
import '../domain/movie_models.dart';

/// Enam section beranda dalam satu snapshot.
final FutureProvider<HomeData> homeProvider = FutureProvider<HomeData>(
  (Ref ref) => ref.watch(movieRepositoryProvider).fetchHome(),
);

/// Daftar film per kombinasi query, urutan, dan halaman.
final moviesProvider = FutureProvider.family<MoviePage, MovieQuery>(
  (Ref ref, MovieQuery query) => ref.watch(movieRepositoryProvider).fetchMovies(
        query: query.query,
        sort: query.sort,
        page: query.page,
      ),
);
