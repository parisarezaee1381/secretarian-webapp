
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/documents.dart';
import 'package:flutter_application_1/widgets.dart/pdf_save.dart';
import '../document_repository.dart'; 

import '../widgets.dart/smart_date_field.dart';
import '../widgets.dart/modal.dart';
import '../widgets.dart/letter_number_generator.dart';
import '../attachments.dart/attached_item.dart';
import '../attachments.dart/attachments_panel.dart';
import 'package:flutter_application_1/documents/m_sadere.dart';

import '../widgets.dart/switch_button.dart';
import '../widgets.dart/buttons.dart';
import '../widgets.dart/text_input.dart';
import '../widgets.dart/dropdown_menu.dart';
import '../widgets.dart/header.dart';

import 'package:flutter_application_1/widgets.dart/pdf_document.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class OutgoingLetterFormPage extends StatefulWidget {
  const OutgoingLetterFormPage({super.key, this.initialDocument});

  final OutgoingLetterDocument? initialDocument;

  @override
  State<OutgoingLetterFormPage> createState() => _OutgoingLetterFormPageState();
}

class _OutgoingLetterFormPageState extends State<OutgoingLetterFormPage> {
  String? _followUpDate;
  String? _followUpBy;
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

  @override
void initState() {
  super.initState();
  final doc = widget.initialDocument;
  if (doc != null) {
    letterNumberController.text = doc.letterNumber;
    dateController.text = doc.date;
    registrationDateController.text = doc.registrationDate;
    subjectController.text = doc.subject;
    organizationController.text = doc.organization;
    recipientController.text = doc.recipient;
    signerController.text = doc.signer;
    actionByController.text = doc.actionBy;
    registrationNumberController.text = doc.registrationNumber;
    archiveFolderController.text = doc.archiveFolder;
    tags = List<String>.from(doc.tags);
    selectedPriority = doc.priority;
    selectedSendMethod = doc.sendMethod;
    _isSwitchOn = doc.needsFollowUp;
    _followUpDate = doc.followUpDate;
    _followUpBy = doc.followUpBy;
    _isFileSwitchOn = doc.saveFile;
  }
}

  final _fnSubject = FocusNode();
  final _fnOrganization = FocusNode();
  final _fnRecipient = FocusNode();
  final _fnSigner = FocusNode();
  final _fnActionBy = FocusNode();
  final _fnRegistrationNumber = FocusNode();
  final _fnArchiveFolder = FocusNode();

  final Map<String, String?> _errors = {
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

  bool _isSwitchOn = false;
  bool _isFileSwitchOn = false;

  List<AttachedItem> _currentAttachments = [];

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
    _fnSubject.dispose();
    _fnOrganization.dispose();
    _fnRecipient.dispose();
    _fnSigner.dispose();
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
    setState(() => tags.removeAt(index));
  }

void _showModal() {
  showDialog(
    context: context,
    builder: (context) => const CustomModal(),
  ).then((result) {
    if (result != null) {
      setState(() {
        _followUpDate = (result['date']); // تغییر همینجا
        _followUpBy = result['followUpBy'];
        _isSwitchOn = true;
      });
    }
  });
}



  bool _validateForm() {
    final newErrors = <String, String?>{
      'subject': subjectController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
      'organization': organizationController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
      'recipient': recipientController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
      'signer': signerController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
      'actionBy': actionByController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
      'registrationNumber': registrationNumberController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
      'archiveFolder': archiveFolderController.text.trim().isEmpty ? 'لطفا این فیلد را پر کنید' : null,
    };
    setState(() => _errors.addAll(newErrors));
    return newErrors.values.every((e) => e == null);
  }

Future<void> _submitForm() async {
  if (!_validateForm()) return;

  // مسیر نهایی PDF
  String? pdfPath;

  // =====================================================
  // 1. اگر سوییچ ذخیره فایل روشن است، پوشه را انتخاب کن
  // =====================================================

  if (_isFileSwitchOn) {
    final pdfData = PdfDocumentData(
      type: PdfDocumentType.outgoing,
      letterNumber: letterNumberController.text.trim(),
      date: dateController.text,
      subject: subjectController.text.trim(),
      tags: List<String>.from(tags),
      organization: organizationController.text.trim(),
      recipient: recipientController.text.trim(),
      registrationDate: registrationDateController.text,
      signer: signerController.text.trim(),
      outgoingActionBy: actionByController.text.trim(),
      sendMethod: selectedSendMethod,
      archiveFolder: archiveFolderController.text.trim(),
      priority: selectedPriority,
      needsFollowUp: _isSwitchOn,
      followUpDate: _followUpDate,
      followUpBy: _followUpBy,
    );

    // فقط پوشه را از کاربر می‌گیرد
    final selectedFolder =
        await SavePdfWidget.chooseSaveFolder();

    // اگر کاربر Cancel کرد
    if (selectedFolder == null) {
      return;
    }

    // ساخت مسیر کامل فایل PDF
    pdfPath = SavePdfWidget.buildFilePath(
      folderPath: selectedFolder,
      document: pdfData,
      suggestedFileName: letterNumberController.text.trim(),
    );
  }

  // =====================================================
  // 2. ساخت Document اصلی
  // =====================================================

  final document = OutgoingLetterDocument(
    id: widget.initialDocument?.id ??
        DateTime.now().microsecondsSinceEpoch.toString(),

    letterNumber: letterNumberController.text.trim(),
    date: dateController.text,
    subject: subjectController.text.trim(),
    tags: List<String>.from(tags),

    organization: organizationController.text.trim(),
    recipient: recipientController.text.trim(),
    signer: signerController.text.trim(),
    actionBy: actionByController.text.trim(),

    registrationNumber: registrationNumberController.text.trim(),
    registrationDate: registrationDateController.text,
    archiveFolder: archiveFolderController.text.trim(),

    priority: selectedPriority,
    sendMethod: selectedSendMethod,

    needsFollowUp: _isSwitchOn,
    followUpDate: _followUpDate,
    followUpBy: _followUpBy,

    saveFile: _isFileSwitchOn,

    // اگر سوییچ خاموش باشد null است
    // اگر روشن باشد مسیر PDF است
    filePath: pdfPath,

    attachments: _currentAttachments.map((item) {
      return AttachmentDocument(
        name: item.name,
        path: item.path,
        bytes: item.bytes,
      );
    }).toList(),
  );

  // =====================================================
  // 3. ساخت و ذخیره PDF
  // =====================================================

  if (document.saveFile && document.filePath != null) {
    try {
      await SavePdfWidget.savePdf(
        document: PdfDocumentData.fromOutgoing(document),
        path: document.filePath!,
      );

      rootScaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('PDF با موفقیت ذخیره شد'),
          backgroundColor: Color(0xFF3863A8),
        ),
      );
    } catch (e) {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('خطا در ساخت یا ذخیره PDF'),
          backgroundColor: Color(0xFFA85838),
        ),
      );

      return;
    }
  }

  // =====================================================
  // 4. ذخیره Document در Repository
  // =====================================================

  if (widget.initialDocument != null) {
    DocumentRepository.instance.updateOutgoing(
      widget.initialDocument!.id,
      document,
    );
  } else {
    await DocumentRepository.instance.addOutgoing(document);
  }

  // =====================================================
  // 5. رفتن به صفحه نمایش نامه
  // =====================================================

  if (!mounted) return;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => OutgoingLetterViewPage(
        document: document,
      ),
    ),
  );
}

  void _cancelForm() {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(content: Text('عملیات لغو شد'), backgroundColor: Color(0xFF828288)),
    );
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  Widget _buildAttachmentsPanel() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      AttachmentsPanel(
        onChanged: (items) => _currentAttachments = items,
      ),
      const SizedBox(height: 64),
      Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    CustomButton(
      label: 'ثبت',
      type: ButtonType.primary,
      width: 204,
      onPressed: _submitForm,
    ),
    const SizedBox(width: 16),
    CustomButton(
      label: 'انصراف',
      type: ButtonType.tertiary,
      width: 204,
      onPressed: _cancelForm,
    ),
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
                    title: 'ثبت نامه صادره',
                    leading: HeaderLeading.back,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 32, top: 64),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LetterNumberField(
  controller: letterNumberController,
  type: LetterNumberType.outgoing,
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
                        // نحوه ارسال
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildSectionLabel('نحوه ارسال:'),
                            AppDropdown<String>(
                              items: const ['ایمیل', 'فکس', 'حضوری'],
                              value: selectedSendMethod,
                              onChanged: (value) {
                                if (value != null) setState(() => selectedSendMethod = value);
                              },
                              width: 216,
                              height: 64,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // سوئیچ نیاز به پیگیری — حالا مستقیم AppSwitch
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildSectionLabel('نیاز به پیگیری:'),
                            AppSwitch(
  value: _isSwitchOn,
  onChanged: (value) {
    if (value) {
      _showModal();
    } else {
      setState(() {
        _isSwitchOn = false;
        _followUpDate = null;
        _followUpBy = null;
      });
    }
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
  onChanged: (value) {
    setState(() {
      _isFileSwitchOn = value;
    });
  },
),
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

class OutgoingLetterData {
  final String letterNumber;
  final String date;
  final String subject;
  final List<String> tags;
  final String organization;
  final String recipient;
  final String signer;
  final String actionBy;
  final String registrationNumber;
  final String registrationDate;
  final String archiveFolder;
  final String priority;
  final String sendMethod;
  final bool needsFollowUp;
  final String? followUpDate;
  final String? followUpBy;
  final bool saveFile;
  final String? savedFileName;
  final List<AttachedItem> attachments;

  const OutgoingLetterData({
    required this.letterNumber,
    required this.date,
    required this.subject,
    required this.tags,
    required this.organization,
    required this.recipient,
    required this.signer,
    required this.actionBy,
    required this.registrationNumber,
    required this.registrationDate,
    required this.archiveFolder,
    required this.priority,
    required this.sendMethod,
    required this.needsFollowUp,
    this.followUpDate,
    this.followUpBy,
    required this.saveFile,
    this.savedFileName,
    required this.attachments,
  });
}