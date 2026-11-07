import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'key_activation.dart';
import 'package:flutter_application_1/core/theme.dart';

/// رنگ‌های پیش‌فرض ویجت [AppSwitch].
@immutable
class AppSwitchColors {
  const AppSwitchColors({
    this.on = AppColors.primary,
    this.off = AppColors.mutedText,
    this.disabled = AppColors.border,
    this.thumb = AppColors.background,
    this.thumbDisabled = AppColors.surfaceDisabled,
    this.hoverOpacity = 0.5,
  });

  final Color on;
  final Color off;
  final Color disabled;
  final Color thumb;
  final Color thumbDisabled;

  final double hoverOpacity;
}

/// An iOS-style toggle switch: an animated track with a sliding thumb.
///
/// When focused it claims only space/enter (the activation-key contract
/// in `key_activation.dart`), so Tab and other shortcuts keep working.
/// While disabled ([enabled] false or [onChanged] null) it is skipped
/// during keyboard traversal, shows no focus border, and drops its
/// hover/click affordances.
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

  final bool responsive;

  @override
  State<AppSwitch> createState() => _AppSwitchState();
}

class _AppSwitchState extends State<AppSwitch> {
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();

  /// The node's own skipTraversal setting, captured before this widget
  /// touches it, so a caller-provided node is restored on dispose.
  late final bool _previousSkipTraversal = _focusNode.skipTraversal;

  bool _isHovered = false;
  bool _isFocused = false;

  bool get _isInteractive => widget.enabled && widget.onChanged != null;

  @override
  void initState() {
    super.initState();

    _updateSkipTraversal();
  }

  @override
  void didUpdateWidget(covariant AppSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.enabled != widget.enabled ||
        (oldWidget.onChanged == null) != (widget.onChanged == null)) {
      _updateSkipTraversal();
    }
  }

  /// A disabled switch must not be reachable with Tab.
  void _updateSkipTraversal() {
    _focusNode.skipTraversal = _previousSkipTraversal || !_isInteractive;
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.skipTraversal = _previousSkipTraversal;
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

  double _responsiveWidth(BoxConstraints constraints) {
    if (!widget.responsive) {
      return widget.width;
    }

    if (!constraints.maxWidth.isFinite) {
      return widget.width;
    }

    // Follow parents narrower than the 48px design minimum instead of
    // clamping up — an inverted clamp range would overflow the parent.
    if (constraints.maxWidth < 48.0) {
      return constraints.maxWidth;
    }

    return widget.width.clamp(48.0, constraints.maxWidth);
  }

  double _responsiveHeight(double width) {
    if (!widget.responsive) {
      return widget.height;
    }

    final calculatedHeight = width / 2;

    return calculatedHeight.clamp(24.0, widget.height);
  }

  double _responsiveThumbPadding(double height) {
    if (!widget.responsive) {
      return widget.thumbPadding;
    }

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
            // Only claim the keys this switch acts on (space/enter);
            // everything else must pass so Tab traversal and app
            // shortcuts keep working while the switch is focused.
            if (!_isInteractive || !isActivationKeyEvent(event)) {
              return KeyEventResult.ignored;
            }

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

                border: _isFocused && _isInteractive
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
        if (!widget.responsive) {
          return _buildSwitch(
            width: widget.width,
            height: widget.height,
            thumbPadding: widget.thumbPadding,
          );
        }

        final availableWidth = constraints.maxWidth;

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
