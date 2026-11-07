import 'dart:io';
import 'dart:typed_data';

/// Desktop/mobile implementation: writes [bytes] to [path] and flushes so
/// the file is durable as soon as the future completes.
class PdfWriter {
  PdfWriter._();

  static Future<void> write(String path, Uint8List bytes) =>
      File(path).writeAsBytes(bytes, flush: true);
}
