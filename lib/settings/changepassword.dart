import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_application_1/core/app_constants.dart';
import 'package:flutter_application_1/widgets/text_input.dart';
import 'package:flutter_application_1/widgets/buttons.dart';
import 'package:flutter_application_1/widgets/page_scaffold.dart';
import 'package:flutter_application_1/authentication/user_repository.dart';

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
  bool _isSubmitting = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _currentPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'رمز عبور را وارد کنید';
    }

    return null;
  }

  String? _newPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'رمز عبور جدید را وارد کنید';
    }

    if (value.length < kMinPasswordLength) {
      return 'رمز عبور باید حداقل $kMinPasswordLength کاراکتر باشد';
    }

    if (value == _currentPasswordController.text) {
      return 'رمز عبور جدید باید با رمز عبور قبلی متفاوت باشد';
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
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _isSubmitting) return;

    setState(() => _isSubmitting = true);

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
    } catch (e, stackTrace) {
      debugPrint('CHANGE PASSWORD ERROR: $e');
      debugPrint('$stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e is UserFacingException
                ? e.message
                : 'خطا در تغییر رمز عبور. دوباره تلاش کنید.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _handleCancel() {
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'تغییر رمز عبور',

      children: [
        Form(
          key: _formKey,

          child: Column(
            mainAxisSize: MainAxisSize.min,

            // چون پروژه RTL است:
            // start = سمت راست
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              AppTextField(
                controller: _currentPasswordController,
                labelText: 'رمز عبور قبلی',
                obscureText: _obscureCurrentPassword,
                textInputAction: TextInputAction.next,
                validator: _currentPasswordValidator,
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

              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      label: 'تأیید',
                      type: ButtonType.primary,
                      width: 204.w,
                      isLoading: _isSubmitting,
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
            ],
          ),
        ),
      ],
    );
  }
}
