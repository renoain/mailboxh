// Pemilih tag untuk menandai entri diary.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/tag_chip.dart';
import '../../domain/tag_models.dart';
import '../tag_provider.dart';

/// Memilih tag yang sudah ada atau menambahkan tag baru.
class TagSelector extends ConsumerStatefulWidget {
  const TagSelector({
    required this.label,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final String label;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  @override
  ConsumerState<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends ConsumerState<TagSelector> {
  static const AppText text = AppStrings.id;

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add(String raw) {
    final String name = raw.trim();
    if (name.isEmpty) return;
    if (widget.selected.contains(name)) {
      _controller.clear();
      return;
    }
    if (widget.selected.length >= AppValues.maxTagsPerLog) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(text.logTagLimitReached)));
      return;
    }
    ref.read(tagCreateProvider.notifier).create(name);
    widget.onChanged(<String>[...widget.selected, name]);
    _controller.clear();
  }

  void _remove(String name) {
    widget.onChanged(
      widget.selected.where((String item) => item != name).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Tag> suggestions =
        ref.watch(tagsProvider).asData?.value ?? const <Tag>[];
    final List<Tag> available = suggestions
        .where((Tag tag) => !widget.selected.contains(tag.name))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTypography.labelLg),
        if (widget.selected.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              for (final String name in widget.selected)
                TagChip(
                  label: name,
                  isSelected: true,
                  onRemove: () => _remove(name),
                ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.done,
                onSubmitted: _add,
                decoration: InputDecoration(hintText: text.addTag),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton(
              onPressed: () => _add(_controller.text),
              icon: const Icon(Icons.add),
              tooltip: text.addTag,
            ),
          ],
        ),
        if (available.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              for (final Tag tag in available)
                TagChip(label: tag.name, onTap: () => _add(tag.name)),
            ],
          ),
        ],
      ],
    );
  }
}
