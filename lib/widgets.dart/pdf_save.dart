import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';

import 'pdf_generator.dart';
import 'pdf_document.dart';

class SavePdfWidget {
  SavePdfWidget._();

  /// فقط مسیر ذخیره را از کاربر می‌گیرد.
  /// در این مرحله PDF ساخته نمی‌شود.
  static Future<String?> chooseSaveLocation({
    required PdfDocumentData document,
    String? suggestedFileName,
  }) async {
    final String fileName = _buildFileName(
      document,
      suggestedFileName,
    );

    const XTypeGroup pdfType = XTypeGroup(
      label: 'PDF',
      extensions: <String>['pdf'],
      mimeTypes: <String>['application/pdf'],
    );

    final FileSaveLocation? location = await getSaveLocation(
      suggestedName: fileName,
      acceptedTypeGroups: <XTypeGroup>[pdfType],
    );

    if (location == null) {
      return null;
    }

    String path = location.path;

    if (!path.toLowerCase().endsWith('.pdf')) {
      path = '$path.pdf';
    }

    return path;
  }

  /// PDF را تولید می‌کند و در مسیر انتخاب‌شده ذخیره می‌کند.
  static Future<void> savePdf({
    required PdfDocumentData document,
    required String path,
  }) async {
    final Uint8List pdfBytes =
        await DocumentPdfGenerator.generate(document);

    final file = XFile.fromData(
      pdfBytes,
      name: path.split(RegExp(r'[\\/]')).last,
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
      final name = suggestedFileName.trim();

      if (name.toLowerCase().endsWith('.pdf')) {
        return name;
      }

      return '$name.pdf';
    }

    final number = document.letterNumber.trim();

    if (number.isNotEmpty) {
      return '$number.pdf';
    }

    return 'document.pdf';
  }
}