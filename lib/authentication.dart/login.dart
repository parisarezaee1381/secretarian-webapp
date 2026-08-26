import 'package:flutter/material.dart';

import 'package:flutter_application_1/widgets.dart/text_input.dart';
import 'package:flutter_application_1/widgets.dart/buttons.dart';
import 'package:flutter_application_1/widgets.dart/card.dart';
import 'package:flutter_application_1/widgets.dart/rectangles.dart';
import 'package:flutter_application_1/dashboard.dart';
import 'forgetpassword.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _isForgotPasswordHovered = false;

  // ------------------------------------------------------------
  // Dispose
  // ------------------------------------------------------------

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  // ------------------------------------------------------------
  // Login
  // ------------------------------------------------------------

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ),
      );
    }
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

                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  return 'نام کاربری را وارد کنید';
                                }

                                return null;
                              },
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
                                  TextInputAction.done,

                              suffixIcon:
                                  IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,

                                  color:
                                      const Color(
                                    0xFFF3F3F7,
                                  ),
                                ),

                                onPressed: () {
                                  setState(() {
                                    _obscurePassword =
                                        !_obscurePassword;
                                  });
                                },
                              ),

                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  return 'رمز عبور را وارد کنید';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // ========================================
                            // Forgot Password
                            // ========================================

                            // ========================================
// Forgot Password
// ========================================

SizedBox(
  width: 808,
  child: Align(
    alignment: Alignment.centerRight,
    child: MouseRegion(
      cursor: SystemMouseCursors.click,

      onEnter: (_) {
        setState(() {
          _isForgotPasswordHovered = true;
        });
      },

      onExit: (_) {
        setState(() {
          _isForgotPasswordHovered = false;
        });
      },

      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const ForgotPasswordPage(),
            ),
          );
        },

        child: Text(
          'فراموشی رمز',

          style: TextStyle(
            fontFamily: 'Estedad-VF',
            fontSize: 14,
            fontWeight: FontWeight.normal,

            color: const Color(0xFF3863A8).withValues(
              alpha: _isForgotPasswordHovered
                  ? 0.5
                  : 1.0,
            ),
          ),
        ),
      ),
    ),
  ),
),

                            const SizedBox(height: 64),

                            // ========================================
                            // Login Button
                            // ========================================

                            CustomButton(
                              label: 'ورود',

                              type:
                                  ButtonType.primary,

                              width: 204,

                              onPressed:
                                  _handleLogin,
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
                              Color(0xFFF3F3F7),
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
    );
  }
}