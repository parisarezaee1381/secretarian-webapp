import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as p;

import 'pdf_generator.dart';
import 'pdf_document.dart';

class SavePdfWidget {
  SavePdfWidget._();

  static Future<String?> chooseSaveFolder() async {
    final String? folderPath = await getDirectoryPath(
      confirmButtonText: 'انتخاب پوشه',
    );

    return folderPath;
  }

static String buildFilePath({
  required String folderPath,
  required PdfDocumentData document,
  String? suggestedFileName,
}) {
  final fileName = _buildFileName(
    document,
    suggestedFileName,
  );

  return p.join(folderPath, fileName);
}

  static Future<void> savePdf({
    required PdfDocumentData document,
    required String path,
  }) async {
    final Uint8List pdfBytes =
        await DocumentPdfGenerator.generate(document);

    final XFile file = XFile.fromData(
      pdfBytes,
      name: p.basename(path),
      mimeType: 'application/pdf',
    );

    await file.saveTo(path);
  }

  static String _buildFileName(
    PdfDocumentData document,
    String? suggestedFileName,
  ) {
    if (suggestedFileName != null &&
        suggestedFileName.trim().isNotEmpty) {
      final String name = suggestedFileName.trim();

      if (name.toLowerCase().endsWith('.pdf')) {
        return name;
      }

      return '$name.pdf';
    }

    final String number = document.letterNumber.trim();

    if (number.isNotEmpty) {
      return '$number.pdf';
    }

    return 'document.pdf';
  }
}