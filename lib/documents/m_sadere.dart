import 'package:flutter/material.dart';

import '../widgets.dart/header.dart';
import '../widgets.dart/buttons.dart';
import '../documents.dart';

class OutgoingLetterViewPage extends StatelessWidget {
  final OutgoingLetterDocument document;

  const OutgoingLetterViewPage({
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
                  title: 'مشاهده نامه صادره',
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
                      // -----------------------------
                      // اطلاعات اولیه نامه
                      // -----------------------------

                      _row(
                        'شماره نامه:',
                        document.letterNumber,
                      ),

                      _row(
                        'تاریخ:',
                        document.date,
                      ),

                      _row(
                        'عنوان/خلاصه نامه:',
                        document.subject,
                      ),

                      _row(
                        'کلمات کلیدی:',
                        document.tags.join('، '),
                      ),

                      _divider(),

                      // -----------------------------
                      // اطلاعات گیرنده
                      // -----------------------------

                      _row(
                        'به سازمان/شرکت:',
                        document.organization,
                      ),

                      _row(
                        'گیرنده نامه:',
                        document.recipient,
                      ),

                      _row(
                        'امضا کننده:',
                        document.signer,
                      ),

                      _row(
                        'اقدام کننده:',
                        document.actionBy,
                      ),

                      _divider(),

                      // -----------------------------
                      // اطلاعات دبیرخانه
                      // -----------------------------

                      _row(
                        'شماره ثبت دبیرخانه:',
                        document.registrationNumber,
                      ),

                      _row(
                        'تاریخ ثبت:',
                        document.registrationDate,
                      ),

                      _row(
                        'پوشه بایگانی:',
                        document.archiveFolder,
                      ),

                      _row(
                        'اولویت:',
                        document.priority,
                      ),

                      _row(
                        'نحوه ارسال:',
                        document.sendMethod,
                      ),

                      // -----------------------------
                      // پیگیری
                      // -----------------------------

                      _row(
                        'نیاز به پیگیری:',
                        document.needsFollowUp
                            ? 'دارد'
                            : 'ندارد',
                      ),

                      if (document.needsFollowUp) ...[
                        _row(
                          'تاریخ پیگیری:',
                          document.followUpDate ?? '',
                        ),

                        _row(
                          'پیگیری توسط:',
                          document.followUpBy ?? '',
                        ),
                      ],

                      // -----------------------------
                      // فایل
                      // -----------------------------

                      _row(
                        'ذخیره فایل:',
                        document.saveFile
                            ? 'بله'
                            : 'خیر',
                      ),

                      if (document.filePath != null)
                        _row(
                          'فایل ذخیره شده:',
                          document.filePath!,
                        ),

                      // -----------------------------
                      // پیوست‌ها
                      // -----------------------------

                      if (document.attachments.isNotEmpty) ...[
                        _row(
                          'تعداد پیوست:',
                          document.attachments.length.toString(),
                        ),
                      ],

                      // -----------------------------
                      // دکمه‌ها
                      // -----------------------------

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