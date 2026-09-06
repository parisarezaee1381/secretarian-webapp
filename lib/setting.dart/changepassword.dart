import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/widgets.dart/header.dart';
import 'package:flutter_application_1/widgets.dart/text_input.dart';
import 'package:flutter_application_1/widgets.dart/buttons.dart';
import 'package:flutter_application_1/authentication.dart/user_repository.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
      TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'رمز عبور را وارد کنید';
    }

    return null;
  }

  String? _newPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'رمز عبور جدید را وارد کنید';
    }

    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'تکرار رمز عبور جدید را وارد کنید';
    }

    if (value != _newPasswordController.text) {
      return 'رمز عبور جدید و تکرار آن یکسان نیستند';
    }

    return null;
  }

  Future<void> _handleConfirm() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      final isCorrect = await UserRepository.instance.verifyCurrentPassword(
        currentPassword: _currentPasswordController.text,
      );

      if (!mounted) return;

      if (!isCorrect) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('رمز عبور قبلی اشتباه است')),
        );
        return;
      }

      await UserRepository.instance.changePassword(
        newPassword: _newPasswordController.text,
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  void _handleCancel() {
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F7),

      appBar: const AppHeader(
        title: 'تغییر رمز عبور',
        leading: HeaderLeading.back,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 128.h),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,

              // چون پروژه RTL است:
              // start = سمت راست
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // =========================
                // رمز عبور قبلی
                // =========================
                AppTextField(
                  controller: _currentPasswordController,
                  labelText: 'رمز عبور قبلی',
                  obscureText: _obscureCurrentPassword,
                  textInputAction: TextInputAction.next,
                  validator: _passwordValidator,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureCurrentPassword = !_obscureCurrentPassword;
                      });
                    },
                    icon: Icon(
                      _obscureCurrentPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20.sp,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // =========================
                // رمز عبور جدید
                // =========================
                AppTextField(
                  controller: _newPasswordController,
                  labelText: 'رمز عبور جدید',
                  obscureText: _obscureNewPassword,
                  textInputAction: TextInputAction.next,
                  validator: _newPasswordValidator,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                    icon: Icon(
                      _obscureNewPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20.sp,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // =========================
                // تکرار رمز عبور جدید
                // =========================
                AppTextField(
                  controller: _confirmPasswordController,
                  labelText: 'تکرار رمز عبور جدید',
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  validator: _confirmPasswordValidator,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20.sp,
                    ),
                  ),
                ),

                const SizedBox(height: 64),

                // =========================
                // تأیید و لغو
                // وسط چین
                // =========================
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomButton(
                        label: 'تأیید',
                        type: ButtonType.primary,
                        width: 204.w,
                        onPressed: _handleConfirm,
                      ),

                      SizedBox(width: 32.w),

                      CustomButton(
                        label: 'لغو',
                        type: ButtonType.secondary,
                        width: 204.w,
                        onPressed: _handleCancel,
                      ),
                    ],
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
      ),
    );
  }
}
