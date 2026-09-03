import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/widgets.dart/pdf_document.dart';
import 'package:flutter_application_1/widgets.dart/pdf_save.dart';
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
  const ContractFormPage({super.key, this.initialDocument});

  final ContractDocument? initialDocument;

  @override
  State<ContractFormPage> createState() => _ContractFormPageState();
}

class _ContractFormPageState extends State<ContractFormPage> {
  // ============================================================
  // Controllers
  // ============================================================

  final letterNumberController = TextEditingController();
  final dateController = TextEditingController();
  final registrationDateController = TextEditingController();
  final subjectController = TextEditingController();
  final organizationController = TextEditingController();
  final recipientController = TextEditingController();
  final actionByController = TextEditingController();
  final registrationNumberController = TextEditingController();
  final archiveFolderController = TextEditingController();

  // ============================================================
  // Focus Nodes
  // ============================================================

  final _fnSubject = FocusNode();
  final _fnOrganization = FocusNode();
  final _fnRecipient = FocusNode();
  final _fnActionBy = FocusNode();
  final _fnRegistrationNumber = FocusNode();
  final _fnArchiveFolder = FocusNode();

  // ============================================================
  // Validation
  // ============================================================

  final Map<String, String?> _errors = {
    'subject': null,
    'organization': null,
    'recipient': null,
    'actionBy': null,
    'registrationNumber': null,
    'archiveFolder': null,
  };

  // ============================================================
  // Tags
  // ============================================================

  List<String> tags = [];
  final _tagInputController = TextEditingController();

  // ============================================================
  // File
  // ============================================================

  bool _isFileSwitchOn = false;
  String? _selectedFilePath;

  // ============================================================
  // Attachments
  // ============================================================

  List<AttachedItem> _currentAttachments = [];

  // ============================================================
  // Responsive constants
  // ============================================================

  static const double _desktopContentWidth = 900;
  static const double _fieldWidth = 548;
  static const double _labelWidth = 150;
  static const double _mobileBreakpoint = 700;

  // ============================================================
  // Init
  // ============================================================

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
      actionByController.text = doc.actionBy;

      registrationNumberController.text = doc.contractSubject;
      archiveFolderController.text = doc.referenceContractNumber;

      tags = List<String>.from(doc.tags);

      _isFileSwitchOn = doc.saveFile;
      _selectedFilePath = doc.filePath;
    }
  }

  // ============================================================
  // Dispose
  // ============================================================

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

  // ============================================================
  // Tags
  // ============================================================

  void _addTag() {
    final text = _tagInputController.text.trim();

    if (text.isEmpty) {
      return;
    }

    setState(() {
      tags.add(text);
      _tagInputController.clear();
    });
  }

  void _removeTag(int index) {
    setState(() {
      tags.removeAt(index);
    });
  }

  // ============================================================
  // Validation
  // ============================================================

  bool _validateForm() {
    final newErrors = <String, String?>{
      'subject': subjectController.text.trim().isEmpty
          ? 'لطفا این فیلد را پر کنید'
          : null,
      'organization': organizationController.text.trim().isEmpty
          ? 'لطفا این فیلد را پر کنید'
          : null,
      'recipient': recipientController.text.trim().isEmpty
          ? 'لطفا این فیلد را پر کنید'
          : null,
      'actionBy': actionByController.text.trim().isEmpty
          ? 'لطفا این فیلد را پر کنید'
          : null,
      'registrationNumber': registrationNumberController.text.trim().isEmpty
          ? 'لطفا این فیلد را پر کنید'
          : null,
      'archiveFolder': archiveFolderController.text.trim().isEmpty
          ? 'لطفا این فیلد را پر کنید'
          : null,
    };

    setState(() {
      _errors.addAll(newErrors);
    });

    return newErrors.values.every((error) => error == null);
  }

  // ============================================================
  // Submit
  // ============================================================

  Future<void> _submitForm() async {
    if (!_validateForm()) {
      return;
    }

    String? pdfPath;
    bool pdfSaved = false;

    try {
      // ========================================================
      // 1. ساخت Contract اولیه
      // ========================================================

      final document = ContractDocument(
        id:
            widget.initialDocument?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),

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
        filePath: null,

        attachments: _currentAttachments.map((item) {
          return AttachmentDocument(
            name: item.name,
            path: item.path,
            bytes: item.bytes,
          );
        }).toList(),
      );

      // ========================================================
      // 2. ذخیره PDF
      // ========================================================

      if (_isFileSwitchOn) {
        final pdfData = PdfDocumentData.fromContract(document);

        final suggestedName = document.letterNumber.trim().isNotEmpty
            ? '${document.letterNumber.trim()}.pdf'
            : 'قرارداد.pdf';

        pdfPath = await SavePdfWidget.chooseSavePath(
          suggestedFileName: suggestedName,
        );

        if (pdfPath != null) {
          await SavePdfWidget.savePdf(document: pdfData, path: pdfPath);

          pdfSaved = true;
        }
      }

      // ========================================================
      // 3. Document نهایی
      // ========================================================

      final finalDocument = ContractDocument(
        id: document.id,

        letterNumber: document.letterNumber,
        date: document.date,
        subject: document.subject,
        tags: document.tags,

        organization: document.organization,
        recipient: document.recipient,
        actionBy: document.actionBy,

        contractSubject: document.contractSubject,
        registrationDate: document.registrationDate,
        referenceContractNumber: document.referenceContractNumber,

        saveFile: pdfSaved,
        filePath: pdfPath,

        attachments: document.attachments,
      );

      // ========================================================
      // 4. Repository
      // ========================================================

      if (widget.initialDocument != null) {
        await DocumentRepository.instance.updateContract(
          widget.initialDocument!.id,
          finalDocument,
        );
      } else {
        await DocumentRepository.instance.addContract(finalDocument);
      }

      // ========================================================
      // 5. Success message
      // ========================================================

      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            pdfSaved
                ? 'قرارداد و PDF با موفقیت ذخیره شدند'
                : 'قرارداد با موفقیت ذخیره شد',
          ),
          backgroundColor: const Color(0xFF3863A8),
        ),
      );

      // ========================================================
      // 6. View page
      // ========================================================

      if (!mounted) {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContractViewPage(document: finalDocument),
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('SUBMIT CONTRACT ERROR: $e');
      debugPrint('$stackTrace');

      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('خطا در ذخیره قرارداد: $e'),
          backgroundColor: const Color(0xFFA85838),
        ),
      );
    }
  }

  // ============================================================
  // Cancel
  // ============================================================

  void _cancelForm() {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Text('عملیات لغو شد'),
        backgroundColor: Color(0xFF828288),
      ),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  // ============================================================
  // Responsive field
  // ============================================================

  Widget _buildFormRow(
    String label,
    TextEditingController controller, {
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    String? errorKey,
    required bool compact,
  }) {
    final errorText = errorKey != null ? _errors[errorKey] : null;

    final showLimitWarning = errorText == null && controller.text.length >= 55;

    final field = AppTextField(
      controller: controller,
      focusNode: focusNode,
      labelText: compact ? null : label,
      labelWidth: compact ? 0 : _labelWidth,
      labelSpacing: compact ? 0 : 0,
      width: compact ? double.infinity : _fieldWidth,
      height: 64,
      textInputAction: nextFocusNode != null
          ? TextInputAction.next
          : TextInputAction.done,
      inputFormatters: [LengthLimitingTextInputFormatter(55)],
      errorText: errorText,
      onChanged: (_) {
        setState(() {});
      },
      onSubmitted: (_) {
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
    );

    if (!compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          field,

          if (errorText != null || showLimitWarning)
            Padding(
              padding: const EdgeInsets.only(top: 4, right: _labelWidth),
              child: Text(
                errorText ?? 'حداکثر 55 کاراکتر مجاز است',
                style: const TextStyle(
                  color: Color(0xFFA85838),
                  fontSize: 12,
                  fontFamily: 'Estedad',
                ),
              ),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMobileLabel(label),
        const SizedBox(height: 8),
        field,

        if (errorText != null || showLimitWarning)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText ?? 'حداکثر 55 کاراکتر مجاز است',
              style: const TextStyle(
                color: Color(0xFFA85838),
                fontSize: 12,
                fontFamily: 'Estedad',
              ),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // Section label
  // ============================================================

  Widget _buildSectionLabel(
    String text, {
    required bool compact,
    double width = _labelWidth,
  }) {
    if (compact) {
      return _buildMobileLabel(text);
    }

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

  Widget _buildMobileLabel(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: const TextStyle(
          color: Color(0xFF101018),
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: 'Estedad',
        ),
      ),
    );
  }

  // ============================================================
  // Letter number + date
  // ============================================================

  Widget _buildTopFields({required bool compact}) {
    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMobileLabel('شماره قرارداد:'),
          const SizedBox(height: 8),

          LetterNumberField(
            controller: letterNumberController,
            type: LetterNumberType.contract,
          ),

          const SizedBox(height: 24),

          _buildMobileLabel('تاریخ:'),
          const SizedBox(height: 8),

          SmartDateField(
            controller: dateController,
            label: '',
            isReadOnly: true,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LetterNumberField(
          controller: letterNumberController,
          type: LetterNumberType.contract,
        ),

        const SizedBox(height: 32),

        SmartDateField(
          controller: dateController,
          label: 'تاریخ:',
          isReadOnly: true,
        ),
      ],
    );
  }

  // ============================================================
  // Tags
  // ============================================================

  Widget _buildTagsSection({required bool compact}) {
    final input = AppTextField(
      controller: _tagInputController,
      width: compact ? double.infinity : _fieldWidth,
      height: 64,
      onSubmitted: (_) => _addTag(),
      suffixIcon: IconButton(
        icon: const Icon(Icons.add_circle_outline, color: Color(0xFFF3F3F7)),
        onPressed: _addTag,
      ),
    );

    final tagsWidget = SizedBox(
      width: compact ? double.infinity : _fieldWidth,
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
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Color(0xFFF3F3F7),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMobileLabel('کلمات کلیدی:'),
          const SizedBox(height: 8),
          input,
          const SizedBox(height: 12),
          tagsWidget,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('کلمات کلیدی:', compact: false),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [input, const SizedBox(height: 12), tagsWidget],
        ),
      ],
    );
  }

  // ============================================================
  // Divider
  // ============================================================

  Widget _buildDivider({required bool compact}) {
    return Column(
      children: [
        SizedBox(height: compact ? 28 : 32),

        Container(
          width: double.infinity,
          height: 1,
          color: const Color(0xFF828288),
        ),

        SizedBox(height: compact ? 40 : 64),
      ],
    );
  }

  // ============================================================
  // File section
  // ============================================================

  Widget _buildFileSection({required bool compact}) {
    final switchWidget = AppSwitch(
      value: _isFileSwitchOn,
      onChanged: (value) {
        setState(() {
          _isFileSwitchOn = value;
        });
      },
    );

    final filePathWidget = _selectedFilePath == null
        ? null
        : Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF3863A8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _selectedFilePath!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  color: Color(0xFFF3F3F7),
                  fontSize: 14,
                  fontFamily: 'Estedad',
                ),
              ),
            ),
          );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMobileLabel('ذخیره فایل:'),
          const SizedBox(height: 8),

          Row(
            children: [
              switchWidget,

              if (filePathWidget != null) ...[
                const SizedBox(width: 16),
                filePathWidget,
              ],
            ],
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildSectionLabel('ذخیره فایل:', compact: false),

        Row(
          children: [
            switchWidget,

            if (filePathWidget != null) ...[
              const SizedBox(width: 16),
              filePathWidget,
            ],
          ],
        ),
      ],
    );
  }

  // ============================================================
  // Attachments
  // ============================================================

  Widget _buildAttachmentsPanel({required bool compact}) {
    final buttons = compact
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomButton(
                label: 'ثبت',
                type: ButtonType.primary,
                width: double.infinity,
                onPressed: _submitForm,
              ),
              const SizedBox(height: 16),
              CustomButton(
                label: 'انصراف',
                type: ButtonType.tertiary,
                width: double.infinity,
                onPressed: _cancelForm,
              ),
            ],
          )
        : Row(
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
          );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: compact
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.center,
      children: [
        AttachmentsPanel(
          onChanged: (items) {
            _currentAttachments = items;
          },
        ),

        const SizedBox(height: 48),

        buttons,
      ],
    );
  }

  // ============================================================
  // Main form
  // ============================================================

  Widget _buildForm({required bool compact}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTopFields(compact: compact),

        const SizedBox(height: 32),

        _buildFormRow(
          'عنوان/خلاصه نامه:',
          subjectController,
          focusNode: _fnSubject,
          nextFocusNode: _fnOrganization,
          errorKey: 'subject',
          compact: compact,
        ),

        const SizedBox(height: 32),

        _buildTagsSection(compact: compact),

        _buildDivider(compact: compact),

        _buildFormRow(
          'شرکت طرف قرارداد:',
          organizationController,
          focusNode: _fnOrganization,
          nextFocusNode: _fnRecipient,
          errorKey: 'organization',
          compact: compact,
        ),

        const SizedBox(height: 32),

        _buildFormRow(
          'شخص طرف قرارداد:',
          recipientController,
          focusNode: _fnRecipient,
          nextFocusNode: _fnActionBy,
          errorKey: 'recipient',
          compact: compact,
        ),

        const SizedBox(height: 32),

        _buildFormRow(
          'اقدام کننده:',
          actionByController,
          focusNode: _fnActionBy,
          nextFocusNode: _fnRegistrationNumber,
          errorKey: 'actionBy',
          compact: compact,
        ),

        _buildDivider(compact: compact),

        _buildFormRow(
          'موضوع قرارداد:',
          registrationNumberController,
          focusNode: _fnRegistrationNumber,
          nextFocusNode: _fnArchiveFolder,
          errorKey: 'registrationNumber',
          compact: compact,
        ),

        const SizedBox(height: 32),

        _buildRegistrationDate(compact: compact),

        const SizedBox(height: 32),

        _buildFormRow(
          'شماره قرارداد مرجع:',
          archiveFolderController,
          focusNode: _fnArchiveFolder,
          errorKey: 'archiveFolder',
          compact: compact,
        ),

        const SizedBox(height: 32),

        _buildFileSection(compact: compact),
      ],
    );
  }

  // ============================================================
  // Registration date
  // ============================================================

  Widget _buildRegistrationDate({required bool compact}) {
    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMobileLabel('تاریخ ثبت:'),
          const SizedBox(height: 8),
          SmartDateField(controller: registrationDateController, label: ''),
        ],
      );
    }

    return SmartDateField(
      controller: registrationDateController,
      label: 'تاریخ ثبت:',
    );
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3F7),

        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;

              final compact = screenWidth < _mobileBreakpoint;

              final horizontalPadding = compact
                  ? 16.0
                  : screenWidth < 1000
                  ? 24.0
                  : 32.0;

              return Column(
                children: [
                  // ==================================================
                  // Header
                  // ==================================================

                  const AppHeader(
                    title: 'ثبت قرارداد',
                    leading: HeaderLeading.back,
                  ),

                  // ==================================================
                  // Scrollable content
                  // ==================================================
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: horizontalPadding,
                        right: horizontalPadding,
                        top: compact ? 32 : 64,
                        bottom: 64,
                      ),

                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: _desktopContentWidth,
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,

                            children: [
                              // ==================================================
                              // Form
                              // ==================================================

                              _buildForm(compact: compact),

                              // ==================================================
                              // Attachments
                              // ==================================================
                              SizedBox(height: compact ? 40 : 48),

                              _buildAttachmentsPanel(compact: compact),

                              SizedBox(height: compact ? 40 : 64),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Contract Data
// ============================================================================

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
