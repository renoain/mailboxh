// Halaman lists.

import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Halaman [ListDetailPage].
class ListDetailPage extends StatelessWidget {
  const ListDetailPage({super.key});

  static const AppText text = AppStrings.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(text.listDetailTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Center(
          child: Text(
            text.listDetailTitle,
            style: AppTypography.headlineSm,
          ),
        ),
      ),
    );
  }
}
