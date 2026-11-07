import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/theme.dart';

@immutable
class AppTextFieldColors {
  const AppTextFieldColors({
    this.idle = AppColors.mutedText,
    this.hover = AppColors.border,
    this.focused = AppColors.primary,
    this.disabled = AppColors.border,
    this.error = AppColors.danger,
    this.text = AppColors.background,
    this.hint = AppColors.background,
  });

  final Color idle;
  final Color hover;
  final Color focused;
  final Color disabled;
  final Color error;
  final Color text;
  final Color hint;
}

/// A labeled text input with desktop/mobile responsive layouts and an
/// idle/hover/focused/error/disabled color palette ([AppTextFieldColors]).
///
/// Pass either [controller] or [initialValue], never both (asserted in
/// debug). The SAME controller and focus-node instances must be supplied
/// for the widget's whole lifetime — the state binds them once on mount,
/// so swapping either instance on rebuild is not picked up. Create them
/// once in the owning widget instead.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.width = 548,
    this.height = 64,
    this.maxLines = 1,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius = 10,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 32,
    ),
    this.animationDuration = const Duration(milliseconds: 300),
    this.colors = const AppTextFieldColors(),
    this.textStyle,
    this.labelStyle,
    this.labelWidth = 140,
    this.labelSpacing = 16,

    this.responsive = true,
    this.mobileBreakpoint = 700,
    this.mobileLabelSpacing = 8,
    this.mobileHorizontalPadding = 0,
  }) : assert(
         controller == null || initialValue == null,
         'controller و initialValue را هم‌زمان مقدار ندهید.',
       );

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final String? errorText;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;

  final double width;

  final double height;

  final int maxLines;

  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final TextAlign textAlign;

  final List<TextInputFormatter>? inputFormatters;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final double borderRadius;

  final EdgeInsetsGeometry contentPadding;

  final Duration animationDuration;

  final AppTextFieldColors colors;

  final TextStyle? textStyle;
  final TextStyle? labelStyle;

  final double labelWidth;

  final double labelSpacing;

  final bool responsive;

  final double mobileBreakpoint;

  final double mobileLabelSpacing;

  final double mobileHorizontalPadding;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController(text: widget.initialValue);

  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();

  bool _isHovered = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);

    if (widget.controller == null) {
      _controller.dispose();
    }

    if (widget.focusNode == null) {
      _focusNode.dispose();
    }

    super.dispose();
  }

  void _handleFocusChange() {
    if (!mounted) return;

    if (_isFocused != _focusNode.hasFocus) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  bool get _hasError {
    return widget.errorText != null && widget.errorText!.isNotEmpty;
  }

  Color _backgroundColor() {
    final colors = widget.colors;

    if (!widget.enabled) {
      return colors.disabled;
    }

    if (_hasError) {
      return colors.error;
    }

    if (_isFocused) {
      return colors.focused;
    }

    if (_isHovered) {
      return colors.hover.withValues(alpha: 0.5);
    }

    return colors.idle;
  }

  TextStyle _baseTextStyle() {
    return widget.textStyle ??
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );
  }

  TextStyle _labelTextStyle() {
    return widget.labelStyle ??
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );
  }

  Widget _buildTextField() {
    final textStyle = _baseTextStyle().copyWith(color: widget.colors.text);

    final hintStyle = _baseTextStyle().copyWith(
      color: widget.colors.hint.withValues(alpha: 0.7),
    );

    return AnimatedContainer(
      duration: widget.animationDuration,
      curve: Curves.easeOut,

      // در Responsive حالت width توسط parent تعیین می‌شود.
      width: widget.responsive ? double.infinity : widget.width,

      height: widget.maxLines == 1 ? widget.height : null,

      constraints: widget.maxLines != 1
          ? BoxConstraints(minHeight: widget.height)
          : null,

      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),

      child: Material(
        type: MaterialType.transparency,
        child: TextFormField(
          controller: _controller,
          focusNode: _focusNode,

          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,

          validator: widget.validator,

          obscureText: widget.obscureText,

          maxLines: widget.obscureText ? 1 : widget.maxLines,

          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,

          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,

          textAlign: widget.textAlign,

          inputFormatters: widget.inputFormatters,

          cursorColor: widget.colors.text,

          style: textStyle,

          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: hintStyle,

            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,

            filled: false,

            isCollapsed: false,

            errorText: widget.errorText,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide.none,
            ),

            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide.none,
            ),

            contentPadding: widget.contentPadding,
          ),
        ),
      ),
    );
  }

  Widget _buildLabel() {
    if (widget.labelText == null) {
      return const SizedBox.shrink();
    }

    return Text(
      widget.labelText!,
      textAlign: TextAlign.right,
      softWrap: true,
      style: _labelTextStyle().copyWith(color: AppColors.text),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          SizedBox(width: widget.labelWidth, child: _buildLabel()),

          SizedBox(width: widget.labelSpacing),
        ],

        SizedBox(width: widget.width, child: _buildTextField()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.mobileHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.labelText != null) ...[
            _buildLabel(),

            SizedBox(height: widget.mobileLabelSpacing),
          ],

          _buildTextField(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        final isMobile =
            widget.responsive && availableWidth < widget.mobileBreakpoint;

        return MouseRegion(
          cursor: widget.enabled
              ? SystemMouseCursors.text
              : SystemMouseCursors.basic,

          onEnter: widget.enabled
              ? (_) {
                  if (!_isHovered) {
                    setState(() {
                      _isHovered = true;
                    });
                  }
                }
              : null,

          onExit: widget.enabled
              ? (_) {
                  if (_isHovered) {
                    setState(() {
                      _isHovered = false;
                    });
                  }
                }
              : null,

          child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
        );
      },
    );
  }
}
