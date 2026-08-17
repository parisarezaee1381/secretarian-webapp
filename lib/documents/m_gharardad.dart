import 'package:flutter/material.dart';

import 'widgets.dart/header.dart';
import 'widgets.dart/buttons.dart';

class ContractViewPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const ContractViewPage({
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
                        'شرکت طرف قرارداد:',
                        data['organization'] ?? '',
                      ),

                      _row(
                        'شخص طرف قرارداد:',
                        data['recipient'] ?? '',
                      ),

                      _row(
                        'اقدام کننده:',
                        data['actionBy'] ?? '',
                      ),

                      _divider(),

                      _row(
                        'موضوع قرارداد:',
                        data['contractSubject'] ?? '',
                      ),

                      _row(
                        'تاریخ ثبت:',
                        data['registrationDate'] ?? '',
                      ),

                      _row(
                        'شماره قرارداد مرجع:',
                        data['referenceContractNumber'] ?? '',
                      ),

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