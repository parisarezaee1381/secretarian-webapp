import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class AppTextFieldColors {
  const AppTextFieldColors({
    this.idle = const Color(0xFF828288),
    this.hover = const Color(0xFFBBBBC0),
    this.focused = const Color(0xFF3863A8),
    this.disabled = const Color(0xFFBBBBC0),
    this.error = const Color(0xFFD64545),
    this.text = const Color(0xFFF3F3F7),
    this.hint = const Color(0xFFF3F3F7),
  });

  final Color idle;
  final Color hover;
  final Color focused;
  final Color disabled;
  final Color error;
  final Color text;
  final Color hint;
}

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

    // Responsive
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

  /// عرض پیش‌فرض در دسکتاپ
  final double width;

  /// ارتفاع فیلد
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

  /// عرض label در دسکتاپ
  final double labelWidth;

  /// فاصله label و input در دسکتاپ
  final double labelSpacing;

  // =========================================================
  // Responsive properties
  // =========================================================

  /// اگر false باشد، رفتار قبلی کاملاً حفظ می‌شود.
  final bool responsive;

  /// زیر این عرض، فیلد وارد حالت موبایل می‌شود.
  final double mobileBreakpoint;

  /// فاصله label و input در حالت موبایل
  final double mobileLabelSpacing;

  /// padding افقی اضافی در حالت موبایل
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
          fontFamily: 'Estedad',
        );
  }

  TextStyle _labelTextStyle() {
    return widget.labelStyle ??
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Estedad',
        );
  }

  // =========================================================
  // TextFormField
  // =========================================================

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

  // =========================================================
  // Label
  // =========================================================

  Widget _buildLabel() {
    if (widget.labelText == null) {
      return const SizedBox.shrink();
    }

    return Text(
      widget.labelText!,
      textAlign: TextAlign.right,
      softWrap: true,
      style: _labelTextStyle().copyWith(color: const Color(0xFF101018)),
    );
  }

  // =========================================================
  // Desktop Layout
  // =========================================================

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

  // =========================================================
  // Mobile Layout
  // =========================================================

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

  // =========================================================
  // Build
  // =========================================================

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
