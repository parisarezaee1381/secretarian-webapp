import 'package:flutter/material.dart';

import 'package:flutter_application_1/widgets.dart/text_input.dart';
import 'package:flutter_application_1/widgets.dart/buttons.dart';
import 'package:flutter_application_1/widgets.dart/card.dart';
import 'package:flutter_application_1/widgets.dart/rectangles.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController();

  // ------------------------------------------------------------
  // Dispose
  // ------------------------------------------------------------

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // Email Validator
  // ------------------------------------------------------------

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'ایمیل را وارد کنید';
    }

    final String email = value.trim();

    final RegExp emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(email)) {
      return 'فرمت ایمیل صحیح نیست';
    }

    return null;
  }

  // ------------------------------------------------------------
  // Send Code
  // ------------------------------------------------------------

  void _handleSendCode() {
    final bool isValid =
        _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    // فعلاً منطق ارسال کد اینجا قرار می‌گیرد.
  }

  // ------------------------------------------------------------
  // Build
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F7),

      body: Stack(
        children: [

          // ====================================================
          // Background
          // ====================================================

          const Positioned.fill(
            child: ClipRect(
              child: Align(
                alignment: Alignment.center,
                child: NestedRotatedRectangles(),
              ),
            ),
          ),

          // ====================================================
          // Scrollable Main Content
          // ====================================================

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: 32,
              ),

              child: Center(
                child: FakoorLoginCard(
                  child: Form(
                    key: _formKey,

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment:
                          CrossAxisAlignment.center,

                      children: [

                        // ==========================================
                        // Logo
                        // ==========================================

                        Image.asset(
                          'assets/images/logo.png',
                          width: 120,
                          height: 64,
                        ),

                        const SizedBox(height: 32),

                        // ==========================================
                        // Title
                        // ==========================================

                        const Text(
                          'سیستم دبیرخانه فکور',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Estedad-VF',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF101018),
                          ),
                        ),

                        const SizedBox(height: 64),

                        // ==========================================
                        // Email
                        // ==========================================

                        AppTextField(
                          controller:
                              _emailController,

                          labelText: 'ایمیل',

                          keyboardType:
                              TextInputType.emailAddress,

                          textInputAction:
                              TextInputAction.done,

                          validator:
                              _emailValidator,
                        ),

                        const SizedBox(height: 64),

                        // ==========================================
                        // Send Code Button
                        // ==========================================

                        CustomButton(
                          label: 'ارسال کد',

                          type:
                              ButtonType.primary,

                          width: 204,

                          onPressed:
                              _handleSendCode,
                        ),

                        const SizedBox(height: 24),

                        // ==========================================
                        // Back Button
                        // ==========================================

                        CustomButton(
                          label: 'بازگشت',

                          type:
                              ButtonType.tertiary,

                          width: 204,

                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ====================================================
          // Version
          // ====================================================

Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    const SizedBox(height: 64),

    Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: const Text(
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

    const SizedBox(height: 128),
  ],
)
        ],
      ),
    );
  }
}