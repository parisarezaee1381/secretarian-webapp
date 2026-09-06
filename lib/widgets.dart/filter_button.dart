import 'package:flutter/material.dart';

import 'buttons.dart';

enum DocumentType { outgoing, incoming, contract }

extension DocumentTypeLabel on DocumentType {
  String get label {
    switch (this) {
      case DocumentType.outgoing:
        return 'صادره';
      case DocumentType.incoming:
        return 'وارده';
      case DocumentType.contract:
        return 'قرارداد';
    }
  }
}

class DocumentTypeFilterButtons extends StatefulWidget {
  const DocumentTypeFilterButtons({
    super.key,
    this.initialSelected = const {},
    this.onChanged,
  });

  final Set<DocumentType> initialSelected;

  final ValueChanged<Set<DocumentType>>? onChanged;

  @override
  State<DocumentTypeFilterButtons> createState() =>
      _DocumentTypeFilterButtonsState();
}

class _DocumentTypeFilterButtonsState extends State<DocumentTypeFilterButtons> {
  late Set<DocumentType> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {...widget.initialSelected};
  }

  void _toggle(DocumentType type) {
    setState(() {
      if (_selected.contains(type)) {
        _selected.remove(type);
      } else {
        _selected.add(type);
      }
    });

    widget.onChanged?.call(_selected);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          label: DocumentType.outgoing.label,
          type: _selected.contains(DocumentType.outgoing)
              ? ButtonType.primary
              : ButtonType.secondary,
          width: 200,
          onPressed: () => _toggle(DocumentType.outgoing),
        ),

        const SizedBox(width: 64),

        CustomButton(
          label: DocumentType.incoming.label,
          type: _selected.contains(DocumentType.incoming)
              ? ButtonType.primary
              : ButtonType.secondary,
          width: 200,
          onPressed: () => _toggle(DocumentType.incoming),
        ),

        const SizedBox(width: 64),

        CustomButton(
          label: DocumentType.contract.label,
          type: _selected.contains(DocumentType.contract)
              ? ButtonType.primary
              : ButtonType.secondary,
          width: 200,
          onPressed: () => _toggle(DocumentType.contract),
        ),
      ],
    );
  }
}
