import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/domain/documents.dart';
import 'package:flutter_application_1/widgets/table.dart';

OutgoingLetterDocument outgoing({List<AttachmentDocument> attachments = const []}) {
  return OutgoingLetterDocument(
    id: 'o',
    letterNumber: '3886/ص/03',
    date: '1403/01/01',
    subject: 'موضوع صادره',
    tags: const [],
    organization: 'سازمان الف',
    recipient: 'گیرنده',
    signer: 'امضا',
    actionBy: 'اقدام',
    registrationNumber: '12',
    registrationDate: '1403/01/02',
    archiveFolder: 'پوشه',
    priority: kUrgentPriority,
    sendMethod: 'ایمیل',
    needsFollowUp: false,
    saveFile: false,
    attachments: attachments,
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
    archiveFolder: 'پوشه',
    priority: kNormalPriority,
    needsFollowUp: true,
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
    actionBy: 'اقدام',
    contractSubject: 'خرید',
    registrationDate: '1403/01/06',
    referenceContractNumber: '9',
    saveFile: false,
  );
}

void main() {
  group('DocumentTableRow', () {
    test('maps an outgoing letter onto the five columns', () {
      final row = DocumentTableRow.fromOutgoing(outgoing());

      expect(row.number, '3886/ص/03');
      expect(row.organization, 'سازمان الف');
      expect(row.title, 'موضوع صادره');
      expect(row.priority, kUrgentPriority);
      expect(row.hasAttachments, isFalse);
    });

    test('maps an incoming letter', () {
      final row = DocumentTableRow.fromIncoming(incoming());

      expect(row.number, '3887/و/03');
      expect(row.organization, 'سازمان ب');
      expect(row.title, 'موضوع وارده');
      expect(row.priority, kNormalPriority);
    });

    test('contracts fall back to the normal priority', () {
      // Contracts carry no priority of their own; the table shows «عادی».
      expect(DocumentTableRow.fromContract(contract()).priority, kNormalPriority);
    });

    test('reports attachments when there is at least one', () {
      final row = DocumentTableRow.fromOutgoing(
        outgoing(
          attachments: const [
            AttachmentDocument(name: 'a.pdf', path: '/tmp/a.pdf'),
          ],
        ),
      );

      expect(row.hasAttachments, isTrue);
    });

    test('passes the callbacks through untouched', () {
      var edited = 0;
      Future<void> deleted() async {}

      final row = DocumentTableRow.fromOutgoing(
        outgoing(),
        onEdit: () => edited++,
        onDelete: deleted,
      );

      row.onEdit!();
      expect(edited, 1);
      expect(row.onDelete, same(deleted));
      expect(row.onAddAttachment, isNull);
    });
  });
}
