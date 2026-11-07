import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter_application_1/domain/documents.dart';
import 'package:flutter_test/flutter_test.dart';

// Builders deliberately set every field (including the nullable ones) to a
// known value so tests can both mutate and clear each one.
OutgoingLetterDocument buildOutgoing() => OutgoingLetterDocument(
      id: '1',
      letterNumber: 'L-1',
      date: '2024-01-01',
      subject: 'Subject',
      tags: const ['a', 'b'],
      organization: 'Org',
      recipient: 'Rec',
      signer: 'Signer',
      actionBy: 'Actor',
      registrationNumber: 'R-1',
      registrationDate: '2024-01-02',
      archiveFolder: 'Folder',
      priority: 'عادي',
      sendMethod: 'Post',
      needsFollowUp: true,
      followUpDate: '2024-02-01',
      followUpBy: 'Person',
      saveFile: true,
      filePath: '/path/to/file',
      attachments: const [AttachmentDocument(name: 'a.txt', path: '/a.txt')],
    );

IncomingLetterDocument buildIncoming() => IncomingLetterDocument(
      id: '2',
      letterNumber: 'L-2',
      date: '2024-01-03',
      subject: 'Subject',
      tags: const ['c'],
      organization: 'Org',
      sender: 'Sender',
      senderLetterNumber: 'SL-1',
      recipient: 'Rec',
      registrationDate: '2024-01-04',
      archiveFolder: 'Folder',
      priority: 'عادي',
      needsFollowUp: true,
      followUpDate: '2024-02-02',
      followUpBy: 'Person',
      saveFile: true,
      filePath: '/path/to/file',
      attachments: const [AttachmentDocument(name: 'b.txt', path: '/b.txt')],
    );

ContractDocument buildContract() => ContractDocument(
      id: '3',
      letterNumber: 'L-3',
      date: '2024-01-05',
      subject: 'Subject',
      tags: const ['d'],
      organization: 'Org',
      recipient: 'Rec',
      actionBy: 'Actor',
      contractSubject: 'Contract subject',
      registrationDate: '2024-01-06',
      referenceContractNumber: 'RC-1',
      saveFile: true,
      filePath: '/path/to/file',
      attachments: const [AttachmentDocument(name: 'c.txt', path: '/c.txt')],
    );

void main() {
  group('OutgoingLetterDocument', () {
    late OutgoingLetterDocument base;
    setUp(() => base = buildOutgoing());

    test('value equality and hashCode', () {
      final same = buildOutgoing();
      expect(base, same);
      expect(base.hashCode, same.hashCode);
    });

    test('copyWith() with no arguments is a no-op', () {
      expect(base.copyWith(), base);
    });

    test('every field participates in == (guards the sync hazard)', () {
      final mutations = <String, OutgoingLetterDocument>{
        'id': base.copyWith(id: 'x'),
        'letterNumber': base.copyWith(letterNumber: 'x'),
        'date': base.copyWith(date: 'x'),
        'subject': base.copyWith(subject: 'x'),
        'tags': base.copyWith(tags: const ['z']),
        'organization': base.copyWith(organization: 'x'),
        'recipient': base.copyWith(recipient: 'x'),
        'signer': base.copyWith(signer: 'x'),
        'actionBy': base.copyWith(actionBy: 'x'),
        'registrationNumber': base.copyWith(registrationNumber: 'x'),
        'registrationDate': base.copyWith(registrationDate: 'x'),
        'archiveFolder': base.copyWith(archiveFolder: 'x'),
        'priority': base.copyWith(priority: 'x'),
        'sendMethod': base.copyWith(sendMethod: 'x'),
        'needsFollowUp': base.copyWith(needsFollowUp: false),
        'followUpDate': base.copyWith(followUpDate: 'x'),
        'followUpBy': base.copyWith(followUpBy: 'x'),
        'saveFile': base.copyWith(saveFile: false),
        'filePath': base.copyWith(filePath: 'x'),
        'attachments': base.copyWith(attachments: const []),
      };
      mutations.forEach((field, changed) {
        expect(changed, isNot(base), reason: 'changing `$field` must change ==');
      });
    });

    test('copyWith preserves fields it is not given', () {
      final changed = base.copyWith(subject: 'new');
      expect(changed.subject, 'new');
      expect(changed.id, base.id);
      expect(changed.tags, base.tags);
      expect(changed.signer, base.signer);
      expect(changed.attachments, base.attachments);
    });

    test('nullable fields can be cleared with copyWith(null)', () {
      final cleared =
          base.copyWith(followUpDate: null, followUpBy: null, filePath: null);
      expect(cleared.followUpDate, isNull);
      expect(cleared.followUpBy, isNull);
      expect(cleared.filePath, isNull);
      expect(cleared, isNot(base));
      expect(cleared.id, base.id);
    });
  });

  group('IncomingLetterDocument', () {
    late IncomingLetterDocument base;
    setUp(() => base = buildIncoming());

    test('value equality and hashCode', () {
      final same = buildIncoming();
      expect(base, same);
      expect(base.hashCode, same.hashCode);
    });

    test('copyWith() with no arguments is a no-op', () {
      expect(base.copyWith(), base);
    });

    test('every field participates in == (guards the sync hazard)', () {
      final mutations = <String, IncomingLetterDocument>{
        'id': base.copyWith(id: 'x'),
        'letterNumber': base.copyWith(letterNumber: 'x'),
        'date': base.copyWith(date: 'x'),
        'subject': base.copyWith(subject: 'x'),
        'tags': base.copyWith(tags: const ['z']),
        'organization': base.copyWith(organization: 'x'),
        'sender': base.copyWith(sender: 'x'),
        'senderLetterNumber': base.copyWith(senderLetterNumber: 'x'),
        'recipient': base.copyWith(recipient: 'x'),
        'registrationDate': base.copyWith(registrationDate: 'x'),
        'archiveFolder': base.copyWith(archiveFolder: 'x'),
        'priority': base.copyWith(priority: 'x'),
        'needsFollowUp': base.copyWith(needsFollowUp: false),
        'followUpDate': base.copyWith(followUpDate: 'x'),
        'followUpBy': base.copyWith(followUpBy: 'x'),
        'saveFile': base.copyWith(saveFile: false),
        'filePath': base.copyWith(filePath: 'x'),
        'attachments': base.copyWith(attachments: const []),
      };
      mutations.forEach((field, changed) {
        expect(changed, isNot(base), reason: 'changing `$field` must change ==');
      });
    });

    test('nullable fields can be cleared with copyWith(null)', () {
      final cleared =
          base.copyWith(followUpDate: null, followUpBy: null, filePath: null);
      expect(cleared.followUpDate, isNull);
      expect(cleared.followUpBy, isNull);
      expect(cleared.filePath, isNull);
      expect(cleared, isNot(base));
    });
  });

  group('ContractDocument', () {
    late ContractDocument base;
    setUp(() => base = buildContract());

    test('value equality and hashCode', () {
      final same = buildContract();
      expect(base, same);
      expect(base.hashCode, same.hashCode);
    });

    test('copyWith() with no arguments is a no-op', () {
      expect(base.copyWith(), base);
    });

    test('every field participates in == (guards the sync hazard)', () {
      final mutations = <String, ContractDocument>{
        'id': base.copyWith(id: 'x'),
        'letterNumber': base.copyWith(letterNumber: 'x'),
        'date': base.copyWith(date: 'x'),
        'subject': base.copyWith(subject: 'x'),
        'tags': base.copyWith(tags: const ['z']),
        'organization': base.copyWith(organization: 'x'),
        'recipient': base.copyWith(recipient: 'x'),
        'actionBy': base.copyWith(actionBy: 'x'),
        'contractSubject': base.copyWith(contractSubject: 'x'),
        'registrationDate': base.copyWith(registrationDate: 'x'),
        'referenceContractNumber': base.copyWith(referenceContractNumber: 'x'),
        'saveFile': base.copyWith(saveFile: false),
        'filePath': base.copyWith(filePath: 'x'),
        'attachments': base.copyWith(attachments: const []),
      };
      mutations.forEach((field, changed) {
        expect(changed, isNot(base), reason: 'changing `$field` must change ==');
      });
    });

    test('nullable filePath can be cleared with copyWith(null)', () {
      final cleared = base.copyWith(filePath: null);
      expect(cleared.filePath, isNull);
      expect(cleared, isNot(base));
    });
  });

  group('AttachmentDocument', () {
    test('value equality (bytes compared by content)', () {
      final a = AttachmentDocument(name: 'f', path: '/f', bytes: Uint8List.fromList([1, 2, 3]));
      final b = AttachmentDocument(name: 'f', path: '/f', bytes: Uint8List.fromList([1, 2, 3]));
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('different bytes are not equal', () {
      final a = AttachmentDocument(name: 'f', bytes: Uint8List.fromList([1, 2, 3]));
      final b = AttachmentDocument(name: 'f', bytes: Uint8List.fromList([9, 9, 9]));
      expect(a, isNot(b));
    });

    test('asserts that at least path or bytes is provided (debug only)', () {
      expect(
        () => AttachmentDocument(name: 'f'),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
