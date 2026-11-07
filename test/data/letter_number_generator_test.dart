import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'package:flutter_application_1/data/database/collections/letter_counter.dart';
import 'package:flutter_application_1/data/database/database_service.dart';
import 'package:flutter_application_1/domain/documents.dart';
import 'package:flutter_application_1/widgets/letter_number_generator.dart';

import '../support/test_database.dart';

void main() {
  Isar? isar;

  final yearSuffix = (Jalali.now().year % 100).toString().padLeft(2, '0');

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
  });

  final generator = LetterNumberGenerator.instance;

  group(
    'letter numbering',
    skip: isarSkipReason,
    () {
      test('letters start at 3886 and contracts at 10', () async {
        expect(await generator.generate(DocumentType.outgoing), '3886/ص/$yearSuffix');
        expect(await generator.generate(DocumentType.contract), '10/ق/$yearSuffix');
      });

      test('outgoing and incoming letters share one counter', () async {
        expect(await generator.generate(DocumentType.outgoing), '3886/ص/$yearSuffix');
        expect(await generator.generate(DocumentType.incoming), '3887/و/$yearSuffix');
        expect(await generator.generate(DocumentType.outgoing), '3888/ص/$yearSuffix');
      });

      test('contracts keep their own counter', () async {
        await generator.generate(DocumentType.outgoing);

        expect(await generator.generate(DocumentType.contract), '10/ق/$yearSuffix');
        expect(await generator.generate(DocumentType.contract), '11/ق/$yearSuffix');
        // The shared letter counter was not advanced by the contracts.
        expect(await generator.generate(DocumentType.outgoing), '3887/ص/$yearSuffix');
      });

      test('peek previews the next number without reserving it', () async {
        final first = await generator.peekNextNumber(DocumentType.outgoing);
        final second = await generator.peekNextNumber(DocumentType.outgoing);

        expect(first, '3886/ص/$yearSuffix');
        expect(second, first);

        final reserved = await generator.generate(DocumentType.outgoing);

        expect(reserved, first);
        expect(
          await generator.peekNextNumber(DocumentType.outgoing),
          '3887/ص/$yearSuffix',
        );
      });

      test('parallel saves never receive the same number', () async {
        final numbers = await Future.wait([
          generator.generate(DocumentType.outgoing),
          generator.generate(DocumentType.outgoing),
          generator.generate(DocumentType.incoming),
        ]);

        expect(numbers.toSet(), hasLength(3));
        expect(
          numbers.map((n) => n.split('/').first),
          unorderedEquals(['3886', '3887', '3888']),
        );
      });

      test('the counter survives a restart', () async {
        await generator.generate(DocumentType.outgoing);

        // Re-open the same database through a second service instance: the
        // reserved number must still be there afterwards.
        final persisted = await isar!.letterCounters.where().findAll();
        expect(persisted.single.type, 'document');
        expect(persisted.single.value, 3886);
      });
    },
  );
}
