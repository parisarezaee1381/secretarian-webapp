import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_application_1/widgets.dart/text_input.dart';
import 'package:flutter_application_1/widgets.dart/buttons.dart';
import 'package:flutter_application_1/widgets.dart/card.dart';
import 'package:flutter_application_1/widgets.dart/rectangles.dart';
import 'package:flutter_application_1/dashboard.dart';
import 'forgetpassword.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({super.key});

  @override
  State<VerificationCodePage> createState() =>
      _VerificationCodePageState();
}

class _VerificationCodePageState
    extends State<VerificationCodePage> {
  final _formKey = GlobalKey<FormState>();

  final _code1Controller = TextEditingController();
  final _code2Controller = TextEditingController();
  final _code3Controller = TextEditingController();
  final _code4Controller = TextEditingController();

  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();
  final _focusNode4 = FocusNode();

  Timer? _timer;

  int _remainingSeconds = 120;

  // ------------------------------------------------------------
  // Init
  // ------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  // ------------------------------------------------------------
  // Timer
  // ------------------------------------------------------------

  void _startTimer() {
    _timer?.cancel();

    setState(() {
      _remainingSeconds = 120;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          timer.cancel();
        }
      },
    );
  }

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  bool get _canResend => _remainingSeconds == 0;

  // ------------------------------------------------------------
  // Dispose
  // ------------------------------------------------------------

  @override
  void dispose() {
    _timer?.cancel();

    _code1Controller.dispose();
    _code2Controller.dispose();
    _code3Controller.dispose();
    _code4Controller.dispose();

    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();

    super.dispose();
  }

  // ------------------------------------------------------------
  // Code
  // ------------------------------------------------------------

  void _handleCodeChanged(
    String value,
    FocusNode? nextFocus,
  ) {
    if (value.isNotEmpty && nextFocus != null) {
      nextFocus.requestFocus();
    }
  }

  void _handleVerifyCode() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ),
      );
    }
  }

  void _handleResendCode() {
    if (!_canResend) return;

    // فعلاً فقط تایمر دوباره شروع می‌شود.
    // بعداً منطق واقعی ارسال کد را اینجا قرار می‌دهیم.
    _startTimer();
  }

  void _handleBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordPage(),
      ),
    );
  }

  // ------------------------------------------------------------
  // Code Field
  // ------------------------------------------------------------

  Widget _buildCodeField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required FocusNode? nextFocus,
    required FocusNode? previousFocus,
  }) {
    return AppTextField(
      controller: controller,
      focusNode: focusNode,

      width: 64,
      height: 64,

      textAlign: TextAlign.center,

      keyboardType: TextInputType.number,

      textInputAction: TextInputAction.next,

      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(1),
      ],

      onChanged: (value) {
        _handleCodeChanged(
          value,
          nextFocus,
        );
      },

      onSubmitted: (_) {
        if (nextFocus != null) {
          nextFocus.requestFocus();
        }
      },
    );
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
                            // Remaining Time + Resend
                            // ========================================

                            Row(
                              mainAxisSize:
                                  MainAxisSize.min,

                              crossAxisAlignment:
                                  CrossAxisAlignment.center,

                              children: [

                                const Text(
                                  'زمان باقی مانده:',
                                  style: TextStyle(
                                    fontFamily:
                                        'Estedad-VF',
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w600,
                                    color:
                                        Color(0xFF101018),
                                  ),
                                ),

                                const SizedBox(
                                  width: 16,
                                ),

                                Text(
                                  _formattedTime,
                                  style:
                                      const TextStyle(
                                    fontFamily:
                                        'Estedad-VF',
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w600,
                                    color:
                                        Color(0xFF101018),
                                  ),
                                ),

                                const SizedBox(
                                  width: 32,
                                ),

                                CustomButton(
                                  label:
                                      'ارسال مجدد',

                                  type:
                                      ButtonType.tertiary,

                                  width: 140,

                                  onPressed:
                                      _canResend
                                          ? _handleResendCode
                                          : null,
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 24,
                            ),

                            // ========================================
                            // Verification Code Fields
                            // ========================================

                            Row(
                              mainAxisSize:
                                  MainAxisSize.min,

                              children: [

                                _buildCodeField(
                                  controller:
                                      _code1Controller,
                                  focusNode:
                                      _focusNode1,
                                  nextFocus:
                                      _focusNode2,
                                  previousFocus:
                                      null,
                                ),

                                const SizedBox(
                                  width: 16,
                                ),

                                _buildCodeField(
                                  controller:
                                      _code2Controller,
                                  focusNode:
                                      _focusNode2,
                                  nextFocus:
                                      _focusNode3,
                                  previousFocus:
                                      _focusNode1,
                                ),

                                const SizedBox(
                                  width: 16,
                                ),

                                _buildCodeField(
                                  controller:
                                      _code3Controller,
                                  focusNode:
                                      _focusNode3,
                                  nextFocus:
                                      _focusNode4,
                                  previousFocus:
                                      _focusNode2,
                                ),

                                const SizedBox(
                                  width: 16,
                                ),

                                _buildCodeField(
                                  controller:
                                      _code4Controller,
                                  focusNode:
                                      _focusNode4,
                                  nextFocus:
                                      null,
                                  previousFocus:
                                      _focusNode3,
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 64,
                            ),

                            // ========================================
                            // Verify Code
                            // ========================================

                            CustomButton(
                              label:
                                  'تایید کد',

                              type:
                                  ButtonType.primary,

                              width: 204,

                              onPressed:
                                  _handleVerifyCode,
                            ),

                            const SizedBox(
                              height: 24,
                            ),

                            // ========================================
                            // Back
                            // ========================================

                            CustomButton(
                              label:
                                  'بازگشت',

                              type:
                                  ButtonType.tertiary,

                              width: 204,

                              onPressed:
                                  _handleBack,
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