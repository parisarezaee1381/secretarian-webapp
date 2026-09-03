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

    /// اگر false باشد اندازه‌های width و height
    /// دقیقاً مانند قبل استفاده می‌شوند.
    this.responsive = true,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  final bool enabled;
  final String? semanticLabel;

  final FocusNode? focusNode;
  final bool autofocus;

  final double width;
  final double height;

  final double thumbPadding;

  final Duration animationDuration;
  final AppSwitchColors colors;

  /// فعال/غیرفعال کردن رفتار responsive.
  final bool responsive;

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

    if (!_isInteractive) {
      return colors.disabled;
    }

    final baseColor = widget.value ? colors.on : colors.off;

    if (_isHovered) {
      return baseColor.withValues(alpha: colors.hoverOpacity);
    }

    return baseColor;
  }

  Color _thumbColor() {
    return _isInteractive ? widget.colors.thumb : widget.colors.thumbDisabled;
  }

  /// نسبت پیش‌فرض Switch:
  ///
  /// 128 / 64 = 2
  ///
  /// بنابراین هنگام responsive شدن نیز
  /// همین نسبت حفظ می‌شود.
  double _responsiveWidth(BoxConstraints constraints) {
    if (!widget.responsive) {
      return widget.width;
    }

    if (!constraints.maxWidth.isFinite) {
      return widget.width;
    }

    return widget.width.clamp(48.0, constraints.maxWidth);
  }

  double _responsiveHeight(double width) {
    if (!widget.responsive) {
      return widget.height;
    }

    // نسبت width / height = 2
    final calculatedHeight = width / 2;

    // جلوگیری از Switch بیش از حد کوچک یا بزرگ
    return calculatedHeight.clamp(24.0, widget.height);
  }

  double _responsiveThumbPadding(double height) {
    if (!widget.responsive) {
      return widget.thumbPadding;
    }

    // Padding متناسب با ارتفاع
    final scaledPadding = height * (widget.thumbPadding / widget.height);

    return scaledPadding.clamp(2.0, widget.thumbPadding);
  }

  Widget _buildSwitch({
    required double width,
    required double height,
    required double thumbPadding,
  }) {
    final trackRadius = height / 2;

    final thumbSize = (height - thumbPadding * 2).clamp(0.0, double.infinity);

    return Semantics(
      toggled: widget.value,
      enabled: _isInteractive,
      label: widget.semanticLabel,
      child: MouseRegion(
        cursor: _isInteractive
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,

        onEnter: _isInteractive
            ? (_) {
                setState(() {
                  _isHovered = true;
                });
              }
            : null,

        onExit: _isInteractive
            ? (_) {
                setState(() {
                  _isHovered = false;
                });
              }
            : null,

        child: Focus(
          focusNode: _focusNode,
          autofocus: widget.autofocus,

          onFocusChange: (hasFocus) {
            if (!mounted) return;

            setState(() {
              _isFocused = hasFocus;
            });
          },

          onKeyEvent: (node, event) {
            _handleKeyEvent(event);

            return KeyEventResult.handled;
          },

          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _toggle,

            child: AnimatedContainer(
              duration: widget.animationDuration,
              curve: Curves.easeOut,

              width: width,
              height: height,

              decoration: BoxDecoration(
                color: _trackColor(),
                borderRadius: BorderRadius.circular(trackRadius),

                border: _isFocused
                    ? Border.all(color: widget.colors.on, width: 2)
                    : null,
              ),

              child: Padding(
                padding: EdgeInsets.all(thumbPadding),

                child: AnimatedAlign(
                  duration: widget.animationDuration,
                  curve: Curves.easeOut,

                  alignment: widget.value
                      ? Alignment.centerRight
                      : Alignment.centerLeft,

                  child: AnimatedContainer(
                    duration: widget.animationDuration,
                    curve: Curves.easeOut,

                    width: thumbSize,
                    height: thumbSize,

                    decoration: BoxDecoration(
                      color: _thumbColor(),

                      borderRadius: BorderRadius.circular(thumbSize / 2),
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // اگر responsive خاموش باشد،
        // دقیقاً اندازه‌های قبلی استفاده می‌شوند.
        if (!widget.responsive) {
          return _buildSwitch(
            width: widget.width,
            height: widget.height,
            thumbPadding: widget.thumbPadding,
          );
        }

        final availableWidth = constraints.maxWidth;

        // اگر عرض نامحدود باشد، اندازه پیش‌فرض استفاده می‌شود.
        if (!availableWidth.isFinite) {
          return _buildSwitch(
            width: widget.width,
            height: widget.height,
            thumbPadding: widget.thumbPadding,
          );
        }

        final width = _responsiveWidth(constraints);

        final height = _responsiveHeight(width);

        final thumbPadding = _responsiveThumbPadding(height);

        return _buildSwitch(
          width: width,
          height: height,
          thumbPadding: thumbPadding,
        );
      },
    );
  }
}
