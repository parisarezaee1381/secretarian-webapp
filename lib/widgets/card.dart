import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_application_1/core/app_constants.dart';
import 'package:flutter_application_1/core/theme.dart';

/// The login/registration card.
///
/// The card only frames a form: the logo above the title is a plain picture.
/// Opening the app happens on the welcome screen, which shows the same logo
/// full size and is clicked once to enter.
class FakoorLoginCard extends StatefulWidget {
  final Widget? child;

  /// Если false, то размеры десктопные предыдущие сохраняются.
  final bool responsive;

  const FakoorLoginCard({super.key, this.child, this.responsive = true});

  @override
  State<FakoorLoginCard> createState() => _FakoorLoginCardState();
}

class _FakoorLoginCardState extends State<FakoorLoginCard> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        final bool isMobile = widget.responsive && screenWidth < 600;

        final bool isTablet =
            widget.responsive && screenWidth >= 600 && screenWidth < 900;

        final double cardWidth = !widget.responsive
            ? 808
            : isMobile
            ? screenWidth - 32
            : isTablet
            ? screenWidth - 64
            : 808;

        final double verticalPadding = !widget.responsive
            ? 64
            : isMobile
            ? 32
            : isTablet
            ? 48
            : 64;

        final double logoTitleSpacing = isMobile ? 24 : 32;

        return Center(
          child: Container(
            width: cardWidth,
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.9),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: verticalPadding,
                bottom: verticalPadding,
                left: isMobile ? 16 : 32,
                right: isMobile ? 16 : 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    kLogoAssetPath,
                    width: 120.w,
                    height: 64.w,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('logo asset failed to load: $error');
                      return Icon(
                        Icons.image_outlined,
                        color: AppColors.mutedText,
                        size: 64.w,
                      );
                    },
                  ),

                  SizedBox(height: logoTitleSpacing),

                  Text(
                    'سیستم دبیرخانه فکور',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),

                  if (widget.child != null) ...[
                    SizedBox(height: 40.w),
                    widget.child!,
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
