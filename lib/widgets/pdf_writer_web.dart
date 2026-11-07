import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';

/// Web implementation: a browser cannot choose a filesystem path, so the
/// PDF is delivered as a download named after the file part of [path].
class PdfWriter {
  PdfWriter._();

  static Future<void> write(String path, Uint8List bytes) {
    var name = path.split(RegExp(r'[\\/]')).last;

    if (name.isEmpty) {
      name = 'document.pdf';
    }

    return XFile.fromData(
      bytes,
      mimeType: 'application/pdf',
      name: name,
    ).saveTo(name);
  }
}
