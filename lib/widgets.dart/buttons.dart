import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ButtonType { primary, secondary, tertiary }

/// رنگ‌های پیش‌فرض یک نوع دکمه.
@immutable
class _ButtonTypeColors {
  const _ButtonTypeColors({
    required this.background,
    required this.text,
    required this.border,
  });

  final Color background;
  final Color text;
  final Color border;
}

const Map<ButtonType, _ButtonTypeColors> _kDefaultColors = {
  ButtonType.primary: _ButtonTypeColors(
    background: Color(0xFF3863A8),
    text: Color(0xFFF3F3F7),
    border: Colors.transparent,
  ),
  ButtonType.secondary: _ButtonTypeColors(
    background: Color(0xFF828288),
    text: Color(0xFFF3F3F7),
    border: Colors.transparent,
  ),
  ButtonType.tertiary: _ButtonTypeColors(
    background: Colors.transparent,
    text: Color(0xFF101018),
    border: Color(0xFF101018),
  ),
};

/// یک دکمه‌ی سفارشی با سه نوع ظاهری (primary/secondary/tertiary)، پشتیبانی
/// از hover، press، غیرفعال، بارگذاری (loading) و آیکون کنار متن.
///
/// تغییرات نسبت به نسخه‌ی قبلی:
/// * **رفع باگ کوچک‌شدن اندازه هنگام press**: قبلاً هنگام press، عرض
///   (۲۰۴ → ۱۹۶) و ارتفاع (۶۴ → ۶۰) واقعی دکمه کم می‌شد. اگر این دکمه
///   کنار ویجت‌های دیگری در یک `Row`/`Column` قرار می‌گرفت، این تغییر
///   اندازه باعث جابه‌جایی آن‌ها هم می‌شد. الان اندازه‌ی بیرونی همیشه
///   ثابت است و فیدبک press فقط با یک `AnimatedScale` ظریف روی محتوای
///   داخلی داده می‌شود.
/// * **رفع باگ نادیده گرفتن `width`/`height` سفارشی در حالت غیرفعال**:
///   قبلاً وقتی `isDisabled: true` بود، حتی اگر `width`/`height` سفارشی
///   داده بودید، دکمه به‌جای آن مقدار، به اندازه‌ی پیش‌فرض (۲۰۴×۶۴)
///   برمی‌گشت. الان `width`/`height` سفارشی همیشه اولویت دارند.
/// * **رفع باگ نادیده گرفتن `borderColor` سفارشی برای primary/secondary**:
///   قبلاً ضخامت border فقط بر اساس نوع دکمه (`tertiary`) تعیین می‌شد؛
///   یعنی اگر برای یک دکمه‌ی primary مقدار `borderColor` می‌دادید، چون
///   ضخامت border صفر بود، اصلاً دیده نمی‌شد. الان دادن `borderColor`
///   سفارشی به‌تنهایی هم border را قابل‌مشاهده می‌کند.
/// * **حالت `isLoading`**: در زمان انجام یک عملیات ناهمگام، دکمه یک
///   spinner نشان می‌دهد و از تعامل مجدد جلوگیری می‌کند (بدون نیاز به
///   `isDisabled` دستی).
/// * **آیکون اختیاری** کنار برچسب دکمه.
/// * **دسترس‌پذیری**: قابل فوکوس با کیبورد و فعال‌سازی با Space/Enter،
///   به‌همراه `Semantics(button: true)`.
/// * `onPressed == null` یعنی دکمه به‌صورت خودکار غیرفعال است (مشابه
///   دکمه‌های استاندارد فلاتر)، بدون نیاز به ست کردن `isDisabled` جداگانه.
/// * منطق رنگ‌ها ساده‌تر شده: به‌جای سه متد جدا با سه `switch` تکراری،
///   رنگ‌های هر نوع دکمه در یک جدول (`_kDefaultColors`) نگه داشته می‌شوند.
class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isDisabled = false,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.height,
    this.borderRadius = 10,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
    this.duration = const Duration(milliseconds: 100),
    this.pressedDuration = const Duration(milliseconds: 300),
    this.focusNode,
    this.autofocus = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isDisabled;
  final bool isLoading;
  final Widget? icon;

  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsets padding;

  final Duration duration;
  final Duration pressedDuration;

  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();

  bool _isHovered = false;
  bool _isPressed = false;

  bool get _isInteractive =>
      !widget.isDisabled && !widget.isLoading && widget.onPressed != null;

  _ButtonTypeColors get _typeColors => _kDefaultColors[widget.type]!;

  /// border فقط وقتی رسم می‌شود که نوع دکمه tertiary باشد یا کاربر
  /// صراحتاً `borderColor` سفارشی داده باشد.
  bool get _hasVisibleBorder =>
      widget.type == ButtonType.tertiary || widget.borderColor != null;

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _setHovered(bool hovered) {
    if (!_isInteractive) return;
    setState(() {
      _isHovered = hovered;
      if (!hovered) _isPressed = false;
    });
  }

  void _setPressed(bool pressed) {
    if (!_isInteractive) return;
    setState(() => _isPressed = pressed);
  }

  void _handlePress() {
    if (!_isInteractive) return;
    widget.onPressed?.call();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (!_isInteractive) return;
    if (event is KeyDownEvent &&
        (event.logicalKey == LogicalKeyboardKey.space ||
            event.logicalKey == LogicalKeyboardKey.enter)) {
      _setPressed(true);
      _handlePress();
    } else if (event is KeyUpEvent &&
        (event.logicalKey == LogicalKeyboardKey.space ||
            event.logicalKey == LogicalKeyboardKey.enter)) {
      _setPressed(false);
    }
  }

  Color _backgroundColor() {
    final base = widget.backgroundColor ?? _typeColors.background;
    if (!_isInteractive) return base.withValues(alpha: 0.5);
    if (_isPressed) return base.withValues(alpha: 0.5);
    return base;
  }

  Color _textColor() {
    final base = widget.textColor ?? _typeColors.text;
    return _isInteractive ? base : base.withValues(alpha: 0.5);
  }

  Color _borderColor() {
    final base = widget.borderColor ?? _typeColors.border;
    if (!_isInteractive) return base.withValues(alpha: 0.5);
    if (_isHovered && _hasVisibleBorder) return base.withValues(alpha: 0.5);
    return base;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _textColor();

    final content = widget.isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: textColor),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                IconTheme(
                  data: IconThemeData(color: textColor, size: 20),
                  child: widget.icon!,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Estedad',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    return Semantics(
      button: true,
      enabled: _isInteractive,
      label: widget.label,
      child: MouseRegion(
        onEnter: (_) => _setHovered(true),
        onExit: (_) => _setHovered(false),
        cursor: _isInteractive
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        child: Focus(
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          onKeyEvent: (node, event) {
            _handleKeyEvent(event);
            return KeyEventResult.handled;
          },
          child: GestureDetector(
            onTapDown: _isInteractive ? (_) => _setPressed(true) : null,
            onTapUp: _isInteractive
                ? (_) {
                    _setPressed(false);
                    _handlePress();
                  }
                : null,
            onTapCancel: _isInteractive ? () => _setPressed(false) : null,
            child: AnimatedScale(
              scale: _isPressed ? 0.97 : 1,
              duration: widget.duration,
              curve: Curves.easeOut,
              child: AnimatedContainer(
                duration: _isPressed ? widget.pressedDuration : widget.duration,
                curve: Curves.easeOut,
                width: widget.width,
                height: widget.height,
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: _backgroundColor(),
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: _hasVisibleBorder
                      ? Border.all(color: _borderColor(), width: 2)
                      : null,
                ),
                alignment: Alignment.center,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}