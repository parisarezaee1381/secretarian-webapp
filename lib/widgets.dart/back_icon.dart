import 'package:flutter/material.dart';
import 'hoverablecontainer.dart';

/// دکمه‌ی بازگشت استاندارد برنامه.
///
/// نسبت به نسخه‌ی قبلی:
/// * **حذف افکت press مرده**: در کد قبلی فیلد `_isPressed` تعریف شده بود
///   ولی هیچ‌جا (نه در `onTapDown`، نه جای دیگری) مقدارش تغییر نمی‌کرد؛
///   یعنی همیشه `false` می‌ماند و کل منطق کوچک‌شدن آیکون هنگام press
///   (`pressedSize`) و `AnimatedSwitcher` دورش، کد مرده و کاملاً بی‌اثر
///   بود. چون [HoverableContainer] خودش hover، press (با یک scale ظریف)،
///   غیرفعال بودن و فوکوس با کیبورد را به‌درستی مدیریت می‌کند، این ویجت
///   الان یک `StatelessWidget` ساده است که فقط از آن استفاده می‌کند —
///   بدون نیاز به state و بدون تکرار منطق.
/// * **رفع جهت پیکان در RTL**: چون این یک اپ فارسی/راست‌به‌چپ است، پیکان
///   بازگشت باید در چیدمان RTL به سمت راست اشاره کند. به‌جای تلاش برای
///   mirror کردن گرافیکی آیکون (که `Icon` چنین قابلیتی ندارد)، بر اساس
///   `Directionality.of(context)` بین `Icons.arrow_back` و
///   `Icons.arrow_forward` سوییچ می‌کنیم؛ همان روشی که خودِ فلاتر هم در
///   ویجت داخلی `BackButtonIcon` استفاده می‌کند.
/// * **افزایش ناحیه‌ی لمسی به حداقل اندازه‌ی قابل دسترس**: قبلاً ناحیه‌ی
///   قابل لمس دقیقاً برابر اندازه‌ی بصری آیکون (پیش‌فرض ۳۲ پیکسل) بود که
///   کمتر از حداقل توصیه‌شده (۴۴dp/pt) برای دکمه‌های لمسی است. الان
///   اندازه‌ی ناحیه‌ی لمسی از اندازه‌ی بصری آیکون جدا شده و پیش‌فرض حداقل
///   ۴۴ پیکسل است، بدون این‌که خودِ آیکون درشت‌تر به‌نظر برسد.
/// * **پارامترهای اضافه**: `isDisabled`، `semanticLabel` (برای
///   دسترس‌پذیری) و `icon` سفارشی.
class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    required this.onPressed,
    this.icon,
    this.iconColor = const Color(0xFF3863A8),
    this.size = 32,
    this.touchTargetSize,
    this.hoverBackgroundColor = const Color(0xFF828288),
    this.hoverBackgroundOpacity = 0.5,
    this.borderRadius = 10,
    this.isDisabled = false,
    this.semanticLabel = 'بازگشت',
  });

  final VoidCallback onPressed;

  /// آیکون سفارشی. اگر ندهید، بر اساس جهت متن (`Directionality`) به‌طور
  /// خودکار بین `Icons.arrow_back` (LTR) و `Icons.arrow_forward` (RTL)
  /// انتخاب می‌شود تا جهت پیکان بازگشت همیشه درست باشد.
  final IconData? icon;
  final Color iconColor;

  /// اندازه‌ی بصری آیکون.
  final double size;

  /// اندازه‌ی ناحیه‌ی قابل لمس. اگر ندهید، حداقل ۴۴ پیکسل یا اندازه‌ی
  /// آیکون (هرکدام بزرگ‌تر بود) استفاده می‌شود.
  final double? touchTargetSize;

  final Color hoverBackgroundColor;
  final double hoverBackgroundOpacity;
  final double borderRadius;
  final bool isDisabled;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final effectiveTouchSize = touchTargetSize ?? (size < 44 ? 44 : size);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final resolvedIcon = icon ?? (isRtl ? Icons.arrow_forward : Icons.arrow_back);

    return HoverableContainer(
      width: effectiveTouchSize,
      height: effectiveTouchSize,
      borderRadius: borderRadius,
      hoverColor: hoverBackgroundColor,
      hoverOpacity: hoverBackgroundOpacity,
      isDisabled: isDisabled,
      semanticLabel: semanticLabel,
      onTap: onPressed,
      child: Center(
        child: Icon(
          resolvedIcon,
          color: iconColor,
          size: size,
        ),
      ),
    );
  }
}