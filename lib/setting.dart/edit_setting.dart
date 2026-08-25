import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets.dart/header.dart';
import 'package:flutter_application_1/widgets.dart/text_input.dart';
import 'package:flutter_application_1/widgets.dart/buttons.dart';
import 'package:flutter_application_1/setting.dart/settingview.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.initialUsername,
    required this.initialEmail,
  });

  final String initialUsername;
  final String initialEmail;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _usernameController =
      TextEditingController(text: widget.initialUsername);

  late final TextEditingController _emailController =
      TextEditingController(text: widget.initialEmail);

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'ایمیل را وارد کنید';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'فرمت ایمیل صحیح نیست';
    }

    return null;
  }

  // رفتن به صفحه مشاهده رمز عبور
  Future<void> _handleChangePassword() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const SettingsViewPage(username: '', email: '',),
      ),
    );

    if (result == true) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('عملیات با موفقیت انجام شد'),
        ),
      );
    }
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      // منطق ثبت اطلاعات را اینجا اضافه کن
    }
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F7),

      appBar: const AppHeader(
        title: 'ویرایش اطلاعات',
        leading: HeaderLeading.back,
      ),

      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 32),
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
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? 'نام کاربری را وارد کنید'
                                : null,
                      ),

                      const SizedBox(height: 24),

                      AppTextField(
                        controller: _emailController,
                        labelText: 'ایمیل',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validator: _emailValidator,
                      ),

                      const SizedBox(height: 64),

                      // مشاهده رمز عبور
                      CustomButton(
                        label: 'مشاهده رمز عبور',
                        type: ButtonType.secondary,
                        width: 204,
                        onPressed: _handleChangePassword,
                      ),

                      const SizedBox(height: 64),

                      // ثبت و لغو
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomButton(
                            label: 'ثبت',
                            type: ButtonType.primary,
                            width: 204,
                            onPressed: _handleSave,
                          ),

                          const SizedBox(width: 32),

                          CustomButton(
                            label: 'لغو',
                            type: ButtonType.secondary,
                            width: 204,
                            onPressed: _handleCancel,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // متن نسخه؛ همیشه ۱۲۸ پیکسل از پایین صفحه، وسط‌چین
          const Positioned(
            left: 0,
            right: 0,
            bottom: 128,
            child: Center(
              child: Text(
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
          ),
        ],
      ),
    );
  }
}