import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Stitch scanned page images (PNG bytes) into a single multi-page PDF.
/// Each page is scaled to fit A4, preserving aspect ratio.
class ScannerPdf {
  /// Builds the PDF. Returns the PDF file bytes.
  ///
  /// Throws [ArgumentError] when [pages] is empty.
  static Future<Uint8List> buildPdf(List<Uint8List> pages) async {
    if (pages.isEmpty) {
      throw ArgumentError.value(pages, 'pages', 'must not be empty');
    }

    final doc = pw.Document();

    for (final pageBytes in pages) {
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (context) => pw.Image(
            pw.MemoryImage(pageBytes),
            fit: pw.BoxFit.contain,
          ),
        ),
      );
    }

    return doc.save();
  }
}
