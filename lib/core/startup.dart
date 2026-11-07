import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'theme.dart';

/// Shown while [SessionController.start] is working.
class StartupLoadingScreen extends StatelessWidget {
  const StartupLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            SizedBox(
              width: 28.r,
              height: 28.r,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),

            SizedBox(height: 20.h),

            Text(
              'در حال بارگذاری اطلاعات…',
              style: TextStyle(fontSize: 15.sp, color: AppColors.mutedText),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when startup failed, so the failure is visible and retryable instead of
/// leaving an empty window behind.
class StartupErrorScreen extends StatelessWidget {
  const StartupErrorScreen({super.key, this.error, required this.onRetry});

  /// The startup failure, shown verbatim so it can be reported.
  final Object? error;

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),

          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                const Icon(
                  Icons.storage_rounded,
                  size: 44,
                  color: AppColors.error,
                ),

                SizedBox(height: 20.h),

                Text(
                  'باز کردن پایگاه داده ناموفق بود',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),

                SizedBox(height: 12.h),

                Text(
                  'اطلاعات برنامه بارگذاری نشد. اگر نمونه‌ی دیگری از برنامه باز است، آن را ببندید و دوباره تلاش کنید.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.7,
                    color: AppColors.mutedText,
                  ),
                ),

                SizedBox(height: 20.h),

                Container(
                  constraints: const BoxConstraints(maxHeight: 140),
                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),

                  child: SingleChildScrollView(
                    child: SelectableText(
                      error?.toString() ?? 'خطای نامشخص',

                      // Exception text is usually Latin, so it reads left to
                      // right even inside the app's RTL layout.
                      textDirection: TextDirection.ltr,

                      style: TextStyle(
                        fontSize: 12.sp,
                        height: 1.6,
                        color: AppColors.mutedText,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Kept at its intrinsic width instead of stretching the column.
                Align(
                  child: FilledButton.icon(
                    onPressed: onRetry,

                    icon: const Icon(Icons.refresh_rounded, size: 18),

                    label: const Text('تلاش دوباره'),

                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.surface,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
