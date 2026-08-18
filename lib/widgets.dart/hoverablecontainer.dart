import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HoverableContainer extends StatefulWidget {
  const HoverableContainer({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
    this.padding,
    this.alignment,
    this.hoverColor = const Color(0xFF828288),
    this.hoverOpacity = 0.5,
    this.pressedColor,
    this.pressedOpacity = 0.7,
    this.normalColor = Colors.transparent,
    this.borderRadius = 10,
    this.border,
    this.duration = const Duration(milliseconds: 300),
    this.returnDuration = const Duration(milliseconds: 100),
    this.isDisabled = false,
    this.disabledOpacity = 0.5,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final AlignmentGeometry? alignment;

  final Color hoverColor;
  final double hoverOpacity;

  /// [pressedOpacity] استفاده می‌شود.
  final Color? pressedColor;
  final double pressedOpacity;

  final Color normalColor;
  final double borderRadius;
  final BoxBorder? border;

  final Duration duration;
  final Duration returnDuration;

  final bool isDisabled;

  final double disabledOpacity;

  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<HoverableContainer> createState() => _HoverableContainerState();
}

class _HoverableContainerState extends State<HoverableContainer> {
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();

  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  bool get _isInteractive => !widget.isDisabled && widget.onTap != null;

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

  void _handleTap() {
    if (!_isInteractive) return;
    widget.onTap?.call();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (!_isInteractive) return;
    if (event is KeyDownEvent &&
        (event.logicalKey == LogicalKeyboardKey.space ||
            event.logicalKey == LogicalKeyboardKey.enter)) {
      _setPressed(true);
      _handleTap();
    } else if (event is KeyUpEvent &&
        (event.logicalKey == LogicalKeyboardKey.space ||
            event.logicalKey == LogicalKeyboardKey.enter)) {
      _setPressed(false);
    }
  }

  Color _backgroundColor() {
    if (widget.isDisabled) return Colors.transparent;
    if (_isPressed) {
      return (widget.pressedColor ?? widget.hoverColor)
          .withValues(alpha: widget.pressedColor != null
              ? widget.pressedOpacity
              : widget.hoverOpacity * widget.pressedOpacity);
    }
    if (_isHovered) {
      return widget.hoverColor.withValues(alpha: widget.hoverOpacity);
    }
    return widget.normalColor;
  }

  @override
  Widget build(BuildContext context) {
    final content = AnimatedOpacity(
      duration: widget.duration,
      opacity: widget.isDisabled ? widget.disabledOpacity : 1,
      child: widget.child,
    );

    return Semantics(
      button: true,
      enabled: _isInteractive,
      label: widget.semanticLabel,
      child: MouseRegion(
        onEnter: (_) => _setHovered(true),
        onExit: (_) => _setHovered(false),
        cursor: widget.isDisabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: Focus(
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
          onKeyEvent: (node, event) {
            _handleKeyEvent(event);
            return KeyEventResult.handled;
          },
          child: GestureDetector(
            onTapDown: _isInteractive ? (_) => _setPressed(true) : null,
            onTapUp: _isInteractive
                ? (_) {
                    _setPressed(false);
                    _handleTap();
                  }
                : null,
            onTapCancel: _isInteractive ? () => _setPressed(false) : null,
            onLongPress: _isInteractive ? widget.onLongPress : null,
            child: AnimatedScale(
              scale: _isPressed ? 0.97 : 1,
              duration: widget.returnDuration,
              curve: Curves.easeOut,
              child: AnimatedContainer(
                duration: _isPressed ? widget.returnDuration : widget.duration,
                curve: Curves.easeOut,
                width: widget.width,
                height: widget.height,
                padding: widget.padding,
                alignment: widget.alignment,
                decoration: BoxDecoration(
                  color: _backgroundColor(),
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: widget.border ??
                      (_isFocused
                          ? Border.all(color: widget.hoverColor, width: 2)
                          : null),
                ),
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}