import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_application_1/widgets.dart/text_input.dart';
import 'package:flutter_application_1/widgets.dart/buttons.dart';
import 'package:flutter_application_1/widgets.dart/card.dart';
import 'package:flutter_application_1/widgets.dart/rectangles.dart';
import 'package:flutter_application_1/dashboard.dart';
import 'forgetpassword.dart';

import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/authentication.dart/user_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isForgotPasswordHovered = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _handleLogin() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final user = await UserRepository.instance.login(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (user == null) {
        rootScaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('نام کاربری یا رمز عبور اشتباه است')),
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

      body: Stack(
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

                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'نام کاربری را وارد کنید';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 24),

                            AppTextField(
                              controller: _passwordController,

                              labelText: 'رمز عبور',

                              obscureText: _obscurePassword,

                              textInputAction: TextInputAction.done,

                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,

                                  size: 20.sp,

                                  color: const Color(0xFFF3F3F7),
                                ),

                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),

                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'رمز عبور را وارد کنید';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            SizedBox(
                              width: 808.w,
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
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.normal,

                                        color: const Color(0xFF3863A8)
                                            .withValues(
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

                            CustomButton(
                              label: 'ورود',

                              type: ButtonType.primary,

                              width: 204.w,

                              isLoading: _isSubmitting,

                              onPressed: _handleLogin,
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

                    const SizedBox(height: 128),
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
