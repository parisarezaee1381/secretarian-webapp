import 'package:flutter/material.dart';

import '../widgets.dart/header.dart';
import '../widgets.dart/buttons.dart';
import '../documents.dart';

class ContractViewPage extends StatelessWidget {
  final ContractDocument document;

  const ContractViewPage({super.key, required this.document});

  static const double _desktopContentWidth = 900;
  static const double _labelWidth = 150;
  static const double _fieldWidth = 548;

  Widget _row(BuildContext context, String label, String value) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 700;

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
                value.isEmpty ? '-' : value,
                softWrap: true,
                style: const TextStyle(
                  color: Color(0xFF101018),
                  fontSize: 14,
                  fontFamily: 'Estedad',
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
            width: _labelWidth,
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
            width: _fieldWidth,
            child: Text(
              value.isEmpty ? '-' : value,
              softWrap: true,
              style: const TextStyle(
                color: Color(0xFF101018),
                fontSize: 14,
                fontFamily: 'Estedad',
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 700;

    if (isMobile) {
      return const Padding(
        padding: EdgeInsets.only(top: 8, bottom: 40),
        child: Divider(color: Color(0xFF828288), height: 1),
      );
    }

    return const Padding(
      padding: EdgeInsets.only(bottom: 64),
      child: Row(
        children: [
          SizedBox(width: _labelWidth),
          SizedBox(
            width: _fieldWidth,
            child: Divider(color: Color(0xFF828288), height: 1),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 64),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F7),

      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'مشاهده قرارداد',
              leading: HeaderLeading.back,
            ),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;

                  final horizontalPadding = screenWidth < 600 ? 20.0 : 32.0;

                  return SingleChildScrollView(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _desktopContentWidth,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: horizontalPadding,
                            right: horizontalPadding,
                            top: 48,
                            bottom: 32,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _row(
                                context,
                                'شماره نامه:',
                                document.letterNumber,
                              ),

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

                              _row(
                                context,
                                'شرکت طرف قرارداد:',
                                document.organization,
                              ),

                              _row(
                                context,
                                'شخص طرف قرارداد:',
                                document.recipient,
                              ),

                              _row(context, 'اقدام کننده:', document.actionBy),

                              _divider(context),

                              _row(
                                context,
                                'موضوع قرارداد:',
                                document.contractSubject,
                              ),

                              _row(
                                context,
                                'تاریخ ثبت:',
                                document.registrationDate,
                              ),

                              _row(
                                context,
                                'شماره قرارداد مرجع:',
                                document.referenceContractNumber,
                              ),

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

                              if (document.attachments.isNotEmpty)
                                _row(
                                  context,
                                  'تعداد پیوست:',
                                  document.attachments.length.toString(),
                                ),

                              _actionButtons(context),
                            ],
                          ),
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
