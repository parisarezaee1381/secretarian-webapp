import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/widgets.dart/header.dart';
import 'package:flutter_application_1/widgets.dart/buttons.dart';
import 'package:flutter_application_1/authentication.dart/login.dart';
import 'package:flutter_application_1/setting.dart/edit_setting.dart';

class SettingsViewPage extends StatelessWidget {
  const SettingsViewPage({
    super.key,
    required this.username,
    required this.email,
  });

  final String username;
  final String email;

  static TextStyle get _labelStyle => TextStyle(
    fontFamily: 'Estedad',
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF101018),
  );

  static TextStyle get _valueStyle => TextStyle(
    fontFamily: 'Estedad',
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF101018),
  );

  Widget _buildLabelRow(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: _labelStyle, textAlign: TextAlign.right),

        SizedBox(width: 16.w),

        Text(value, style: _valueStyle, textAlign: TextAlign.right),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F7),

      appBar: const AppHeader(title: 'تنظیمات', leading: HeaderLeading.back),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 128.h),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            // پروژه RTL است:
            // start = سمت راست
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // =========================
              // نام کاربری
              // =========================
              _buildLabelRow('نام کاربری:', username),

              const SizedBox(height: 24),

              // =========================
              // ایمیل
              // =========================
              _buildLabelRow('ایمیل:', email),

              const SizedBox(height: 64),

              // =========================
              // دکمه ویرایش
              // وسط چین
              // =========================
              Center(
                child: CustomButton(
                  label: 'ویرایش',
                  type: ButtonType.primary,
                  width: 204.w,
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
              ),

              const SizedBox(height: 24),

              // =========================
              // خروج از حساب
              // وسط چین
              // =========================
              Center(
                child: CustomButton(
                  label: 'خروج از حساب',
                  type: ButtonType.tertiary,
                  width: 204.w,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 64),

              // =========================
              // نسخه
              // همراه محتوا اسکرول می‌شود
              // =========================
              Center(
                child: Text(
                  'نسخه 1.0.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Estedad-VF',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF101018),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
