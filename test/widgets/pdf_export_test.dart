import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/domain/documents.dart';
import 'package:flutter_application_1/widgets/pdf_document.dart';
import 'package:flutter_application_1/widgets/pdf_generator.dart';
import 'package:flutter_application_1/widgets/pdf_save.dart';

OutgoingLetterDocument outgoing() => OutgoingLetterDocument(
  id: 'o',
  letterNumber: '3886/ص/03',
  date: '1403/01/01',
  subject: 'موضوع صادره',
  tags: const ['مالی'],
  organization: 'سازمان الف',
  recipient: 'گیرنده',
  signer: 'امضا',
  actionBy: 'اقدام',
  registrationNumber: '12',
  registrationDate: '1403/01/02',
  archiveFolder: 'پوشه',
  priority: kUrgentPriority,
  sendMethod: 'ایمیل',
  needsFollowUp: true,
  followUpDate: '1403/02/02',
  followUpBy: 'علی',
  saveFile: false,
);

IncomingLetterDocument incoming() => IncomingLetterDocument(
  id: 'i',
  letterNumber: '3887/و/03',
  date: '1403/01/03',
  subject: 'موضوع وارده',
  tags: const [],
  organization: 'سازمان ب',
  sender: 'فرستنده',
  senderLetterNumber: '77',
  recipient: 'مخاطب',
  registrationDate: '1403/01/04',
  archiveFolder: 'پوشه',
  priority: kNormalPriority,
  needsFollowUp: false,
  saveFile: false,
);

ContractDocument contract() => ContractDocument(
  id: 'c',
  letterNumber: '10/ق/03',
  date: '1403/01/05',
  subject: 'موضوع قرارداد',
  tags: const [],
  organization: 'شرکت پ',
  recipient: 'طرف',
  actionBy: 'اقدام',
  contractSubject: 'خرید',
  registrationDate: '1403/01/06',
  referenceContractNumber: '9',
  saveFile: false,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('pdf_export_');
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('generation', () {
    test('every document kind produces a PDF', () async {
      final documents = <PdfDocumentData>[
        PdfDocumentData.fromOutgoing(outgoing()),
        PdfDocumentData.fromIncoming(incoming()),
        PdfDocumentData.fromContract(contract()),
      ];

      for (final data in documents) {
        final bytes = await DocumentPdfGenerator.generate(data);

        expect(bytes, isNotEmpty);
        expect(String.fromCharCodes(bytes.take(4)), '%PDF', reason: data.documentTitle);
      }
    });

    test('a document without optional fields still renders', () async {
      final minimal = PdfDocumentData.fromContract(contract());

      final bytes = await DocumentPdfGenerator.generate(minimal);

      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });
  });

  group('saving', () {
    test('a missing .pdf extension is appended', () async {
      final requested = '${tempDir.path}${Platform.pathSeparator}letter';

      await PdfSaver.savePdf(
        document: PdfDocumentData.fromOutgoing(outgoing()),
        path: requested,
      );

      final written = File('$requested.pdf');
      expect(written.existsSync(), isTrue);
      expect(File(requested).existsSync(), isFalse);

      final bytes = await written.readAsBytes();
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });

    test('an existing .pdf extension is kept as-is', () async {
      final requested = '${tempDir.path}${Platform.pathSeparator}letter.pdf';

      await PdfSaver.savePdf(
        document: PdfDocumentData.fromIncoming(incoming()),
        path: requested,
      );

      expect(File(requested).existsSync(), isTrue);
      expect(File('$requested.pdf').existsSync(), isFalse);
    });

    test('an upper-case extension is not doubled either', () async {
      final requested = '${tempDir.path}${Platform.pathSeparator}Letter.PDF';

      await PdfSaver.savePdf(
        document: PdfDocumentData.fromContract(contract()),
        path: requested,
      );

      expect(File(requested).existsSync(), isTrue);
      expect(File('$requested.pdf').existsSync(), isFalse);
    });

    test('the file is complete and non-trivial', () async {
      final requested = '${tempDir.path}${Platform.pathSeparator}full.pdf';

      await PdfSaver.savePdf(
        document: PdfDocumentData.fromOutgoing(outgoing()),
        path: requested,
      );

      final bytes = await File(requested).readAsBytes();

      expect(bytes.length, greaterThan(1000));
      expect(String.fromCharCodes(bytes.sublist(bytes.length - 5).where((b) => b > 32)), contains('EOF'));
    });
  });
}
