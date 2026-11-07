import 'package:flutter/material.dart';

import 'package:flutter_application_1/domain/documents.dart';
import 'package:flutter_application_1/documents/document_view.dart';
import 'package:flutter_application_1/documents/s_gharardad.dart';

/// Read-only view of a contract. «ویرایش» opens [ContractFormPage] with the
/// document prefilled; the form pops back with the saved document and this
/// page refreshes in place, so the stack never grows and no stale data is
/// shown.
class ContractViewPage extends StatefulWidget {
  const ContractViewPage({super.key, required this.document});

  final ContractDocument document;

  @override
  State<ContractViewPage> createState() => _ContractViewPageState();
}

class _ContractViewPageState extends State<ContractViewPage> {
  late ContractDocument document = widget.document;

  Future<void> _handleEdit() async {
    final updated = await Navigator.push<ContractDocument>(
      context,
      MaterialPageRoute(
        builder: (context) => ContractFormPage(initialDocument: document),
      ),
    );

    if (updated == null || !mounted) return;

    setState(() => document = updated);
  }

  @override
  Widget build(BuildContext context) {
    return DocumentViewScaffold(
      title: 'مشاهده قرارداد',
      onEdit: _handleEdit,
      children: [
        DocumentDetailRow(
          label: 'شماره قرارداد:',
          value: document.letterNumber,
        ),

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

        DocumentDetailRow(
          label: 'شرکت طرف قرارداد:',
          value: document.organization,
        ),

        DocumentDetailRow(label: 'شخص طرف قرارداد:', value: document.recipient),

        DocumentDetailRow(label: 'اقدام کننده:', value: document.actionBy),

        const DocumentViewDivider(),

        DocumentDetailRow(label: 'موضوع قرارداد:', value: document.contractSubject),

        DocumentDetailRow(label: 'تاریخ ثبت:', value: document.registrationDate),

        DocumentDetailRow(
          label: 'شماره قرارداد مرجع:',
          value: document.referenceContractNumber,
        ),

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
