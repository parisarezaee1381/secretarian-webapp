import 'package:flutter/material.dart';

import 'package:flutter_application_1/domain/documents.dart';
import 'package:flutter_application_1/documents/document_view.dart';
import 'package:flutter_application_1/documents/s_sadere.dart';

/// Read-only view of an outgoing letter. «ویرایش» opens
/// [OutgoingLetterFormPage] with the document prefilled; the form pops back
/// with the saved document and this page refreshes in place.
class OutgoingLetterViewPage extends StatefulWidget {
  const OutgoingLetterViewPage({super.key, required this.document});

  final OutgoingLetterDocument document;

  @override
  State<OutgoingLetterViewPage> createState() => _OutgoingLetterViewPageState();
}

class _OutgoingLetterViewPageState extends State<OutgoingLetterViewPage> {
  late OutgoingLetterDocument document = widget.document;

  Future<void> _handleEdit() async {
    final updated = await Navigator.push<OutgoingLetterDocument>(
      context,
      MaterialPageRoute(
        builder: (context) => OutgoingLetterFormPage(initialDocument: document),
      ),
    );

    if (updated == null || !mounted) return;

    setState(() => document = updated);
  }

  @override
  Widget build(BuildContext context) {
    return DocumentViewScaffold(
      title: 'مشاهده نامه صادره',
      onEdit: _handleEdit,
      children: [
        DocumentDetailRow(label: 'شماره نامه:', value: document.letterNumber),

        DocumentDetailRow(label: 'تاریخ:', value: document.date),

        DocumentDetailRow(
          label: 'عنوان/خلاصه نامه:',
          value: document.subject,
        ),

        if (document.tags.isNotEmpty)
          DocumentDetailRow(
            label: 'کلمات کلیدی:',
            value: document.tags.join('، '),
          ),

        const DocumentViewDivider(),

        DocumentDetailRow(label: 'به سازمان/شرکت:', value: document.organization),

        DocumentDetailRow(label: 'گیرنده نامه:', value: document.recipient),

        DocumentDetailRow(label: 'امضا کننده:', value: document.signer),

        DocumentDetailRow(label: 'اقدام کننده:', value: document.actionBy),

        const DocumentViewDivider(),

        DocumentDetailRow(
          label: 'شماره ثبت دبیرخانه:',
          value: document.registrationNumber,
        ),

        DocumentDetailRow(label: 'تاریخ ثبت:', value: document.registrationDate),

        DocumentDetailRow(label: 'پوشه بایگانی:', value: document.archiveFolder),

        DocumentDetailRow(label: 'اولویت:', value: document.priority),

        DocumentDetailRow(label: 'نحوه ارسال:', value: document.sendMethod),

        DocumentDetailRow(
          label: 'نیاز به پیگیری:',
          value: document.needsFollowUp ? 'دارد' : 'ندارد',
        ),

        if (document.needsFollowUp) ...[
          DocumentDetailRow(
            label: 'تاریخ پیگیری:',
            value: document.followUpDate ?? '',
          ),

          DocumentDetailRow(
            label: 'پیگیری توسط:',
            value: document.followUpBy ?? '',
          ),
        ],

        DocumentDetailRow(
          label: 'ذخیره فایل:',
          value: document.saveFile ? 'بله' : 'خیر',
        ),

        if (document.filePath != null)
          DocumentDetailRow(label: 'فایل ذخیره شده:', value: document.filePath!),

        if (document.attachments.isNotEmpty)
          DocumentDetailRow(
            label: 'تعداد پیوست:',
            value: document.attachments.length.toString(),
          ),
      ],
    );
  }
}
