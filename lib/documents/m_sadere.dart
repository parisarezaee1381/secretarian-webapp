import 'package:flutter/material.dart';

import '../widgets.dart/header.dart';
import '../widgets.dart/buttons.dart';
import '../documents.dart';

class OutgoingLetterViewPage extends StatelessWidget {
  final OutgoingLetterDocument document;

  const OutgoingLetterViewPage({super.key, required this.document});

  // ============================================================
  // Breakpoints
  // ============================================================

  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 900;

  // ============================================================
  // Row
  // ============================================================

  Widget _row(BuildContext context, String label, String value) {
    final width = MediaQuery.sizeOf(context).width;

    final isMobile = width < _mobileBreakpoint;

    final displayValue = value.isEmpty ? '-' : value;

    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF101018),
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Estedad',
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                displayValue,
                softWrap: true,
                style: const TextStyle(
                  color: Color(0xFF101018),
                  fontSize: 14,
                  fontFamily: 'Estedad',
                  height: 1.8,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final labelWidth = width < _tabletBreakpoint ? 130.0 : 150.0;

    final availableValueWidth = width - 64 - labelWidth - 24;

    final valueWidth = availableValueWidth.clamp(200.0, 548.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF101018),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Estedad',
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: valueWidth,
            child: Text(
              displayValue,
              softWrap: true,
              style: const TextStyle(
                color: Color(0xFF101018),
                fontSize: 14,
                fontFamily: 'Estedad',
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Divider
  // ============================================================

  Widget _divider(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final isMobile = width < _mobileBreakpoint;

    if (isMobile) {
      return const Padding(
        padding: EdgeInsets.only(top: 8, bottom: 40),
        child: Divider(color: Color(0xFF828288), height: 1),
      );
    }

    final labelWidth = width < _tabletBreakpoint ? 130.0 : 150.0;

    final dividerWidth = (width - 64 - labelWidth - 16).clamp(200.0, 548.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 64),
      child: Row(
        children: [
          SizedBox(width: labelWidth),
          const SizedBox(width: 16),
          SizedBox(
            width: dividerWidth,
            child: const Divider(color: Color(0xFF828288), height: 1),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Action Buttons
  // ============================================================

  Widget _actionButtons(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final isMobile = width < _mobileBreakpoint;

    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomButton(
              label: 'چاپ',
              type: ButtonType.secondary,
              width: double.infinity,
              height: 56,
              onPressed: () {
                // فعلاً عملکرد چاپ اضافه نشده
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: 'ویرایش',
              type: ButtonType.secondary,
              width: double.infinity,
              height: 56,
              onPressed: () {
                // فعلاً عملکرد ویرایش اضافه نشده
              },
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 128),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            label: 'چاپ',
            type: ButtonType.secondary,
            width: 204,
            height: 64,
            onPressed: () {
              // فعلاً عملکرد چاپ اضافه نشده
            },
          ),
          const SizedBox(width: 32),
          CustomButton(
            label: 'ویرایش',
            type: ButtonType.secondary,
            width: 204,
            height: 64,
            onPressed: () {
              // فعلاً عملکرد ویرایش اضافه نشده
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Main
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F7),

      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'مشاهده نامه صادره',
              leading: HeaderLeading.back,
            ),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;

                  final isMobile = screenWidth < _mobileBreakpoint;

                  final horizontalPadding = isMobile
                      ? 16.0
                      : screenWidth < _tabletBreakpoint
                      ? 24.0
                      : 32.0;

                  final maxContentWidth = screenWidth > 1000
                      ? 900.0
                      : double.infinity;

                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      top: isMobile ? 32 : 64,
                      bottom: 32,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxContentWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // =================================================
                            // اطلاعات اولیه نامه
                            // =================================================

                            _row(context, 'شماره نامه:', document.letterNumber),

                            _row(context, 'تاریخ:', document.date),

                            _row(
                              context,
                              'عنوان/خلاصه نامه:',
                              document.subject,
                            ),

                            _row(
                              context,
                              'کلمات کلیدی:',
                              document.tags.join('، '),
                            ),

                            _divider(context),

                            // =================================================
                            // اطلاعات گیرنده
                            // =================================================
                            _row(
                              context,
                              'به سازمان/شرکت:',
                              document.organization,
                            ),

                            _row(context, 'گیرنده نامه:', document.recipient),

                            _row(context, 'امضا کننده:', document.signer),

                            _row(context, 'اقدام کننده:', document.actionBy),

                            _divider(context),

                            // =================================================
                            // اطلاعات دبیرخانه
                            // =================================================
                            _row(
                              context,
                              'شماره ثبت دبیرخانه:',
                              document.registrationNumber,
                            ),

                            _row(
                              context,
                              'تاریخ ثبت:',
                              document.registrationDate,
                            ),

                            _row(
                              context,
                              'پوشه بایگانی:',
                              document.archiveFolder,
                            ),

                            _row(context, 'اولویت:', document.priority),

                            _row(context, 'نحوه ارسال:', document.sendMethod),

                            // =================================================
                            // پیگیری
                            // =================================================
                            _row(
                              context,
                              'نیاز به پیگیری:',
                              document.needsFollowUp ? 'دارد' : 'ندارد',
                            ),

                            if (document.needsFollowUp) ...[
                              _row(
                                context,
                                'تاریخ پیگیری:',
                                document.followUpDate ?? '',
                              ),

                              _row(
                                context,
                                'پیگیری توسط:',
                                document.followUpBy ?? '',
                              ),
                            ],

                            // =================================================
                            // فایل
                            // =================================================
                            _row(
                              context,
                              'ذخیره فایل:',
                              document.saveFile ? 'بله' : 'خیر',
                            ),

                            if (document.filePath != null)
                              _row(
                                context,
                                'فایل ذخیره شده:',
                                document.filePath!,
                              ),

                            // =================================================
                            // پیوست‌ها
                            // =================================================
                            if (document.attachments.isNotEmpty)
                              _row(
                                context,
                                'تعداد پیوست:',
                                document.attachments.length.toString(),
                              ),

                            // =================================================
                            // دکمه‌ها
                            // =================================================
                            _actionButtons(context),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
