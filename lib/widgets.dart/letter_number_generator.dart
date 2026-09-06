import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'text_input.dart';
import 'package:flutter_application_1/database/database_service.dart';
import 'package:flutter_application_1/database/letter_counter.dart';

enum LetterNumberType { outgoing, incoming, contract }

class LetterNumberGenerator {
  LetterNumberGenerator._internal();

  static final LetterNumberGenerator instance =
      LetterNumberGenerator._internal();

  String _suffixFor(LetterNumberType type) {
    switch (type) {
      case LetterNumberType.outgoing:
        return 'ص';
      case LetterNumberType.incoming:
        return 'و';
      case LetterNumberType.contract:
        return 'ق';
    }
  }

  /// فقط شماره بعدی را برمی‌گرداند.
  /// این متد هیچ تغییری در Isar ایجاد نمی‌کند.
  Future<String> getNextNumber(LetterNumberType type) async {
    final isar = await DatabaseService.instance.database;

    final year = (Jalali.now().year % 100).toString().padLeft(2, '0');

    final counterType = type == LetterNumberType.contract
        ? 'contract'
        : 'document';

    final counter = await isar.letterCounters
        .filter()
        .typeEqualTo(counterType)
        .findFirst();

    final nextNumber = counter == null
        ? (type == LetterNumberType.contract ? 10 : 3200)
        : counter.value + 1;

    return '$nextNumber/${_suffixFor(type)}/$year';
  }

  /// شماره را واقعاً مصرف می‌کند و در Isar ثبت می‌کند.
  ///
  /// این متد باید فقط هنگام ذخیره نهایی نامه صدا زده شود.
  Future<String> generate(LetterNumberType type) async {
    final isar = await DatabaseService.instance.database;

    final year = (Jalali.now().year % 100).toString().padLeft(2, '0');

    final counterType = type == LetterNumberType.contract
        ? 'contract'
        : 'document';

    late int number;

    await isar.writeTxn(() async {
      var counter = await isar.letterCounters
          .filter()
          .typeEqualTo(counterType)
          .findFirst();

      if (counter == null) {
        counter = LetterCounter()
          ..type = counterType
          ..value = type == LetterNumberType.contract ? 10 : 3200;
      } else {
        counter.value++;
      }

      number = counter.value;

      await isar.letterCounters.put(counter);
    });

    return '$number/${_suffixFor(type)}/$year';
  }
}

class LetterNumberField extends StatefulWidget {
  final TextEditingController controller;
  final LetterNumberType type;
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
    final number = await LetterNumberGenerator.instance.getNextNumber(
      widget.type,
    );

    if (!mounted) return;

    if (widget.controller.text.isEmpty) {
      widget.controller.text = number;
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
        disabled: Color(0xFFF3F3F7),
        text: Color(0xFF101018),
      ),
    );
  }
}
