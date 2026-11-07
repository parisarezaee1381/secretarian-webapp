import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'key_activation.dart';
import 'dropdown_menu_items.dart';
import 'package:flutter_application_1/core/theme.dart';

/// رنگ‌های پیش‌فرض [AppDropdown].
@immutable
class AppDropdownColors {
  const AppDropdownColors({
    this.idle = AppColors.mutedText,
    this.hover = AppColors.mutedText,
    this.hoverOpacity = 0.5,
    this.open = AppColors.primary,
    this.disabled = AppColors.border,
    this.error = AppColors.danger,
    this.text = AppColors.background,
    this.hint = AppColors.background,
    this.icon = AppColors.background,
    this.menuBackground = AppColors.primary,
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

  final String Function(T item)? itemLabelBuilder;

  final double width;
  final double height;

  final double maxMenuHeight;

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
  bool _isFocused = false;
  late T? _selectedValue = widget.value;

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  @override
  void didUpdateWidget(covariant AppDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _selectedValue) {
      setState(() => _selectedValue = widget.value);
    }
    if (!widget.enabled && _isOpen) {
      _closeMenu();
    }
    if (_isOpen) {
      // Keep the open menu in sync with changed `items` or `value`.
      _overlayEntry?.markNeedsBuild();
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.dispose();
    super.dispose();
  }

  String _labelFor(T item) =>
      widget.itemLabelBuilder?.call(item) ?? item.toString();

  void _toggleMenu() {
    if (!widget.enabled) return;
    _isOpen ? _closeMenu() : _openMenu();
  }

  void _openMenu() {
    if (_isOpen) return;
    _focusNode.requestFocus();
    _overlayEntry = _buildOverlayEntry(openBelow: _shouldOpenBelow());
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

  /// Returns true when the key event was consumed by the dropdown: the
  /// activation keys (space/enter) toggle the menu, and Escape closes it —
  /// but only while it is open. Everything else (Tab, arrows, …) must stay
  /// unhandled so focus traversal and global shortcuts keep working.
  bool _handleKeyEvent(KeyEvent event) {
    if (isActivationKeyEvent(event)) {
      if (event is KeyDownEvent) _toggleMenu();
      return true;
    }

    if (_isOpen &&
        event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      _closeMenu();
      return true;
    }

    return false;
  }

  Color _backgroundColor() {
    final colors = widget.colors;
    if (!widget.enabled) return colors.disabled;
    if (_hasError) return colors.error;
    if (_isOpen) return colors.open;
    if (_isHovered) return colors.hover.withValues(alpha: colors.hoverOpacity);
    return colors.idle;
  }

  /// Whether the menu should open below the trigger. It prefers downward,
  /// but flips up when the viewport has less room below than the menu needs
  /// (and more room above), so it isn't clipped off-screen.
  bool _shouldOpenBelow() {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached) return true;

    final rawMenuHeight = widget.items.length * kDropdownItemCompactHeight;
    final menuHeight =
        rawMenuHeight < widget.maxMenuHeight
            ? rawMenuHeight
            : widget.maxMenuHeight;
    final needed = menuHeight + widget.menuGap;

    final topLeft = box.localToGlobal(Offset.zero);
    final spaceBelow =
        MediaQuery.sizeOf(context).height - (topLeft.dy + box.size.height);
    final spaceAbove = topLeft.dy;

    return spaceBelow >= needed || spaceBelow >= spaceAbove;
  }

  OverlayEntry _buildOverlayEntry({required bool openBelow}) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeMenu,
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor: openBelow
                  ? (isRtl
                        ? Alignment.bottomRight
                        : Alignment.bottomLeft)
                  : (isRtl
                        ? Alignment.topRight
                        : Alignment.topLeft),
              followerAnchor: openBelow
                  ? (isRtl
                        ? Alignment.topRight
                        : Alignment.topLeft)
                  : (isRtl
                        ? Alignment.bottomRight
                        : Alignment.bottomLeft),
              offset: Offset(0, openBelow ? widget.menuGap : -widget.menuGap),
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
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius,
                        ),
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
                              isSelected: item == _selectedValue,
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
    final textStyle = kDropdownItemTextStyle.copyWith(
      color: widget.colors.text,
    );

    final label = _selectedValue != null
        ? _labelFor(_selectedValue as T)
        : null;

    final box = Semantics(
      button: true,
      enabled: widget.enabled,
      label: label ?? widget.hintText ?? '',
      child: CompositedTransformTarget(
        link: _layerLink,
        child: MouseRegion(
          cursor: widget.enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: widget.enabled
              ? (_) => setState(() => _isHovered = true)
              : null,
          onExit: widget.enabled
              ? (_) => setState(() => _isHovered = false)
              : null,
          child: Focus(
            focusNode: _focusNode,
            onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
            // Only claim the keys the dropdown acts on (space/enter, plus
            // Escape while the menu is open); everything else must bubble so
            // Tab traversal and global shortcuts keep working.
            onKeyEvent: (node, event) {
              return _handleKeyEvent(event)
                  ? KeyEventResult.handled
                  : KeyEventResult.ignored;
            },
            child: GestureDetector(
              onTap: _toggleMenu,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: widget.width,
                height: widget.height,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: _backgroundColor(),
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: _isFocused
                      ? Border.all(color: widget.colors.hover, width: 2)
                      : null,
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
