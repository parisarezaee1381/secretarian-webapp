import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_application_1/widgets.dart/pdf_document.dart';
import 'package:flutter_application_1/widgets.dart/pdf_save.dart';
import '../document_repository.dart';

import '../widgets.dart/smart_date_field.dart';
import '../widgets.dart/modal.dart';
import '../widgets.dart/letter_number_generator.dart';
import '../attachments.dart/attached_item.dart';
import '../attachments.dart/attachments_panel.dart';

import 'package:flutter_application_1/documents.dart';
import 'package:flutter_application_1/documents/m_varede.dart';

import '../widgets.dart/switch_button.dart';
import '../widgets.dart/buttons.dart';
import '../widgets.dart/text_input.dart';
import '../widgets.dart/dropdown_menu.dart';
import '../widgets.dart/header.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class IncomingLetterFormPage extends StatefulWidget {
  const IncomingLetterFormPage({super.key, this.initialDocument});

  final IncomingLetterDocument? initialDocument;

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

  // ------------------------------------------------------------
  // Focus Nodes
  // ------------------------------------------------------------

  final _fnSubject = FocusNode();
  final _fnOrganization = FocusNode();
  final _fnRecipient = FocusNode();
  final _fnSigner = FocusNode();
  final _fnActionBy = FocusNode();
  final _fnArchiveFolder = FocusNode();

  // ------------------------------------------------------------
  // Errors
  // ------------------------------------------------------------

  final Map<String, String?> _errors = {
    'letterNumber': null,
    'subject': null,
    'organization': null,
    'recipient': null,
    'signer': null,
    'actionBy': null,
    'archiveFolder': null,
  };

  // ------------------------------------------------------------
  // State
  // ------------------------------------------------------------

  String selectedPriority = 'عادی';
  String selectedSendMethod = 'ایمیل';

  List<String> tags = [];

  final _tagInputController = TextEditingController();

  bool _isSwitchOn = false;
  bool _isFileSwitchOn = false;

  String? _followUpDate;
  String? _followUpBy;

  List<AttachedItem> _currentAttachments = [];

  // ------------------------------------------------------------
  // Init State
  // ------------------------------------------------------------

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
      recipientController.text = doc.senderLetterNumber;
      signerController.text = doc.senderLetterNumber;
      actionByController.text = doc.recipient;
      archiveFolderController.text = doc.archiveFolder;

      tags = List<String>.from(doc.tags);

      selectedPriority = doc.priority;

      _isSwitchOn = doc.needsFollowUp;
      _followUpDate = doc.followUpDate;
      _followUpBy = doc.followUpBy;

      _isFileSwitchOn = doc.saveFile;
    }
  }

  // ------------------------------------------------------------
  // Dispose
  // ------------------------------------------------------------

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

    _fnSubject.dispose();
    _fnOrganization.dispose();
    _fnRecipient.dispose();
    _fnSigner.dispose();
    _fnActionBy.dispose();
    _fnArchiveFolder.dispose();

    super.dispose();
  }

  // ------------------------------------------------------------
  // Tags
  // ------------------------------------------------------------

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

  // ------------------------------------------------------------
  // Follow Up Modal
  // ------------------------------------------------------------

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

  // ------------------------------------------------------------
  // Validation
  // ------------------------------------------------------------

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

      'archiveFolder': archiveFolderController.text.trim().isEmpty
          ? 'لطفا این فیلد را پر کنید'
          : null,
    };

    setState(() => _errors.addAll(newErrors));

    return newErrors.values.every((e) => e == null);
  }

  // ------------------------------------------------------------
  // Submit
  // ------------------------------------------------------------

  Future<void> _submitForm() async {
    if (!_validateForm()) return;

    String? pdfPath;
    bool pdfSaved = false;

    try {
      // =====================================================
      // 1. ساخت Document اولیه
      // =====================================================

      final document = IncomingLetterDocument(
        id:
            widget.initialDocument?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),

        letterNumber: letterNumberController.text.trim(),
        date: dateController.text,
        subject: subjectController.text.trim(),
        tags: List<String>.from(tags),

        organization: organizationController.text.trim(),

        // شخص ارسال کننده
        sender: recipientController.text.trim(),

        // شماره نامه فرستنده
        senderLetterNumber: signerController.text.trim(),

        // مخاطب
        recipient: actionByController.text.trim(),

        registrationDate: registrationDateController.text,
        archiveFolder: archiveFolderController.text.trim(),

        priority: selectedPriority,

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

      // =====================================================
      // 2. ذخیره PDF
      // =====================================================

      if (_isFileSwitchOn) {
        final pdfData = PdfDocumentData.fromIncoming(document);

        final suggestedName = document.letterNumber.trim().isNotEmpty
            ? '${document.letterNumber.trim()}.pdf'
            : 'نامه-وارده.pdf';

        pdfPath = await SavePdfWidget.chooseSavePath(
          suggestedFileName: suggestedName,
        );

        if (pdfPath != null) {
          await SavePdfWidget.savePdf(document: pdfData, path: pdfPath);

          pdfSaved = true;
        }
      }

      // =====================================================
      // 3. ساخت Document نهایی
      // =====================================================

      final finalDocument = IncomingLetterDocument(
        id: document.id,

        letterNumber: document.letterNumber,
        date: document.date,
        subject: document.subject,
        tags: document.tags,

        organization: document.organization,
        sender: document.sender,
        senderLetterNumber: document.senderLetterNumber,
        recipient: document.recipient,

        registrationDate: document.registrationDate,
        archiveFolder: document.archiveFolder,

        priority: document.priority,

        needsFollowUp: document.needsFollowUp,
        followUpDate: document.followUpDate,
        followUpBy: document.followUpBy,

        saveFile: pdfSaved,
        filePath: pdfPath,

        attachments: document.attachments,
      );

      // =====================================================
      // 4. ذخیره Repository / Isar
      // =====================================================

      if (widget.initialDocument != null) {
        await DocumentRepository.instance.updateIncoming(
          widget.initialDocument!.id,
          finalDocument,
        );
      } else {
        await DocumentRepository.instance.addIncoming(finalDocument);
      }

      // =====================================================
      // 5. پیام موفقیت
      // =====================================================

      if (pdfSaved) {
        rootScaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text('نامه وارده و PDF با موفقیت ذخیره شدند'),
            backgroundColor: Color(0xFF3863A8),
          ),
        );
      } else {
        rootScaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text('نامه وارده با موفقیت ذخیره شد'),
            backgroundColor: Color(0xFF3863A8),
          ),
        );
      }

      // =====================================================
      // 6. رفتن به صفحه نمایش نامه
      // =====================================================

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IncomingLetterViewPage(document: finalDocument),
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('SUBMIT INCOMING ERROR: $e');
      debugPrint('$stackTrace');

      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('خطا در ذخیره نامه وارده: $e'),
          backgroundColor: const Color(0xFFA85838),
        ),
      );
    }
  }

  // ------------------------------------------------------------
  // Cancel
  // ------------------------------------------------------------

  void _cancelForm() {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Text('عملیات لغو شد'),
        backgroundColor: Color(0xFF828288),
      ),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  // ------------------------------------------------------------
  // Attachments
  // ------------------------------------------------------------

  Widget _buildAttachmentsPanel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AttachmentsPanel(
          onChanged: (items) {
            _currentAttachments = items;
          },
        ),

        SizedBox(height: 64.w),

        LayoutBuilder(
          builder: (context, constraints) {
            final buttonWidth = 204.w;
            final spacing = 16.w;

            final totalWidth = (buttonWidth * 2) + spacing;

            if (constraints.maxWidth >= totalWidth) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    label: 'ثبت',
                    type: ButtonType.primary,
                    width: buttonWidth,
                    onPressed: _submitForm,
                  ),

                  SizedBox(width: spacing),

                  CustomButton(
                    label: 'انصراف',
                    type: ButtonType.tertiary,
                    width: buttonWidth,
                    onPressed: _cancelForm,
                  ),
                ],
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  label: 'ثبت',
                  type: ButtonType.primary,
                  width: buttonWidth,
                  onPressed: _submitForm,
                ),

                SizedBox(height: spacing),

                CustomButton(
                  label: 'انصراف',
                  type: ButtonType.tertiary,
                  width: buttonWidth,
                  onPressed: _cancelForm,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // Divider
  // ------------------------------------------------------------

  Widget _buildDivider() {
    return Column(
      children: [
        SizedBox(height: 32.w),

        Row(
          children: [
            Expanded(
              flex: 148,
              child: Container(height: 1, color: const Color(0xFFF3F3F7)),
            ),

            Expanded(
              flex: 548,
              child: Container(height: 1, color: const Color(0xFF828288)),
            ),
          ],
        ),

        SizedBox(height: 64.w),
      ],
    );
  }

  // ------------------------------------------------------------
  // Form Row
  // ------------------------------------------------------------

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

          labelWidth: 150.w,
          labelSpacing: 0,

          width: 548.w,
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
        ),

        if (errorText != null || showLimitWarning)
          Padding(
            padding: EdgeInsets.only(top: 4.w, right: 150.w),
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

  // ------------------------------------------------------------
  // Section Label
  // ------------------------------------------------------------

  Widget _buildSectionLabel(String text, {double width = 150}) {
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

  // ------------------------------------------------------------
  // Tags
  // ------------------------------------------------------------

  Widget _buildTagsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final labelWidth = 150.w;
        final fieldWidth = 548.w;

        final totalWidth = labelWidth + fieldWidth;

        if (constraints.maxWidth >= totalWidth) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel('کلمات کلیدی:'),

              _buildTagsContent(width: fieldWidth),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('کلمات کلیدی:'),

            SizedBox(height: 12.w),

            _buildTagsContent(width: constraints.maxWidth),
          ],
        );
      },
    );
  }

  Widget _buildTagsContent({required double width}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: _tagInputController,
          width: width,
          height: 64.w,

          onSubmitted: (_) => _addTag(),

          suffixIcon: IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFFF3F3F7),
            ),
            onPressed: _addTag,
          ),
        ),

        SizedBox(height: 12.w),

        SizedBox(
          width: width,
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
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // Dropdown Row
  // ------------------------------------------------------------

  Widget _buildDropdownRow({required String label, required Widget child}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final labelWidth = 150.w;
        final dropdownWidth = 216.w;

        if (constraints.maxWidth >= labelWidth + dropdownWidth) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_buildSectionLabel(label), child],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel(label),

            SizedBox(height: 12.w),

            child,
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------
  // Switch Row
  // ------------------------------------------------------------

  Widget _buildSwitchRow({required String label, required Widget child}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final labelWidth = 150.w;

        if (constraints.maxWidth >= labelWidth + 100.w) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_buildSectionLabel(label), child],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel(label),

            SizedBox(height: 12.w),

            child,
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------
  // Build
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),

      behavior: HitTestBehavior.translucent,

      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3F7),

        body: Column(
          children: [
            // ====================================================
            // Header
            // ====================================================

            const AppHeader(
              title: 'ثبت نامه وارده',
              leading: HeaderLeading.back,
            ),

            // ====================================================
            // Scrollable Content
            // ====================================================
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 1440.w),

                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 32.w,
                        left: 32.w,
                        top: 64.w,
                        bottom: 64.w,
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // ==================================
                          // Letter Number
                          // ==================================

                          LetterNumberField(
                            controller: letterNumberController,
                            type: LetterNumberType.incoming,
                          ),

                          SizedBox(height: 32.w),

                          // ==================================
                          // Date
                          // ==================================
                          SmartDateField(
                            controller: dateController,
                            label: 'تاریخ:',
                            isReadOnly: true,
                          ),

                          SizedBox(height: 32.w),

                          // ==================================
                          // Subject
                          // ==================================
                          _buildFormRow(
                            'عنوان/خلاصه نامه:',
                            subjectController,
                            focusNode: _fnSubject,
                            nextFocusNode: _fnOrganization,
                            errorKey: 'subject',
                          ),

                          SizedBox(height: 32.w),

                          // ==================================
                          // Tags
                          // ==================================
                          _buildTagsSection(),

                          // ==================================
                          // Divider
                          // ==================================
                          _buildDivider(),

                          // ==================================
                          // Organization
                          // ==================================
                          _buildFormRow(
                            'به سازمان/شرکت:',
                            organizationController,
                            focusNode: _fnOrganization,
                            nextFocusNode: _fnRecipient,
                            errorKey: 'organization',
                          ),

                          SizedBox(height: 32.w),

                          // ==================================
                          // Sender
                          // ==================================
                          _buildFormRow(
                            'شخص ارسال کننده:',
                            recipientController,
                            focusNode: _fnRecipient,
                            nextFocusNode: _fnSigner,
                            errorKey: 'recipient',
                          ),

                          SizedBox(height: 32.w),

                          // ==================================
                          // Sender Letter Number
                          // ==================================
                          _buildFormRow(
                            'شماره نامه فرستنده:',
                            signerController,
                            focusNode: _fnSigner,
                            nextFocusNode: _fnActionBy,
                            errorKey: 'signer',
                          ),

                          SizedBox(height: 32.w),

                          // ==================================
                          // Recipient
                          // ==================================
                          _buildFormRow(
                            'مخاطب:',
                            actionByController,
                            focusNode: _fnActionBy,
                            nextFocusNode: _fnArchiveFolder,
                            errorKey: 'actionBy',
                          ),

                          // ==================================
                          // Divider
                          // ==================================
                          _buildDivider(),

                          // ==================================
                          // Registration Date
                          // ==================================
                          SmartDateField(
                            controller: registrationDateController,
                            label: 'تاریخ ثبت:',
                          ),

                          SizedBox(height: 32.w),

                          // ==================================
                          // Archive Folder
                          // ==================================
                          _buildFormRow(
                            'پوشه بایگانی:',
                            archiveFolderController,
                            focusNode: _fnArchiveFolder,
                            errorKey: 'archiveFolder',
                          ),

                          SizedBox(height: 32.w),

                          // ==================================
                          // Priority
                          // ==================================
                          _buildDropdownRow(
                            label: 'اولویت:',
                            child: AppDropdown<String>(
                              items: const ['عادی', 'فوری'],

                              value: selectedPriority,

                              itemLabelBuilder: (item) =>
                                  item == 'فوری' ? '🔴 $item' : item,

                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => selectedPriority = value);
                                }
                              },

                              width: 216.w,
                              height: 64.w,
                            ),
                          ),

                          SizedBox(height: 32.w),

                          // ==================================
                          // Follow Up
                          // ==================================
                          _buildSwitchRow(
                            label: 'نیاز به پیگیری:',

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

                          // ==================================
                          // Save File
                          // ==================================
                          _buildSwitchRow(
                            label: 'ذخیره فایل:',

                            child: AppSwitch(
                              value: _isFileSwitchOn,

                              onChanged: (value) {
                                setState(() {
                                  _isFileSwitchOn = value;
                                });
                              },
                            ),
                          ),

                          // ==================================
                          // Attachments
                          // ==================================
                          SizedBox(height: 48.w),

                          Center(child: _buildAttachmentsPanel()),

                          SizedBox(height: 64.w),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IncomingLetterData {
  final String letterNumber;
  final String date;
  final String subject;
  final List<String> tags;
  final String organization;
  final String sender;
  final String senderLetterNumber;
  final String recipient;
  final String registrationDate;
  final String archiveFolder;
  final String priority;
  final bool needsFollowUp;
  final String? followUpDate;
  final String? followUpBy;
  final bool saveFile;
  final String? savedFileName;
  final List<AttachedItem> attachments;

  const IncomingLetterData({
    required this.letterNumber,
    required this.date,
    required this.subject,
    required this.tags,
    required this.organization,
    required this.sender,
    required this.senderLetterNumber,
    required this.recipient,
    required this.registrationDate,
    required this.archiveFolder,
    required this.priority,
    required this.needsFollowUp,
    this.followUpDate,
    this.followUpBy,
    required this.saveFile,
    this.savedFileName,
    required this.attachments,
  });
}
