// Chip label untuk tag pada entri diary dan filter.

import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Menampilkan nama tag yang bisa dipilih atau dilepas.
class TagChip extends StatelessWidget {
  const TagChip({
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.onRemove,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return InputChip(
      label: Text(label),
      selected: isSelected,
      onPressed: onTap,
      onDeleted: onRemove,
      deleteIcon: const Icon(Icons.close, size: AppSpacing.twoXs),
      showCheckmark: isSelected,
      backgroundColor: scheme.surface,
      selectedColor: scheme.primaryContainer,
      side: BorderSide(
        color: isSelected ? scheme.primary : scheme.outlineVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
    );
  }
}