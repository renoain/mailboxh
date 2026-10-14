// Deretan chip untuk memfilter feed, incoming activity, dan tag.

import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Satu pilihan filter berupa label dan nilai yang dikembalikan.
class FilterOption<T> {
  const FilterOption({required this.label, required this.value});

  final String label;
  final T value;
}

/// Baris chip filter yang bisa digulir horizontal.
class ChipFilterRow<T> extends StatelessWidget {
  const ChipFilterRow({
    required this.options,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<FilterOption<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.touchTarget,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (BuildContext context, int index) {
          final FilterOption<T> option = options[index];
          return ChoiceChip(
            label: Text(option.label),
            selected: option.value == selected,
            onSelected: (_) => onSelected(option.value),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          );
        },
      ),
    );
  }
}