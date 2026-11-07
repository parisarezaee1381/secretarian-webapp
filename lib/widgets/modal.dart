import 'package:flutter/material.dart';

import 'buttons.dart';
import 'text_input.dart';
import 'hoverablecontainer.dart';
import 'smart_date_field.dart';
import 'package:flutter_application_1/domain/documents.dart';
import 'package:flutter_application_1/core/theme.dart';

/// What the user entered in [CustomModal]; popped on confirm. Dismissing
/// the dialog (close button or barrier) pops `null`.
@immutable
class FollowUpResult {
  const FollowUpResult({required this.date, required this.followUpBy});

  final String date;
  final String followUpBy;
}

class CustomModal extends StatefulWidget {
  const CustomModal({super.key});

  @override
  State<CustomModal> createState() => _CustomModalState();
}

class _CustomModalState extends State<CustomModal> {
  final _dateController = TextEditingController();
  final _followUpByController = TextEditingController();

  static const double _desktopModalWidth = 568;
  static const double _desktopFieldWidth = 308;
  static const double _desktopLabelWidth = 150;

  static const Color _errorColor = AppColors.error;

  String? _dateError;
  String? _followUpByError;

  @override
  void dispose() {
    _dateController.dispose();
    _followUpByController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool valid = true;

    setState(() {
      // Shared Jalali parser: rejects partial or non-numeric input, and a
      // run of zeros counts as "not filled in".
      final dateValue = jalaliToComparable(_dateController.text);

      if (dateValue == null || dateValue == 0) {
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

  Widget _buildErrorText(String? error) {
    if (error == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        error,
        style: const TextStyle(
          color: _errorColor,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildTitle(bool isMobile) {
    return SizedBox(
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 52),
            child: Text(
              'نیاز به پیگیری',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.text,
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Positioned(
            left: 0,
            child: HoverableContainer(
              width: 44,
              height: 44,
              hoverColor: AppColors.border,
              onTap: () => Navigator.of(context).pop(),
              semanticLabel: 'بستن',
              child: const Icon(Icons.close, color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({required bool isMobile, required double fieldWidth}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isMobile) ...[
          const Text(
            'تاریخ پیگیری:',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.text,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],

        SmartDateField(
          controller: _dateController,
          label: isMobile ? '' : 'تاریخ پیگیری:',
          fieldWidth: fieldWidth,
          labelWidth: isMobile ? 0 : _desktopLabelWidth,
        ),

        if (_dateError != null)
          isMobile
              ? _buildErrorText(_dateError)
              : Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                    right: _desktopLabelWidth,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _buildErrorText(_dateError),
                  ),
                ),
      ],
    );
  }

  Widget _buildFollowUpField({
    required bool isMobile,
    required double fieldWidth,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isMobile) ...[
          const Text(
            'پیگیری توسط:',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.text,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],

        AppTextField(
          controller: _followUpByController,
          labelText: isMobile ? null : 'پیگیری توسط:',
          labelWidth: _desktopLabelWidth,
          labelSpacing: 0,
          width: fieldWidth,
          height: 64,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        if (_followUpByError != null)
          isMobile
              ? _buildErrorText(_followUpByError)
              : Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                    right: _desktopLabelWidth,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _buildErrorText(_followUpByError),
                  ),
                ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final isMobile = screenWidth < 600;

    final horizontalPadding = isMobile ? 20.0 : 32.0;

    final modalWidth = isMobile ? screenWidth - 32 : _desktopModalWidth;

    final fieldWidth = isMobile
        ? modalWidth - (horizontalPadding * 2)
        : _desktopFieldWidth;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: _desktopModalWidth,
          maxHeight: MediaQuery.sizeOf(context).height - 48,
        ),
        child: Container(
          width: modalWidth,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: isMobile ? 20 : 24,
          ),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTitle(isMobile),

                const SizedBox(height: 8),

                const Divider(color: AppColors.border, height: 1),

                SizedBox(height: isMobile ? 20 : 24),

                _buildDateField(isMobile: isMobile, fieldWidth: fieldWidth),

                const SizedBox(height: 20),

                _buildFollowUpField(
                  isMobile: isMobile,
                  fieldWidth: fieldWidth,
                ),

                SizedBox(height: isMobile ? 28 : 32),

                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 204,
                      minWidth: isMobile ? 0 : 204,
                    ),
                    child: SizedBox(
                      width: isMobile ? fieldWidth : 204,
                      child: CustomButton(
                        label: 'تایید',
                        type: ButtonType.primary,
                        width: isMobile ? fieldWidth : 204,
                        height: 64,
                        onPressed: () {
                          if (_validate()) {
                            Navigator.of(context).pop(
                              FollowUpResult(
                                date: _dateController.text,
                                followUpBy: _followUpByController.text,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
