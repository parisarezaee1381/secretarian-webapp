import 'package:flutter/material.dart';
import 'buttons.dart';
import 'text_input.dart';
import 'hoverablecontainer.dart';
import 'smart_date_field.dart';

class CustomModal extends StatefulWidget {
  const CustomModal({super.key});

  @override
  State<CustomModal> createState() => _CustomModalState();
}

class _CustomModalState extends State<CustomModal> {
  final _organizationController = TextEditingController();
  final _dateController = TextEditingController();
  final _followUpByController = TextEditingController();

  static const double _modalFieldWidth = 308;

  static const double _modalLabelWidth = 150;

  String? _dateError;
  String? _followUpByError;

  static const Color _errorColor = Color(0xFFA85838);

  @override
  void dispose() {
    _organizationController.dispose();
    _dateController.dispose();
    _followUpByController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool valid = true;
    setState(() {
      final dateDigits = _dateController.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (dateDigits.isEmpty || int.tryParse(dateDigits) == 0) {
        _dateError = 'لطفا این فیلد را پر کنید';
        valid = false;
      } else {
        _dateError = null;
      }
      if (_followUpByController.text.trim().isEmpty) {
        _followUpByError = 'لطفا این فیلد را پر کنید';
        valid = false;
      } else {
        _followUpByError = null;
      }
    });
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: 568,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Text(
                      'نیاز به پیگیری',
                      style: TextStyle(
                        color: Color(0xFF101018),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Estedad',
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: HoverableContainer(
                      width: 44,
                      height: 44,
                      hoverColor: const Color(0xFFBBBBC0),
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close, color: Color(0xFF101018)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: Color(0xFFBBBBC0)),
            const SizedBox(height: 24),
            // ردیف تاریخ پیگیری + خطا
            Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmartDateField(
                    controller: _dateController,
                    label: 'تاریخ پیگیری:',
                    fieldWidth: _modalFieldWidth,
                    labelWidth: _modalLabelWidth,
                  ),
                  if (_dateError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, right: _modalLabelWidth),
                      child: Text(
                        _dateError!,
                        style: const TextStyle(color: _errorColor, fontSize: 12, fontFamily: 'Estedad'),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    controller: _followUpByController,
                    labelText: 'پیگیری توسط:',
                    labelWidth: _modalLabelWidth,
                    labelSpacing: 0,
                    width: _modalFieldWidth,
                    height: 64,
                    errorText: _followUpByError,
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Estedad',
                    ),
                  ),
                  if (_followUpByError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, right: _modalLabelWidth),
                      child: Text(
                        _followUpByError!,
                        style: const TextStyle(color: _errorColor, fontSize: 12, fontFamily: 'Estedad'),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: CustomButton(
                label: 'تایید',
                type: ButtonType.primary,
                width: 204,
                height: 64,
                onPressed: () {
                  if (_validate()) {
                    Navigator.of(context).pop({
                      'organization': _organizationController.text,
                      'date': _dateController.text,
                      'followUpBy': _followUpByController.text,
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
