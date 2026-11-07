import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_application_1/widgets/pdf_document.dart';
import 'package:flutter_application_1/widgets/pdf_save.dart';
import '../core/app_constants.dart';
import '../data/document_repository.dart';

import '../widgets/smart_date_field.dart';
import '../widgets/modal.dart';
import '../widgets/letter_number_generator.dart';
import '../attachments/attached_item.dart';
import '../attachments/attachments_panel.dart';

import 'package:flutter_application_1/domain/documents.dart';
import 'package:flutter_application_1/documents/m_varede.dart';

import '../widgets/switch_button.dart';
import '../widgets/buttons.dart';
import '../widgets/text_input.dart';
import '../widgets/dropdown_menu.dart';
import '../widgets/header.dart';
import 'package:flutter_application_1/core/theme.dart';

class IncomingLetterFormPage extends StatefulWidget {
  const IncomingLetterFormPage({
    super.key,
    this.initialDocument,
    this.openToAttachments = false,
  });

  final IncomingLetterDocument? initialDocument;

  /// When true, the form scrolls down to the attachments panel on open.
  final bool openToAttachments;

  @override
  State<IncomingLetterFormPage> createState() => _IncomingLetterFormPageState();
}

class _IncomingLetterFormPageState extends State<IncomingLetterFormPage> {
  final letterNumberController = TextEditingController();
  final dateController = TextEditingController();
  final registrationDateController = TextEditingController();
  final subjectController = TextEditingController();
  final organizationController = TextEditingController();
  final senderController = TextEditingController();
  final senderLetterNumberController = TextEditingController();
  final recipientController = TextEditingController();
  final archiveFolderController = TextEditingController();

  final _fnSubject = FocusNode();
  final _fnOrganization = FocusNode();
  final _fnSender = FocusNode();
  final _fnSenderLetterNumber = FocusNode();
  final _fnRecipient = FocusNode();
  final _fnArchiveFolder = FocusNode();

  final Map<String, String?> _errors = {
    'subject': null,
    'organization': null,
    'sender': null,
    'senderLetterNumber': null,
    'recipient': null,
    'archiveFolder': null,
  };

  String selectedPriority = 'عادی';
  String selectedSendMethod = 'ایمیل';

  List<String> tags = [];

  final _tagInputController = TextEditingController();

  bool _isSwitchOn = false;
  bool _isFileSwitchOn = false;

  String? _followUpDate;
  String? _followUpBy;

  List<AttachedItem> _currentAttachments = [];

  final _attachmentsKey = GlobalKey();

  /// True while a submit is in flight — guards against double-taps that
  /// would save the document twice.
  bool _isSubmitting = false;

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
      senderController.text = doc.sender;
      senderLetterNumberController.text = doc.senderLetterNumber;
      recipientController.text = doc.recipient;
      archiveFolderController.text = doc.archiveFolder;

      tags = List<String>.from(doc.tags);

      selectedPriority = doc.priority;

      _isSwitchOn = doc.needsFollowUp;
      _followUpDate = doc.followUpDate;
      _followUpBy = doc.followUpBy;

      _isFileSwitchOn = doc.saveFile;

      _currentAttachments = doc.attachments.map((attachment) {
        return AttachedItem(
          name: attachment.name,
          path: attachment.path,
          bytes: attachment.bytes,
        );
      }).toList();
    }

    if (widget.openToAttachments) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = _attachmentsKey.currentContext;
        if (ctx != null) Scrollable.ensureVisible(ctx);
      });
    }
  }

  @override
  void dispose() {
    letterNumberController.dispose();
    dateController.dispose();
    registrationDateController.dispose();
    subjectController.dispose();
    organizationController.dispose();
    senderController.dispose();
    senderLetterNumberController.dispose();
    recipientController.dispose();
    archiveFolderController.dispose();

    _tagInputController.dispose();

    _fnSubject.dispose();
    _fnOrganization.dispose();
    _fnSender.dispose();
    _fnSenderLetterNumber.dispose();
    _fnRecipient.dispose();
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
    showDialog<FollowUpResult>(
      context: context,
      builder: (context) => const CustomModal(),
    ).then((result) {
      if (!mounted || result == null) return;

      setState(() {
        _followUpDate = result.date;
        _followUpBy = result.followUpBy;
        _isSwitchOn = true;
      });
    });
  }

  bool _validateForm() {
    final newErrors = <String, String?>{
      'subject': subjectController.text.trim().isEmpty
          ? kRequiredFieldMessage
          : null,

      'organization': organizationController.text.trim().isEmpty
          ? kRequiredFieldMessage
          : null,

      'sender': senderController.text.trim().isEmpty
          ? kRequiredFieldMessage
          : null,

      'senderLetterNumber': senderLetterNumberController.text.trim().isEmpty
          ? kRequiredFieldMessage
          : null,

      'recipient': recipientController.text.trim().isEmpty
          ? kRequiredFieldMessage
          : null,

      'archiveFolder': archiveFolderController.text.trim().isEmpty
          ? kRequiredFieldMessage
          : null,
    };

    setState(() => _errors.addAll(newErrors));

    return newErrors.values.every((e) => e == null);
  }

  Future<void> _submitForm() async {
    if (_isSubmitting || !_validateForm()) return;

    setState(() => _isSubmitting = true);

    String? pdfPath;
    bool pdfSaved = false;

    try {
      if (widget.initialDocument == null) {
        letterNumberController.text = await LetterNumberGenerator.instance
            .generate(DocumentType.incoming);
      }

      final document = IncomingLetterDocument(
        id:
            widget.initialDocument?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),

        letterNumber: letterNumberController.text.trim(),
        date: dateController.text,
        subject: subjectController.text.trim(),
        tags: List<String>.from(tags),

        organization: organizationController.text.trim(),

        sender: senderController.text.trim(),

        senderLetterNumber: senderLetterNumberController.text.trim(),

        recipient: recipientController.text.trim(),

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

      if (_isFileSwitchOn) {
        final pdfData = PdfDocumentData.fromIncoming(document);

        final suggestedName = document.letterNumber.trim().isNotEmpty
            ? '${document.letterNumber.trim()}.pdf'
            : 'نامه-وارده.pdf';

        pdfPath = await PdfSaver.chooseSavePath(
          suggestedFileName: suggestedName,
        );

        if (pdfPath != null) {
          await PdfSaver.savePdf(document: pdfData, path: pdfPath);

          pdfSaved = true;
        }
      }

      // Canceling the save dialog during an edit keeps the previously
      // recorded PDF reference instead of silently dropping it; switching
      // the option off explicitly clears it.
      final keepExistingPdf =
          _isFileSwitchOn &&
          widget.initialDocument != null &&
          widget.initialDocument!.saveFile;

      final finalDocument = document.copyWith(
        saveFile: pdfSaved || keepExistingPdf,
        filePath:
            pdfPath ?? (keepExistingPdf ? widget.initialDocument!.filePath : null),
      );

      if (widget.initialDocument != null) {
        await DocumentRepository.instance.updateIncoming(
          widget.initialDocument!.id,
          finalDocument,
        );
      } else {
        await DocumentRepository.instance.addIncoming(finalDocument);
      }

      if (!mounted) return;

      if (pdfSaved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('نامه وارده و PDF با موفقیت ذخیره شدند'),
            backgroundColor: AppColors.primary,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('نامه وارده با موفقیت ذخیره شد'),
            backgroundColor: AppColors.primary,
          ),
        );
      }

      if (widget.initialDocument != null) {
        // Editing: hand the saved document back to the view page that opened
        // us, which refreshes itself — instead of stacking a second view.
        Navigator.pop(context, finalDocument);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IncomingLetterViewPage(document: finalDocument),
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('SUBMIT INCOMING ERROR: $e');
      debugPrint('$stackTrace');

      if (!mounted) return;

      // The exception itself stays in the debug log; users get a generic
      // message (the settings screens' convention — never raw error text).
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('خطا در ذخیره نامه وارده'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  /// True when the user typed into a field, added tags/attachments, or set
  /// follow-up data. Auto-filled fields (the generated letter number, the
  /// date pickers) are deliberately not counted, so a pristine create form
  /// cancels instantly.
  bool _hasUnsavedContent() {
    return subjectController.text.isNotEmpty ||
        organizationController.text.isNotEmpty ||
        senderController.text.isNotEmpty ||
        senderLetterNumberController.text.isNotEmpty ||
        recipientController.text.isNotEmpty ||
        archiveFolderController.text.isNotEmpty ||
        tags.isNotEmpty ||
        _currentAttachments.isNotEmpty ||
        _isSwitchOn;
  }

  Future<void> _cancelForm() async {
    if (_hasUnsavedContent()) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('انصراف از ثبت؟'),
          content: const Text('اطلاعات واردشده ذخیره نمی‌شود.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('ادامه'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('انصراف'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('عملیات لغو شد'),
        backgroundColor: AppColors.mutedText,
      ),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  Widget _buildAttachmentsPanel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AttachmentsPanel(
          initialItems: _currentAttachments,
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
                    isLoading: _isSubmitting,
                    onPressed: _submitForm,
                  ),

                  SizedBox(width: spacing),

                  CustomButton(
                    label: 'انصراف',
                    type: ButtonType.tertiary,
                    width: buttonWidth,
                    isDisabled: _isSubmitting,
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
                  isLoading: _isSubmitting,
                  onPressed: _submitForm,
                ),

                SizedBox(height: spacing),

                CustomButton(
                  label: 'انصراف',
                  type: ButtonType.tertiary,
                  width: buttonWidth,
                  isDisabled: _isSubmitting,
                  onPressed: _cancelForm,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Column(
      children: [
        SizedBox(height: 32.w),

        Row(
          children: [
            Expanded(
              flex: 148,
              child: Container(height: 1, color: AppColors.background),
            ),

            Expanded(
              flex: 548,
              child: Container(height: 1, color: AppColors.mutedText),
            ),
          ],
        ),

        SizedBox(height: 64.w),
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
                color: AppColors.error,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionLabel(String text, {double width = 150}) {
    return SizedBox(
      width: width.w,
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.text,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

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
              color: AppColors.background,
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
                  color: AppColors.mutedText,
                  borderRadius: BorderRadius.circular(8.r),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tag,
                      style: TextStyle(
                        color: AppColors.background,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(width: 8.w),

                    GestureDetector(
                      onTap: () => _removeTag(index),
                      child: Icon(
                        Icons.close,
                        size: 16.sp,
                        color: AppColors.background,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),

      behavior: HitTestBehavior.translucent,

      child: Scaffold(
        backgroundColor: AppColors.background,

        body: Column(
          children: [
            const AppHeader(
              title: 'ثبت نامه وارده',
              leading: HeaderLeading.back,
            ),

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
                          LetterNumberField(
                            controller: letterNumberController,
                            type: DocumentType.incoming,
                          ),

                          SizedBox(height: 32.w),

                          SmartDateField(
                            controller: dateController,
                            label: 'تاریخ:',
                            isReadOnly: true,
                          ),

                          SizedBox(height: 32.w),

                          _buildFormRow(
                            'عنوان/خلاصه نامه:',
                            subjectController,
                            focusNode: _fnSubject,
                            nextFocusNode: _fnOrganization,
                            errorKey: 'subject',
                          ),

                          SizedBox(height: 32.w),

                          _buildTagsSection(),

                          _buildDivider(),

                          _buildFormRow(
                            'به سازمان/شرکت:',
                            organizationController,
                            focusNode: _fnOrganization,
                            nextFocusNode: _fnSender,
                            errorKey: 'organization',
                          ),

                          SizedBox(height: 32.w),

                          _buildFormRow(
                            'شخص ارسال کننده:',
                            senderController,
                            focusNode: _fnSender,
                            nextFocusNode: _fnSenderLetterNumber,
                            errorKey: 'sender',
                          ),

                          SizedBox(height: 32.w),

                          _buildFormRow(
                            'شماره نامه فرستنده:',
                            senderLetterNumberController,
                            focusNode: _fnSenderLetterNumber,
                            nextFocusNode: _fnRecipient,
                            errorKey: 'senderLetterNumber',
                          ),

                          SizedBox(height: 32.w),

                          _buildFormRow(
                            'مخاطب:',
                            recipientController,
                            focusNode: _fnRecipient,
                            nextFocusNode: _fnArchiveFolder,
                            errorKey: 'recipient',
                          ),

                          _buildDivider(),

                          SmartDateField(
                            controller: registrationDateController,
                            label: 'تاریخ ثبت:',
                            fieldWidth: 548.w,
                            labelWidth: 150.w,
                            mobileBreakpoint: 700.w,
                          ),

                          SizedBox(height: 32.w),

                          _buildFormRow(
                            'پوشه بایگانی:',
                            archiveFolderController,
                            focusNode: _fnArchiveFolder,
                            errorKey: 'archiveFolder',
                          ),

                          SizedBox(height: 32.w),

                          _buildDropdownRow(
                            label: 'اولویت:',
                            child: AppDropdown<String>(
                              items: kPriorityOptions,

                              value: selectedPriority,

                              itemLabelBuilder: (item) =>
                                  item == kUrgentPriority ? '🔴 $item' : item,

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

                          SizedBox(height: 48.w),

                          Center(
                            child: KeyedSubtree(
                              key: _attachmentsKey,
                              child: _buildAttachmentsPanel(),
                            ),
                          ),

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
