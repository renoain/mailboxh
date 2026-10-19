// Halaman detail film.

import 'package:flutter/material.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({required this.tmdbId, super.key});

  final int tmdbId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Film')),
      body: Center(child: Text('Detail film ID: $tmdbId')),
    );
  }
}
