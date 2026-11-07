import 'package:file_selector/file_selector.dart';

import 'pdf_writer.dart';
import 'pdf_generator.dart';
import 'pdf_document.dart';

/// Static helpers for the PDF export step: choose a destination with the
/// system save dialog, then hand the bytes to [PdfWriter], which is
/// conditionally imported so `dart:io` never reaches a web build.
class PdfSaver {
  PdfSaver._();

  static Future<String?> chooseSavePath({
    required String suggestedFileName,
  }) async {
    final XTypeGroup pdfType = XTypeGroup(
      label: 'PDF',
      extensions: ['pdf'],
      mimeTypes: ['application/pdf'],
    );

    final FileSaveLocation? location = await getSaveLocation(
      suggestedName: suggestedFileName,
      acceptedTypeGroups: [pdfType],
      confirmButtonText: 'ذخیره',
    );

    return location?.path;
  }

  static Future<void> savePdf({
    required PdfDocumentData document,
    required String path,
  }) async {
    final pdfBytes = await DocumentPdfGenerator.generate(document);

    String finalPath = path;

    if (!finalPath.toLowerCase().endsWith('.pdf')) {
      finalPath = '$finalPath.pdf';
    }

    await PdfWriter.write(finalPath, pdfBytes);
  }
}
