import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// رنگ‌های پیش‌فرض ویجت [AppSwitch].
@immutable
class AppSwitchColors {
  const AppSwitchColors({
    this.on = const Color(0xFF3863A8),
    this.off = const Color(0xFF828288),
    this.disabled = const Color(0xFFBBBBC0),
    this.thumb = const Color(0xFFF3F3F7),
    this.thumbDisabled = const Color(0xFFE0E0E4),
    this.hoverOpacity = 0.5,
  });

  final Color on;
  final Color off;
  final Color disabled;
  final Color thumb;
  final Color thumbDisabled;

  /// شفافیتی که هنگام hover روی رنگ track اعمال می‌شود.
  final double hoverOpacity;
}

/// یک سوییچ سفارشی با انیمیشن نرم، پشتیبانی از hover، فوکوس با صفحه‌کلید
/// (Space/Enter) و حالت غیرفعال.
///
/// در مقایسه با نسخه‌ی قبلی:
/// * با صفحه‌کلید هم قابل استفاده است (فوکوس‌پذیر + فعال‌سازی با
///   Space/Enter) که برای دسترس‌پذیری (Accessibility) لازم است.
/// * `Semantics` مناسب برای screen readerها دارد (`toggled`, `label`).
/// * حالت `enabled: false` را پشتیبانی می‌کند.
/// * اندازه‌ها (عرض، ارتفاع، اندازه‌ی thumb، padding) به‌جای مقادیر
///   ثابت، از طریق سازنده قابل تنظیم هستند.
/// * رنگ‌ها در یک کلاس جدا (`AppSwitchColors`) نگه‌داری می‌شوند تا قابل
///   استفاده‌ی مجدد و شخصی‌سازی باشند.
/// * رنگ track با `AnimatedContainer` و همچنین جابه‌جایی thumb با
///   `AnimatedAlign` انیمیشن می‌شوند (بدون تغییر رفتار قبلی).
/// * حلقه‌ی فوکوس (focus ring) ساده برای وضوح دسترس‌پذیری اضافه شده.
class AppSwitch extends StatefulWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.width = 128,
    this.height = 64,
    this.thumbPadding = 4,
    this.animationDuration = const Duration(milliseconds: 300),
    this.colors = const AppSwitchColors(),
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool autofocus;

  final double width;
  final double height;

  /// فاصله‌ی thumb از لبه‌های track.
  final double thumbPadding;

  final Duration animationDuration;
  final AppSwitchColors colors;

  @override
  State<AppSwitch> createState() => _AppSwitchState();
}

class _AppSwitchState extends State<AppSwitch> {
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();

  bool _isHovered = false;
  bool _isFocused = false;

  bool get _isInteractive => widget.enabled && widget.onChanged != null;

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _toggle() {
    if (!_isInteractive) return;
    widget.onChanged!(!widget.value);
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    if (event.logicalKey == LogicalKeyboardKey.space ||
        event.logicalKey == LogicalKeyboardKey.enter) {
      _toggle();
    }
  }

  Color _trackColor() {
    final colors = widget.colors;
    if (!_isInteractive) return colors.disabled;

    final baseColor = widget.value ? colors.on : colors.off;
    return _isHovered ? baseColor.withValues(alpha: colors.hoverOpacity) : baseColor;
  }

  Color _thumbColor() {
    return _isInteractive ? widget.colors.thumb : widget.colors.thumbDisabled;
  }

  double get _thumbSize => widget.height - widget.thumbPadding * 2;

  @override
  Widget build(BuildContext context) {
    final trackRadius = widget.height / 2;

    return Semantics(
      toggled: widget.value,
      enabled: _isInteractive,
      label: widget.semanticLabel,
      child: MouseRegion(
        cursor:
            _isInteractive ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: _isInteractive ? (_) => setState(() => _isHovered = true) : null,
        onExit: _isInteractive ? (_) => setState(() => _isHovered = false) : null,
        child: Focus(
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
          onKeyEvent: (node, event) {
            _handleKeyEvent(event);
            return KeyEventResult.handled;
          },
          child: GestureDetector(
            onTap: _toggle,
            child: AnimatedContainer(
              duration: widget.animationDuration,
              curve: Curves.easeOut,
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: _trackColor(),
                borderRadius: BorderRadius.circular(trackRadius),
                border: _isFocused
                    ? Border.all(color: widget.colors.on, width: 2)
                    : null,
              ),
              child: Padding(
                padding: EdgeInsets.all(widget.thumbPadding),
                child: AnimatedAlign(
                  duration: widget.animationDuration,
                  curve: Curves.easeOut,
                  alignment:
                      widget.value ? Alignment.centerRight : Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: widget.animationDuration,
                    curve: Curves.easeOut,
                    width: _thumbSize,
                    height: _thumbSize,
                    decoration: BoxDecoration(
                      color: _thumbColor(),
                      borderRadius: BorderRadius.circular(_thumbSize / 2),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}