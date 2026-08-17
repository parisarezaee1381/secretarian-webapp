import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'widgets.dart/switch_button.dart';
import 'widgets.dart/buttons.dart';
import 'widgets.dart/text_input.dart';
import 'widgets.dart/dropdown_menu.dart';
import 'widgets.dart/header.dart';
import 'widgets.dart/hoverablecontainer.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color primaryColor;
  final Color backgroundColor;

  const PrimaryButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.primaryColor = const Color(0xFF3863A8),
    this.backgroundColor = const Color(0xFFF3F3F7),
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: label,
      type: ButtonType.primary,
      icon: icon != null ? Icon(icon) : null,
      backgroundColor: primaryColor,
      textColor: backgroundColor,
      onPressed: onPressed,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;

  const SecondaryButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: label,
      type: ButtonType.secondary,
      icon: icon != null ? Icon(icon) : null,
      onPressed: onPressed,
    );
  }
}

class TertiaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const TertiaryButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFF3F3F7),
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: label,
      type: ButtonType.tertiary,
      icon: icon != null ? Icon(icon) : null,
      backgroundColor: backgroundColor,
      onPressed: onPressed,
    );
  }
}

class AttachedItem {
  final String name;
  final Uint8List? bytes;
  final String? path;
  final bool isImage;

  AttachedItem({required this.name, this.bytes, this.path})
      : isImage = _checkIsImage(name);

  static bool _checkIsImage(String name) {
    final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
    return ['jpg', 'jpeg', 'png', 'bmp', 'gif', 'webp'].contains(ext);
  }
}

class SmartDateField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isReadOnly;
  final double fieldWidth;
  final double labelWidth;

  const SmartDateField({
    super.key,
    required this.controller,
    required this.label,
    this.isReadOnly = false,
    this.fieldWidth = 548,
    this.labelWidth = 150,
  });

  @override
  State<SmartDateField> createState() => _SmartDateFieldState();
}

class _SmartDateFieldState extends State<SmartDateField> {
  late final TextEditingController _displayController;
  late final FocusNode _focusNode;

  bool _isUpdating = false;
  bool _isDefaultUntouched = false;

  // تاریخ امروز شمسی
  String _getTodayDigits() {
    final today = Jalali.now();

    return '${today.year.toString().padLeft(4, '0')}'
        '${today.month.toString().padLeft(2, '0')}'
        '${today.day.toString().padLeft(2, '0')}';
  }

  // تبدیل 14050827 به 1405/08/27
  String _displayDate(String digits) {
    if (digits.isEmpty) return '';

    final padded = digits.padRight(8, '_');

    final year = padded.substring(0, 4).replaceAll('_', '');
    final month = padded.substring(4, 6).replaceAll('_', '');
    final day = padded.substring(6, 8).replaceAll('_', '');

    final displayYear =
        year.isNotEmpty ? year.padRight(4, '_') : '____';

    final displayMonth =
        month.isNotEmpty ? month.padRight(2, '_') : '__';

    final displayDay =
        day.isNotEmpty ? day.padRight(2, '_') : '__';

    return '$displayYear/$displayMonth/$displayDay';
  }

  // بررسی و اصلاح تاریخ واردشده
  String _processFinalDate(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleaned.isEmpty) return '';

    final today = Jalali.now();

    int day = today.day;
    int month = today.month;
    int year = today.year;

    if (cleaned.length == 1) {
      day = int.parse(cleaned);
    } else if (cleaned.length == 2) {
      day = int.parse(cleaned.substring(0, 2));
    } else if (cleaned.length == 4) {
      day = int.parse(cleaned.substring(0, 2));
      month = int.parse(cleaned.substring(2, 4));
    } else if (cleaned.length == 6) {
      day = int.parse(cleaned.substring(0, 2));
      month = int.parse(cleaned.substring(2, 4));

      final shortYear = int.parse(cleaned.substring(4, 6));
      year = 1400 + shortYear;
    } else if (cleaned.length >= 8) {
      day = int.parse(cleaned.substring(0, 2));
      month = int.parse(cleaned.substring(2, 4));
      year = int.parse(cleaned.substring(4, 8));
    }

    // محدود کردن ماه
    if (month < 1) month = 1;
    if (month > 12) month = 12;

    // محدود کردن روز بر اساس تعداد واقعی روزهای همان ماه
    final maxDay = Jalali(year, month, 1).monthLength;

    if (day < 1) day = 1;
    if (day > maxDay) day = maxDay;

    // ساخت تاریخ معتبر شمسی
    final date = Jalali(year, month, day);

    return '${date.year.toString().padLeft(4, '0')}'
        '${date.month.toString().padLeft(2, '0')}'
        '${date.day.toString().padLeft(2, '0')}';
  }

  void _updateDisplay(String value) {
    var digits = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length > 8) {
      digits = digits.substring(0, 8);
    }

    String day;
    String month;
    String year;

    if (digits.isNotEmpty) {
      final dayLength = digits.length >= 2 ? 2 : digits.length;

      day = digits
          .substring(0, dayLength)
          .padLeft(2, '0');

      if (digits.length > 2) {
        const monthStart = 2;

        final monthLength =
            digits.length >= 4 ? 2 : digits.length - 2;

        month = digits
            .substring(monthStart, monthStart + monthLength)
            .padLeft(2, '0');

        if (digits.length > 4) {
          const yearStart = 4;

          final yearLength =
              digits.length >= 8 ? 4 : digits.length - 4;

          year = digits
              .substring(yearStart, yearStart + yearLength)
              .padLeft(4, '0');
        } else {
          year = '0000';
        }
      } else {
        month = '00';
        year = '0000';
      }
    } else {
      day = '00';
      month = '00';
      year = '0000';
    }

    widget.controller.text = '$year$month$day';

    _isDefaultUntouched = false;
  }

  void _onFocusLost() {
    if (widget.controller.text.isNotEmpty) {
      widget.controller.text =
          _processFinalDate(widget.controller.text);
    }
  }

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    if (widget.controller.text.isEmpty) {
      widget.controller.text = _getTodayDigits();
      _isDefaultUntouched = true;
    }

    _displayController = TextEditingController(
      text: _displayDate(widget.controller.text),
    );

    widget.controller.addListener(_syncDisplayController);
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      if (_isDefaultUntouched && !widget.isReadOnly) {
        _displayController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _displayController.text.length,
        );
      }
    } else if (!widget.isReadOnly) {
      _onFocusLost();
    }
  }

  void _syncDisplayController() {
    if (_isUpdating) return;

    _isUpdating = true;

    _displayController.text =
        _displayDate(widget.controller.text);

    _displayController.selection =
        TextSelection.collapsed(
      offset: _displayController.text.length,
    );

    _isUpdating = false;
  }

  @override
  void didUpdateWidget(
    covariant SmartDateField oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller
          .removeListener(_syncDisplayController);

      widget.controller
          .addListener(_syncDisplayController);

      _syncDisplayController();
    }
  }

  @override
  void dispose() {
    widget.controller
        .removeListener(_syncDisplayController);

    _focusNode
        .removeListener(_handleFocusChange);

    _focusNode.dispose();
    _displayController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.isReadOnly
        ? const AppTextFieldColors(
            disabled: Color(0xFFF3F3F7),
            text: Color(0xFF101018),
          )
        : const AppTextFieldColors();

    return AppTextField(
      controller: _displayController,
      focusNode: _focusNode,
      labelText: widget.label,
      labelWidth: widget.labelWidth,
      labelSpacing: 0,
      width: widget.fieldWidth,
      height: 64,
      enabled: !widget.isReadOnly,
      keyboardType: TextInputType.number,
      onChanged:
          widget.isReadOnly ? null : _updateDisplay,
      colors: colors,
    );
  }
}

class CustomModal extends StatefulWidget {
  const CustomModal({super.key});

  @override
  State<CustomModal> createState() => _CustomModalState();
}

class _CustomModalState extends State<CustomModal> {
  final _organizationController = TextEditingController();
  final _dateController = TextEditingController();
  final _followUpByController = TextEditingController();

  static const double _modalFieldWidth = 308;

  static const double _modalLabelWidth = 150;

  String? _dateError;
  String? _followUpByError;

  static const Color _errorColor = Color(0xFFA85838);

  @override
  void dispose() {
    _organizationController.dispose();
    _dateController.dispose();
    _followUpByController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool valid = true;
    setState(() {
      final dateDigits = _dateController.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (dateDigits.isEmpty || int.tryParse(dateDigits) == 0) {
        _dateError = 'لطفا این فیلد را پر کنید';
        valid = false;
      } else {
        _dateError = null;
      }
      if (_followUpByController.text.trim().isEmpty) {
        _followUpByError = 'لطفا این فیلد را پر کنید';
        valid = false;
      } else {
        _followUpByError = null;
      }
    });
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: 568,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Text(
                      'نیاز به پیگیری',
                      style: TextStyle(
                        color: Color(0xFF101018),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Estedad',
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: HoverableContainer(
                      width: 44,
                      height: 44,
                      hoverColor: const Color(0xFFBBBBC0),
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close, color: Color(0xFF101018)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: Color(0xFFBBBBC0)),
            const SizedBox(height: 24),
            // ردیف تاریخ پیگیری + خطا
            Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmartDateField(
                    controller: _dateController,
                    label: 'تاریخ پیگیری:',
                    fieldWidth: _modalFieldWidth,
                    labelWidth: _modalLabelWidth,
                  ),
                  if (_dateError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, right: _modalLabelWidth),
                      child: Text(
                        _dateError!,
                        style: const TextStyle(color: _errorColor, fontSize: 12, fontFamily: 'Estedad'),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    controller: _followUpByController,
                    labelText: 'پیگیری توسط:',
                    labelWidth: _modalLabelWidth,
                    labelSpacing: 0,
                    width: _modalFieldWidth,
                    height: 64,
                    errorText: _followUpByError,
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Estedad',
                    ),
                  ),
                  if (_followUpByError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, right: _modalLabelWidth),
                      child: Text(
                        _followUpByError!,
                        style: const TextStyle(color: _errorColor, fontSize: 12, fontFamily: 'Estedad'),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: CustomButton(
                label: 'تایید',
                type: ButtonType.primary,
                width: 204,
                height: 64,
                onPressed: () {
                  if (_validate()) {
                    Navigator.of(context).pop({
                      'organization': _organizationController.text,
                      'date': _dateController.text,
                      'followUpBy': _followUpByController.text,
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IncomingLetterFormPage extends StatefulWidget {
  const IncomingLetterFormPage({super.key});

  @override
  State<IncomingLetterFormPage> createState() => _IncomingLetterFormPageState();
}

class _IncomingLetterFormPageState extends State<IncomingLetterFormPage> {
  final letterNumberController = TextEditingController();
  final dateController = TextEditingController();
  final registrationDateController = TextEditingController();
  final subjectController = TextEditingController();
  final organizationController = TextEditingController();
  final recipientController = TextEditingController();
  final signerController = TextEditingController();
  final actionByController = TextEditingController();
  final archiveFolderController = TextEditingController();

  final _fnLetterNumber = FocusNode();
  final _fnSubject = FocusNode();
  final _fnOrganization = FocusNode();
  final _fnRecipient = FocusNode();
  final _fnSigner = FocusNode();
  final _fnActionBy = FocusNode();
  final _fnArchiveFolder = FocusNode();

  final Map<String, String?> _errors = {
    'letterNumber': null,
    'subject': null,
    'organization': null,
    'recipient': null,
    'signer': null,
    'actionBy': null,
    'archiveFolder': null,
  };

  String selectedPriority = 'عادی';
  String selectedSendMethod = 'ایمیل';

  List<String> tags = [];
  final _tagInputController = TextEditingController();

  bool _isSwitchOn = false;
  bool _isFileSwitchOn = false;
  String? _selectedFilePath;

  final List<AttachedItem> _attachedItems = [];

  static const double _a4Width = 793.7;
  static const double _a4Height = 1122.5;
  static const double _thumbnailWidth = _a4Width / 4;
  static const double _thumbnailHeight = _a4Height / 4;

  Map<String, int> _getCurrentDate() {
    final now = DateTime.now();
    final year = now.year - 621;
    var month = now.month;
    final day = now.day;
    month = month > 6 ? month - 6 : month + 6;
    return {'year': year, 'month': month, 'day': day};
  }

  String _getTodayDigits() {
    final d = _getCurrentDate();
    return '${d['year']!.toString().padLeft(4, '0')}${d['month']!.toString().padLeft(2, '0')}${d['day']!.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    dateController.text = _getTodayDigits();
  }

  @override
  void dispose() {
    letterNumberController.dispose();
    dateController.dispose();
    registrationDateController.dispose();
    subjectController.dispose();
    organizationController.dispose();
    recipientController.dispose();
    signerController.dispose();
    actionByController.dispose();
    archiveFolderController.dispose();
    _tagInputController.dispose();
    _fnLetterNumber.dispose();
    _fnSubject.dispose();
    _fnOrganization.dispose();
    _fnRecipient.dispose();
    _fnSigner.dispose();
    _fnActionBy.dispose();
    _fnArchiveFolder.dispose();
    super.dispose();
  }

  void _addTag() {
    final text = _tagInputController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        tags.add(text);
        _tagInputController.clear();
      });
    }
  }

  void _removeTag(int index) {
    setState(() => tags.removeAt(index));
  }

  void _showModal() {
    showDialog(
      context: context,
      builder: (context) => const CustomModal(),
    ).then((result) {
      if (result != null) {
        rootScaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(
              'اطلاعات ذخیره شد:\nسازمان: ${result['organization']}\nتاریخ: ${result['date']}\nپیگیری: ${result['followUpBy']}',
              style: const TextStyle(fontFamily: 'Estedad'),
            ),
            backgroundColor: const Color(0xFF3863A8),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.saveFile(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
      );
      if (result != null) {
        final fileName = result.split(Platform.pathSeparator).last;
        setState(() {
          _selectedFilePath = fileName;
          _isFileSwitchOn = true;
        });
        rootScaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('فایل ذخیره شد: $fileName'), backgroundColor: const Color(0xFF3863A8)),
        );
      } else {
        setState(() => _isFileSwitchOn = false);
      }
    } catch (e) {
      setState(() => _isFileSwitchOn = false);
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text('خطا در ذخیره فایل'), backgroundColor: Color(0xFFA85838)),
      );
    }
  }

  Future<void> _pickAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
        withData: true,
      );
      if (result != null) {
        final file = result.files.first;
        setState(() {
          _attachedItems.add(AttachedItem(name: file.name, bytes: file.bytes, path: file.path));
        });
      }
    } catch (e) {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text('خطا در انتخاب فایل'), backgroundColor: Color(0xFFA85838)),
      );
    }
  }

  Future<void> _scanDocument() async {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Text(
          'اتصال به اسکنر هنوز پیاده‌سازی نشده است. برای اتصال واقعی به یک پکیج/درایور اسکنر مخصوص پلتفرم نیاز است.',
          style: TextStyle(fontFamily: 'Estedad'),
        ),
        backgroundColor: Color(0xFFA85838),
      ),
    );
  }

  // ignore: unused_element
  void _onScanComplete(Uint8List imageBytes, String fileName) {
    setState(() => _attachedItems.add(AttachedItem(name: fileName, bytes: imageBytes)));
  }

  void _removeAttachedItem(int index) {
    setState(() => _attachedItems.removeAt(index));
  }

  bool _validateForm() {
    final newErrors = <String, String?>{
      'letterNumber': letterNumberController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
      'subject': subjectController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
      'organization': organizationController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
      'recipient': recipientController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
      'signer': signerController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
      'actionBy': actionByController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
      'archiveFolder': archiveFolderController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
    };
    setState(() => _errors.addAll(newErrors));
    return newErrors.values.every((e) => e == null);
  }

  void _submitForm() {
    if (!_validateForm()) return;

    setState(() => _isSwitchOn = true);
    _showModal();

    rootScaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(content: Text('نامه ثبت شد'), backgroundColor: Color(0xFF3863A8)),
    );
  }

  void _cancelForm() {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(content: Text('عملیات لغو شد'), backgroundColor: Color(0xFF828288)),
    );
  }

  Widget _buildFileIconPlaceholder(String name) {
    return Container(
      color: const Color(0xFFF3F3F7),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.insert_drive_file, color: Color(0xFF828288), size: 40),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF101018), fontSize: 11, fontFamily: 'Estedad'),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(AttachedItem item, int index) {
    Widget preview;
    if (item.isImage && item.bytes != null) {
      preview = Image.memory(item.bytes!, fit: BoxFit.cover);
    } else if (item.isImage && item.path != null) {
      preview = Image.file(File(item.path!), fit: BoxFit.cover);
    } else {
      preview = _buildFileIconPlaceholder(item.name);
    }

    // دکمه‌ی حذف پیوست حالا روی HoverableContainer سوار شده تا هاورش با
    // بقیه‌ی اپ هماهنگ باشه.
    return Container(
      width: _thumbnailWidth,
      height: _thumbnailHeight,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBBBBC0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox.expand(child: preview),
          ),
          Positioned(
            top: 6,
            left: 6,
            child: HoverableContainer(
              width: 24,
              height: 24,
              borderRadius: 12,
              normalColor: const Color(0xFFA85838),
              hoverColor: const Color(0xFFA85838),
              hoverOpacity: 0.8,
              onTap: () => _removeAttachedItem(index),
              child: const Icon(Icons.close, size: 16, color: Color(0xFFF3F3F7)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsPanel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_attachedItems.isNotEmpty) ...[
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: List.generate(_attachedItems.length, (i) => _buildThumbnail(_attachedItems[i], i)),
          ),
          const SizedBox(height: 16),
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SecondaryButton(label: 'اسکن سند', icon: Icons.print_outlined, onPressed: _scanDocument),
            const SizedBox(width: 16),
            SecondaryButton(label: '+ افزودن پیوست', onPressed: _pickAttachment),
          ],
        ),
        const SizedBox(height: 64),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(label: 'ثبت', onPressed: _submitForm),
            const SizedBox(width: 16),
            TertiaryButton(label: 'انصراف', onPressed: _cancelForm),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Column(
      children: [
        const SizedBox(height: 32),
        Row(
          children: [
            Container(width: 148, height: 1, color: const Color(0xFFF3F3F7)),
            Container(width: 548, height: 1, color: const Color(0xFF828288)),
          ],
        ),
        const SizedBox(height: 64),
      ],
    );
  }

  Widget _buildFormRow(
    String label,
    TextEditingController controller, {
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    String? errorKey,
  }) {
    final errorText = errorKey != null ? _errors[errorKey] : null;
    final showLimitWarning = errorText == null && controller.text.length >= 55;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: controller,
          focusNode: focusNode,
          labelText: label,
          labelWidth: 150,
          labelSpacing: 0,
          width: 548,
          height: 64,
          textInputAction: nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
          inputFormatters: [LengthLimitingTextInputFormatter(55)],
          errorText: errorText,
          // برای این‌که هشدار سقف کاراکتر لحظه‌به‌لحظه به‌روز بشه
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
        ),
        if (errorText != null || showLimitWarning)
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 150),
            child: Text(
              errorText ?? 'حداکثر 55 کاراکتر مجاز است',
              style: const TextStyle(color: Color(0xFFA85838), fontSize: 12, fontFamily: 'Estedad'),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionLabel(String text, {double width = 150}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF101018),
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Estedad',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3F7),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 1440,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // هدر صفحه، حالا از AppHeader استفاده می‌شه. چون این
                  // صفحه‌ی ریشه‌ست و دکمه‌ی بازگشتی نداریم،
                  // leading رو none گذاشتیم.
                  const AppHeader(
                    title: 'ثبت نامه وارده',
                    leading: HeaderLeading.none,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 32, top: 64),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormRow(
                          'شماره نامه:',
                          letterNumberController,
                          focusNode: _fnLetterNumber,
                          nextFocusNode: _fnSubject,
                          errorKey: 'letterNumber',
                        ),
                        const SizedBox(height: 32),
                        SmartDateField(
                          controller: dateController,
                          label: 'تاریخ:',
                          isReadOnly: true,
                        ),
                        const SizedBox(height: 32),
                        _buildFormRow(
                          'عنوان/خلاصه نامه:',
                          subjectController,
                          focusNode: _fnSubject,
                          nextFocusNode: _fnOrganization,
                          errorKey: 'subject',
                        ),
                        const SizedBox(height: 32),
                        // بخش تگ‌ها — دیگه نیازی به منطق دستی
                        // hover/focus نیست چون AppTextField خودش
                        // suffixIcon و رنگ‌بندی رو مدیریت می‌کنه.
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionLabel('کلمات کلیدی:'),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextField(
                                  controller: _tagInputController,
                                  width: 548,
                                  height: 64,
                                  onSubmitted: (_) => _addTag(),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.add_circle_outline, color: Color(0xFFF3F3F7)),
                                    onPressed: _addTag,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: 548,
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: tags.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final tag = entry.value;
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF828288),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              tag,
                                              style: const TextStyle(
                                                color: Color(0xFFF3F3F7),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Estedad',
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () => _removeTag(index),
                                              child: const Icon(Icons.close, size: 16, color: Color(0xFFF3F3F7)),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        _buildDivider(),
                        _buildFormRow(
                          'به سازمان/شرکت:',
                          organizationController,
                          focusNode: _fnOrganization,
                          nextFocusNode: _fnRecipient,
                          errorKey: 'organization',
                        ),
                        const SizedBox(height: 32),
                        _buildFormRow(
                          'شخص ارسال کننده:',
                          recipientController,
                          focusNode: _fnRecipient,
                          nextFocusNode: _fnSigner,
                          errorKey: 'recipient',
                        ),
                        const SizedBox(height: 32),
                        _buildFormRow(
                          'شماره نامه فرستنده:',
                          signerController,
                          focusNode: _fnSigner,
                          nextFocusNode: _fnActionBy,
                          errorKey: 'signer',
                        ),
                        const SizedBox(height: 32),
                        _buildFormRow(
                          'مخاطب:',
                          actionByController,
                          focusNode: _fnActionBy,
                          errorKey: 'actionBy',
                        ),
                        _buildDivider(),
                        SmartDateField(controller: registrationDateController, label: 'تاریخ ثبت:'),
                        const SizedBox(height: 32),
                        _buildFormRow(
                          'پوشه بایگانی:',
                          archiveFolderController,
                          focusNode: _fnArchiveFolder,
                          errorKey: 'archiveFolder',
                        ),
                        const SizedBox(height: 32),
                        // اولویت — با AppDropdown<String>. توجه: نسخه‌ی
                        // جدیدِ ویجت آیتم‌های دراپ‌داون (DropdownMenuItemWidget)
                        // ورودیِ رنگِ نشانگر (indicator dot) نداره؛ برای اینکه
                        // گزینه‌ی «فوری» هنوز قابل تشخیص باشه، یک نشانگر متنی
                        // ساده کنارش گذاشتیم. اگه دایره‌ی رنگیِ واقعی لازمه،
                        // باید یک پارامتر leading به DropdownMenuItemWidget
                        // اضافه بشه.
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildSectionLabel('اولویت:'),
                            AppDropdown<String>(
                              items: const ['عادی', 'فوری'],
                              value: selectedPriority,
                              itemLabelBuilder: (item) => item == 'فوری' ? '🔴 $item' : item,
                              onChanged: (value) {
                                if (value != null) setState(() => selectedPriority = value);
                              },
                              width: 216,
                              height: 64,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildSectionLabel('نیاز به پیگیری:'),
                            AppSwitch(
                              value: _isSwitchOn,
                              onChanged: (value) {
                                setState(() => _isSwitchOn = value);
                                if (value) _showModal();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // سوئیچ فایل
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildSectionLabel('ذخیره فایل:'),
                            Row(
                              children: [
                                AppSwitch(
                                  value: _isFileSwitchOn,
                                  onChanged: (value) async {
                                    if (value) {
                                      await _pickFile();
                                    } else {
                                      setState(() {
                                        _isFileSwitchOn = false;
                                        _selectedFilePath = null;
                                      });
                                    }
                                  },
                                ),
                                if (_selectedFilePath != null) ...[
                                  const SizedBox(width: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3863A8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _selectedFilePath!,
                                      style: const TextStyle(
                                        color: Color(0xFFF3F3F7),
                                        fontSize: 14,
                                        fontFamily: 'Estedad',
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  Center(child: _buildAttachmentsPanel()),
                  const SizedBox(height: 64),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}