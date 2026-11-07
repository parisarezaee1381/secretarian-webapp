import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_application_1/core/app_constants.dart';
import 'package:flutter_application_1/widgets/text_input.dart';
import 'package:flutter_application_1/widgets/buttons.dart';
import 'package:flutter_application_1/widgets/card.dart';
import 'package:flutter_application_1/widgets/rectangles.dart';
import 'package:flutter_application_1/authentication/user_repository.dart';
import 'package:flutter_application_1/core/session.dart';
import 'package:flutter_application_1/core/theme.dart';

/// Password recovery.
///
/// There is no mail system to send a code through, so the recovery answer
/// (the "favorite color" stored at registration) is the proof of ownership:
/// verify it, set a new password, and the gate signs the user in.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _recoveryAnswerController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _recoveryAnswerController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _recoveryAnswerValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رنگ مورد علاقه را وارد کنید';
    }

    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رمز عبور جدید را وارد کنید';
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

  Future<void> _handleResetPassword() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final bool answerExists = await UserRepository.instance
          .recoveryAnswerExists(answer: _recoveryAnswerController.text);

      if (!mounted) return;

      if (!answerExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('پاسخ وارد شده اشتباه است')),
        );
        return;
      }

      await UserRepository.instance.changePassword(
        newPassword: _passwordController.text,
      );

      if (!mounted) return;

      // The gate swaps to the dashboard; drop this page so it is not sitting
      // behind it when the user navigates back later.
      SessionScope.of(context).signIn();
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e, stackTrace) {
      debugPrint('RESET PASSWORD ERROR: $e');
      debugPrint('$stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('خطا در بازنشانی رمز. دوباره تلاش کنید.')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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
                                controller: _recoveryAnswerController,

                                labelText: 'رنگ مورد علاقه',

                                keyboardType: TextInputType.text,

                                textInputAction: TextInputAction.next,

                                validator: _recoveryAnswerValidator,
                              ),

                              const SizedBox(height: 24),

                              AppTextField(
                                controller: _passwordController,

                                labelText: 'رمز عبور جدید',

                                obscureText: _obscurePassword,

                                textInputAction: TextInputAction.next,

                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
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

                                labelText: 'تکرار رمز عبور جدید',

                                obscureText: _obscureConfirmPassword,

                                textInputAction: TextInputAction.done,

                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
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

                              const SizedBox(height: 64),

                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final double buttonWidth = 204.w;

                                  final double buttonSpacing = 32.w;

                                  final double totalWidth =
                                      (buttonWidth * 2) + buttonSpacing;

                                  if (constraints.maxWidth >= totalWidth) {
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomButton(
                                          label: 'بازنشانی رمز',
                                          type: ButtonType.primary,
                                          width: buttonWidth,
                                          isLoading: _isSubmitting,
                                          onPressed: _handleResetPassword,
                                        ),

                                        SizedBox(width: buttonSpacing),

                                        CustomButton(
                                          label: 'بازگشت',
                                          type: ButtonType.tertiary,
                                          width: buttonWidth,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  }

                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomButton(
                                        label: 'بازنشانی رمز',
                                        type: ButtonType.primary,
                                        width: buttonWidth,
                                        isLoading: _isSubmitting,
                                        onPressed: _handleResetPassword,
                                      ),

                                      SizedBox(height: buttonSpacing),

                                      CustomButton(
                                        label: 'بازگشت',
                                        type: ButtonType.tertiary,
                                        width: buttonWidth,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 64),

                      SizedBox(
                        width: double.infinity,
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
