import 'package:flutter/material.dart';

/// رنگ‌های پیش‌فرض [DropdownMenuItemWidget].
@immutable
class DropdownItemColors {
  const DropdownItemColors({
    this.background = const Color(0xFFBBBBC0),
    this.hover = const Color(0xFF828288),
    this.pressed = const Color(0xFFBBBBC0),
    this.pressedOpacity = 0.5,
    this.selected = const Color(0xFF828288),
    this.text = const Color(0xFF101018),
  });

  final Color background;
  final Color hover;
  final Color pressed;
  final double pressedOpacity;

  final Color selected;

  final Color text;
}

class DropdownMenuItemWidget extends StatefulWidget {
  const DropdownMenuItemWidget({
    super.key,
    required this.label,
    this.onTap,
    this.isFirst = false,
    this.isLast = false,
    this.isSelected = false,
    this.height = 64,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
    this.borderRadius = 10,
    this.duration = const Duration(milliseconds: 100),
    this.pressedDuration = const Duration(milliseconds: 300),
    this.colors = const DropdownItemColors(),
    this.textStyle,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isFirst;
  final bool isLast;
  final bool isSelected;

  final double height;
  final EdgeInsets padding;
  final double borderRadius;
  final Duration duration;
  final Duration pressedDuration;
  final DropdownItemColors colors;
  final TextStyle? textStyle;

  @override
  State<DropdownMenuItemWidget> createState() => _DropdownMenuItemWidgetState();
}

class _DropdownMenuItemWidgetState extends State<DropdownMenuItemWidget> {
  bool _isHovered = false;
  bool _isPressed = false;

  bool get _isInteractive => widget.onTap != null;

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

  Color _backgroundColor() {
    final colors = widget.colors;
    if (_isPressed) return colors.pressed.withValues(alpha: colors.pressedOpacity);
    if (widget.isSelected) return colors.selected;
    if (_isHovered) return colors.hover;
    return colors.background;
  }

  BorderRadius _resolvedBorderRadius() {
    final radius = Radius.circular(widget.borderRadius);
    if (widget.isFirst && widget.isLast) return BorderRadius.all(radius);
    if (widget.isFirst) return BorderRadius.vertical(top: radius);
    if (widget.isLast) return BorderRadius.vertical(bottom: radius);
    return BorderRadius.zero;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: widget.isSelected,
      enabled: _isInteractive,
      label: widget.label,
      child: MouseRegion(
        onEnter: (_) => _setHovered(true),
        onExit: (_) => _setHovered(false),
        cursor: _isInteractive ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          onTapDown: _isInteractive ? (_) => _setPressed(true) : null,
          onTapUp: _isInteractive
              ? (_) {
                  _setPressed(false);
                  widget.onTap?.call();
                }
              : null,
          onTapCancel: _isInteractive ? () => _setPressed(false) : null,
          child: AnimatedContainer(
            duration: _isPressed ? widget.pressedDuration : widget.duration,
            curve: Curves.easeOut,
            width: double.infinity,
            height: widget.height,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: _backgroundColor(),
              borderRadius: _resolvedBorderRadius(),
            ),
            alignment: Alignment.center,
            child: AnimatedScale(
              scale: _isPressed ? 0.97 : 1,
              duration: widget.duration,
              curve: Curves.easeOut,
              child: Text(
                widget.label,
                style: widget.textStyle ??
                    TextStyle(
                      color: widget.colors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Estedad',
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}