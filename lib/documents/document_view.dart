import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_application_1/core/app_constants.dart';
import 'package:flutter_application_1/core/theme.dart';
import 'package:flutter_application_1/widgets/buttons.dart';
import 'package:flutter_application_1/widgets/header.dart';

// Wide-layout geometry of one detail row: label + gap + value.
const double kDocumentViewLabelWidth = 150;
const double kDocumentViewValueWidth = 548;
const double _kRowGap = 16;

/// Widest content column: exactly one detail row.
const double kDocumentViewRowWidth =
    kDocumentViewLabelWidth + _kRowGap + kDocumentViewValueWidth;

/// Side-by-side desktop layout applies at/above this width; below it
/// everything stacks. One shared threshold for rows, dividers, action
/// buttons and page padding (the three view pages used to switch at
/// 600/700/900 independently), and it is the smallest width where the fixed
/// `kDocumentViewRowWidth` row still fits beside the 32px page padding —
/// the old fixed-width desktop row overflowed between 700 and 777px.
/// Aliased from `kWideLayoutBreakpoint` so the letter forms switch layouts
/// at exactly the same width.
const double kDocumentViewWideBreakpoint = kWideLayoutBreakpoint;

bool _isWide(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= kDocumentViewWideBreakpoint;

/// One label/value pair: side-by-side on wide screens, stacked with the
/// value in a card below the breakpoint. Empty values render as `-`.
class DocumentDetailRow extends StatelessWidget {
  const DocumentDetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final displayValue = value.isEmpty ? '-' : value;

    if (!_isWide(context)) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                displayValue,
                softWrap: true,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 14.sp,
                  height: 1.7,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: kDocumentViewLabelWidth,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: _kRowGap),
          SizedBox(
            width: kDocumentViewValueWidth,
            child: Text(
              displayValue,
              softWrap: true,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 14.sp,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Section divider, aligned under the value column on wide screens.
class DocumentViewDivider extends StatelessWidget {
  const DocumentViewDivider({super.key});

  @override
  Widget build(BuildContext context) {
    if (!_isWide(context)) {
      return const Padding(
        padding: EdgeInsets.only(top: 8, bottom: 40),
        child: Divider(color: AppColors.mutedText, height: 1),
      );
    }

    return const Padding(
      padding: EdgeInsets.only(bottom: 64),
      child: Row(
        children: [
          SizedBox(width: kDocumentViewLabelWidth),
          SizedBox(width: _kRowGap),
          SizedBox(
            width: kDocumentViewValueWidth,
            child: Divider(color: AppColors.mutedText, height: 1),
          ),
        ],
      ),
    );
  }
}

/// Print and Edit actions. No print implementation exists anywhere in the
/// app, so the button is honestly disabled instead of silently doing
/// nothing on tap; Edit opens the document's form and the view refreshes
/// itself with the document the form hands back.
class _DocumentViewActions extends StatelessWidget {
  const _DocumentViewActions({required this.onEdit});

  final VoidCallback onEdit;

  Widget _printButton({required double width, required double height}) {
    return CustomButton(
      label: 'چاپ',
      type: ButtonType.secondary,
      width: width,
      height: height,
      onPressed: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isWide(context)) {
      return Padding(
        padding: const EdgeInsets.only(top: 32, bottom: 128),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _printButton(width: 204, height: 64),
            const SizedBox(width: 32),
            CustomButton(
              label: 'ویرایش',
              type: ButtonType.secondary,
              width: 204,
              height: 64,
              onPressed: onEdit,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _printButton(width: double.infinity, height: 56),
          const SizedBox(height: 16),
          CustomButton(
            label: 'ویرایش',
            type: ButtonType.secondary,
            width: double.infinity,
            height: 56,
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}

/// Shared chrome for the three document view pages (`m_*`): header, centered
/// scrollable detail column, and the action buttons at the end.
class DocumentViewScaffold extends StatelessWidget {
  const DocumentViewScaffold({
    super.key,
    required this.title,
    required this.children,
    required this.onEdit,
  });

  final String title;

  /// The detail rows, rendered above the action buttons.
  final List<Widget> children;

  /// Opens the document's edit form with the current document prefilled.
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final isWide = _isWide(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(title: title, leading: HeaderLeading.back),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: isWide ? 32 : 20,
                  right: isWide ? 32 : 20,
                  top: 48,
                  bottom: 32,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: kDocumentViewRowWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...children,

                        _DocumentViewActions(onEdit: onEdit),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
