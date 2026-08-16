import 'package:flutter/material.dart';
import 'back_icon.dart';

/// رنگ‌های پیش‌فرض [AppHeader].
@immutable
class AppHeaderColors {
  const AppHeaderColors({
    this.background = const Color(0xFFBBBBC0), // Neutral
    this.title = const Color(0xFF101018), // Text
    this.icon = const Color(0xFF3863A8), // Primary
    this.hover = const Color(0xFF828288), // Secondary
    this.hoverOpacity = 0.5,
  });

  final Color background;
  final Color title;
  final Color icon;
  final Color hover;
  final double hoverOpacity;
}

/// نوع آیتم سمت leading هدر (در فارسی: سمت راست چون RTL پیش‌فرض است، اما
/// از نظر layout همان سمت «شروع» صفحه محسوب می‌شود).
enum HeaderLeading { back, settings, none }

/// ویجت هدر استاندارد برنامه.
///
/// شامل:
/// - عنوان صفحه (همیشه واقعاً در مرکز هدر، بدون همپوشانی با لوگو یا آیکون)
/// - دکمه بازگشت یا تنظیمات در سمت leading
/// - لوگو در سمت trailing (اجباری)
///
/// تغییرات نسبت به نسخه‌ی قبلی:
/// * **رفع باگ آیکون تنظیمات**: قبلاً وقتی `showSettings: true` بود، از
///   همان `AppBackButton` (که آیکون فلش بازگشت است) استفاده می‌شد و در
///   عمل یک فلش بازگشت به‌جای آیکون تنظیمات نمایش داده می‌شد. حالا یک
///   دکمه‌ی آیکون‌دار عمومی (`_HeaderIconButton`) با همان استایل hover/press
///   ساخته شده که می‌تواند هر `IconData` ای (از جمله تنظیمات) را نشان دهد.
/// * **جلوگیری از همپوشانی عنوان**: قبلاً عنوان با `Center` روی کل عرض
///   Container قرار می‌گرفت و اگر متن بلند بود می‌توانست زیر لوگو یا آیکون
///   برود. حالا با محاسبه‌ی فضای رزرو‌شده در دو طرف (بر اساس بیشترین عرض
///   بین آیکون leading و لوگو)، عنوان همیشه در فضای امن قرار می‌گیرد و در
///   صورت طولانی بودن با `ellipsis` کوتاه می‌شود.
/// * **enum به‌جای دو فلگ بولی**: `showBackButton` و `showSettings` قبلاً
///   می‌توانستند هم‌زمان true باشند (که رفتار مبهم داشت چون بازگشت اولویت
///   داشت). حالا `HeaderLeading` این حالت را از نظر نوع داده غیرممکن می‌کند.
/// * رنگ‌ها در `AppHeaderColors` جمع شده‌اند تا قابل شخصی‌سازی از بیرون
///   باشند (به‌جای static const ثابت).
/// * `Semantics(header: true)` برای دسترس‌پذیری بهتر اضافه شده.
/// * پارامترهای اختیاری برای ارتفاع، padding افقی و استایل عنوان.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    super.key,
    required this.title,
    required this.logo,
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
  final Widget logo;

  /// نوع آیتم سمت leading. برای مخفی کردنش [HeaderLeading.none] بدهید.
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
          onPressed: onLeadingPressed ?? () => Navigator.of(context).pop(),
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
    // بیشترین عرض بین آیتم leading و لوگو، برای اینکه عنوان همیشه در فضای
    // امن و واقعاً در مرکز باقی بماند.
    final sideReserved = (logoWidth > 48.0 ? logoWidth : 48.0) + 16;

    return Semantics(
      header: true,
      child: Container(
        height: height,
        width: double.infinity,
        color: colors.background,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0,
              child: _buildLeading(context),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sideReserved),
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
            Positioned(
              right: 0,
              child: SizedBox(
                width: logoWidth,
                height: logoHeight,
                child: logo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// دکمه‌ی آیکون‌دار عمومی برای سمت leading هدر (مثلاً تنظیمات)، با همان
/// استایل hover/press که [AppBackButton] دارد.
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
  State<_HeaderIconButton> createState() => _HeaderIconButtonState();
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
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
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