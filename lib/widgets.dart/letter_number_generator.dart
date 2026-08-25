import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'text_input.dart';

enum LetterNumberType { outgoing, incoming, contract }

class LetterNumberGenerator {
  LetterNumberGenerator._internal();
  static final LetterNumberGenerator instance =
      LetterNumberGenerator._internal();

  int _outgoingIncomingCounter = 3200;

  int _contractCounter = 10;

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

  String generate(LetterNumberType type) {
    final year = (Jalali.now().year % 100).toString().padLeft(2, '0');

    late final int number;
    if (type == LetterNumberType.contract) {
      number = _contractCounter;
      _contractCounter++;
    } else {
      number = _outgoingIncomingCounter;
      _outgoingIncomingCounter++;
    }

    return '$number/${_suffixFor(type)}/$year';
  }
}

class LetterNumberField extends StatelessWidget {
  final TextEditingController controller;
  final LetterNumberType type;
  final String label;
  final double labelWidth;
  final double labelSpacing;
  final double fieldWidth;

  LetterNumberField({
    super.key,
    required this.controller,
    required this.type,
    this.label = 'شماره نامه:',
    this.labelWidth = 150,
    this.labelSpacing = 0,
    this.fieldWidth = 548,
  }) {

    if (controller.text.isEmpty) {
      controller.text = LetterNumberGenerator.instance.generate(type);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelText: label,
      labelWidth: labelWidth,
      labelSpacing: labelSpacing,
      width: fieldWidth,
      height: 64,
      enabled: false,
      colors: const AppTextFieldColors(
        disabled: Color(0xFFF3F3F7),
        text: Color(0xFF101018),
      ),
    );
  }
}