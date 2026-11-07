import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'text_input.dart';
import 'package:flutter_application_1/data/database/database_service.dart';
import 'package:flutter_application_1/data/database/collections/letter_counter.dart';
import 'package:flutter_application_1/domain/documents.dart';
import 'package:flutter_application_1/core/theme.dart';

/// Issues letter numbers for newly saved documents.
///
/// Incoming and outgoing letters share one `'document'` counter; contracts
/// keep a separate `'contract'` counter. A fresh database continues the
/// historical numbering (letters start at 3886, contracts at 10).
///
/// The generator speaks the domain [DocumentType] directly, so there is no
/// second enum to keep in sync.
class LetterNumberGenerator {
  LetterNumberGenerator._internal();

  static final LetterNumberGenerator instance =
      LetterNumberGenerator._internal();

  /// First number handed out when no counter row exists yet.
  static const int _initialDocumentNumber = 3886;
  static const int _initialContractNumber = 10;

  String _suffixFor(DocumentType type) {
    switch (type) {
      case DocumentType.outgoing:
        return 'ص';
      case DocumentType.incoming:
        return 'و';
      case DocumentType.contract:
        return 'ق';
    }
  }

  /// The Isar counter row that two of the three document kinds share.
  String _counterTypeFor(DocumentType type) =>
      type == DocumentType.contract ? 'contract' : 'document';

  /// Seed value for a database that has no counter row for [type] yet.
  int _initialValueFor(DocumentType type) => type == DocumentType.contract
      ? _initialContractNumber
      : _initialDocumentNumber;

  /// The two-digit Jalali year suffix appended to every number.
  String _yearSuffix() =>
      (Jalali.now().year % 100).toString().padLeft(2, '0');

  /// Reads the number [generate] would hand out next **without reserving
  /// it** — used only to preview the value in a create form's field.
  Future<String> peekNextNumber(DocumentType type) async {
    final isar = await DatabaseService.instance.database;

    final counter = await isar.letterCounters
        .filter()
        .typeEqualTo(_counterTypeFor(type))
        .findFirst();

    final nextNumber =
        counter == null ? _initialValueFor(type) : counter.value + 1;

    return '$nextNumber/${_suffixFor(type)}/${_yearSuffix()}';
  }

  /// Atomically increments the counter for [type] and returns the reserved
  /// number. Runs in a write transaction, so two saves can never receive
  /// the same number.
  Future<String> generate(DocumentType type) async {
    final isar = await DatabaseService.instance.database;

    late int number;

    await isar.writeTxn(() async {
      var counter = await isar.letterCounters
          .filter()
          .typeEqualTo(_counterTypeFor(type))
          .findFirst();

      if (counter == null) {
        counter = LetterCounter()
          ..type = _counterTypeFor(type)
          ..value = _initialValueFor(type);
      } else {
        counter.value++;
      }

      number = counter.value;

      await isar.letterCounters.put(counter);
    });

    return '$number/${_suffixFor(type)}/${_yearSuffix()}';
  }
}

class LetterNumberField extends StatefulWidget {
  final TextEditingController controller;
  final DocumentType type;
  final String label;
  final double labelWidth;
  final double labelSpacing;
  final double fieldWidth;

  const LetterNumberField({
    super.key,
    required this.controller,
    required this.type,
    this.label = 'شماره نامه:',
    this.labelWidth = 150,
    this.labelSpacing = 0,
    this.fieldWidth = 548,
  });

  @override
  State<LetterNumberField> createState() => _LetterNumberFieldState();
}

class _LetterNumberFieldState extends State<LetterNumberField> {
  @override
  void initState() {
    super.initState();

    if (widget.controller.text.isEmpty) {
      _loadNextNumber();
    }
  }

  Future<void> _loadNextNumber() async {
    try {
      final number = await LetterNumberGenerator.instance.peekNextNumber(
        widget.type,
      );

      if (!mounted) return;

      if (widget.controller.text.isEmpty) {
        widget.controller.text = number;
      }
    } catch (error) {
      // Leave the field empty rather than crashing a create form; the save
      // path generates (and reserves) the real number anyway.
      debugPrint('letter number preview failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      labelText: widget.label,
      labelWidth: widget.labelWidth,
      labelSpacing: widget.labelSpacing,
      width: widget.fieldWidth,
      height: 64,
      enabled: false,
      colors: const AppTextFieldColors(
        disabled: AppColors.background,
        text: AppColors.text,
      ),
    );
  }
}
