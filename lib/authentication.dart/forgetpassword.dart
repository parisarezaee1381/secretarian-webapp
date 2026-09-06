import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_application_1/widgets.dart/text_input.dart';
import 'package:flutter_application_1/widgets.dart/buttons.dart';
import 'package:flutter_application_1/widgets.dart/card.dart';
import 'package:flutter_application_1/widgets.dart/rectangles.dart';
import 'package:flutter_application_1/authentication.dart/user_repository.dart';
import 'package:flutter_application_1/dashboard.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendCode() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final bool exists = await UserRepository.instance.emailExists(
        email: _emailController.text.trim(),
      );

      if (!mounted) return;

      if (!exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('کلمه وارد شده اشتباه است ')),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F7),

      body: Material(
        color: const Color(0xFFF3F3F7),

        child: Stack(
          children: [
            const Positioned.fill(child: NestedRotatedRectangles()),

            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 32.w),

                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      SizedBox(height: 64.w),

                      FakoorLoginCard(
                        child: Form(
                          key: _formKey,

                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: [
                              AppTextField(
                                controller: _emailController,

                                labelText: 'رنگ مورد علاقه',

                                keyboardType: TextInputType.text,

                                textInputAction: TextInputAction.done,
                              ),

                              SizedBox(height: 64.w),

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
                                        // ارسال کد
                                        CustomButton(
                                          label: 'تایید',
                                          type: ButtonType.primary,
                                          width: buttonWidth,
                                          isLoading: _isSubmitting,
                                          onPressed: _handleSendCode,
                                        ),

                                        SizedBox(width: buttonSpacing),

                                        // بازگشت
                                        CustomButton(
                                          label: 'بازگشت',
                                          type: ButtonType.tertiary,
                                          width: buttonWidth,
                                          isLoading: _isSubmitting,
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
                                        label: 'تایید',
                                        type: ButtonType.primary,
                                        width: buttonWidth,
                                        isLoading: _isSubmitting,
                                        onPressed: _handleSendCode,
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

                      SizedBox(height: 64.w),

                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'نسخه 1.0.0',

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontFamily: 'Estedad-VF',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFFF3F3F7),
                          ),
                        ),
                      ),

                      SizedBox(height: 128.w),
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
