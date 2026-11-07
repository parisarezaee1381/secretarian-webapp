import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_application_1/domain/documents.dart';
import 'package:flutter_application_1/widgets/pdf_save.dart';
import '../core/app_constants.dart';
import '../data/document_repository.dart';

import '../widgets/smart_date_field.dart';
import '../widgets/modal.dart';
import '../widgets/letter_number_generator.dart';
import '../attachments/attached_item.dart';
import '../attachments/attachments_panel.dart';

import 'package:flutter_application_1/documents/m_sadere.dart';

import '../widgets/switch_button.dart';
import '../widgets/buttons.dart';
import '../widgets/text_input.dart';
import '../widgets/dropdown_menu.dart';
import '../widgets/header.dart';

import 'package:flutter_application_1/widgets/pdf_document.dart';
import 'package:flutter_application_1/core/theme.dart';

class OutgoingLetterFormPage extends StatefulWidget {
  const OutgoingLetterFormPage({
    super.key,
    this.initialDocument,
    this.openToAttachments = false,
  });

  final OutgoingLetterDocument? initialDocument;

  /// When true, the form scrolls down to the attachments panel on open.
  final bool openToAttachments;

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

  final _attachmentsKey = GlobalKey();

  /// True while a submit is in flight — guards against double-taps that
  /// would save the document twice.
  bool _isSubmitting = false;

  static const double _desktopContentWidth = 900;
  static const double _fieldWidth = 548;
  static const double _labelWidth = 150;

  /// Shared with the view pages (`kWideLayoutBreakpoint`) so a form and its
  /// view switch layouts at the same width.
  static const double _mobileBreakpoint = kWideLayoutBreakpoint;

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

      'recipient': recipientController.text.trim().isEmpty
          ? kRequiredFieldMessage
          : null,

      'signer': signerController.text.trim().isEmpty
          ? kRequiredFieldMessage
          : null,

      'actionBy': actionByController.text.trim().isEmpty
          ? kRequiredFieldMessage
          : null,

      'registrationNumber': registrationNumberController.text.trim().isEmpty
          ? kRequiredFieldMessage
          : null,

      'archiveFolder': archiveFolderController.text.trim().isEmpty
          ? kRequiredFieldMessage
          : null,
    };

    setState(() {
      _errors.addAll(newErrors);
    });

    return newErrors.values.every((error) => error == null);
  }

  Future<void> _submitForm() async {
    if (_isSubmitting || !_validateForm()) {
      return;
    }

    setState(() => _isSubmitting = true);

    String? pdfPath;
    bool pdfSaved = false;

    try {
      if (widget.initialDocument == null) {
        letterNumberController.text = await LetterNumberGenerator.instance
            .generate(DocumentType.outgoing);
      }

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

      if (_isFileSwitchOn) {
        final pdfData = PdfDocumentData.fromOutgoing(document);

        final suggestedName = document.letterNumber.trim().isNotEmpty
            ? '${document.letterNumber.trim()}.pdf'
            : 'نامه-صادره.pdf';

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
        await DocumentRepository.instance.updateOutgoing(
          widget.initialDocument!.id,
          finalDocument,
        );
      } else {
        await DocumentRepository.instance.addOutgoing(finalDocument);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            pdfSaved
                ? 'نامه و PDF با موفقیت ذخیره شدند'
                : 'نامه با موفقیت ذخیره شد',
          ),
          backgroundColor: AppColors.primary,
        ),
      );

      if (widget.initialDocument != null) {
        // Editing: hand the saved document back to the view page that opened
        // us, which refreshes itself — instead of stacking a second view.
        Navigator.pop(context, finalDocument);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OutgoingLetterViewPage(document: finalDocument),
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('SUBMIT ERROR: $e');
      debugPrint('$stackTrace');

      if (!mounted) return;

      // The exception itself stays in the debug log; users get a generic
      // message (the settings screens' convention — never raw error text).
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('خطا در ذخیره نامه'),
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
        recipientController.text.isNotEmpty ||
        signerController.text.isNotEmpty ||
        actionByController.text.isNotEmpty ||
        registrationNumberController.text.isNotEmpty ||
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

  Widget _buildMobileLabel(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

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

      labelSpacing: 0,

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
                  color: AppColors.error,
                  fontSize: 12,
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
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionLabelText(String text, {double width = _labelWidth}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTopFields({required bool compact}) {
    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMobileLabel('شماره نامه:'),

          const SizedBox(height: 8),

          LetterNumberField(
            controller: letterNumberController,
            type: DocumentType.outgoing,
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
          type: DocumentType.outgoing,
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

  Widget _buildTagsSection({required bool compact}) {
    final input = AppTextField(
      controller: _tagInputController,

      width: compact ? double.infinity : _fieldWidth,

      height: 64,

      onSubmitted: (_) => _addTag(),

      suffixIcon: IconButton(
        icon: const Icon(Icons.add_circle_outline, color: AppColors.background),
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
              color: AppColors.mutedText,
              borderRadius: BorderRadius.circular(8),
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tag,
                  style: const TextStyle(
                    color: AppColors.background,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(width: 8),

                GestureDetector(
                  onTap: () => _removeTag(index),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.background,
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
        _buildSectionLabelText('کلمات کلیدی:'),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [input, const SizedBox(height: 12), tagsWidget],
        ),
      ],
    );
  }

  Widget _buildDivider({required bool compact}) {
    return Column(
      children: [
        SizedBox(height: compact ? 28 : 32),

        Container(
          width: double.infinity,
          height: 1,
          color: AppColors.mutedText,
        ),

        SizedBox(height: compact ? 40 : 64),
      ],
    );
  }

  Widget _buildDropdownRow({
    required String label,
    required Widget child,
    required bool compact,
  }) {
    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_buildMobileLabel(label), const SizedBox(height: 12), child],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [_buildSectionLabelText(label), child],
    );
  }

  Widget _buildSwitchRow({
    required String label,
    required Widget child,
    required bool compact,
  }) {
    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_buildMobileLabel(label), const SizedBox(height: 12), child],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [_buildSectionLabelText(label), child],
    );
  }

  Widget _buildAttachmentsPanel({required bool compact}) {
    final buttons = compact
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomButton(
                label: 'ثبت',
                type: ButtonType.primary,
                width: double.infinity,
                isLoading: _isSubmitting,
                onPressed: _submitForm,
              ),

              const SizedBox(height: 16),

              CustomButton(
                label: 'انصراف',
                type: ButtonType.tertiary,
                width: double.infinity,
                isDisabled: _isSubmitting,
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
                isLoading: _isSubmitting,
                onPressed: _submitForm,
              ),

              const SizedBox(width: 16),

              CustomButton(
                label: 'انصراف',
                type: ButtonType.tertiary,
                width: 204,
                isDisabled: _isSubmitting,
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
          initialItems: _currentAttachments,
          onChanged: (items) {
            _currentAttachments = items;
          },
        ),

        const SizedBox(height: 48),

        buttons,
      ],
    );
  }

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
          'به سازمان/شرکت:',
          organizationController,
          focusNode: _fnOrganization,
          nextFocusNode: _fnRecipient,
          errorKey: 'organization',
          compact: compact,
        ),

        const SizedBox(height: 32),

        _buildFormRow(
          'گیرنده نامه:',
          recipientController,
          focusNode: _fnRecipient,
          nextFocusNode: _fnSigner,
          errorKey: 'recipient',
          compact: compact,
        ),

        const SizedBox(height: 32),

        _buildFormRow(
          'امضا کننده:',
          signerController,
          focusNode: _fnSigner,
          nextFocusNode: _fnActionBy,
          errorKey: 'signer',
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
          'شماره ثبت دبیرخانه:',
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
          'پوشه بایگانی:',
          archiveFolderController,
          focusNode: _fnArchiveFolder,
          errorKey: 'archiveFolder',
          compact: compact,
        ),

        const SizedBox(height: 32),

        _buildDropdownRow(
          label: 'اولویت:',
          compact: compact,

          child: AppDropdown<String>(
            items: kPriorityOptions,

            value: selectedPriority,

            itemLabelBuilder: (item) =>
                item == kUrgentPriority ? '🔴 $item' : item,

            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedPriority = value;
                });
              }
            },

            width: 216,
            height: 64,
          ),
        ),

        const SizedBox(height: 32),

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

            width: 216,
            height: 64,
          ),
        ),

        const SizedBox(height: 32),

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

        const SizedBox(height: 16),

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },

      behavior: HitTestBehavior.translucent,

      child: Scaffold(
        backgroundColor: AppColors.background,

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
                  const AppHeader(
                    title: 'ثبت نامه صادره',
                    leading: HeaderLeading.back,
                  ),

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
                              _buildForm(compact: compact),

                              SizedBox(height: compact ? 40 : 48),

                              KeyedSubtree(
                                key: _attachmentsKey,
                                child: _buildAttachmentsPanel(compact: compact),
                              ),

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
