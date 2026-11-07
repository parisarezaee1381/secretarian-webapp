import 'package:flutter/material.dart';
import 'back_icon.dart';
import 'hoverablecontainer.dart';
import '../core/app_constants.dart';
import 'package:flutter_application_1/core/theme.dart';

@immutable
class AppHeaderColors {
  const AppHeaderColors({
    this.background = AppColors.border,
    this.title = AppColors.text,
    this.icon = AppColors.primary,
    this.hover = AppColors.mutedText,
    this.hoverOpacity = 0.5,
  });

  final Color background;
  final Color title;
  final Color icon;
  final Color hover;
  final double hoverOpacity;
}

enum HeaderLeading { back, settings, none }

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    super.key,
    required this.title,
    this.leading = HeaderLeading.back,
    this.onLeadingPressed,
    this.logoWidth = 120,
    this.logoHeight = 64,
    this.height = 80,
    this.horizontalPadding = 24,
    this.titleStyle,
    this.colors = const AppHeaderColors(),
    this.responsive = true,
  });

  final String title;

  final HeaderLeading leading;
  final VoidCallback? onLeadingPressed;

  final double logoWidth;
  final double logoHeight;
  final double height;
  final double horizontalPadding;

  final TextStyle? titleStyle;
  final AppHeaderColors colors;

  final bool responsive;

  @override
  Size get preferredSize => Size.fromHeight(height);

  Widget _buildLeading(BuildContext context, double iconSize) {
    switch (leading) {
      case HeaderLeading.back:
        return AppBackButton(
          onPressed: onLeadingPressed,
          iconColor: colors.icon,
          size: iconSize,
          hoverBackgroundColor: colors.hover,
          hoverBackgroundOpacity: colors.hoverOpacity,
          borderRadius: 10,
        );

      case HeaderLeading.settings:
        return HoverableContainer(
          padding: const EdgeInsets.all(6),
          borderRadius: 10,
          hoverColor: colors.hover,
          hoverOpacity: colors.hoverOpacity,
          isDisabled: onLeadingPressed == null,
          semanticLabel: 'تنظیمات',
          onTap: onLeadingPressed,
          child: Icon(
            Icons.settings_outlined,
            color: colors.icon,
            size: iconSize,
          ),
        );

      case HeaderLeading.none:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;

        final bool isMobile = responsive && screenWidth < 600;

        final bool isTablet =
            responsive && screenWidth >= 600 && screenWidth < 900;

        final double headerHeight = !responsive
            ? height
            : isMobile
            ? 64
            : isTablet
            ? 72
            : height;

        final double padding = !responsive
            ? horizontalPadding
            : isMobile
            ? 12
            : isTablet
            ? 16
            : horizontalPadding;

        final double currentLogoWidth = !responsive
            ? logoWidth
            : isMobile
            ? 72
            : isTablet
            ? 96
            : logoWidth;

        final double currentLogoHeight = !responsive
            ? logoHeight
            : isMobile
            ? 48
            : isTablet
            ? 56
            : logoHeight;

        // آیکون
        final double iconSize = isMobile ? 28 : 32;

        // عنوان
        final double titleFontSize = !responsive
            ? 24
            : isMobile
            ? 18
            : isTablet
            ? 21
            : 24;

        final double leftSpace = leading == HeaderLeading.none
            ? 16
            : iconSize + 24;

        final double rightSpace = currentLogoWidth + 24;

        return Semantics(
          // A boundary with explicit child nodes, so the leading button, the
          // title and the logo each get their own semantics node instead of
          // collapsing into this one.
          container: true,
          explicitChildNodes: true,
          header: true,
          child: Container(
            width: double.infinity,
            height: headerHeight,
            color: colors.background,
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(child: _buildLeading(context, iconSize)),
                ),

                Positioned(
                  left: leftSpace,
                  right: rightSpace,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          titleStyle ??
                          TextStyle(
                            color: colors.title,
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),

                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: SizedBox(
                    width: currentLogoWidth,
                    height: currentLogoHeight,
                    child: Image.asset(
                      kLogoAssetPath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('logo asset failed to load: $error');
                        return Icon(Icons.image_outlined, color: colors.icon);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

