import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

import 'widgets.dart/switch_button.dart';
import 'widgets.dart/buttons.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: LetterFormPage(),
      ),
    );
  }
}


void _showOfflineModal(BuildContext context, {required Color backgroundColor}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      backgroundColor: backgroundColor,
      title: const Text(
        'خطای اتصال',
        style: TextStyle(fontFamily: 'Estedad', fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'اتصال به اینترنت برقرار نیست. لطفاً اتصال خود را بررسی کرده و دوباره تلاش کنید.',
        style: TextStyle(fontFamily: 'Estedad'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('باشه', style: TextStyle(fontFamily: 'Estedad')),
        ),
      ],
    ),
  );
}

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppSwitch(
      value: value,
      onChanged: onChanged,
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isOffline;
  final Color primaryColor;
  final Color backgroundColor;

  const PrimaryButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isOffline = false,
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
      onPressed: isOffline
          ? () => _showOfflineModal(
                context,
                backgroundColor: backgroundColor,
              )
          : onPressed,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isOffline;

  const SecondaryButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: label,
      type: ButtonType.secondary,
      icon: icon != null ? Icon(icon) : null,
      onPressed: isOffline
          ? () => _showOfflineModal(
                context,
                backgroundColor: const Color(0xFFF3F3F7),
              )
          : onPressed,
    );
  }
}

class TertiaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isOffline;
  final Color backgroundColor;

  const TertiaryButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isOffline = false,
    this.backgroundColor = const Color(0xFFF3F3F7),
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: label,
      type: ButtonType.tertiary,
      icon: icon != null ? Icon(icon) : null,
      backgroundColor: backgroundColor,
      onPressed: isOffline
          ? () => _showOfflineModal(
                context,
                backgroundColor: backgroundColor,
              )
          : onPressed,
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

  const SmartDateField({
    super.key,
    required this.controller,
    required this.label,
    this.isReadOnly = false,
    this.fieldWidth = 548,
  });

  @override
  State<SmartDateField> createState() => _SmartDateFieldState();
}

class _SmartDateFieldState extends State<SmartDateField> {
  bool _isHovered = false;
  bool _isFocused = false;

  late final TextEditingController _displayController;
  bool _isUpdating = false;

  // true تا وقتی که مقدار فیلد همون تاریخ پیش‌فرض (امروز) باشه و کاربر هنوز چیزی تایپ نکرده باشه
  bool _isDefaultUntouched = false;

  // دریافت تاریخ جاری شمسی
  Map<String, int> _getCurrentDate() {
    final now = DateTime.now();
    final year = now.year - 621;
    var month = now.month;
    final day = now.day;

    month = month > 6 ? month - 6 : month + 6;

    return {'year': year, 'month': month, 'day': day};
  }

  int _getMaxDaysInMonth(int month) {
    if ([1, 2, 3, 7, 8, 9, 10, 11, 12].contains(month)) return 31;
    if ([4, 5, 6].contains(month)) return 30;
    return 29;
  }

  String _getTodayDigits() {
    final currentDate = _getCurrentDate();
    final year = currentDate['year']!;
    final month = currentDate['month']!;
    final day = currentDate['day']!;
    return '${year.toString().padLeft(4, '0')}${month.toString().padLeft(2, '0')}${day.toString().padLeft(2, '0')}';
  }

  // نمایش با فرمت YYYY/MM/DD
  String _displayDate(String digits) {
    if (digits.isEmpty) return '';
    final padded = digits.padRight(8, '_');
    final year = padded.substring(0, 4).replaceAll('_', '');
    final month = padded.substring(4, 6).replaceAll('_', '');
    final day = padded.substring(6, 8).replaceAll('_', '');

    final displayYear = year.isNotEmpty ? year.padRight(4, '_') : '____';
    final displayMonth = month.isNotEmpty ? month.padRight(2, '_') : '__';
    final displayDay = day.isNotEmpty ? day.padRight(2, '_') : '__';

    return '$displayYear/$displayMonth/$displayDay';
  }

  String _processFinalDate(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) return '';

    final currentDate = _getCurrentDate();
    final currentYear = currentDate['year']!;
    final currentMonth = currentDate['month']!;
    final currentDay = currentDate['day']!;

    var day = currentDay;
    var month = currentMonth;
    var year = currentYear;

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

    final maxDay = _getMaxDaysInMonth(month);
    if (day == 0) day = 1;
    if (day > maxDay) day = maxDay;
    if (month == 0) month = 1;
    if (month > 12) month = 12;
    if (year == 0) year = currentYear;
    if (year >= 0 && year <= 99) year = 1400 + year;
    if (year < 1000) year = 1400 + year;

    return '${year.toString().padLeft(4, '0')}${month.toString().padLeft(2, '0')}${day.toString().padLeft(2, '0')}';
  }

  void _updateDisplay(String value) {
    var digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 8) {
      digits = digits.substring(0, 8);
    }

    String day, month, year;

    if (digits.isNotEmpty) {
      final dayLength = digits.length >= 2 ? 2 : digits.length;
      day = digits.substring(0, dayLength).padLeft(2, '0');

      if (digits.length > 2) {
        const monthStart = 2;
        final monthLength = digits.length >= 4 ? 2 : digits.length - 2;
        month = digits.substring(monthStart, monthStart + monthLength).padLeft(2, '0');

        if (digits.length > 4) {
          const yearStart = 4;
          final yearLength = digits.length >= 8 ? 4 : digits.length - 4;
          year = digits.substring(yearStart, yearStart + yearLength).padLeft(4, '0');
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
  }

  void _onFocusLost() {
    if (widget.controller.text.isNotEmpty) {
      widget.controller.text = _processFinalDate(widget.controller.text);
    }
  }

  Color _getFillColor() {
    if (widget.isReadOnly) return const Color(0xFFF3F3F7);
    if (_isFocused) return const Color(0xFF3863A8);
    if (_isHovered) return const Color(0xFFBBBBC0);
    return const Color(0xFF828288);
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isEmpty) {
      widget.controller.text = _getTodayDigits();
      // چون مقدار اولیه توسط خود ویجت (نه کاربر) پر شده، این‌جا علامت می‌زنیم
      // که تا وقتی کاربر شروع به تایپ نکرده، این مقدار "پیش‌فرض" حساب بشه
      _isDefaultUntouched = true;
    }
    _displayController = TextEditingController(text: _displayDate(widget.controller.text));
    widget.controller.addListener(_syncDisplayController);
  }

  void _syncDisplayController() {
    if (_isUpdating) return;
    _isUpdating = true;
    _displayController.text = _displayDate(widget.controller.text);
    _displayController.selection = TextSelection.collapsed(offset: _displayController.text.length);
    _isUpdating = false;
  }

  @override
  void didUpdateWidget(covariant SmartDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_syncDisplayController);
      widget.controller.addListener(_syncDisplayController);
      _syncDisplayController();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncDisplayController);
    _displayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Color(0xFF101018),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Estedad',
            ),
          ),
        ),
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Focus(
            onFocusChange: (hasFocus) {
              setState(() => _isFocused = hasFocus);

              if (hasFocus) {
                // اگر مقدار فعلی همون تاریخ پیش‌فرضه و کاربر هنوز دستکاریش نکرده،
                // کل متن رو انتخاب می‌کنیم تا اولین کاراکتری که تایپ می‌شه
                // جای کل تاریخ پیش‌فرض رو بگیره، نه این‌که به وسطش اضافه بشه.
                if (_isDefaultUntouched && !widget.isReadOnly) {
                  _displayController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _displayController.text.length,
                  );
                }
              } else if (!widget.isReadOnly) {
                _onFocusLost();
              }
            },
            child: SizedBox(
              width: widget.fieldWidth,
              height: 64,
              child: TextField(
                controller: _displayController,
                enabled: !widget.isReadOnly,
                style: TextStyle(
                  color: widget.isReadOnly ? const Color(0xFF101018) : const Color(0xFFF3F3F7),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Estedad',
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _getFillColor(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  counterText: '',
                ),
                onChanged: (value) {
                  if (!widget.isReadOnly) {
                    _updateDisplay(value);
                  }
                },
              ),
            ),
          ),
        ),
      ],
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

  // عرض هر یک از دو تکست‌اینپوت «تاریخ پیگیری» و «پیگیری توسط»
  // (این دو باید دقیقاً هم‌عرض باشن)
  static const double _modalFieldWidth = 308;

  // عرض لیبل‌ها. SmartDateField داخلی‌اش لیبل رو با عرض ثابت 150 رسم می‌کنه،
  // پس برای اینکه اینپوت «پیگیری توسط» هم دقیقاً از همون نقطه شروع بشه،
  // لیبل «پیگیری توسط» هم باید همین عرض (150) رو داشته باشه.
  static const double _modalLabelWidth = 150;

  // خطاهای اعتبارسنجی
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
      // تاریخ پیگیری: کنترلر ارقام خام ذخیره می‌کند؛ اگر خالی یا فقط صفر بود، خطا بده
      final dateDigits = _dateController.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (dateDigits.isEmpty || int.tryParse(dateDigits) == 0) {
        _dateError = 'لطفا این فیلد را پر کنید';
        valid = false;
      } else {
        _dateError = null;
      }
      // پیگیری توسط
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
            // هدر: عنوان وسط، دکمه‌ی بستن راست
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
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF101018)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: Color(0xFFBBBBC0)),
            const SizedBox(height: 24),
            // ردیف تاریخ پیگیری (RTL لیبل + LTR فیلد) + خطا
            Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmartDateField(
                    controller: _dateController,
                    label: 'تاریخ پیگیری:',
                    fieldWidth: _modalFieldWidth,
                  ),
                  if (_dateError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, right: _modalLabelWidth),
                      child: Text(
                        _dateError!,
                        style: const TextStyle(
                          color: _errorColor,
                          fontSize: 12,
                          fontFamily: 'Estedad',
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // نام سازمان/شرکت (بدون اعتبارسنجی)
            const SizedBox(height: 20),
            // پیگیری توسط (الزامی) + خطا
            Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('پیگیری توسط:', _followUpByController),
                  if (_followUpByError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, right: _modalLabelWidth),
                      child: Text(
                        _followUpByError!,
                        style: const TextStyle(
                          color: _errorColor,
                          fontSize: 12,
                          fontFamily: 'Estedad',
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // دکمه ثبت وسط
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_validate()) {
                    Navigator.of(context).pop({
                      'organization': _organizationController.text,
                      'date': _dateController.text,
                      'followUpBy': _followUpByController.text,
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3863A8),
                  foregroundColor: const Color(0xFFF3F3F7),
                  minimumSize: const Size(204 , 64),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Estedad',
                  ),
                ),
                child: const Text('تایید'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // لیبل راست‌چین، اینپوت چپ‌چین
  // عرض لیبل و عرض اینپوت با SmartDateField یکسان شده تا هر دو فیلد
  // (تاریخ پیگیری و پیگیری توسط) دقیقاً هم‌اندازه باشن و از یک نقطه شروع بشن.
  Widget _buildTextField(String label, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: _modalLabelWidth,
          child: Text(
            label,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: Color(0xFF101018),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Estedad',
            ),
          ),
        ),
        Directionality(
          textDirection: TextDirection.ltr,
          child: HoverTextField(controller: controller, width: _modalFieldWidth),
        ),
      ],
    );
  }
}

class LetterFormPage extends StatefulWidget {
  const LetterFormPage({super.key});

  @override
  State<LetterFormPage> createState() => _LetterFormPageState();
}

class _LetterFormPageState extends State<LetterFormPage> {
  final letterNumberController = TextEditingController();
  final dateController = TextEditingController();
  final registrationDateController = TextEditingController();
  final subjectController = TextEditingController();
  final organizationController = TextEditingController();
  final recipientController = TextEditingController();
  final signerController = TextEditingController();
  final actionByController = TextEditingController();
  final registrationNumberController = TextEditingController();
  final archiveFolderController = TextEditingController();

  // ============================================================
  // FocusNode ها — ترتیب Tab/Enter در فرم
  // ترتیب: شماره نامه → عنوان → به سازمان → گیرنده → امضا → اقدام
  //        → شماره ثبت → پوشه → اولویت → نحوه ارسال
  // ============================================================
  final _fnLetterNumber      = FocusNode();
  final _fnSubject           = FocusNode();
  final _fnOrganization      = FocusNode();
  final _fnRecipient         = FocusNode();
  final _fnSigner            = FocusNode();
  final _fnActionBy          = FocusNode();
  final _fnRegistrationNumber = FocusNode();
  final _fnArchiveFolder     = FocusNode();
  final _fnPriority          = FocusNode();
  final _fnSendMethod        = FocusNode();

  // خطاهای اعتبارسنجی — کلید: نام فیلد
  final Map<String, String?> _errors = {
    'letterNumber': null,
    'subject': null,
    'organization': null,
    'recipient': null,
    'signer': null,
    'actionBy': null,
    'registrationNumber': null,
    'archiveFolder': null,
  };

  String selectedPriority = 'عادی';
  String selectedSendMethod = 'ایمیل';

  List<String> tags = [];
  final _tagInputController = TextEditingController();
  bool _isTagHovered = false;
  bool _isTagFocused = false;

  bool _isSwitchOn = false;
  bool _isFileSwitchOn = false;
  String? _selectedFilePath;

  // ============================================================
  // پیوست‌ها (اسکن سند / افزودن پیوست)
  // ============================================================
  final List<AttachedItem> _attachedItems = [];

  // اندازه‌ی A4 تقریبی به پیکسل (در ۹۶ dpi) و یک‌چهارمِ اون برای پیش‌نمایش
  static const double _a4Width = 793.7;
  static const double _a4Height = 1122.5;
  static const double _thumbnailWidth = _a4Width / 4; // ~198
  static const double _thumbnailHeight = _a4Height / 4; // ~280

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
    registrationNumberController.dispose();
    archiveFolderController.dispose();
    _tagInputController.dispose();
    _fnLetterNumber.dispose();
    _fnSubject.dispose();
    _fnOrganization.dispose();
    _fnRecipient.dispose();
    _fnSigner.dispose();
    _fnActionBy.dispose();
    _fnRegistrationNumber.dispose();
    _fnArchiveFolder.dispose();
    _fnPriority.dispose();
    _fnSendMethod.dispose();
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

  Color _getTagFillColor() {
    if (_isTagFocused) return const Color(0xFF3863A8);
    if (_isTagHovered) return const Color(0xFFBBBBC0);
    return const Color(0xFF828288);
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
        // سوییچ فقط بعد از انتخاب موفق مسیر ذخیره‌سازی روشن می‌شود
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

  // ============================================================
  // + افزودن پیوست: باز کردن دیالوگ انتخاب فایل و اضافه کردن به لیست
  // ============================================================
  Future<void> _pickAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
        withData: true, // برای در دسترس بودن بایت‌های فایل (مثلاً روی وب)
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

  // ============================================================
  // اسکن سند: نقطه‌ی اتصال به اسکنر/پرینتر
  //
  // توجه مهم: اتصال مستقیم به یک اسکنر فیزیکی از طریق درایور سیستم‌عامل
  // (مثل WIA در ویندوز یا SANE در لینوکس) بخشی از Flutter استاندارد نیست
  // و نیازمند یک پکیج/پلاگین نیتیو مخصوص همون پلتفرمه. این متد فقط محل
  // اتصال (hook) رو آماده کرده؛ وقتی نتیجه‌ی اسکن به‌صورت بایت تصویر آماده
  // شد، کافیه _onScanComplete رو با اون بایت‌ها صدا بزنی تا دقیقاً مثل یک
  // پیوست معمولی به لیست اضافه بشه.
  // ============================================================
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

  // بعد از این‌که نتیجه‌ی اسکن (بایت تصویر) از درایور/پکیج اسکنر رسید،
  // این متد رو با اون بایت‌ها صدا بزن.
  // ignore: unused_element
  void _onScanComplete(Uint8List imageBytes, String fileName) {
    setState(() => _attachedItems.add(AttachedItem(name: fileName, bytes: imageBytes)));
  }

  void _removeAttachedItem(int index) {
    setState(() => _attachedItems.removeAt(index));
  }

  // ============================================================
  // اعتبارسنجی فرم — همه‌ی فیلدهای اجباری را بررسی می‌کند
  // ============================================================
  bool _validateForm() {
    final newErrors = <String, String?>{
      'letterNumber':       letterNumberController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
      'subject':            subjectController.text.trim().isEmpty      ? 'لطفا این فیلد را پر کنید' : null,
      'organization':       organizationController.text.trim().isEmpty  ? 'لطفا این فیلد را پر کنید' : null,
      'recipient':          recipientController.text.trim().isEmpty     ? 'لطفا این فیلد را پر کنید' : null,
      'signer':             signerController.text.trim().isEmpty        ? 'لطفا این فیلد را پر کنید' : null,
      'actionBy':           actionByController.text.trim().isEmpty      ? 'لطفا این فیلد را پر کنید' : null,
      'registrationNumber': registrationNumberController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
      'archiveFolder':      archiveFolderController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
    };
    setState(() => _errors.addAll(newErrors));
    return newErrors.values.every((e) => e == null);
  }

  // ============================================================
  // منطق دکمه‌های نهایی فرم
  // ============================================================
  void _submitForm() {
    if (!_validateForm()) return;

    // بعد از ثبت، سوییچ «نیاز به پیگیری» روشن می‌شود و مودال پیگیری باز می‌شود
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

    return Container(
      width: _thumbnailWidth,
      height: _thumbnailHeight,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBBBBC0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
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
            child: GestureDetector(
              onTap: () => _removeAttachedItem(index),
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(color: Color(0xFFA85838), shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 16, color: Color(0xFFF3F3F7)),
              ),
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
            children: List.generate(
              _attachedItems.length,
              (i) => _buildThumbnail(_attachedItems[i], i),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SecondaryButton(
              label: 'اسکن سند',
              icon: Icons.print_outlined,
              onPressed: _scanDocument,
            ),
            const SizedBox(width: 16),
            SecondaryButton(
              label: '+ افزودن پیوست',
              onPressed: _pickAttachment,
            ),
          ],
        ),
        // فاصله‌ی ۶۴ پیکسلی زیر دکمه‌های ثانویه (اسکن/پیوست) تا دکمه‌های نهایی فرم
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF101018),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Estedad',
            ),
          ),
        ),
        HoverTextField(
          controller: controller,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          errorText: errorKey != null ? _errors[errorKey] : null,
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
                  Container(
                    width: 1440,
                    height: 80,
                    color: const Color(0xFFBBBBC0),
                    alignment: Alignment.center,
                    child: const Text(
                      'ثبت نامه صادره',
                      style: TextStyle(
                        color: Color(0xFF101018),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Estedad',
                      ),
                    ),
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
                          isReadOnly: true, // غیرفعال (فقط نمایش)
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
                        // بخش تگ‌ها
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionLabel('کلمات کلیدی:'),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MouseRegion(
                                  onEnter: (_) => setState(() => _isTagHovered = true),
                                  onExit: (_) => setState(() => _isTagHovered = false),
                                  child: Focus(
                                    onFocusChange: (hasFocus) => setState(() => _isTagFocused = hasFocus),
                                    child: SizedBox(
                                      width: 548,
                                      height: 64,
                                      child: TextField(
                                        controller: _tagInputController,
                                        style: const TextStyle(
                                          color: Color(0xFFF3F3F7),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Estedad',
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: _getTagFillColor(),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                          suffixIcon: IconButton(
                                            icon: const Icon(Icons.add_circle_outline, color: Color(0xFFF3F3F7)),
                                            onPressed: _addTag,
                                          ),
                                        ),
                                        onSubmitted: (_) => _addTag(),
                                      ),
                                    ),
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
                          'گیرنده نامه:',
                          recipientController,
                          focusNode: _fnRecipient,
                          nextFocusNode: _fnSigner,
                          errorKey: 'recipient',
                        ),
                        const SizedBox(height: 32),
                        _buildFormRow(
                          'امضا کننده:',
                          signerController,
                          focusNode: _fnSigner,
                          nextFocusNode: _fnActionBy,
                          errorKey: 'signer',
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
                          'شماره ثبت دبیرخانه:',
                          registrationNumberController,
                          focusNode: _fnRegistrationNumber,
                          nextFocusNode: _fnArchiveFolder,
                          errorKey: 'registrationNumber',
                        ),
                        const SizedBox(height: 32),
                        SmartDateField(controller: registrationDateController, label: 'تاریخ ثبت:'),
                        const SizedBox(height: 32),
                        _buildFormRow(
                          'پوشه بایگانی:',
                          archiveFolderController,
                          focusNode: _fnArchiveFolder,
                          nextFocusNode: _fnPriority,
                          errorKey: 'archiveFolder',
                        ),
                        const SizedBox(height: 32),
                        // اولویت
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildSectionLabel('اولویت:'),
                            HoverDropdownField(
                              value: selectedPriority,
                              items: const ['عادی', 'فوری'],
                              focusNode: _fnPriority,
                              nextFocusNode: _fnSendMethod,
                              itemIndicatorColors: const {'فوری': Color(0xFFA85838)},
                              onChanged: (value) => setState(() => selectedPriority = value),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // نحوه ارسال
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildSectionLabel('نحوه ارسال:'),
                            HoverDropdownField(
                              value: selectedSendMethod,
                              items: const ['ایمیل', 'فکس', 'حضوری'],
                              focusNode: _fnSendMethod,
                              onChanged: (value) => setState(() => selectedSendMethod = value),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // سوئیچ نیاز به پیگیری
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildSectionLabel('نیاز به پیگیری:'),
                            CustomSwitch(
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
                                CustomSwitch(
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

                  // === پنل اسکن/پیوست + دکمه‌های نهایی: زیر فرم و وسط صفحه ===
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

class HoverTextField extends StatefulWidget {
  final TextEditingController controller;
  final double width;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final String? errorText;

  const HoverTextField({
    super.key,
    required this.controller,
    this.width = 548,
    this.focusNode,
    this.nextFocusNode,
    this.errorText,
  });

  @override
  State<HoverTextField> createState() => _HoverTextFieldState();
}

class _HoverTextFieldState extends State<HoverTextField> {
  bool isHovered = false;
  bool isFocused = false;
  static const int maxChars = 55;

  void _onControllerChanged() => setState(() {});

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
    widget.focusNode?.addListener(_onFocusChanged);
  }

  void _onFocusChanged() => setState(() => isFocused = widget.focusNode?.hasFocus ?? false);

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    widget.focusNode?.removeListener(_onFocusChanged);
    super.dispose();
  }

  Color _getFillColor() {
    if (isFocused) return const Color(0xFF3863A8);
    if (isHovered) return const Color(0xFFBBBBC0);
    return const Color(0xFF828288);
  }

  @override
  Widget build(BuildContext context) {
    final bool limitReached = widget.controller.text.length >= maxChars;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: SizedBox(
            width: widget.width,
            height: 64,
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              maxLength: maxChars,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textInputAction: widget.nextFocusNode != null
                  ? TextInputAction.next
                  : TextInputAction.done,
              onSubmitted: (_) {
                if (widget.nextFocusNode != null) {
                  FocusScope.of(context).requestFocus(widget.nextFocusNode);
                }
              },
              style: const TextStyle(
                color: Color(0xFFF3F3F7),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Estedad',
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: _getFillColor(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                counterText: '',
              ),
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                color: Color(0xFFA85838),
                fontSize: 12,
                fontFamily: 'Estedad',
              ),
            ),
          )
        else if (limitReached)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'حداکثر 55 کاراکتر مجاز است',
              style: TextStyle(color: Color(0xFFA85838), fontSize: 12, fontFamily: 'Estedad'),
            ),
          ),
      ],
    );
  }
}

class HoverDropdownField extends StatefulWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  // نگاشت اختیاری «متن آیتم -> رنگ دایره‌ی نشانگر». مثلاً برای نمایش
  // یک دایره‌ی قرمز کنار آیتم «فوری»: {'فوری': Color(0xFFA85838)}
  final Map<String, Color>? itemIndicatorColors;

  const HoverDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.focusNode,
    this.nextFocusNode,
    this.itemIndicatorColors,
  });

  @override
  State<HoverDropdownField> createState() => _HoverDropdownFieldState();
}

class _HoverDropdownFieldState extends State<HoverDropdownField> {
  bool _isHovered = false;
  late final FocusNode _keyboardFocusNode;

  @override
  void initState() {
    super.initState();
    _keyboardFocusNode = FocusNode(skipTraversal: true);
  }

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: KeyboardListener(
        focusNode: _keyboardFocusNode,
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter &&
              widget.nextFocusNode != null) {
            widget.nextFocusNode!.requestFocus();
          }
        },
        child: SizedBox(
          width: 216,
          height: 64,
          // نکته‌ی اصلیِ فیکس باگ «دو بار کلیک»:
          // قبلاً یک TextEditingController جدا به DropdownMenu داده می‌شد و
          // هم‌زمان initialSelection هم ست شده بود. وقتی این دو با رندر
          // بیرونی (بعد از setState والد) درست هم‌گام نبودن، اولین کلیک فقط
          // ایندکس داخلی ویجت رو عوض می‌کرد ولی متنِ نمایش داده‌شده به‌روز
          // نمی‌شد، و کاربر مجبور بود دوباره کلیک کنه تا واقعاً هماهنگ بشه.
          // با حذف کنترلر دستی و دادن یک key بر پایه‌ی مقدار فعلی، هر بار که
          // value از بیرون عوض بشه، DropdownMenu کاملاً از نو با
          // initialSelection جدید ساخته می‌شه و از همون کلیک اول درست کار
          // می‌کنه.
          child: DropdownMenu<String>(
            key: ValueKey(widget.value),
            focusNode: widget.focusNode,
            initialSelection: widget.value,
            enableFilter: true,
            enableSearch: true,
            width: 216,
            textStyle: const TextStyle(
              color: Color(0xFFF3F3F7),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Estedad',
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: _isHovered
                  ? const Color(0xFFBBBBC0)
                  : const Color(0xFF828288),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            dropdownMenuEntries: widget.items.map((item) {
              final indicatorColor = widget.itemIndicatorColors?[item];
              return DropdownMenuEntry<String>(
                value: item,
                label: item,
                // چون کل درخت به‌صورت RTL هست، leadingIcon سمت راست آیتم
                // (طرفِ شروع/start) نمایش داده می‌شه.
                leadingIcon: indicatorColor != null
                    ? Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: indicatorColor,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              );
            }).toList(),
            onSelected: (value) {
              if (value != null) {
                widget.onChanged(value);
                widget.nextFocusNode?.requestFocus();
              }
            },
          ),
        ),
      ),
    );
  }
}