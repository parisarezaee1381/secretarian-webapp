import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_application_1/widgets/text_input.dart';
import 'package:flutter_application_1/widgets/buttons.dart';
import 'package:flutter_application_1/widgets/card.dart';
import 'package:flutter_application_1/widgets/rectangles.dart';
import 'package:flutter_application_1/core/app_constants.dart';
import 'package:flutter_application_1/core/session.dart';
import 'package:flutter_application_1/authentication/user_repository.dart';
import 'package:flutter_application_1/core/theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _recoveryAnswerController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _recoveryAnswerController.dispose();

    super.dispose();
  }

  String? _usernameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'نام کاربری را وارد کنید';
    }

    return null;
  }

  String? _recoveryAnswerValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رنگ مورد علاقه را وارد کنید';
    }

    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رمز عبور را وارد کنید';
    }

    if (value.length < kMinPasswordLength) {
      return 'رمز عبور باید حداقل $kMinPasswordLength کاراکتر باشد';
    }

    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'تکرار رمز عبور را وارد کنید';
    }

    if (value != _passwordController.text) {
      return 'با رمز عبور یکسان نیست';
    }

    return null;
  }

  // ------------------------------------------------------------
  // Register
  // ------------------------------------------------------------

  Future<void> _handleRegister() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      await UserRepository.instance.registerUser(
        username: _usernameController.text.trim(),
        recoveryAnswer: _recoveryAnswerController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      // The gate swaps to the dashboard; this screen does not navigate.
      SessionScope.of(context).signIn();
    } catch (e, stackTrace) {
      debugPrint('SIGN UP ERROR: $e');
      debugPrint('$stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e is UserFacingException
                ? e.message
                : 'خطا در ثبت‌نام. دوباره تلاش کنید.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Material(
        color: AppColors.background,

        child: Stack(
          children: [
            const Positioned.fill(child: NestedRotatedRectangles()),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 32),

                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      const SizedBox(height: 64),

                      FakoorLoginCard(
                        child: Form(
                          key: _formKey,

                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: [
                              AppTextField(
                                controller: _usernameController,

                                labelText: 'نام کاربری',

                                keyboardType: TextInputType.text,

                                textInputAction: TextInputAction.next,

                                validator: _usernameValidator,
                              ),

                              const SizedBox(height: 24),

                              AppTextField(
                                controller: _passwordController,

                                labelText: 'رمز عبور',

                                obscureText: _obscurePassword,

                                textInputAction: TextInputAction.next,

                                suffixIcon: IconButton(
                                  onPressed: _togglePasswordVisibility,

                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,

                                    size: 20.sp,

                                    color: AppColors.background,
                                  ),
                                ),

                                validator: _passwordValidator,
                              ),

                              const SizedBox(height: 24),

                              AppTextField(
                                controller: _confirmPasswordController,

                                labelText: 'تکرار رمز عبور',

                                obscureText: _obscureConfirmPassword,

                                textInputAction: TextInputAction.next,

                                suffixIcon: IconButton(
                                  onPressed: _toggleConfirmPasswordVisibility,

                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,

                                    size: 20.sp,

                                    color: AppColors.background,
                                  ),
                                ),

                                validator: _confirmPasswordValidator,
                              ),

                              const SizedBox(height: 24),

                              // ========================================
                              // Recovery answer (password-recovery proof)
                              // ========================================
                              AppTextField(
                                controller: _recoveryAnswerController,

                                labelText: 'رنگ مورد علاقه',

                                keyboardType: TextInputType.text,

                                textInputAction: TextInputAction.done,

                                validator: _recoveryAnswerValidator,
                              ),

                              const SizedBox(height: 64),

                              CustomButton(
                                label: 'ثبت نام',

                                type: ButtonType.primary,

                                width: 204.w,

                                isLoading: _isSubmitting,

                                onPressed: _handleRegister,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 64),

                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,

                        child: Text(
                          kAppVersionLabel,

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal,
                            color: AppColors.background,
                          ),
                        ),
                      ),

                      // ==================================================
                      // 128 px below version
                      // ==================================================
                      const SizedBox(height: 128),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
