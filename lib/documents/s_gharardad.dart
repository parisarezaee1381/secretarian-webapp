import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import '../document_repository.dart'; 

import '../widgets.dart/smart_date_field.dart';
import '../widgets.dart/letter_number_generator.dart';
import '../attachments.dart/attached_item.dart';
import '../attachments.dart/attachments_panel.dart';

import 'package:flutter_application_1/documents.dart';
import 'package:flutter_application_1/documents/m_gharardad.dart';

import '../widgets.dart/switch_button.dart';
import '../widgets.dart/buttons.dart';
import '../widgets.dart/text_input.dart';
import '../widgets.dart/header.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

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

  final _fnSubject = FocusNode();
  final _fnOrganization = FocusNode();
  final _fnRecipient = FocusNode();
  final _fnActionBy = FocusNode();
  final _fnRegistrationNumber = FocusNode();
  final _fnArchiveFolder = FocusNode();

  final Map<String, String?> _errors = {
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

  List<AttachedItem> _currentAttachments = [];

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
  Future<void> _pickPdfSavePath() async {
  try {
    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'محل ذخیره PDF را انتخاب کنید',
      fileName: '${letterNumberController.text.trim()}.pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        _selectedFilePath = result;
        _isFileSwitchOn = true;
      });
    } else {
      setState(() {
        _isFileSwitchOn = false;
        _selectedFilePath = null;
      });
    }
  } catch (e) {
    if (!mounted) return;

    setState(() {
      _isFileSwitchOn = false;
      _selectedFilePath = null;
    });
  }
 }

  bool _validateForm() {
    final newErrors = <String, String?>{
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
    date: dateController.text,
    subject: subjectController.text.trim(),
    tags: List<String>.from(tags),

    organization: organizationController.text.trim(),
    recipient: recipientController.text.trim(),
    actionBy: actionByController.text.trim(),

    contractSubject: registrationNumberController.text.trim(),
    registrationDate: registrationDateController.text,
    referenceContractNumber: archiveFolderController.text.trim(),

    saveFile: _isFileSwitchOn,
    filePath: _selectedFilePath,

    attachments: _currentAttachments.map((item) {
      return AttachmentDocument(
        name: item.name,
        path: item.path,
        bytes: item.bytes,
      );
    }).toList(),
  );
  DocumentRepository.instance.addContract(document);

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
                    title: 'ثبت قرارداد',
                    leading: HeaderLeading.back,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 32, top: 64),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LetterNumberField(
  controller: letterNumberController,
  type: LetterNumberType.contract,
),
const SizedBox(height: 32),
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
                                      await _pickPdfSavePath();
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