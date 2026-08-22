import 'package:flutter/material.dart';
import 'back_icon.dart';

/// رنگ‌های پیش‌فرض [AppHeader].
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

/// نوع آیتم سمت leading هدر.
enum HeaderLeading {
  back,
  settings,
  none,
}

/// هدر استاندارد برنامه.
class AppHeader extends StatelessWidget
    implements PreferredSizeWidget {
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

  @override
  Size get preferredSize => Size.fromHeight(height);

  Widget _buildLeading(BuildContext context) {
    switch (leading) {
      case HeaderLeading.back:
        return AppBackButton(
    onPressed: onLeadingPressed, 
    iconColor: colors.icon,
    size: 32,
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
        return const SizedBox(width: 32);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sideReserved =
        (logoWidth > 48.0 ? logoWidth : 48.0) + 16;

    return Semantics(
      header: true,
      child: Container(
        height: height,
        width: double.infinity,
        color: colors.background,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // دکمه‌ی Back یا Settings
            Positioned(
              left: 0,
              child: _buildLeading(context),
            ),

            // عنوان
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sideReserved,
              ),
              child: Text(
                title,
                style: titleStyle ??
                    TextStyle(
                      color: colors.title,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Estedad',
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // لوگوی ثابت برنامه
            Positioned(
              right: 0,
              child: SizedBox(
                width: logoWidth,
                height: logoHeight,
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
  }
}

/// دکمه‌ی آیکون‌دار عمومی برای سمت leading هدر.
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

class _HeaderIconButtonState
    extends State<_HeaderIconButton> {
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
                  ? widget.hoverColor.withValues(
                      alpha: widget.hoverOpacity,
                    )
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