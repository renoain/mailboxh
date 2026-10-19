// Data contoh untuk tur pengenalan dan tab ulasan sebelum endpoint tersedia.

import 'package:flutter/material.dart';

/// Satu baris film contoh dengan rating dalam kelipatan setengah bintang.
class SampleFilm {
  const SampleFilm({
    required this.title,
    required this.year,
    this.rating = 0,
    this.liked = false,
    this.icon,
    this.day,
  });

  final String title;
  final int year;
  final double rating;
  final bool liked;
  final IconData? icon;
  final int? day;
}

/// Satu ulasan contoh untuk tab ulasan.
class SampleReview {
  const SampleReview({
    required this.film,
    required this.year,
    required this.user,
    required this.rating,
    required this.body,
    this.liked = false,
    this.footnote,
  });

  final String film;
  final int year;
  final String user;
  final double rating;
  final String body;
  final bool liked;
  final String? footnote;
}

abstract final class SampleContent {
  static const String diaryMonth = 'JANUARY 2016';

  static const List<SampleFilm> diary = [
    SampleFilm(
      day: 27,
      title: 'Only Lovers Left Alive',
      year: 2013,
      rating: 4.5,
      liked: true,
      icon: Icons.reorder,
    ),
    SampleFilm(
      day: 27,
      title: 'Blood Simple',
      year: 1984,
      rating: 4,
      liked: true,
      icon: Icons.sync,
    ),
    SampleFilm(
      day: 25,
      title: 'True Grit',
      year: 2010,
      rating: 4.5,
      liked: true,
      icon: Icons.sync,
    ),
    SampleFilm(
      day: 24,
      title: 'A Serious Man',
      year: 2009,
      rating: 5,
      liked: true,
      icon: Icons.sync,
    ),
    SampleFilm(
      day: 22,
      title: 'Kings of the Road',
      year: 1976,
      rating: 4.5,
      liked: true,
    ),
    SampleFilm(
      day: 22,
      title: 'City Lights',
      year: 1931,
      rating: 3.5,
      icon: Icons.reorder,
    ),
    SampleFilm(day: 21, title: 'Unfriended', year: 2014, rating: 2),
  ];

  static const String tourReviewUser = 'Matthew Buchanan';
  static const String tourReviewFilm = 'Drive';
  static const int tourReviewYear = 2011;
  static const String tourReviewWatched = 'Watched 11 Nov 2011';
  static const String tourReviewBody =
      'The tech writer John Gruber is fond of a Kubrick quote about the truth '
      'of a thing being in the feel of it rather than the think of it, a '
      'phrase that for me perfectly explains the appeal of Nicolas Winding '
      'Refn’s noirish adaptation of the James Sallis novel. Right from '
      'the first hotel room scene, through a near wordless 15-minute opening '
      'stanza, the foreboding atmosphere of an after-hours, back-streets Los '
      'Angeles takes hold. The ambient, minimal score by Cliff Martinez blends '
      'with deftly selected French electro-pop to deliver a moody, European '
      'sensibility that extends through the production design, colour palette '
      'and camera work. Flashes of sharp violence punctuate the film but are '
      'short-lived, like those in the fairy tales from which the director has '
      'drawn inspiration.';

  static const String tourActivityLiked = 'liked';
  static const String tourActivityLikedList = 'Kel\u2019s Female Filmmakers';
  static const String tourActivityReviewed = 'reviewed';
  static const String tourActivityListed = 'listed';
  static const String tourActivityOscar = '2016 Oscar Pool';
  static const String tourActivityOscarCount = '(57 films)';
  static const String tourActivityAge = '2d';
  static const String tourActivityReview =
      'Impressive for its obsessive focus on character\u2014really, the only '
      'thing that it has going on\u2014which manages to avoid devolving into '
      'explanation or even\u2026';
  static const List<String> tourActivityUsers = [
    'Mariel Mohns',
    'Jake Paul',
    'Lise',
    'Jonathan Paula',
  ];
  static const SampleFilm tourActivityFilm =
      SampleFilm(title: 'Only Lovers Left Alive', year: 2013, rating: 4.5);
  static const SampleFilm tourActivityFilmFaded =
      SampleFilm(title: 'Moulin Rouge!', year: 2001);

  static const String tourListOwner = 'Adrian Wills';
  static const String tourListTitle = '10 Reasons Sam Rockwell is Awesome';
  static const String tourListBody =
      'A somewhat unknown actor in the wider circles, Sam Rockwell has played '
      'some sweet roles and done a fine job no less. Suggestions welcome.';
  static const List<String> tourListFilms = [
    'Confessions',
    'Moon',
    'Choke',
    'Matchstick Men',
    'Hitchhiker’s Guide',
    'Jesse James',
    'Iron Man 2',
    'Cowboys & Aliens',
    'Charlie’s Angels',
    'The Hawk',
  ];

  static const List<SampleReview> reviews = [
    SampleReview(
      film: 'Digger',
      year: 2026,
      user: 'Anne',
      rating: 5,
      liked: true,
      body:
          'I loved this brilliant movie. It’s smart and trippy and '
          'aggressive and funny and ambitious. It’s worth making the time '
          'see and decide for yourself what you make of it.',
      footnote: 'For me? 10/10',
    ),
    SampleReview(
      film: 'Other Mommy',
      year: 2026,
      user: 'mak',
      rating: 2,
      body: 'you’re blatantly just not me mum',
    ),
    SampleReview(
      film: 'Digger',
      year: 2026,
      user: 'demi',
      rating: 5,
      liked: true,
      body: 'movies do not have the power to change the world',
    ),
    SampleReview(
      film: 'Digger',
      year: 2026,
      user: 'James',
      rating: 3.5,
      body: 'Better than expected, the second act drags a little.',
    ),
  ];
}
