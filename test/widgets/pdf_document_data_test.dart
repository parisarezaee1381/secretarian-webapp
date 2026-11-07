import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/domain/documents.dart';
import 'package:flutter_application_1/widgets/pdf_document.dart';

OutgoingLetterDocument outgoing() {
  return OutgoingLetterDocument(
    id: 'o',
    letterNumber: '3886/ص/03',
    date: '1403/01/01',
    subject: 'موضوع صادره',
    tags: ['مالی', 'مهم'],
    organization: 'سازمان الف',
    recipient: 'گیرنده',
    signer: 'امضاکننده',
    actionBy: 'اقدام‌کننده',
    registrationNumber: '12',
    registrationDate: '1403/01/02',
    archiveFolder: 'پوشه ۱',
    priority: kUrgentPriority,
    sendMethod: 'فکس',
    needsFollowUp: true,
    followUpDate: '1403/02/02',
    followUpBy: 'علی',
    saveFile: false,
  );
}

IncomingLetterDocument incoming() {
  return IncomingLetterDocument(
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
    archiveFolder: 'پوشه ۲',
    priority: kNormalPriority,
    needsFollowUp: false,
    saveFile: false,
  );
}

ContractDocument contract() {
  return ContractDocument(
    id: 'c',
    letterNumber: '10/ق/03',
    date: '1403/01/05',
    subject: 'موضوع قرارداد',
    tags: const [],
    organization: 'شرکت پ',
    recipient: 'طرف قرارداد',
    actionBy: 'اقدام قرارداد',
    contractSubject: 'خرید تجهیزات',
    registrationDate: '1403/01/06',
    referenceContractNumber: '9',
    saveFile: false,
  );
}

void main() {
  group('PdfDocumentData', () {
    test('outgoing letters carry their own fields only', () {
      final data = PdfDocumentData.fromOutgoing(outgoing());

      expect(data.type, DocumentType.outgoing);
      expect(data.documentTitle, 'نامه صادره');
      expect(data.signer, 'امضاکننده');
      expect(data.outgoingActionBy, 'اقدام‌کننده');
      expect(data.sendMethod, 'فکس');
      expect(data.needsFollowUp, isTrue);
      expect(data.followUpDate, '1403/02/02');
      expect(data.followUpBy, 'علی');
      expect(data.archiveFolder, 'پوشه ۱');
      expect(data.priority, kUrgentPriority);

      expect(data.sender, isNull);
      expect(data.senderLetterNumber, isNull);
      expect(data.contractSubject, isNull);
      expect(data.referenceContractNumber, isNull);
    });

    test('incoming letters carry sender fields and no signer', () {
      final data = PdfDocumentData.fromIncoming(incoming());

      expect(data.type, DocumentType.incoming);
      expect(data.documentTitle, 'نامه وارده');
      expect(data.sender, 'فرستنده');
      expect(data.senderLetterNumber, '77');
      expect(data.signorOrNull(), isNull);
      expect(data.outgoingActionBy, isNull);
      expect(data.sendMethod, isNull);
      expect(data.contractSubject, isNull);
    });

    test('contracts carry contract fields and no follow-up', () {
      final data = PdfDocumentData.fromContract(contract());

      expect(data.type, DocumentType.contract);
      expect(data.documentTitle, 'قرارداد');
      expect(data.contractSubject, 'خرید تجهیزات');
      expect(data.referenceContractNumber, '9');
      expect(data.contractActionBy, 'اقدام قرارداد');

      expect(data.priority, isNull);
      expect(data.archiveFolder, isNull);
      expect(data.needsFollowUp, isFalse);
      expect(data.followUpDate, isNull);
      expect(data.followUpBy, isNull);
    });

    test('shared fields are copied for every kind', () {
      for (final data in [
        PdfDocumentData.fromOutgoing(outgoing()),
        PdfDocumentData.fromIncoming(incoming()),
        PdfDocumentData.fromContract(contract()),
      ]) {
        expect(data.letterNumber, isNotEmpty);
        expect(data.date, isNotEmpty);
        expect(data.subject, isNotEmpty);
        expect(data.organization, isNotEmpty);
        expect(data.recipient, isNotEmpty);
        expect(data.registrationDate, isNotEmpty);
      }
    });

    test('tags are copied, so later model edits do not leak into a saved PDF', () {
      final document = outgoing();
      final data = PdfDocumentData.fromOutgoing(document);

      expect(data.tags, ['مالی', 'مهم']);
      data.tags.add('new');
      expect(document.tags, ['مالی', 'مهم']);
    });
  });
}

extension on PdfDocumentData {
  /// `signer` is nullable and only meaningful for outgoing letters.
  String? signorOrNull() => signer;
}
