// Keterangan sumber artwork dengan nama film tebal.

import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_typography.dart';

/// Menampilkan "Artwork dari <film>" di tengah.
class ArtworkCredit extends StatelessWidget {
  const ArtworkCredit({required this.film, super.key});

  static const AppText text = AppStrings.id;

  final String film;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextStyle base =
        AppTypography.labelSm.copyWith(color: scheme.onSurfaceVariant);
    return Text.rich(
      TextSpan(
        text: '${text.artworkFromPrefix} ',
        style: base,
        children: [
          TextSpan(
            text: film,
            style: base.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
