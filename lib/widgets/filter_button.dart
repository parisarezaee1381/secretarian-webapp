import 'package:flutter/material.dart';

import 'package:flutter_application_1/domain/documents.dart';

import 'buttons.dart';

/// Multi-select row of document-type filter buttons (صادره / وارده / قرارداد).
///
/// The `DocumentType` enum itself lives with the domain model in
/// `documents.dart`; this file only owns the UI.
///
/// This is a controlled widget: [selected] is the single source of truth and
/// `onChanged` reports the next set. It keeps no internal copy, so a caller
/// that resets filters (a "clear filters" action, a deleted chip) is reflected
/// on the next build with no extra bookkeeping.
class DocumentTypeFilterButtons extends StatelessWidget {
  const DocumentTypeFilterButtons({
    super.key,
    required this.selected,
    this.onChanged,
  });

  /// The currently selected types. Never mutated by this widget.
  final Set<DocumentType> selected;

  /// Called with a new set on every toggle. Without it the row is inert.
  final ValueChanged<Set<DocumentType>>? onChanged;

  void _toggle(DocumentType type) {
    // Hand out a copy: the caller stores this set and may mutate it later, so
    // it must never alias the set passed in through [selected].
    final next = {...selected};

    if (next.contains(type)) {
      next.remove(type);
    } else {
      next.add(type);
    }

    onChanged?.call(next);
  }

  Widget _buildButton(DocumentType type) {
    final isSelected = selected.contains(type);

    return Semantics(
      toggled: isSelected,
      child: CustomButton(
        label: type.label,
        type: isSelected ? ButtonType.primary : ButtonType.secondary,
        width: 200,
        onPressed: () => _toggle(type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Wrapping instead of a fixed Row: 3 × 200 + 2 × 64 = 728px would
    // overflow narrow windows — the buttons stack instead.
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 64,
      runSpacing: 16,
      children: [
        _buildButton(DocumentType.outgoing),
        _buildButton(DocumentType.incoming),
        _buildButton(DocumentType.contract),
      ],
    );
  }
}
