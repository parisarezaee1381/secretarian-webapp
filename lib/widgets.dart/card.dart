import 'package:flutter/material.dart';

class FakoorLoginCard extends StatelessWidget {
  final Widget? child;

  /// اگر false باشد، اندازه‌های دسکتاپ قبلی حفظ می‌شوند.
  final bool responsive;

  const FakoorLoginCard({super.key, this.child, this.responsive = true});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        final bool isMobile = responsive && screenWidth < 600;

        final bool isTablet =
            responsive && screenWidth >= 600 && screenWidth < 900;

        // --------------------------------
        // Card Width
        // --------------------------------

        final double cardWidth = !responsive
            ? 808
            : isMobile
            ? screenWidth - 32
            : isTablet
            ? screenWidth - 64
            : 808;

        // --------------------------------
        // Padding
        // --------------------------------

        final double verticalPadding = !responsive
            ? 64
            : isMobile
            ? 32
            : isTablet
            ? 48
            : 64;

        // --------------------------------
        // Logo
        // --------------------------------

        final double logoWidth = !responsive
            ? 120
            : isMobile
            ? 96
            : isTablet
            ? 108
            : 120;

        final double logoHeight = !responsive
            ? 64
            : isMobile
            ? 52
            : isTablet
            ? 58
            : 64;

        // --------------------------------
        // Title
        // --------------------------------

        final double titleFontSize = !responsive
            ? 20
            : isMobile
            ? 18
            : isTablet
            ? 19
            : 20;

        // --------------------------------
        // Spacing
        // --------------------------------

        final double logoTitleSpacing = isMobile ? 24 : 32;

        final double titleContentSpacing = isMobile ? 40 : 64;

        return Center(
          child: Container(
            width: cardWidth,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F7).withValues(alpha: 0.9),
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
                  // -------------------------
                  // Logo
                  // -------------------------

                  Image.asset(
                    'assets/images/logo.png',
                    width: logoWidth,
                    height: logoHeight,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: logoTitleSpacing),

                  // -------------------------
                  // Title
                  // -------------------------
                  Text(
                    'سیستم دبیرخانه فکور',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Estedad-VF',
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF101018),
                    ),
                  ),

                  // -------------------------
                  // Content
                  // -------------------------
                  if (child != null) ...[
                    SizedBox(height: titleContentSpacing),
                    child!,
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
