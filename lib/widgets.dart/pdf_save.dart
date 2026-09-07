import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';

import 'pdf_generator.dart';
import 'pdf_document.dart';

class SavePdfWidget {
  SavePdfWidget._();

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
    final Uint8List pdfBytes = await DocumentPdfGenerator.generate(document);

    String finalPath = path;

    if (!finalPath.toLowerCase().endsWith('.pdf')) {
      finalPath = '$finalPath.pdf';
    }

    final File file = File(finalPath);

    await file.writeAsBytes(pdfBytes, flush: true);
  }
}
