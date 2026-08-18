import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'package:flutter_application_1/documents.dart';
import 'package:flutter_application_1/documents/m_gharardad.dart';

import '../widgets.dart/switch_button.dart';
import '../widgets.dart/buttons.dart';
import '../widgets.dart/text_input.dart';
import '../widgets.dart/header.dart';
import '../widgets.dart/hoverablecontainer.dart';

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

class ContractFormPage extends StatefulWidget {
  const ContractFormPage({super.key});

  @override
  State<ContractFormPage> createState() => _ContractFormPageState();
}

class _ContractFormPageState extends State<ContractFormPage> {
  final letterNumberController = TextEditingController();
  final dateController = TextEditingController();
  final registrationDateController = TextEditingController();
  final subjectController = TextEditingController();
  final organizationController = TextEditingController();
  final recipientController = TextEditingController();
  final actionByController = TextEditingController();
  final registrationNumberController = TextEditingController();
  final archiveFolderController = TextEditingController();

  final _fnLetterNumber = FocusNode();
  final _fnSubject = FocusNode();
  final _fnOrganization = FocusNode();
  final _fnRecipient = FocusNode();
  final _fnActionBy = FocusNode();
  final _fnRegistrationNumber = FocusNode();
  final _fnArchiveFolder = FocusNode();

  final Map<String, String?> _errors = {
    'letterNumber': null,
    'subject': null,
    'organization': null,
    'recipient': null,
    'actionBy': null,
    'registrationNumber': null,
    'archiveFolder': null,
  };

  String selectedPriority = 'عادی';
  String selectedSendMethod = 'ایمیل';

  List<String> tags = [];
  final _tagInputController = TextEditingController();

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
    actionByController.dispose();
    registrationNumberController.dispose();
    archiveFolderController.dispose();
    _tagInputController.dispose();
    _fnLetterNumber.dispose();
    _fnSubject.dispose();
    _fnOrganization.dispose();
    _fnRecipient.dispose();
    _fnActionBy.dispose();
    _fnRegistrationNumber.dispose();
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

  setState(() {
    tags.removeAt(index);
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
      'actionBy': actionByController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
      'registrationNumber': registrationNumberController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
      'archiveFolder': archiveFolderController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
    };
    setState(() => _errors.addAll(newErrors));
    return newErrors.values.every((e) => e == null);
  }

 void _submitForm() {
  if (!_validateForm()) return;

  final document = ContractDocument(
    letterNumber: letterNumberController.text.trim(),
    date: formatJalaliDate(dateController.text),
    subject: subjectController.text.trim(),
    tags: List<String>.from(tags),

    organization: organizationController.text.trim(),
    recipient: recipientController.text.trim(),
    actionBy: actionByController.text.trim(),

    contractSubject: registrationNumberController.text.trim(),
    registrationDate: formatJalaliDate(registrationDateController.text),
    referenceContractNumber: archiveFolderController.text.trim(),

    saveFile: _isFileSwitchOn,
    filePath: _selectedFilePath,

    attachments: _attachedItems.map((item) {
      return AttachmentDocument(
        name: item.name,
        path: item.path,
        bytes: item.bytes,
      );
    }).toList(),
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ContractViewPage(document: document),
    ),
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
                    title: 'ثبت قرارداد',
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
                          'شرکت طرف قرارداد:',
                          organizationController,
                          focusNode: _fnOrganization,
                          nextFocusNode: _fnRecipient,
                          errorKey: 'organization',
                        ),
                        const SizedBox(height: 32),
                        _buildFormRow(
                          'شخص طرف قرارداد:',
                          recipientController,
                          focusNode: _fnRecipient,
                          nextFocusNode: _fnActionBy,
                          errorKey: 'recipient',
                        ),
                        const SizedBox(height: 32),
                        _buildFormRow(
                          'اقدام کننده:',
                          actionByController,
                          focusNode: _fnActionBy,
                          nextFocusNode: _fnRegistrationNumber,
                          errorKey: 'actionBy',
                        ),
                        _buildDivider(),
                        _buildFormRow(
                          'موضوع قرارداد:',
                          registrationNumberController,
                          focusNode: _fnRegistrationNumber,
                          nextFocusNode: _fnArchiveFolder,
                          errorKey: 'registrationNumber',
                        ),
                        const SizedBox(height: 32),
                        SmartDateField(controller: registrationDateController, label: 'تاریخ ثبت:'),
                        const SizedBox(height: 32),
                        _buildFormRow(
                          'شماره قرارداد مرجع:',
                          archiveFolderController,
                          focusNode: _fnArchiveFolder,
                          errorKey: 'archiveFolder',
                        ),
                        const SizedBox(height: 32),
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

class ContractData {
  final String letterNumber;
  final String date;
  final String subject;
  final List<String> tags;
  final String organization;
  final String recipient;
  final String actionBy;
  final String contractSubject;
  final String registrationDate;
  final String referenceContractNumber;
  final bool saveFile;
  final String? savedFileName;
  final List<AttachedItem> attachments;

  const ContractData({
    required this.letterNumber,
    required this.date,
    required this.subject,
    required this.tags,
    required this.organization,
    required this.recipient,
    required this.actionBy,
    required this.contractSubject,
    required this.registrationDate,
    required this.referenceContractNumber,
    required this.saveFile,
    this.savedFileName,
    required this.attachments,
  });
}

String formatJalaliDate(String digits) {
  final clean = digits.replaceAll(RegExp(r'[^0-9]'), '');
  if (clean.length != 8) return clean;
  return '${clean.substring(0, 4)}/${clean.substring(4, 6)}/${clean.substring(6, 8)}';
}