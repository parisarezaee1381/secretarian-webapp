import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

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

  LetterNumberField({
    super.key,
    required this.controller,
    required this.type,
    this.label = 'شماره نامه:',
    this.labelWidth = 150,
    this.labelSpacing = 0,
  }) {
    if (controller.text.isEmpty) {
      controller.text = LetterNumberGenerator.instance.generate(type);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: labelWidth,
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFF101018),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Estedad',
            ),
          ),
        ),
        SizedBox(width: labelSpacing),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            return Text(
              value.text,
              style: const TextStyle(
                color: Color(0xFF101018),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Estedad',
              ),
            );
          },
        ),
      ],
    );
  }
}