import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'text_input.dart';
import 'package:flutter_application_1/core/theme.dart';

/// Formats digits into `yyyy/MM/dd` Jalali order, inserting separators as
/// they are typed and removing them from pasted text.
///
/// Only digits are kept and there are at most 8 of them, so a fully typed
/// value is `1403/07/21` for 21 Tir 1403. The caret is mapped by digit
/// index, so editing inside the value does not teleport the cursor to the
/// end.
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
      selection: TextSelection.collapsed(
        offset: _caretOffsetForDigitCount(text, newValue),
      ),
    );
  }

  /// Translates the number of digits before the incoming selection into an
  /// offset in the re-slashed [text], keeping the caret beside the digit
  /// the user was editing instead of after the whole value.
  int _caretOffsetForDigitCount(String text, TextEditingValue newValue) {
    final selection = newValue.selection;
    // No selection yet (e.g. programmatic set): fall back to the end.
    if (!selection.isValid) return text.length;

    final digitsBeforeCaret = newValue.text
        .substring(0, selection.baseOffset.clamp(0, newValue.text.length))
        .replaceAll(RegExp(r'[^0-9]'), '')
        .length;

    // Walk the formatted text, counting non-separator characters, until we
    // reach the digit the caret followed.
    int counted = 0;
    for (int i = 0; i < text.length; i++) {
      if (counted == digitsBeforeCaret) return i;
      if (text[i] != '/') counted++;
    }
    return text.length;
  }
}

/// A text field for Jalali dates in `yyyy/MM/dd` order.
///
/// While typing (or when text is pasted in), the value is normalized to
/// digits-only plus separators, and the caret is kept beside the digit the
/// user was editing. When [isReadOnly] is true the field is disabled and,
/// if the [controller] is empty on mount, prefilled with today's Jalali
/// date — so letter dates default to the day the letter is being written.
class SmartDateField extends StatefulWidget {
  const SmartDateField({
    super.key,
    required this.controller,
    this.label,
    this.isReadOnly = false,
    this.fieldWidth = 548,
    this.labelWidth = 150,
    this.labelSpacing = 0,
    this.responsive = true,
    this.mobileBreakpoint = 720,
  });

  final TextEditingController controller;

  /// Rendered as the field's side label; `null` renders no label at all, so
  /// callers that label the field themselves (e.g. the filter panel) can pass
  /// nothing without reserving label space.
  final String? label;

  final bool isReadOnly;

  final double fieldWidth;

  final double labelWidth;

  final double labelSpacing;

  final bool responsive;

  final double mobileBreakpoint;

  @override
  State<SmartDateField> createState() => _SmartDateFieldState();
}

class _SmartDateFieldState extends State<SmartDateField> {
  @override
  void initState() {
    super.initState();

    // اگر فیلد فقط خواندنی است و مقدار ندارد،
    // تاریخ امروز شمسی را قرار می‌دهیم.
    if (widget.isReadOnly && widget.controller.text.isEmpty) {
      final today = Jalali.now();

      widget.controller.text =
          '${today.year.toString().padLeft(4, '0')}/'
          '${today.month.toString().padLeft(2, '0')}/'
          '${today.day.toString().padLeft(2, '0')}';
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
      responsive: widget.responsive,
      mobileBreakpoint: widget.mobileBreakpoint,
      enabled: !widget.isReadOnly,
      keyboardType: TextInputType.number,
      inputFormatters: widget.isReadOnly
          ? null
          : <TextInputFormatter>[_JalaliSlashFormatter()],
      colors: widget.isReadOnly
          ? const AppTextFieldColors(
              disabled: AppColors.background,
              text: AppColors.text,
            )
          : const AppTextFieldColors(),
    );
  }
}
