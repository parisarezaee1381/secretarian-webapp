import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme.dart';

/// Base type style shared by the dropdown trigger (`AppDropdown`'s field)
/// and its menu items — color always comes from the relevant palette.
const TextStyle kDropdownItemTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

/// Item height at narrow menu widths (below 360px). Also used by
/// `AppDropdown` to estimate the menu's height when deciding whether to
/// flip upward near the viewport's bottom edge.
const double kDropdownItemCompactHeight = 52;

/// رنگ‌های پیش‌فرض [DropdownMenuItemWidget].
@immutable
class DropdownItemColors {
  const DropdownItemColors({
    this.background = AppColors.border,
    this.hover = AppColors.mutedText,
    this.pressed = AppColors.border,
    this.pressedOpacity = 0.5,
    this.selected = AppColors.mutedText,
    this.text = AppColors.text,
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

      if (!hovered) {
        _isPressed = false;
      }
    });
  }

  void _setPressed(bool pressed) {
    if (!_isInteractive) return;

    setState(() {
      _isPressed = pressed;
    });
  }

  Color _backgroundColor() {
    final colors = widget.colors;

    if (_isPressed) {
      return colors.pressed.withValues(alpha: colors.pressedOpacity);
    }

    if (widget.isSelected) {
      return colors.selected;
    }

    if (_isHovered) {
      return colors.hover;
    }

    return colors.background;
  }

  BorderRadius _resolvedBorderRadius() {
    final radius = Radius.circular(widget.borderRadius);

    if (widget.isFirst && widget.isLast) {
      return BorderRadius.all(radius);
    }

    if (widget.isFirst) {
      return BorderRadius.vertical(top: radius);
    }

    if (widget.isLast) {
      return BorderRadius.vertical(bottom: radius);
    }

    return BorderRadius.zero;
  }

  EdgeInsets _responsivePadding(double? width) {
    if (width == null || width >= 600) {
      return widget.padding;
    }

    if (width < 360) {
      return const EdgeInsets.symmetric(vertical: 12, horizontal: 16);
    }

    return const EdgeInsets.symmetric(vertical: 14, horizontal: 20);
  }

  double _responsiveHeight(double? width) {
    if (width == null || width >= 600) {
      return widget.height;
    }

    if (width < 360) {
      return kDropdownItemCompactHeight;
    }

    return 56;
  }

  TextStyle _responsiveTextStyle(double? width) {
    final baseStyle = kDropdownItemTextStyle.copyWith(
      color: widget.colors.text,
    );

    if (width == null || width >= 600) {
      return baseStyle;
    }

    if (width < 360) {
      return baseStyle.copyWith(fontSize: 14);
    }

    return baseStyle.copyWith(fontSize: 15);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Unbounded widths (not expected inside the menu's constrained
        // overlay) fall back to the default desktop tiers.
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : null;

        final effectiveHeight = _responsiveHeight(width);

        final effectivePadding = _responsivePadding(width);

        final effectiveTextStyle = _responsiveTextStyle(width);

        return Semantics(
          button: true,
          selected: widget.isSelected,
          enabled: _isInteractive,
          label: widget.label,
          child: MouseRegion(
            onEnter: (_) => _setHovered(true),
            onExit: (_) => _setHovered(false),
            cursor: _isInteractive
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
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
                height: effectiveHeight,

                padding: effectivePadding,

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
                    style: effectiveTextStyle,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
