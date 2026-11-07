import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter_application_1/domain/documents.dart';

import 'pdf_document.dart';

class DocumentPdfGenerator {
  DocumentPdfGenerator._();

  static const String _fontPath =
      'assets/Estedad/Estedad-VariableFont_wght.ttf';

  /// Cached so repeat saves reuse the loaded font instead of re-reading
  /// the bundled asset; the load either works or fails for the session.
  static Future<pw.Font>? _fontFuture;

  static Future<pw.Font> _loadFont() => _fontFuture ??= rootBundle
      .load(_fontPath)
      .then((bytes) => pw.Font.ttf(bytes.buffer.asByteData()));

  static Future<Uint8List> generate(PdfDocumentData data) async {
    final estedad = await _loadFont();

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,

        margin: const pw.EdgeInsets.fromLTRB(45, 45, 45, 45),

        textDirection: pw.TextDirection.rtl,

        theme: pw.ThemeData.withFont(base: estedad),

        header: (context) {
          return _buildHeader(data, estedad);
        },

        footer: (context) {
          return _buildFooter(context, estedad);
        },

        build: (context) {
          return _buildContent(data, estedad);
        },
      ),
    );

    return pdf.save();
  }

  static List<pw.Widget> _buildContent(PdfDocumentData data, pw.Font font) {
    final widgets = <pw.Widget>[
      _buildTwoColumnRow(
        _buildFullWidthField('شماره نامه', data.letterNumber, font),
        _buildFullWidthField('تاریخ', data.date, font),
      ),

      pw.SizedBox(height: 14),

      _buildFullWidthField('عنوان/خلاصه نامه', data.subject, font),

      pw.SizedBox(height: 14),

      _buildTags(data.tags, font),

      pw.SizedBox(height: 24),

      _buildDivider(),

      pw.SizedBox(height: 24),

      _buildFullWidthField('به سازمان/شرکت', data.organization, font),

      pw.SizedBox(height: 14),

      ..._buildTypeSpecificContent(data, font),

      pw.SizedBox(height: 24),

      _buildDivider(),

      pw.SizedBox(height: 24),

      _buildFullWidthField('تاریخ ثبت', data.registrationDate, font),

      pw.SizedBox(height: 14),

      if (data.archiveFolder != null)
        _buildFullWidthField('پوشه بایگانی', data.archiveFolder!, font),

      if (data.archiveFolder != null) pw.SizedBox(height: 14),

      if (data.priority != null)
        _buildFullWidthField('اولویت', data.priority!, font),

      if (data.priority != null) pw.SizedBox(height: 14),

      if (data.type != DocumentType.contract) _buildFollowUp(data, font),
    ];

    return widgets;
  }

  static List<pw.Widget> _buildTypeSpecificContent(
    PdfDocumentData data,
    pw.Font font,
  ) {
    switch (data.type) {
      case DocumentType.outgoing:
        return [
          _buildFullWidthField('گیرنده نامه', data.recipient, font),

          pw.SizedBox(height: 14),

          _buildFullWidthField('امضا کننده', data.signer ?? '-', font),

          pw.SizedBox(height: 14),

          _buildFullWidthField(
            'اقدام کننده',
            data.outgoingActionBy ?? '-',
            font,
          ),

          pw.SizedBox(height: 14),

          _buildFullWidthField('نحوه ارسال', data.sendMethod ?? '-', font),
        ];

      case DocumentType.incoming:
        return [
          _buildFullWidthField('فرستنده', data.sender ?? '-', font),

          pw.SizedBox(height: 14),

          _buildFullWidthField(
            'شماره نامه فرستنده',
            data.senderLetterNumber ?? '-',
            font,
          ),

          pw.SizedBox(height: 14),

          _buildFullWidthField('گیرنده نامه', data.recipient, font),
        ];

      case DocumentType.contract:
        return [
          _buildFullWidthField('گیرنده', data.recipient, font),

          pw.SizedBox(height: 14),

          _buildFullWidthField(
            'اقدام کننده',
            data.contractActionBy ?? '-',
            font,
          ),

          pw.SizedBox(height: 14),

          _buildFullWidthField(
            'موضوع قرارداد',
            data.contractSubject ?? '-',
            font,
          ),

          pw.SizedBox(height: 14),

          _buildFullWidthField(
            'شماره قرارداد مرجع',
            data.referenceContractNumber ?? '-',
            font,
          ),
        ];
    }
  }

  static pw.Widget _buildHeader(PdfDocumentData data, pw.Font font) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Column(
        children: [
          pw.Center(
            child: pw.Text(
              data.documentTitle,
              style: pw.TextStyle(
                font: font,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          pw.SizedBox(height: 10),

          pw.Container(height: 1, color: PdfColors.grey400),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(pw.Context context, pw.Font font) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 15),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(
            'صفحه ${context.pageNumber} از ${context.pagesCount}',
            style: pw.TextStyle(
              font: font,
              fontSize: 8,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFullWidthField(
    String label,
    String value,
    pw.Font font,
  ) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 0.7),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '$label:',
            style: _labelStyle(font),
          ),

          pw.SizedBox(height: 5),

          pw.Text(
            _safeValue(value),
            style: _valueStyle(font),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTwoColumnRow(pw.Widget first, pw.Widget second) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(child: first),

        pw.SizedBox(width: 12),

        pw.Expanded(child: second),
      ],
    );
  }

  static pw.Widget _buildTags(List<String> tags, pw.Font font) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 0.7),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'کلمات کلیدی:',
            style: _labelStyle(font),
          ),

          pw.SizedBox(height: 7),

          if (tags.isEmpty)
            pw.Text(
              '-',
              style: _valueStyle(font),
            ),

          if (tags.isNotEmpty)
            pw.Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tags.map((tag) {
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey600,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    tag,
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 8,
                      color: PdfColors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  static pw.Widget _buildFollowUp(PdfDocumentData data, pw.Font font) {
    if (!data.needsFollowUp) {
      return _buildFullWidthField('نیاز به پیگیری', 'خیر', font);
    }

    final children = <pw.Widget>[
      pw.Text(
        'بله',
        style: _valueStyle(font),
      ),
    ];

    if (data.followUpDate != null && data.followUpDate!.trim().isNotEmpty) {
      children.add(pw.SizedBox(height: 5));

      children.add(
        pw.Text(
          'تاریخ پیگیری: ${data.followUpDate}',
          style: _valueStyle(font),
        ),
      );
    }

    if (data.followUpBy != null && data.followUpBy!.trim().isNotEmpty) {
      children.add(pw.SizedBox(height: 5));

      children.add(
        pw.Text(
          'پیگیری توسط: ${data.followUpBy}',
          style: _valueStyle(font),
        ),
      );
    }

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 0.7),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'نیاز به پیگیری:',
            style: _labelStyle(font),
          ),

          pw.SizedBox(height: 5),

          ...children,
        ],
      ),
    );
  }

  static pw.Widget _buildDivider() {
    return pw.Container(
      width: double.infinity,
      height: 1,
      color: PdfColors.grey400,
    );
  }

  static pw.TextStyle _labelStyle(pw.Font font) => pw.TextStyle(
        font: font,
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.grey700,
      );

  static pw.TextStyle _valueStyle(pw.Font font) =>
      pw.TextStyle(font: font, fontSize: 10);

  static String _safeValue(String value) {
    final trimmed = value.trim();

    return trimmed.isEmpty ? '-' : trimmed;
  }
}
