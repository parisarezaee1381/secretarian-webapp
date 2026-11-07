import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/domain/documents.dart';
import 'package:flutter_application_1/widgets/pdf_document.dart';
import 'package:flutter_application_1/widgets/pdf_generator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generate loads the Estedad font and yields %PDF bytes', () async {
    // The font is declared under `fonts:` only — prove the runtime
    // rootBundle path the generator depends on actually resolves.
    final fontData = await rootBundle.load(
      'assets/Estedad/Estedad-VariableFont_wght.ttf',
    );
    expect(fontData.lengthInBytes, greaterThan(0));

    for (final type in DocumentType.values) {
      final bytes = await DocumentPdfGenerator.generate(
        PdfDocumentData(
          type: type,
          letterNumber: '1/ص/05',
          date: '1403/01/01',
          subject: 'عنوان تست',
          tags: const ['تست'],
          organization: 'سازمان',
          recipient: 'گیرنده',
          registrationDate: '1403/01/01',
        ),
      );

      expect(bytes, isNotEmpty, reason: type.name);
      expect(
        String.fromCharCodes(bytes.sublist(0, 4)),
        '%PDF',
        reason: type.name,
      );
    }
  });
}
