import 'package:flutter/material.dart';

import 'package:flutter_application_1/domain/documents.dart';
import 'package:flutter_application_1/documents/document_view.dart';
import 'package:flutter_application_1/documents/s_varede.dart';

/// Read-only view of an incoming letter. «ویرایش» opens
/// [IncomingLetterFormPage] with the document prefilled; the form pops back
/// with the saved document and this page refreshes in place.
class IncomingLetterViewPage extends StatefulWidget {
  const IncomingLetterViewPage({super.key, required this.document});

  final IncomingLetterDocument document;

  @override
  State<IncomingLetterViewPage> createState() => _IncomingLetterViewPageState();
}

class _IncomingLetterViewPageState extends State<IncomingLetterViewPage> {
  late IncomingLetterDocument document = widget.document;

  Future<void> _handleEdit() async {
    final updated = await Navigator.push<IncomingLetterDocument>(
      context,
      MaterialPageRoute(
        builder: (context) => IncomingLetterFormPage(initialDocument: document),
      ),
    );

    if (updated == null || !mounted) return;

    setState(() => document = updated);
  }

  @override
  Widget build(BuildContext context) {
    return DocumentViewScaffold(
      title: 'مشاهده نامه وارده',
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

        DocumentDetailRow(label: 'شخص ارسال کننده:', value: document.sender),

        DocumentDetailRow(
          label: 'شماره نامه فرستنده:',
          value: document.senderLetterNumber,
        ),

        DocumentDetailRow(label: 'مخاطب:', value: document.recipient),

        const DocumentViewDivider(),

        DocumentDetailRow(label: 'تاریخ ثبت:', value: document.registrationDate),

        DocumentDetailRow(label: 'پوشه بایگانی:', value: document.archiveFolder),

        DocumentDetailRow(label: 'اولویت:', value: document.priority),

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
