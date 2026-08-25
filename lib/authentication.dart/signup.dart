import 'package:flutter/material.dart';

import 'package:flutter_application_1/widgets.dart/text_input.dart';
import 'package:flutter_application_1/widgets.dart/buttons.dart';
import 'package:flutter_application_1/widgets.dart/card.dart';
import 'package:flutter_application_1/widgets.dart/rectangles.dart';
import 'package:flutter_application_1/dashboard.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // ------------------------------------------------------------
  // Dispose
  // ------------------------------------------------------------

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  // ------------------------------------------------------------
  // Validators
  // ------------------------------------------------------------

  String? _usernameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'نام کاربری را وارد کنید';
    }

    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رمز عبور را وارد کنید';
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

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'ایمیل را وارد کنید';
    }

    final String email = value.trim();

    final RegExp emailRegex =
        RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(email)) {
      return 'فرمت ایمیل صحیح نیست';
    }

    return null;
  }

  // ------------------------------------------------------------
  // Register
  // ------------------------------------------------------------

  void _handleRegister() {
    final bool isValid =
        _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Dashboard(),
      ),
    );
  }

  // ------------------------------------------------------------
  // Password visibility
  // ------------------------------------------------------------

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword =
          !_obscureConfirmPassword;
    });
  }

  // ------------------------------------------------------------
  // Build
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F7),

      body: Material(
        color: const Color(0xFFF3F3F7),

        child: Stack(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.center,

                    children: [

                      // ==================================================
                      // 64 px above card
                      // ==================================================

                      Container(
                        height: 64,
                      ),

                      // ==================================================
                      // Card
                      // ==================================================

                      FakoorLoginCard(
                        child: Form(
                          key: _formKey,

                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:
                                CrossAxisAlignment.center,

                            children: [

                              // ========================================
                              // Username
                              // ========================================

                              AppTextField(
                                controller:
                                    _usernameController,

                                labelText:
                                    'نام کاربری',

                                keyboardType:
                                    TextInputType.text,

                                textInputAction:
                                    TextInputAction.next,

                                validator:
                                    _usernameValidator,
                              ),

                              const SizedBox(height: 24),

                              // ========================================
                              // Password
                              // ========================================

                              AppTextField(
                                controller:
                                    _passwordController,

                                labelText:
                                    'رمز عبور',

                                obscureText:
                                    _obscurePassword,

                                textInputAction:
                                    TextInputAction.next,

                                suffixIcon:
                                    IconButton(
                                  onPressed:
                                      _togglePasswordVisibility,

                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,

                                    color:
                                        const Color(
                                      0xFFF3F3F7,
                                    ),
                                  ),
                                ),

                                validator:
                                    _passwordValidator,
                              ),

                              const SizedBox(height: 24),

                              // ========================================
                              // Confirm Password
                              // ========================================

                              AppTextField(
                                controller:
                                    _confirmPasswordController,

                                labelText:
                                    'تکرار رمز عبور',

                                obscureText:
                                    _obscureConfirmPassword,

                                textInputAction:
                                    TextInputAction.next,

                                suffixIcon:
                                    IconButton(
                                  onPressed:
                                      _toggleConfirmPasswordVisibility,

                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,

                                    color:
                                        const Color(
                                      0xFFF3F3F7,
                                    ),
                                  ),
                                ),

                                validator:
                                    _confirmPasswordValidator,
                              ),

                              const SizedBox(height: 24),

                              // ========================================
                              // Email
                              // ========================================

                              AppTextField(
                                controller:
                                    _emailController,

                                labelText:
                                    'ایمیل',

                                keyboardType:
                                    TextInputType.emailAddress,

                                textInputAction:
                                    TextInputAction.done,

                                validator:
                                    _emailValidator,
                              ),

                              const SizedBox(height: 64),

                              // ========================================
                              // Register Button
                              // ========================================

                              CustomButton(
                                label: 'ثبت نام',

                                type:
                                    ButtonType.primary,

                                width: 204,

                                onPressed:
                                    _handleRegister,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ==================================================
                      // 64 px below card
                      // ==================================================

                      Container(
                        height: 64,
                      ),

                      // ==================================================
                      // Version
                      // ==================================================

                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,

                        child: const Text(
                          'نسخه 1.0.0',

                          textAlign:
                              TextAlign.center,

                          style: TextStyle(
                            fontFamily:
                                'Estedad-VF',
                            fontSize: 14,
                            fontWeight:
                                FontWeight.normal,
                            color:
                                Color(0xFF101018),
                          ),
                        ),
                      ),

                      // ==================================================
                      // 128 px below version
                      // ==================================================

                      Container(
                        height: 128,
                      ),
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