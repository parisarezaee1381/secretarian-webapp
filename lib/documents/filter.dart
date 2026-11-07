import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import '../widgets/text_input.dart';
import '../widgets/dropdown_menu.dart';
import '../widgets/buttons.dart';
import '../widgets/smart_date_field.dart';
import '../domain/documents.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/core/theme.dart';

/// Vertical gap between consecutive fields in the panel.
const double _fieldSpacing = 20;

/// Gap between a field's label and its input.
const double _labelGap = 8;

const _labelColor = AppColors.text;
const _lightForeground = AppColors.background;
const _chipColor = AppColors.mutedText;
const _errorColor = AppColors.dangerStrong;

/// The set of constraints the filter panel applies to the document list.
///
/// A value type: two instances with the same field values are equal, so the
/// panel's `didUpdateWidget` only re-syncs when the filter genuinely changes.
class FilterValues {
  FilterValues({
    required this.letterNumber,
    required this.fromDate,
    required this.toDate,
    required this.title,
    required this.organization,
    required this.priority,
    required List<String> keywords,
  }) : keywords = List<String>.unmodifiable(keywords);

  final String letterNumber;
  final String fromDate;
  final String toDate;
  final String title;
  final String organization;
  final String? priority;

  /// Unmodifiable copy: the panel hands its mutable working list straight in.
  final List<String> keywords;

  bool get isEmpty =>
      letterNumber.isEmpty &&
      fromDate.isEmpty &&
      toDate.isEmpty &&
      title.isEmpty &&
      organization.isEmpty &&
      priority == null &&
      keywords.isEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FilterValues &&
          other.letterNumber == letterNumber &&
          other.fromDate == fromDate &&
          other.toDate == toDate &&
          other.title == title &&
          other.organization == organization &&
          other.priority == priority &&
          listEquals(other.keywords, keywords));

  @override
  int get hashCode => Object.hash(
        letterNumber,
        fromDate,
        toDate,
        title,
        organization,
        priority,
        Object.hashAll(keywords),
      );
}

class FilterPanel extends StatefulWidget {
  const FilterPanel({
    super.key,
    this.onApply,
    this.onClear,
    this.initialValues,
    this.priorityItems = kPriorityOptions,
    this.panelWidth,
    this.rightPadding,
    this.leftPadding,
    this.backgroundColor = AppColors.border,
  });

  final ValueChanged<FilterValues>? onApply;
  final VoidCallback? onClear;

  final FilterValues? initialValues;
  final List<String> priorityItems;
  final double? panelWidth;
  final double? rightPadding;
  final double? leftPadding;
  final Color backgroundColor;

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  final _letterNumberController = TextEditingController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final _titleController = TextEditingController();
  final _organizationController = TextEditingController();
  final _tagInputController = TextEditingController();

  String? _priority;
  final List<String> _keywords = [];

  /// Shown under the button when the chosen date range is inverted; cleared
  /// whenever the fields are (re)loaded, cleared, or successfully applied.
  String? _dateRangeError;

  bool get _hasAppliedFilters =>
      widget.initialValues != null && !widget.initialValues!.isEmpty;

  double get _effectivePanelWidth => widget.panelWidth ?? 500.w;
  double get _effectiveRightPadding => widget.rightPadding ?? 64.w;
  double get _effectiveLeftPadding => widget.leftPadding ?? 24.w;

  double get _fieldWidth =>
      _effectivePanelWidth - _effectiveRightPadding - _effectiveLeftPadding;

  @override
  void initState() {
    super.initState();
    _syncFromValues(widget.initialValues);
  }

  @override
  void didUpdateWidget(covariant FilterPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValues != oldWidget.initialValues) {
      _syncFromValues(widget.initialValues);
    }
  }

  void _syncFromValues(FilterValues? values) {
    _dateRangeError = null;
    _letterNumberController.text = values?.letterNumber ?? '';
    _fromDateController.text = values?.fromDate ?? '';
    _toDateController.text = values?.toDate ?? '';
    _titleController.text = values?.title ?? '';
    _organizationController.text = values?.organization ?? '';
    _priority = values?.priority;
    _keywords
      ..clear()
      ..addAll(values?.keywords ?? const []);
  }

  @override
  void dispose() {
    _letterNumberController.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    _titleController.dispose();
    _organizationController.dispose();
    _tagInputController.dispose();
    super.dispose();
  }

  void _addTag() {
    final value = _tagInputController.text.trim();
    if (value.isEmpty || _keywords.contains(value)) return;
    setState(() {
      _keywords.add(value);
      _tagInputController.clear();
    });
  }

  void _removeTag(String tag) {
    setState(() => _keywords.remove(tag));
  }

  void _clearAllFields() {
    _letterNumberController.clear();
    _fromDateController.clear();
    _toDateController.clear();
    _titleController.clear();
    _organizationController.clear();
    _tagInputController.clear();
    setState(() {
      _priority = null;
      _keywords.clear();
      _dateRangeError = null;
    });
  }

  void _handleButtonPressed() {
    if (_hasAppliedFilters) {
      _clearAllFields();
      widget.onClear?.call();
      return;
    }

    final from = jalaliToComparable(_fromDateController.text);
    final to = jalaliToComparable(_toDateController.text);
    if (from != null && to != null && from > to) {
      setState(() {
        _dateRangeError = 'تاریخ شروع نمی‌تواند بعد از تاریخ پایان باشد';
      });
      return;
    }

    setState(() => _dateRangeError = null);

    final values = FilterValues(
      letterNumber: _letterNumberController.text,
      fromDate: _fromDateController.text,
      toDate: _toDateController.text,
      title: _titleController.text,
      organization: _organizationController.text,
      priority: _priority,
      keywords: _keywords,
    );
    widget.onApply?.call(values);
    Scaffold.of(context).closeDrawer();
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(
        color: _labelColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildLabeledField({required String label, required Widget field}) {
    return Padding(
      padding: const EdgeInsets.only(top: _fieldSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildLabel(label),
          const SizedBox(height: _labelGap),
          field,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fields = <(String, Widget)>[
      (
        'شماره نامه',
        AppTextField(controller: _letterNumberController, width: _fieldWidth),
      ),
      (
        'از تاریخ',
        SmartDateField(controller: _fromDateController, fieldWidth: _fieldWidth),
      ),
      (
        'تا تاریخ',
        SmartDateField(controller: _toDateController, fieldWidth: _fieldWidth),
      ),
      (
        'عنوان',
        AppTextField(controller: _titleController, width: _fieldWidth),
      ),
      (
        'سازمان/شرکت',
        AppTextField(controller: _organizationController, width: _fieldWidth),
      ),
      (
        'اولویت',
        AppDropdown<String>(
          value: _priority,
          items: widget.priorityItems,
          itemLabelBuilder: (item) =>
              item == kUrgentPriority ? '🔴 $item' : item,
          width: _fieldWidth,
          hintText: 'همه',
          onChanged: (value) => setState(() => _priority = value),
        ),
      ),
      (
        'کلمات کلیدی',
        AppTextField(
          controller: _tagInputController,
          width: _fieldWidth,
          height: 64,
          onSubmitted: (_) => _addTag(),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: _lightForeground,
            ),
            onPressed: _addTag,
          ),
        ),
      ),
    ];

    return Drawer(
      width: _effectivePanelWidth,
      backgroundColor: widget.backgroundColor,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  right: _effectiveRightPadding,
                  left: _effectiveLeftPadding,
                  // The first field carries its own top gap; subtracting it
                  // keeps the original 32px offset to the first label.
                  top: 32 - _fieldSpacing,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final (label, field) in fields)
                      _buildLabeledField(label: label, field: field),
                    if (_keywords.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: _fieldWidth,
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          spacing: 8.w,
                          runSpacing: 8,
                          children: _keywords
                              .map(
                                (tag) => Chip(
                                  label: Text(
                                    tag,
                                    style: const TextStyle(
                                      color: _lightForeground,
                                    ),
                                  ),
                                  backgroundColor: _chipColor,
                                  deleteIcon: Icon(
                                    Icons.close,
                                    size: 16.sp,
                                    color: _lightForeground,
                                  ),
                                  onDeleted: () => _removeTag(tag),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: _effectiveRightPadding,
                left: _effectiveLeftPadding,
                top: 16,
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_dateRangeError != null) ...[
                    Text(
                      _dateRangeError!,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: _errorColor,
                        fontSize: 14.sp,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  CustomButton(
                    label: _hasAppliedFilters
                        ? 'پاک کردن فیلترها'
                        : 'اعمال فیلترها',
                    type: _hasAppliedFilters
                        ? ButtonType.secondary
                        : ButtonType.primary,
                    width: _fieldWidth,
                    height: 56,
                    onPressed: _handleButtonPressed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
