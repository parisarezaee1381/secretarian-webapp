import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_application_1/core/app_constants.dart';
import 'package:flutter_application_1/widgets/header.dart';
import 'package:flutter_application_1/core/theme.dart';

/// Shared chrome for the settings-style pages: a titled header with a back
/// button, a padded scroll body, and the version label pinned at the bottom.
class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;

  /// The page body, rendered above the version label.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppHeader(title: title, leading: HeaderLeading.back),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 128.h),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            // چون پروژه RTL است:
            // start = سمت راست
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              ...children,

              const SizedBox(height: 64),

              Center(
                child: Text(
                  kAppVersionLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
