import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dropdown_menu_items.dart';

/// رنگ‌های پیش‌فرض [AppDropdown].
@immutable
class AppDropdownColors {
  const AppDropdownColors({
    this.idle = const Color(0xFF828288),
    this.hover = const Color(0xFF828288),
    this.hoverOpacity = 0.5,
    this.open = const Color(0xFF3863A8),
    this.disabled = const Color(0xFFBBBBC0),
    this.error = const Color(0xFFD64545),
    this.text = const Color(0xFFF3F3F7),
    this.hint = const Color(0xFFF3F3F7),
    this.icon = const Color(0xFF3863A8),
    this.menuBackground = const Color(0xFF3863A8),
  });

  final Color idle;
  final Color hover;
  final double hoverOpacity;
  final Color open;
  final Color disabled;
  final Color error;
  final Color text;
  final Color hint;
  final Color icon;
  final Color menuBackground;
}

/// یک dropdown سفارشی و کاملاً کنترل‌شده که به‌جای تکیه بر
/// `DropdownButton` داخلی فلاتر (و هک کردن آن با `enabled: false` +
/// `onChanged: null`)، خودش یک overlay می‌سازد و مسیر باز/بسته شدن،
/// انتخاب آیتم و موقعیت‌دهی منو را کاملاً مدیریت می‌کند.
///
/// تغییرات نسبت به نسخه‌ی قبلی:
/// * **حذف هک `DropdownMenuItem(enabled: false)` + `onChanged: null`**:
///   این روش به رفتار داخلی و مستندنشده‌ی `DropdownButton` وابسته بود و
///   ممکن بود با تغییر نسخه‌ی فلاتر از کار بیفتد. حالا منو با
///   `OverlayEntry` و `CompositedTransformFollower` خودمان رسم می‌شود؛
///   یعنی رفتار کاملاً قابل پیش‌بینی و کنترل‌شده است.
/// * **همگام‌سازی با `widget.value`**: در نسخه‌ی قبلی `_selectedValue`
///   فقط در `initState` مقداردهی می‌شد و اگر مقدار از بیرون (parent)
///   بعداً تغییر می‌کرد، ویجت آن را نشان نمی‌داد. حالا با
///   `didUpdateWidget` این مقدار همگام نگه داشته می‌شود.
/// * **پشتیبانی از نوع عمومی `<T>`**: به‌جای محدود بودن به `List<String>`،
///   حالا هر نوعی را می‌پذیرد (`enum`، مدل و ...) و برچسب هر آیتم را با
///   `itemLabelBuilder` (پیش‌فرض `toString()`) می‌سازد.
/// * **حالت غیرفعال (`enabled: false`) و پیام خطا (`errorText`)** اضافه
///   شده، مشابه الگوی [AppTextField].
/// * **بسته شدن با تپ بیرون از منو** (overlay barrier)، **بسته شدن با
///   کلید Escape** و **باز/بسته شدن با Space/Enter روی کیبورد**.
/// * **اسکرول برای لیست‌های بلند**: ارتفاع منو با `maxMenuHeight` محدود
///   می‌شود و در صورت نیاز اسکرول می‌خورد (در نسخه‌ی قبلی هیچ محدودیتی
///   نبود و لیست‌های بلند می‌توانستند از صفحه بیرون بزنند).
/// * **پشتیبانی از راست‌به‌چپ (RTL)**: موقعیت‌دهی منو بر اساس جهت متن
///   context تعیین می‌شود.
/// * **جلوگیری از overflow متن**: برچسب انتخاب‌شده و hint با `ellipsis`
///   کوتاه می‌شوند.
/// * مدیریت صحیح `dispose` overlay در صورت حذف ویجت درحالی‌که منو باز است.
class AppDropdown<T extends Object> extends StatefulWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hintText,
    this.itemLabelBuilder,
    this.width = 216,
    this.height = 64,
    this.maxMenuHeight = 320,
    this.menuGap = 8,
    this.enabled = true,
    this.errorText,
    this.borderRadius = 10,
    this.colors = const AppDropdownColors(),
  });

  final List<T> items;
  final ValueChanged<T?> onChanged;
  final T? value;
  final String? hintText;

  /// برای ساختن برچسب نمایشی هر آیتم. اگر ندهید، از `toString()` استفاده
  /// می‌شود.
  final String Function(T item)? itemLabelBuilder;

  final double width;
  final double height;

  /// حداکثر ارتفاع پنل منو؛ در صورت طولانی‌تر بودن لیست، اسکرول می‌خورد.
  final double maxMenuHeight;

  /// فاصله‌ی عمودی بین دکمه و پنل منو.
  final double menuGap;

  final bool enabled;
  final String? errorText;
  final double borderRadius;
  final AppDropdownColors colors;

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T extends Object> extends State<AppDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();

  OverlayEntry? _overlayEntry;
  bool _isHovered = false;
  bool _isOpen = false;
  late T? _selectedValue = widget.value;

  bool get _hasError => widget.errorText != null && widget.errorText!.isNotEmpty;

  @override
  void didUpdateWidget(covariant AppDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _selectedValue) {
      setState(() => _selectedValue = widget.value);
    }
    if (!widget.enabled && _isOpen) {
      _closeMenu();
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.dispose();
    super.dispose();
  }

  String _labelFor(T item) => widget.itemLabelBuilder?.call(item) ?? item.toString();

  void _toggleMenu() {
    if (!widget.enabled) return;
    _isOpen ? _closeMenu() : _openMenu();
  }

  void _openMenu() {
    if (_isOpen) return;
    _focusNode.requestFocus();
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeMenu() {
    _removeOverlay();
    if (_isOpen) setState(() => _isOpen = false);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectItem(T item) {
    setState(() => _selectedValue = item);
    widget.onChanged(item);
    _closeMenu();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _closeMenu();
    } else if (event.logicalKey == LogicalKeyboardKey.space ||
        event.logicalKey == LogicalKeyboardKey.enter) {
      _toggleMenu();
    }
  }

  Color _backgroundColor() {
    final colors = widget.colors;
    if (!widget.enabled) return colors.disabled;
    if (_hasError) return colors.error;
    if (_isOpen) return colors.open;
    if (_isHovered) return colors.hover.withValues(alpha: colors.hoverOpacity);
    return colors.idle;
  }

  OverlayEntry _buildOverlayEntry() {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // بستن منو با تپ روی هر نقطه‌ی بیرون از پنل.
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeMenu,
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor: isRtl ? Alignment.bottomRight : Alignment.bottomLeft,
              followerAnchor: isRtl ? Alignment.topRight : Alignment.topLeft,
              offset: Offset(0, widget.height + widget.menuGap),
              child: Material(
                color: Colors.transparent,
                child: Align(
                  alignment: isRtl ? Alignment.topRight : Alignment.topLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: widget.width,
                      maxWidth: widget.width,
                      maxHeight: widget.maxMenuHeight,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.colors.menuBackground,
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: widget.items.length,
                          itemBuilder: (context, index) {
                            final item = widget.items[index];
                            return DropdownMenuItemWidget(
                              label: _labelFor(item),
                              isFirst: index == 0,
                              isLast: index == widget.items.length - 1,
                              onTap: () => _selectItem(item),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: widget.colors.text,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: 'Estedad',
    );

    final label = _selectedValue != null ? _labelFor(_selectedValue as T) : null;

    final box = CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        cursor: widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: widget.enabled ? (_) => setState(() => _isHovered = true) : null,
        onExit: widget.enabled ? (_) => setState(() => _isHovered = false) : null,
        child: Focus(
          focusNode: _focusNode,
          onKeyEvent: (node, event) {
            _handleKeyEvent(event);
            return KeyEventResult.handled;
          },
          child: GestureDetector(
            onTap: _toggleMenu,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: widget.width,
              height: widget.height,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: _backgroundColor(),
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label ?? widget.hintText ?? '',
                      style: textStyle.copyWith(
                        color: label != null
                            ? widget.colors.text
                            : widget.colors.hint.withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: _isOpen ? 0.5 : 0,
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: widget.colors.icon,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (!_hasError) return box;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        box,
        Padding(
          padding: const EdgeInsets.only(top: 4, right: 4),
          child: Text(
            widget.errorText!,
            style: TextStyle(color: widget.colors.error, fontSize: 12),
          ),
        ),
      ],
    );
  }
}