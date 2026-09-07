import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_application_1/widgets.dart/header.dart';
import 'package:flutter_application_1/widgets.dart/buttons.dart';
import 'package:flutter_application_1/authentication.dart/login.dart';
import 'package:flutter_application_1/setting.dart/edit_setting.dart';
import 'package:flutter_application_1/authentication.dart/user_repository.dart';

class SettingsViewPage extends StatefulWidget {
  const SettingsViewPage({super.key});

  @override
  State<SettingsViewPage> createState() => _SettingsViewPageState();
}

class _SettingsViewPageState extends State<SettingsViewPage> {
  String _username = '';
  String _email = '';

  bool _isLoading = true;

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
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await UserRepository.instance.getUser();

      if (!mounted) return;

      if (user == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _username = user.username;
        _email = user.email;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطا در دریافت اطلاعات کاربر')));
    }
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

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                _buildLabelRow('نام کاربری:', _username),

                const SizedBox(height: 24),

                _buildLabelRow('رنگ مورد علاقه:', _email),

                const SizedBox(height: 64),

                Center(
                  child: CustomButton(
                    label: 'ویرایش',
                    type: ButtonType.primary,
                    width: 204.w,
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            initialUsername: _username,
                            initialEmail: _email,
                          ),
                        ),
                      );

                      if (!mounted) return;

                      _loadUser();
                    },
                  ),
                ),

                const SizedBox(height: 24),

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
            ],
          ),
        ),
      ),
    );
  }
}
