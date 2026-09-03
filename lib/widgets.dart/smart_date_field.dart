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
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length > 8) {
      digits = digits.substring(0, 8);
    }

    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);

      if ((i == 3 || i == 5) && i != digits.length - 1) {
        buffer.write('/');
      }
    }

    final text = buffer.toString();

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class SmartDateField extends StatelessWidget {
  SmartDateField({
    super.key,
    required this.controller,
    required this.label,
    this.isReadOnly = false,
    this.fieldWidth = 548,
    this.labelWidth = 150,
    this.labelSpacing = 0,
    this.responsive = true,
    this.mobileBreakpoint = 720,
  }) {
    // اگر فیلد فقط خواندنی است و مقدار ندارد،
    // تاریخ امروز شمسی را قرار می‌دهیم.
    if (isReadOnly && controller.text.isEmpty) {
      final today = Jalali.now();

      controller.text =
          '${today.year.toString().padLeft(4, '0')}/'
          '${today.month.toString().padLeft(2, '0')}/'
          '${today.day.toString().padLeft(2, '0')}';
    }
  }

  final TextEditingController controller;

  final String label;

  final bool isReadOnly;

  /// عرض فیلد؛ همان عرضی که AppTextField استفاده می‌کند.
  final double fieldWidth;

  /// عرض label در حالت دسکتاپ.
  final double labelWidth;

  /// فاصله label و فیلد.
  final double labelSpacing;

  /// فعال بودن responsive.
  final bool responsive;

  /// breakpoint موبایل.
  final double mobileBreakpoint;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelText: label,
      labelWidth: labelWidth,
      labelSpacing: labelSpacing,
      width: fieldWidth,
      height: 64,
      responsive: responsive,
      mobileBreakpoint: mobileBreakpoint,
      enabled: !isReadOnly,
      keyboardType: TextInputType.number,
      inputFormatters: isReadOnly
          ? null
          : <TextInputFormatter>[_JalaliSlashFormatter()],
      colors: isReadOnly
          ? const AppTextFieldColors(
              disabled: Color(0xFFF3F3F7),
              text: Color(0xFF101018),
            )
          : const AppTextFieldColors(),
    );
  }
}
