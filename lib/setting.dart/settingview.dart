import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets.dart/header.dart'; // AppHeader
import 'package:flutter_application_1/widgets.dart/buttons.dart'; // CustomButton
import 'package:flutter_application_1/setting.dart/edit_setting.dart';
import 'package:flutter_application_1/authentication.dart/login.dart';

class SettingsViewPage extends StatelessWidget {
  const SettingsViewPage({
    super.key,
    required this.username,
    required this.email,
  });

  final String username;
  final String email;

  static const TextStyle _labelStyle = TextStyle(
    fontFamily: 'Estedad',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF101018),
  );

  static const TextStyle _valueStyle = TextStyle(
    fontFamily: 'Estedad',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Color(0xFF101018),
  );

  Widget _buildLabelRow(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: _labelStyle),
        const SizedBox(width: 16),
        Text(value, style: _valueStyle),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F7),
      appBar: const AppHeader(
        title: 'تنظیمات',
        leading: HeaderLeading.back,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLabelRow('نام کاربری:', username),
                    const SizedBox(height: 24),
                    _buildLabelRow('ایمیل:', email),
                    const SizedBox(height: 64),
                    CustomButton(
                      label: 'ویرایش',
                      type: ButtonType.primary,
                      width: 204,
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EditProfilePage(
      initialUsername: username,
      initialEmail: email,
    ),
  ),
);
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      label: 'خروج از حساب',
                      type: ButtonType.tertiary,
                      width: 204,
                      onPressed: () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const LoginPage(),
    ),
  );
},
                    ),
                  ],
                ),
              ),
            ),
          ),

          // متن نسخه؛ همیشه ۱۲۸ پیکسل از پایین صفحه، وسط‌چین
          const Positioned(
            left: 0,
            right: 0,
            bottom: 128,
            child: Center(
              child: Text(
                'نسخه 1.0.0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Estedad-VF',
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF101018),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}