import 'package:flutter/material.dart';

import 'widgets.dart/header.dart';
import 'widgets.dart/buttons.dart';

class IncomingLetterViewPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const IncomingLetterViewPage({
    super.key,
    required this.data,
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
            // سمت چپ
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

            // سمت راست
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

  Widget _buildAttachments() {
    final attachments = data['attachments'];

    if (attachments is! List || attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 150,
            child: Text(
              'پیوست:',
              style: TextStyle(
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
              attachments.map((file) {
                if (file is Map<String, dynamic>) {
                  return file['name']?.toString() ?? '-';
                }

                return file.toString();
              }).join('، '),
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
                  title: 'مشاهده نامه وارده',
                  leading: HeaderLeading.none,
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    right: 32,
                    top: 64,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _row(
                        'شماره نامه:',
                        data['letterNumber'] ?? '',
                      ),

                      _row(
                        'تاریخ:',
                        data['date'] ?? '',
                      ),

                      _row(
                        'عنوان/خلاصه نامه:',
                        data['subject'] ?? '',
                      ),

                      _row(
                        'کلمات کلیدی:',
                        (data['tags'] as List?)?.join('، ') ?? '',
                      ),

                      _divider(),

                      _row(
                        'به سازمان/شرکت:',
                        data['organization'] ?? '',
                      ),

                      _row(
                        'شخص ارسال کننده:',
                        data['sender'] ?? '',
                      ),

                      _row(
                        'شماره نامه فرستنده:',
                        data['senderLetterNumber'] ?? '',
                      ),

                      _row(
                        'مخاطب:',
                        data['recipient'] ?? '',
                      ),

                      _divider(),

                      _row(
                        'تاریخ ثبت:',
                        data['registrationDate'] ?? '',
                      ),

                      _row(
                        'پوشه بایگانی:',
                        data['archiveFolder'] ?? '',
                      ),

                      _row(
                        'اولویت:',
                        data['priority'] ?? '',
                      ),

                      _row(
                        'نیاز به پیگیری:',
                        data['needsFollowUp'] == true
                            ? 'دارد'
                            : 'ندارد',
                      ),

                      if (data['needsFollowUp'] == true) ...[
                        _row(
                          'تاریخ پیگیری:',
                          data['followUpDate'] ?? '',
                        ),

                        _row(
                          'پیگیری توسط:',
                          data['followUpBy'] ?? '',
                        ),
                      ],

                      _row(
                        'ذخیره فایل:',
                        data['saveFile'] == true
                            ? 'بله'
                            : 'خیر',
                      ),

                      if (data['savedFileName'] != null)
                        _row(
                          'فایل ذخیره شده:',
                          data['savedFileName'] ?? '',
                        ),

                      _buildAttachments(),

                      // دکمه‌های ویرایش و چاپ
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