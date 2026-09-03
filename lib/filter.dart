import 'package:flutter/material.dart';
import 'widgets.dart/text_input.dart';
import 'widgets.dart/dropdown_menu.dart';
import 'widgets.dart/buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterValues {
  const FilterValues({
    required this.letterNumber,
    required this.fromDate,
    required this.toDate,
    required this.title,
    required this.organization,
    required this.priority,
    required this.keywords,
  });

  final String letterNumber;
  final String fromDate;
  final String toDate;
  final String title;
  final String organization;
  final String? priority;
  final List<String> keywords;

  bool get isEmpty =>
      letterNumber.isEmpty &&
      fromDate.isEmpty &&
      toDate.isEmpty &&
      title.isEmpty &&
      organization.isEmpty &&
      priority == null &&
      keywords.isEmpty;
}

class FilterPanel extends StatefulWidget {
  const FilterPanel({
    super.key,
    this.onApply,
    this.onClear,
    this.initialValues,
    this.priorityItems = const ['عادی', 'فوری'],
    this.panelWidth,
    this.rightPadding,
    this.leftPadding,
    this.backgroundColor = const Color(0xFFBBBBC0),
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

  bool get _hasAppliedFilters => widget.initialValues != null;

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
    });
  }

  void _handleButtonPressed() {
    if (_hasAppliedFilters) {
      _clearAllFields();
      widget.onClear?.call();
    } else {
      final values = FilterValues(
        letterNumber: _letterNumberController.text,
        fromDate: _fromDateController.text,
        toDate: _toDateController.text,
        title: _titleController.text,
        organization: _organizationController.text,
        priority: _priority,
        keywords: List.unmodifiable(_keywords),
      );
      widget.onApply?.call(values);
      Navigator.of(context).pop();
    }
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(
        color: const Color(0xFF101018),
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'Estedad',
      ),
    );
  }

  Widget _buildLabeledField({required String label, required Widget field}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [_buildLabel(label), const SizedBox(height: 8), field],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  top: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildLabeledField(
                      label: 'شماره نامه',
                      field: AppTextField(
                        controller: _letterNumberController,
                        width: _fieldWidth,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildLabeledField(
                      label: 'از تاریخ',
                      field: AppTextField(
                        controller: _fromDateController,
                        width: _fieldWidth,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildLabeledField(
                      label: 'تا تاریخ',
                      field: AppTextField(
                        controller: _toDateController,
                        width: _fieldWidth,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildLabeledField(
                      label: 'عنوان',
                      field: AppTextField(
                        controller: _titleController,
                        width: _fieldWidth,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildLabeledField(
                      label: 'سازمان/شرکت',
                      field: AppTextField(
                        controller: _organizationController,
                        width: _fieldWidth,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildLabeledField(
                      label: 'اولویت',
                      field: AppDropdown<String>(
                        value: _priority,
                        items: widget.priorityItems,
                        itemLabelBuilder: (item) =>
                            item == 'فوری' ? '🔴 $item' : item,
                        width: _fieldWidth,
                        hintText: ' عادی ',
                        onChanged: (value) => setState(() => _priority = value),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildLabeledField(
                      label: 'کلمات کلیدی',
                      field: AppTextField(
                        controller: _tagInputController,
                        width: _fieldWidth,
                        height: 64,
                        onSubmitted: (_) => _addTag(),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Color(0xFFF3F3F7),
                          ),
                          onPressed: _addTag,
                        ),
                      ),
                    ),
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
                                      color: Color(0xFF828288),
                                      fontFamily: 'Estedad',
                                    ),
                                  ),
                                  backgroundColor: const Color(0xFF3863A8),
                                  deleteIcon: Icon(
                                    Icons.close,
                                    size: 16.sp,
                                    color: const Color(0xFFF3F3F7),
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
              child: CustomButton(
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
            ),
          ],
        ),
      ),
    );
  }
}
