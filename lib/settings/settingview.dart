import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_application_1/widgets/buttons.dart';
import 'package:flutter_application_1/widgets/page_scaffold.dart';
import 'package:flutter_application_1/settings/edit_setting.dart';
import 'package:flutter_application_1/core/session.dart';
import 'package:flutter_application_1/authentication/user_repository.dart';
import 'package:flutter_application_1/core/theme.dart';

class SettingsViewPage extends StatefulWidget {
  const SettingsViewPage({super.key});

  @override
  State<SettingsViewPage> createState() => _SettingsViewPageState();
}

class _SettingsViewPageState extends State<SettingsViewPage> {
  String _username = '';

  /// The forgot-password recovery answer; stored under the legacy-named
  /// `UserDb.email` column.
  String _recoveryAnswer = '';

  bool _isLoading = true;

  static TextStyle get _labelStyle => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static TextStyle get _valueStyle => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.text,
  );

  Widget _buildLabelRow(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: _labelStyle, textAlign: TextAlign.right),

        SizedBox(width: 16.w),

        // Values are user-controlled: a long username must ellipsize instead
        // of overflowing the row.
        Flexible(
          child: Text(
            value,
            style: _valueStyle,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await UserRepository.instance.getUser();

      if (!mounted) return;

      if (user == null) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('کاربر پیدا نشد')));
        return;
      }

      setState(() {
        _username = user.username;
        _recoveryAnswer = user.email;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('LOAD USER ERROR: $e');
      debugPrint('$stackTrace');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('خطا در دریافت اطلاعات کاربر')));
    }
  }

  Future<void> _handleEdit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          initialUsername: _username,
          initialRecoveryAnswer: _recoveryAnswer,
        ),
      ),
    );

    if (!mounted) return;

    _loadUser();
  }

  Future<void> _handleSignOut() async {
    final bool confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('خروج از حساب'),
            content: const Text('از حساب کاربری خارج می‌شوید؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('لغو'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('خروج'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed || !mounted) return;

    // Clearing the session is enough: the gate swaps to the login page, and
    // popping drops this settings page.
    SessionScope.of(context).signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'تنظیمات',

      children: [
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else ...[
          _buildLabelRow('نام کاربری:', _username),

          const SizedBox(height: 24),

          _buildLabelRow('رنگ مورد علاقه:', _recoveryAnswer),

          const SizedBox(height: 64),

          Center(
            child: CustomButton(
              label: 'ویرایش',
              type: ButtonType.primary,
              width: 204.w,
              icon: const Icon(Icons.edit),
              onPressed: _handleEdit,
            ),
          ),

          const SizedBox(height: 24),

          Center(
            child: CustomButton(
              label: 'خروج از حساب',
              type: ButtonType.tertiary,
              width: 204.w,
              onPressed: _handleSignOut,
            ),
          ),
        ],
      ],
    );
  }
}
