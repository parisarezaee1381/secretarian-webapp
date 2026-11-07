import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_application_1/widgets/text_input.dart';
import 'package:flutter_application_1/widgets/buttons.dart';
import 'package:flutter_application_1/widgets/page_scaffold.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:flutter_application_1/authentication/user_repository.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.initialUsername,
    required this.initialRecoveryAnswer,
  });

  final String initialUsername;
  final String initialRecoveryAnswer;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _usernameController = TextEditingController(
    text: widget.initialUsername,
  );

  late final TextEditingController _recoveryAnswerController =
      TextEditingController(text: widget.initialRecoveryAnswer);

  bool _isSubmitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
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

  Future<void> _handleChangePassword() async {
    // Left untyped on purpose: a named route is generated as Route<dynamic>, so
    // asking for Route<bool> here would only risk a cast failure.
    final result = await Navigator.of(context).pushNamed(
      AppRoutes.changePassword,
    );

    if (result == true) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رمز عبور با موفقیت تغییر کرد')),
      );
    }
  }

  Future<void> _handleSave() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      await UserRepository.instance.updateUser(
        username: _usernameController.text.trim(),
        recoveryAnswer: _recoveryAnswerController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اطلاعات با موفقیت ذخیره شد')),
      );

      Navigator.of(context).pop();
    } catch (e, stackTrace) {
      debugPrint('SAVE PROFILE ERROR: $e');
      debugPrint('$stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e is UserFacingException
                ? e.message
                : 'خطا در ذخیره اطلاعات. دوباره تلاش کنید.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'ویرایش تنظیمات',

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
                controller: _usernameController,
                labelText: 'نام کاربری',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: _usernameValidator,
              ),

              const SizedBox(height: 24),

              AppTextField(
                controller: _recoveryAnswerController,
                labelText: 'رنگ مورد علاقه',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                validator: _recoveryAnswerValidator,
              ),

              const SizedBox(height: 64),

              Center(
                child: CustomButton(
                  label: 'تغییر رمز عبور',
                  type: ButtonType.secondary,
                  width: 204.w,
                  onPressed: _handleChangePassword,
                ),
              ),

              const SizedBox(height: 64),

              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      label: 'ثبت',
                      type: ButtonType.primary,
                      width: 204.w,
                      isLoading: _isSubmitting,
                      onPressed: _handleSave,
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
