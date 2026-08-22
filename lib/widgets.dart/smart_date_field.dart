import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'text_input.dart';

class _JalaliSlashFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 8) digits = digits.substring(0, 8);

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if ((i == 3 || i == 5) && i != digits.length - 1) {
        buffer.write('/');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class SmartDateField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isReadOnly;
  final double fieldWidth;
  final double labelWidth;

  SmartDateField({
    super.key,
    required this.controller,
    required this.label,
    this.isReadOnly = false,
    this.fieldWidth = 548,
    this.labelWidth = 150,
  }) {
    // فقط فیلدهای readonly به‌صورت خودکار با تاریخ امروز پر می‌شن.
    // فیلدهای قابل‌ویرایش (مثل «تاریخ ثبت») باید توسط کاربر دستی پر بشن.
    if (isReadOnly && controller.text.isEmpty) {
      final today = Jalali.now();
      controller.text =
          '${today.year.toString().padLeft(4, '0')}/'
          '${today.month.toString().padLeft(2, '0')}/'
          '${today.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelText: label,
      labelWidth: labelWidth,
      labelSpacing: 0,
      width: fieldWidth,
      height: 64,
      enabled: !isReadOnly,
      keyboardType: TextInputType.number,
      inputFormatters: isReadOnly ? null : [_JalaliSlashFormatter()],
      colors: isReadOnly
          ? const AppTextFieldColors(
              disabled: Color(0xFFF3F3F7),
              text: Color(0xFF101018),
            )
          : const AppTextFieldColors(),
    );
  }
}