import 'dart:typed_data';

import 'package:flutter_application_1/attachments/scanner_pdf.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

Uint8List _png({required int width, required int height}) {
  final image = img.Image(width: width, height: height, numChannels: 3);
  return Uint8List.fromList(img.encodePng(image));
}

void main() {
  test('buildPdf stitches scanned pages into one multi-page PDF', () async {
    final pages = <Uint8List>[
      _png(width: 100, height: 140),
      _png(width: 200, height: 100),
      _png(width: 100, height: 140),
    ];

    final pdf = await ScannerPdf.buildPdf(pages);

    expect(pdf, isNotEmpty);
    final text = String.fromCharCodes(pdf);
    expect(text.startsWith('%PDF-'), isTrue);
    expect(text.trim().endsWith('%%EOF'), isTrue);

    // One page object per scanned page (page dicts are written uncompressed).
    expect(RegExp('/Type\\s*/Page(?!s)').allMatches(text).length, 3);
  });

  test('buildPdf rejects an empty page list', () {
    expect(ScannerPdf.buildPdf(const <Uint8List>[]), throwsArgumentError);
  });
}
