import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'package:flutter_application_1/core/pending_letters_data.dart';
import 'package:flutter_application_1/data/database/collections/contract_document_db.dart';
import 'package:flutter_application_1/data/database/collections/incoming_document_db.dart';
import 'package:flutter_application_1/data/database/collections/outgoing_document_db.dart';
import 'package:flutter_application_1/data/database/database_service.dart';
import 'package:flutter_application_1/data/document_repository.dart';
import 'package:flutter_application_1/domain/documents.dart';

import '../support/test_database.dart';

String _todayJalali() {
  final today = Jalali.now();

  return '${today.year.toString().padLeft(4, '0')}/'
      '${today.month.toString().padLeft(2, '0')}/'
      '${today.day.toString().padLeft(2, '0')}';
}

OutgoingLetterDocument outgoing(
  String id, {
  String date = '1403/01/01',
  bool needsFollowUp = false,
  String? followUpDate,
  String? followUpBy,
  List<AttachmentDocument> attachments = const [],
}) {
  return OutgoingLetterDocument(
    id: id,
    letterNumber: '1/ص/03',
    date: date,
    subject: 'موضوع $id',
    tags: const ['مالی'],
    organization: 'سازمان',
    recipient: 'گیرنده',
    signer: 'امضا',
    actionBy: 'اقدام',
    registrationNumber: '100',
    registrationDate: '1403/01/02',
    archiveFolder: 'پوشه',
    priority: kNormalPriority,
    sendMethod: 'ایمیل',
    needsFollowUp: needsFollowUp,
    followUpDate: followUpDate,
    followUpBy: followUpBy,
    saveFile: false,
    attachments: attachments,
  );
}

IncomingLetterDocument incoming(String id) {
  return IncomingLetterDocument(
    id: id,
    letterNumber: '2/و/03',
    date: '1403/01/01',
    subject: 'وارده $id',
    tags: const [],
    organization: 'سازمان',
    sender: 'فرستنده',
    senderLetterNumber: '55',
    recipient: 'مخاطب',
    registrationDate: '1403/01/02',
    archiveFolder: 'پوشه',
    priority: kUrgentPriority,
    needsFollowUp: false,
    saveFile: false,
  );
}

ContractDocument contract(String id) {
  return ContractDocument(
    id: id,
    letterNumber: '10/ق/03',
    date: '1403/01/01',
    subject: 'قرارداد $id',
    tags: const [],
    organization: 'شرکت',
    recipient: 'طرف قرارداد',
    actionBy: 'اقدام',
    contractSubject: 'موضوع قرارداد',
    registrationDate: '1403/01/02',
    referenceContractNumber: '9',
    saveFile: false,
  );
}

void main() {
  final repository = DocumentRepository.instance;

  Isar? isar;

  setUpAll(() async {
    if (isarSkipReason != null) return;

    isar = await openTestIsar();
    DatabaseService.instance.useDatabaseForTesting(isar);
  });

  tearDownAll(() async {
    await isar?.close(deleteFromDisk: true);
    DatabaseService.instance.useDatabaseForTesting(null);
  });

  setUp(() async {
    if (isar == null) return;

    await clearTestDatabase(isar!);

    // Reload every kind so the singleton's in-memory lists (and the pending
    // counter) start empty even when a previous test left data behind.
    await repository.loadOutgoingFromDatabase();
    await repository.loadIncomingFromDatabase();
    await repository.loadContractsFromDatabase();
  });

  group(
    'adding documents',
    skip: isarSkipReason,
    () {
      test('an added document is persisted and mirrored in memory', () async {
        var notifications = 0;
        void listener() => notifications++;

        repository.addListener(listener);
        await repository.addOutgoing(outgoing('a1'));
        repository.removeListener(listener);

        expect(repository.outgoingLetters, hasLength(1));
        expect(repository.outgoingLetters.single.id, 'a1');
        expect(notifications, 1);

        final rows = await isar!.outgoingDocumentDbs.where().findAll();
        expect(rows, hasLength(1));
        expect(rows.single.documentId, 'a1');
        expect(rows.single.createdAt, isNotNull);
      });

      test('a duplicate id is skipped instead of stored twice', () async {
        await repository.addOutgoing(outgoing('dup'));
        await repository.addOutgoing(outgoing('dup'));

        expect(repository.outgoingLetters, hasLength(1));

        await repository.loadOutgoingFromDatabase();
        expect(repository.outgoingLetters, hasLength(1));
        expect(await isar!.outgoingDocumentDbs.count(), 1);
      });

      test('incoming and contract documents are stored per collection', () async {
        await repository.addIncoming(incoming('i1'));
        await repository.addContract(contract('c1'));

        expect(repository.incomingLetters.single.id, 'i1');
        expect(repository.contracts.single.id, 'c1');
        expect(await isar!.incomingDocumentDbs.count(), 1);
        expect(await isar!.contractDocumentDbs.count(), 1);
      });
    },
  );

  group(
    'updating documents',
    skip: isarSkipReason,
    () {
      test('an update rewrites the row and keeps its identity', () async {
        await repository.addOutgoing(outgoing('u1'));

        final before = (await isar!.outgoingDocumentDbs.where().findAll()).single;

        await repository.updateOutgoing(
          'u1',
          outgoing('u1', date: '1403/05/05').copyWith(subject: 'ویرایش شد'),
        );

        final after = (await isar!.outgoingDocumentDbs.where().findAll()).single;

        expect(after.id, before.id, reason: 'Isar id must be reused');
        expect(after.createdAt, before.createdAt);
        expect(after.subject, 'ویرایش شد');
        expect(repository.outgoingLetters.single.subject, 'ویرایش شد');
        expect(repository.outgoingLetters.single.date, '1403/05/05');
      });

      test('updating a document that is not in the database throws', () async {
        await expectLater(
          repository.updateOutgoing('missing', outgoing('missing')),
          throwsA(isA<StateError>()),
        );

        expect(repository.outgoingLetters, isEmpty);
      });
    },
  );

  group(
    'deleting documents',
    skip: isarSkipReason,
    () {
      test('deleting removes the row and the in-memory copy', () async {
        await repository.addOutgoing(outgoing('d1'));

        await repository.deleteOutgoing('d1');

        expect(repository.outgoingLetters, isEmpty);
        expect(await isar!.outgoingDocumentDbs.count(), 0);
      });

      test('deleting an unknown id is a no-op that still notifies', () async {
        var notifications = 0;
        void listener() => notifications++;

        repository.addListener(listener);
        await repository.deleteOutgoing('nope');
        repository.removeListener(listener);

        expect(notifications, 1);
        expect(repository.outgoingLetters, isEmpty);
      });
    },
  );

  group(
    'attachments',
    skip: isarSkipReason,
    () {
      test('bytes and paths survive a save/load round trip', () async {
        await repository.addOutgoing(
          outgoing(
            'att',
            attachments: [
              AttachmentDocument(name: 'scan.pdf', bytes: Uint8List.fromList([1, 2, 3])),
              const AttachmentDocument(name: 'file.pdf', path: r'C:\tmp\f.pdf'),
            ],
          ),
        );

        await repository.loadOutgoingFromDatabase();

        final loaded = repository.outgoingLetters.single;
        expect(loaded.attachments, hasLength(2));
        expect(loaded.attachments.first.bytes, [1, 2, 3]);
        expect(loaded.attachments.last.path, r'C:\tmp\f.pdf');
      });

      test('stored attachments with neither bytes nor path are dropped', () async {
        // A row written by an older build: name only, nothing usable.
        await isar!.writeTxn(() async {
          await isar!.outgoingDocumentDbs.put(
            OutgoingDocumentDb()
              ..createdAt = DateTime.now()
              ..documentId = 'legacy'
              ..letterNumber = '1/ص/03'
              ..date = '1403/01/01'
              ..subject = 'قدیمی'
              ..tags = []
              ..organization = 'سازمان'
              ..recipient = 'گیرنده'
              ..signer = 'امضا'
              ..actionBy = 'اقدام'
              ..registrationNumber = '1'
              ..registrationDate = '1403/01/02'
              ..archiveFolder = 'پوشه'
              ..priority = kNormalPriority
              ..sendMethod = 'ایمیل'
              ..needsFollowUp = false
              ..saveFile = false
              ..attachments = [AttachmentDocumentDb()..name = 'orphan.pdf'],
          );
        });

        await repository.loadOutgoingFromDatabase();

        expect(repository.outgoingLetters.single.id, 'legacy');
        expect(repository.outgoingLetters.single.attachments, isEmpty);
      });
    },
  );

  group(
    'loading',
    skip: isarSkipReason,
    () {
      test('a load replaces the list with exactly what is stored', () async {
        await repository.addOutgoing(outgoing('keep'));

        // A row written behind the repository's back must appear after load.
        await isar!.writeTxn(() async {
          await isar!.outgoingDocumentDbs.put(
            OutgoingDocumentDb()
              ..createdAt = DateTime.now()
              ..documentId = 'external'
              ..letterNumber = '9/ص/03'
              ..date = '1403/02/02'
              ..subject = 'خارجی'
              ..tags = []
              ..organization = 'سازمان'
              ..recipient = 'گیرنده'
              ..signer = 'امضا'
              ..actionBy = 'اقدام'
              ..registrationNumber = '9'
              ..registrationDate = '1403/02/02'
              ..archiveFolder = 'پوشه'
              ..priority = kNormalPriority
              ..sendMethod = 'ایمیل'
              ..needsFollowUp = false
              ..saveFile = false,
          );
        });

        await repository.loadOutgoingFromDatabase();

        expect(
          repository.outgoingLetters.map((d) => d.id),
          unorderedEquals(['keep', 'external']),
        );
      });

      test('getLatest sorts by date, newest first, limited to count', () async {
        await repository.addOutgoing(outgoing('old', date: '1403/01/05'));
        await repository.addOutgoing(outgoing('new', date: '1403/01/07'));
        await repository.addOutgoing(outgoing('mid', date: '1403/01/06'));

        expect(
          repository.getLatest(10).map((d) => d.id),
          ['new', 'mid', 'old'],
        );
        expect(repository.getLatest(2), hasLength(2));
        expect(repository.getLatest(2).first.id, 'new');
      });

      test('equal dates fall back to newest inserted first', () async {
        await repository.addOutgoing(outgoing('first', date: '1403/03/03'));
        await repository.addOutgoing(outgoing('second', date: '1403/03/03'));

        expect(
          repository.getLatest(2).map((d) => d.id),
          ['second', 'first'],
        );
      });

      test('getLatest mixes document kinds', () async {
        await repository.addIncoming(
          incoming('i-new').copyWith(date: '1403/06/06'),
        );
        await repository.addOutgoing(outgoing('o-old', date: '1403/01/01'));

        final latest = repository.getLatest(5);
        expect(latest, hasLength(2));
        expect(latest.first, isA<IncomingLetterDocument>());
        expect(latest.last, isA<OutgoingLetterDocument>());
      });
    },
  );

  group(
    'today\'s pending count',
    skip: isarSkipReason,
    () {
      test('only follow-ups dated today with a responsible person count', () async {
        final today = _todayJalali();

        await repository.addOutgoing(
          outgoing('p1', needsFollowUp: true, followUpDate: today, followUpBy: 'علی'),
        );
        await repository.addIncoming(
          incoming('p2').copyWith(
            needsFollowUp: true,
            followUpDate: today,
            followUpBy: 'سارا',
          ),
        );

        expect(PendingLettersData.count.value, 2);
      });

      test('missing follow-up date, past dates and blank owners do not count', () async {
        final today = _todayJalali();

        await repository.addOutgoing(
          outgoing('n1', needsFollowUp: true, followUpBy: 'علی'),
        );
        await repository.addOutgoing(
          outgoing('n2', needsFollowUp: true, followUpDate: '1403/01/01', followUpBy: 'علی'),
        );
        await repository.addOutgoing(
          outgoing('n3', needsFollowUp: true, followUpDate: today, followUpBy: '   '),
        );

        expect(PendingLettersData.count.value, 0);
      });

      test('an unpadded follow-up date never matches today', () async {
        final today = _todayJalali();
        final parts = today.split('/');
        final unpadded =
            '${parts[0]}/${int.parse(parts[1])}/${int.parse(parts[2])}';

        await repository.addOutgoing(
          outgoing('u', needsFollowUp: true, followUpDate: unpadded, followUpBy: 'علی'),
        );

        // Documents which behaviour is current: the counter compares zero-padded
        // strings, so a manually typed `1403/7/1` is invisible to it.
        expect(PendingLettersData.count.value, 0);
      });

      test('contracts never count as pending', () async {
        await repository.addContract(contract('c'));

        expect(PendingLettersData.count.value, 0);
      });

      test('the count drops again when the letter is deleted', () async {
        final today = _todayJalali();

        await repository.addOutgoing(
          outgoing('p', needsFollowUp: true, followUpDate: today, followUpBy: 'علی'),
        );
        expect(PendingLettersData.count.value, 1);

        await repository.deleteOutgoing('p');
        expect(PendingLettersData.count.value, 0);
      });

      test('editing a letter into a pending one updates the count', () async {
        await repository.addOutgoing(outgoing('e'));
        expect(PendingLettersData.count.value, 0);

        await repository.updateOutgoing(
          'e',
          outgoing('e', needsFollowUp: true, followUpDate: _todayJalali(), followUpBy: 'علی'),
        );

        expect(PendingLettersData.count.value, 1);
      });
    },
  );

  group(
    'write failures',
    skip: isarSkipReason,
    () {
      test('a failed write leaves memory untouched and rethrows', () async {
        await repository.addOutgoing(outgoing('kept'));
        expect(repository.outgoingLetters, hasLength(1));

        // Drop the database: the next write cannot open one (no path_provider
        // in the test VM), so the repository must not touch its lists.
        DatabaseService.instance.useDatabaseForTesting(null);

        try {
          await expectLater(
            repository.addOutgoing(outgoing('lost')),
            throwsA(anything),
          );

          expect(repository.outgoingLetters, hasLength(1));
          expect(repository.outgoingLetters.single.id, 'kept');
        } finally {
          DatabaseService.instance.useDatabaseForTesting(isar);
        }
      });
    },
  );
}
