import 'package:flutter/material.dart';

import '../widgets.dart/header.dart';
import '../widgets.dart/buttons.dart';
import '../documents.dart';

class ContractViewPage extends StatelessWidget {
  final ContractDocument document;

  const ContractViewPage({
    super.key,
    required this.document,
  });

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
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
          SizedBox(
            width: 548,
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(
                color: Color(0xFF101018),
                fontSize: 14,
                fontFamily: 'Estedad',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 64),
      child: Row(
        children: [
          SizedBox(width: 148),
          SizedBox(
            width: 548,
            child: Divider(
              color: Color(0xFF828288),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Column(
      children: [
        const SizedBox(height: 32),
        Row(
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
        const SizedBox(height: 128),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F7),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 1440,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const AppHeader(
                  title: 'مشاهده قرارداد',
                  leading: HeaderLeading.back,
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    right: 32,
                    top: 64,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _row('شماره نامه:', document.letterNumber),
                      _row('تاریخ:', document.date),
                      _row('عنوان/خلاصه نامه:', document.subject),
                      _row('کلمات کلیدی:', document.tags.join('، ')),

                      _divider(),

                      _row('شرکت طرف قرارداد:', document.organization),
                      _row('شخص طرف قرارداد:', document.recipient),
                      _row('اقدام کننده:', document.actionBy),

                      _divider(),

                      _row('موضوع قرارداد:', document.contractSubject),
                      _row('تاریخ ثبت:', document.registrationDate),
                      _row('شماره قرارداد مرجع:', document.referenceContractNumber),

                      _row(
                        'ذخیره فایل:',
                        document.saveFile ? 'بله' : 'خیر',
                      ),

                      if (document.filePath != null)
                        _row('فایل ذخیره شده:', document.filePath!),

                      if (document.attachments.isNotEmpty)
                        _row(
                          'تعداد پیوست:',
                          document.attachments.length.toString(),
                        ),

                      _actionButtons(),
                    ],
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