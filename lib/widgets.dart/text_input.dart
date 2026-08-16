import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// رنگ‌های پیش‌فرض ویجت [AppTextField].
///
/// نگه‌داشتن رنگ‌ها در یک کلاس جدا باعث می‌شود که هم قابل استفاده‌ی مجدد
/// باشند و هم بشود آن‌ها را به‌راحتی از بیرون (مثلاً از طریق تم) تغییر داد.
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

/// یک فیلد متنی سفارشی با پشتیبانی از حالت‌های hover، focus، خطا و غیرفعال،
/// همراه با انیمیشن نرم بین حالت‌ها.
///
/// در مقایسه با نسخه‌ی قبلی:
/// * از [TextFormField] استفاده می‌کند تا اعتبارسنجی (`validator`) و
///   پیام خطا را پشتیبانی کند.
/// * امکان دریافت `FocusNode` از بیرون را دارد (برای مدیریت فوکوس بین چند
///   فیلد).
/// * آیکن‌های prefix/suffix، وضعیت غیرفعال، keyboardType،
///   inputFormatters و موارد دیگر را پشتیبانی می‌کند.
/// * رنگ‌ها به‌جای مقادیر ثابت داخل ویجت، از یک کلاس قابل تنظیم می‌آیند.
/// * از منطق تکراری در ساخت TextStyle جلوگیری شده است.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
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
  }) : assert(
          controller == null || initialValue == null,
          'controller و initialValue را هم‌زمان مقدار ندهید.',
        );

  final TextEditingController? controller;
  final FocusNode? focusNode;
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
    if (_isFocused != _focusNode.hasFocus) {
      setState(() => _isFocused = _focusNode.hasFocus);
    }
  }

  bool get _hasError => widget.errorText != null && widget.errorText!.isNotEmpty;

  Color _backgroundColor() {
    final colors = widget.colors;
    if (!widget.enabled) return colors.disabled;
    if (_hasError) return colors.error;
    if (_isFocused) return colors.focused;
    if (_isHovered) return colors.hover;
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

  @override
  Widget build(BuildContext context) {
    final textStyle = _baseTextStyle().copyWith(color: widget.colors.text);
    final hintStyle = _baseTextStyle().copyWith(
      color: widget.colors.hint.withValues(alpha:0.7),
    );

    return MouseRegion(
      cursor: widget.enabled ? SystemMouseCursors.text : SystemMouseCursors.basic,
      onEnter: widget.enabled ? (_) => setState(() => _isHovered = true) : null,
      onExit: widget.enabled ? (_) => setState(() => _isHovered = false) : null,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        curve: Curves.easeOut,
        width: widget.width,
        height: widget.maxLines == 1 ? widget.height : null,
        constraints: widget.maxLines != 1
            ? BoxConstraints(minHeight: widget.height)
            : null,
        decoration: BoxDecoration(
          color: _backgroundColor(),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
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
            errorText: null, // پیام خطا را خودمان با رنگ پس‌زمینه نشان می‌دهیم
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
}