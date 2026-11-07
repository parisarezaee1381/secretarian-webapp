import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'key_activation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/core/theme.dart';

enum ButtonType { primary, secondary, tertiary }

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
    background: AppColors.primary,
    text: AppColors.background,
    border: Colors.transparent,
  ),
  ButtonType.secondary: _ButtonTypeColors(
    background: AppColors.mutedText,
    text: AppColors.background,
    border: Colors.transparent,
  ),
  ButtonType.tertiary: _ButtonTypeColors(
    background: Colors.transparent,
    text: AppColors.text,
    border: AppColors.text,
  ),
};

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
    this.borderRadius,
    this.padding,
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
  final double? borderRadius;
  final EdgeInsets? padding;

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
    final effectiveWidth = widget.width ?? 204.w;

    final effectivePadding =
        widget.padding ?? EdgeInsets.symmetric(vertical: 16, horizontal: 32.w);

    final effectiveBorderRadius = widget.borderRadius ?? 10.r;

    final textColor = _textColor();

    final content = widget.isLoading
        ? SizedBox(
            width: 20.w,
            height: 20.w,
            child: CircularProgressIndicator(strokeWidth: 2, color: textColor),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                IconTheme(
                  data: IconThemeData(color: textColor, size: 20.sp),
                  child: widget.icon!,
                ),
                SizedBox(width: 8.w),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
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
          // Only claim the keys this button acts on (space/enter); see
          // `isActivationKeyEvent` for the full contract.
          onKeyEvent: (node, event) {
            if (!isActivationKeyEvent(event)) {
              return KeyEventResult.ignored;
            }

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
                width: effectiveWidth,
                height: widget.height,
                padding: effectivePadding,
                decoration: BoxDecoration(
                  color: _backgroundColor(),
                  borderRadius: BorderRadius.circular(effectiveBorderRadius),
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
