import 'package:flutter/material.dart';
import 'back_icon.dart';

@immutable
class AppHeaderColors {
  const AppHeaderColors({
    this.background = const Color(0xFFBBBBC0),
    this.title = const Color(0xFF101018),
    this.icon = const Color(0xFF3863A8),
    this.hover = const Color(0xFF828288),
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
        return _HeaderIconButton(
          icon: Icons.settings_outlined,
          onPressed: onLeadingPressed ?? () {},
          iconColor: colors.icon,
          hoverColor: colors.hover,
          hoverOpacity: colors.hoverOpacity,
          semanticLabel: 'تنظیمات',
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
                            fontFamily: 'Estedad',
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
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
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

class _HeaderIconButton extends StatefulWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onPressed,
    required this.iconColor,
    required this.hoverColor,
    required this.hoverOpacity,
    this.semanticLabel,
  });

  static const double _iconSize = 32;

  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;
  final Color hoverColor;
  final double hoverOpacity;
  final String? semanticLabel;

  @override
  State<_HeaderIconButton> createState() {
    return _HeaderIconButtonState();
  }
}

class _HeaderIconButtonState extends State<_HeaderIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovered = false;
          });
        },
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _isHovered
                  ? widget.hoverColor.withValues(alpha: widget.hoverOpacity)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              widget.icon,
              color: widget.iconColor,
              size: _HeaderIconButton._iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
