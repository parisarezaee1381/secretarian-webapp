import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  // ============================================================
  // Follow Up
  // ============================================================

  String? _followUpDate;
  String? _followUpBy;

  // ============================================================
  // Controllers
  // ============================================================

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
  // Focus Nodes
  // ============================================================

  final _fnSubject = FocusNode();
  final _fnOrganization = FocusNode();
  final _fnRecipient = FocusNode();
  final _fnSigner = FocusNode();
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
    'signer': null,
    'actionBy': null,
    'registrationNumber': null,
    'archiveFolder': null,
  };

  // ============================================================
  // Priority / Send Method
  // ============================================================

  String selectedPriority = 'عادی';
  String selectedSendMethod = 'ایمیل';

  // ============================================================
  // Tags
  // ============================================================

  List<String> tags = [];

  final _tagInputController = TextEditingController();

  // ============================================================
  // Switches
  // ============================================================

  bool _isSwitchOn = false;
  bool _isFileSwitchOn = false;

  // ============================================================
  // Attachments
  // ============================================================

  List<AttachedItem> _currentAttachments = [];

  // ============================================================
  // Responsive Constants
  // ============================================================

  static const double _desktopContentWidth = 1440;
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
  // Follow Up Modal
  // ============================================================

  void _showModal() {
    showDialog(
      context: context,
      builder: (context) => const CustomModal(),
    ).then((result) {
      if (result != null) {
        setState(() {
          _followUpDate = result['date'];
          _followUpBy = result['followUpBy'];
          _isSwitchOn = true;
        });
      }
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

      'signer': signerController.text.trim().isEmpty
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
      // 1. ساخت Document اولیه
      // ========================================================

      final document = OutgoingLetterDocument(
        id:
            widget.initialDocument?.id ??
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

        saveFile: false,
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
        final pdfData = PdfDocumentData.fromOutgoing(document);

        final suggestedName = document.letterNumber.trim().isNotEmpty
            ? '${document.letterNumber.trim()}.pdf'
            : 'نامه-صادره.pdf';

        pdfPath = await SavePdfWidget.chooseSavePath(
          suggestedFileName: suggestedName,
        );

        if (pdfPath != null) {
          await SavePdfWidget.savePdf(document: pdfData, path: pdfPath);

          pdfSaved = true;
        }
      }

      // ========================================================
      // 3. ساخت Document نهایی
      // ========================================================

      final finalDocument = OutgoingLetterDocument(
        id: document.id,

        letterNumber: document.letterNumber,
        date: document.date,
        subject: document.subject,
        tags: document.tags,

        organization: document.organization,
        recipient: document.recipient,
        signer: document.signer,
        actionBy: document.actionBy,

        registrationNumber: document.registrationNumber,

        registrationDate: document.registrationDate,

        archiveFolder: document.archiveFolder,

        priority: document.priority,
        sendMethod: document.sendMethod,

        needsFollowUp: document.needsFollowUp,

        followUpDate: document.followUpDate,

        followUpBy: document.followUpBy,

        saveFile: pdfSaved,
        filePath: pdfPath,

        attachments: document.attachments,
      );

      // ========================================================
      // 4. Repository
      // ========================================================

      if (widget.initialDocument != null) {
        await DocumentRepository.instance.updateOutgoing(
          widget.initialDocument!.id,
          finalDocument,
        );
      } else {
        await DocumentRepository.instance.addOutgoing(finalDocument);
      }

      // ========================================================
      // 5. Success Message
      // ========================================================

      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            pdfSaved
                ? 'نامه و PDF با موفقیت ذخیره شدند'
                : 'نامه با موفقیت ذخیره شد',
          ),
          backgroundColor: const Color(0xFF3863A8),
        ),
      );

      // ========================================================
      // 6. View Page
      // ========================================================

      if (!mounted) {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OutgoingLetterViewPage(document: finalDocument),
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('SUBMIT ERROR: $e');
      debugPrint('$stackTrace');

      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('خطا در ذخیره نامه: $e'),
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
  // Mobile Label
  // ============================================================

  Widget _buildMobileLabel(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: const Color(0xFF101018),
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'Estedad',
        ),
      ),
    );
  }

  // ============================================================
  // Form Row
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

      labelWidth: compact ? 0 : _labelWidth.w,

      labelSpacing: 0,

      width: compact ? double.infinity : _fieldWidth.w,

      height: 64.w,

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
              padding: EdgeInsets.only(top: 4.w, right: _labelWidth.w),
              child: Text(
                errorText ?? 'حداکثر 55 کاراکتر مجاز است',
                style: TextStyle(
                  color: const Color(0xFFA85838),
                  fontSize: 12.sp,
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

        SizedBox(height: 8.w),

        field,

        if (errorText != null || showLimitWarning)
          Padding(
            padding: EdgeInsets.only(top: 4.w),
            child: Text(
              errorText ?? 'حداکثر 55 کاراکتر مجاز است',
              style: TextStyle(
                color: const Color(0xFFA85838),
                fontSize: 12.sp,
                fontFamily: 'Estedad',
              ),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // Section Label
  // ============================================================

  Widget _buildSectionLabel(String text, {double width = _labelWidth}) {
    return SizedBox(
      width: width.w,
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF101018),
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'Estedad',
        ),
      ),
    );
  }

  // ============================================================
  // Letter Number + Date
  // مثل ContractFormPage
  // ============================================================

  Widget _buildTopFields({required bool compact}) {
    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMobileLabel('شماره نامه:'),

          SizedBox(height: 8.w),

          LetterNumberField(
            controller: letterNumberController,
            type: LetterNumberType.outgoing,
          ),

          SizedBox(height: 24.w),

          _buildMobileLabel('تاریخ:'),

          SizedBox(height: 8.w),

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
          type: LetterNumberType.outgoing,
        ),

        SizedBox(height: 32.w),

        SmartDateField(
          controller: dateController,
          label: 'تاریخ:',
          isReadOnly: true,
        ),
      ],
    );
  }

  // ============================================================
  // Registration Date
  // دقیقاً مثل ContractFormPage
  // ============================================================

  Widget _buildRegistrationDate({required bool compact}) {
    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMobileLabel('تاریخ ثبت:'),

          SizedBox(height: 8.w),

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
  // Tags
  // ============================================================

  Widget _buildTagsSection({required bool compact}) {
    final input = AppTextField(
      controller: _tagInputController,

      width: compact ? double.infinity : _fieldWidth.w,

      height: 64.w,

      onSubmitted: (_) => _addTag(),

      suffixIcon: IconButton(
        icon: const Icon(Icons.add_circle_outline, color: Color(0xFFF3F3F7)),
        onPressed: _addTag,
      ),
    );

    final tagsWidget = SizedBox(
      width: compact ? double.infinity : _fieldWidth.w,

      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.w,

        children: tags.asMap().entries.map((entry) {
          final index = entry.key;
          final tag = entry.value;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),

            decoration: BoxDecoration(
              color: const Color(0xFF828288),
              borderRadius: BorderRadius.circular(8.r),
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                Text(
                  tag,
                  style: TextStyle(
                    color: const Color(0xFFF3F3F7),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Estedad',
                  ),
                ),

                SizedBox(width: 8.w),

                GestureDetector(
                  onTap: () => _removeTag(index),

                  child: Icon(
                    Icons.close,
                    size: 16.sp,
                    color: const Color(0xFFF3F3F7),
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

          SizedBox(height: 8.w),

          input,

          SizedBox(height: 12.w),

          tagsWidget,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('کلمات کلیدی:'),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            input,

            SizedBox(height: 12.w),

            tagsWidget,
          ],
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
        SizedBox(height: compact ? 28.w : 32.w),

        Container(
          width: double.infinity,
          height: 1,
          color: const Color(0xFF828288),
        ),

        SizedBox(height: compact ? 40.w : 64.w),
      ],
    );
  }

  // ============================================================
  // Dropdown Row
  // ============================================================

  Widget _buildDropdownRow({
    required String label,
    required Widget child,
    required bool compact,
  }) {
    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMobileLabel(label),

          SizedBox(height: 12.w),

          child,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [_buildSectionLabel(label), child],
    );
  }

  // ============================================================
  // Switch Row
  // ============================================================

  Widget _buildSwitchRow({
    required String label,
    required Widget child,
    required bool compact,
  }) {
    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMobileLabel(label),

          SizedBox(height: 12.w),

          child,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [_buildSectionLabel(label), child],
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

              SizedBox(height: 16.w),

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
                width: 204.w,
                onPressed: _submitForm,
              ),

              SizedBox(width: 16.w),

              CustomButton(
                label: 'انصراف',
                type: ButtonType.tertiary,
                width: 204.w,
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

        SizedBox(height: 48.w),

        buttons,
      ],
    );
  }

  // ============================================================
  // Main Form
  // ============================================================

  Widget _buildForm({required bool compact}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ======================================================
        // Letter Number + Date
        // ======================================================

        _buildTopFields(compact: compact),

        SizedBox(height: 32.w),

        // ======================================================
        // Subject
        // ======================================================
        _buildFormRow(
          'عنوان/خلاصه نامه:',
          subjectController,
          focusNode: _fnSubject,
          nextFocusNode: _fnOrganization,
          errorKey: 'subject',
          compact: compact,
        ),

        SizedBox(height: 32.w),

        // ======================================================
        // Tags
        // ======================================================
        _buildTagsSection(compact: compact),

        // ======================================================
        // Divider
        // ======================================================
        _buildDivider(compact: compact),

        // ======================================================
        // Organization
        // ======================================================
        _buildFormRow(
          'به سازمان/شرکت:',
          organizationController,
          focusNode: _fnOrganization,
          nextFocusNode: _fnRecipient,
          errorKey: 'organization',
          compact: compact,
        ),

        SizedBox(height: 32.w),

        // ======================================================
        // Recipient
        // ======================================================
        _buildFormRow(
          'گیرنده نامه:',
          recipientController,
          focusNode: _fnRecipient,
          nextFocusNode: _fnSigner,
          errorKey: 'recipient',
          compact: compact,
        ),

        SizedBox(height: 32.w),

        // ======================================================
        // Signer
        // ======================================================
        _buildFormRow(
          'امضا کننده:',
          signerController,
          focusNode: _fnSigner,
          nextFocusNode: _fnActionBy,
          errorKey: 'signer',
          compact: compact,
        ),

        SizedBox(height: 32.w),

        // ======================================================
        // Action By
        // ======================================================
        _buildFormRow(
          'اقدام کننده:',
          actionByController,
          focusNode: _fnActionBy,
          nextFocusNode: _fnRegistrationNumber,
          errorKey: 'actionBy',
          compact: compact,
        ),

        // ======================================================
        // Divider
        // ======================================================
        _buildDivider(compact: compact),

        // ======================================================
        // Registration Number
        // ======================================================
        _buildFormRow(
          'شماره ثبت دبیرخانه:',
          registrationNumberController,
          focusNode: _fnRegistrationNumber,
          nextFocusNode: _fnArchiveFolder,
          errorKey: 'registrationNumber',
          compact: compact,
        ),

        SizedBox(height: 32.w),

        // ======================================================
        // Registration Date
        // ======================================================
        _buildRegistrationDate(compact: compact),

        SizedBox(height: 32.w),

        // ======================================================
        // Archive Folder
        // ======================================================
        _buildFormRow(
          'پوشه بایگانی:',
          archiveFolderController,
          focusNode: _fnArchiveFolder,
          errorKey: 'archiveFolder',
          compact: compact,
        ),

        SizedBox(height: 32.w),

        // ======================================================
        // Priority
        // ======================================================
        _buildDropdownRow(
          label: 'اولویت:',
          compact: compact,

          child: AppDropdown<String>(
            items: const ['عادی', 'فوری'],

            value: selectedPriority,

            itemLabelBuilder: (item) => item == 'فوری' ? '🔴 $item' : item,

            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedPriority = value;
                });
              }
            },

            width: 216.w,
            height: 64.w,
          ),
        ),

        SizedBox(height: 32.w),

        // ======================================================
        // Send Method
        // ======================================================
        _buildDropdownRow(
          label: 'نحوه ارسال:',
          compact: compact,

          child: AppDropdown<String>(
            items: const ['ایمیل', 'فکس', 'حضوری'],

            value: selectedSendMethod,

            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedSendMethod = value;
                });
              }
            },

            width: 216.w,
            height: 64.w,
          ),
        ),

        SizedBox(height: 32.w),

        // ======================================================
        // Follow Up
        // ======================================================
        _buildSwitchRow(
          label: 'نیاز به پیگیری:',
          compact: compact,

          child: AppSwitch(
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
        ),

        SizedBox(height: 16.w),

        // ======================================================
        // Save File
        // ======================================================
        _buildSwitchRow(
          label: 'ذخیره فایل:',
          compact: compact,

          child: AppSwitch(
            value: _isFileSwitchOn,

            onChanged: (value) {
              setState(() {
                _isFileSwitchOn = value;
              });
            },
          ),
        ),
      ],
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
                  ? 16.w
                  : screenWidth < 1000.w
                  ? 24.w
                  : 32.w;

              return Column(
                children: [
                  // ==================================================
                  // Header
                  // ==================================================

                  const AppHeader(
                    title: 'ثبت نامه صادره',
                    leading: HeaderLeading.back,
                  ),

                  // ==================================================
                  // Scrollable Content
                  // ==================================================
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: horizontalPadding,
                        right: horizontalPadding,
                        top: compact ? 32.w : 64.w,
                        bottom: 64.w,
                      ),

                      child: Align(
                        alignment: AlignmentDirectional.topStart,

                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: _desktopContentWidth.w,
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,

                            children: [
                              // ====================================
                              // Form
                              // ====================================

                              _buildForm(compact: compact),

                              // ====================================
                              // Attachments
                              // ====================================
                              SizedBox(height: compact ? 40.w : 48.w),

                              _buildAttachmentsPanel(compact: compact),

                              SizedBox(height: compact ? 40.w : 64.w),
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
// Outgoing Letter Data
// ============================================================================

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
