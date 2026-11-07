import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/domain/documents.dart';

void main() {
  group('jalaliToComparable', () {
    test('parses a padded date into a comparable integer', () {
      expect(jalaliToComparable('1403/07/21'), 14030721);
    });

    test('normalizes zero-padding differences', () {
      expect(jalaliToComparable('1403/7/1'), jalaliToComparable('1403/07/01'));
      expect(jalaliToComparable('1403/7/1'), 14030701);
    });

    test('orders dates chronologically', () {
      final a = jalaliToComparable('1403/01/05')!;
      final b = jalaliToComparable('1403/01/06')!;
      final c = jalaliToComparable('1404/01/01')!;

      expect(a < b, isTrue);
      expect(b < c, isTrue);
    });

    test('returns null for anything that is not a complete date', () {
      expect(jalaliToComparable(''), isNull);
      expect(jalaliToComparable('1403/07'), isNull);
      expect(jalaliToComparable('1403/07/21/01'), isNull);
      expect(jalaliToComparable('1403-07-21'), isNull);
      expect(jalaliToComparable('abcd/ef/gh'), isNull);
      expect(jalaliToComparable('۰/۰/۰'), isNull);
    });

    test('trims surrounding whitespace before parsing', () {
      expect(jalaliToComparable(' 1403/07/21 '), 14030721);
    });

    test('accepts semantically odd but well-formed numbers', () {
      // No calendar validation happens here: it is a sort key, not a date.
      expect(jalaliToComparable('1403/13/40'), 14031340);
      expect(jalaliToComparable('0000/00/00'), 0);
    });
  });

  group('document labels and options', () {
    test('every document type has its Persian label', () {
      expect(DocumentType.outgoing.label, 'صادره');
      expect(DocumentType.incoming.label, 'وارده');
      expect(DocumentType.contract.label, 'قرارداد');
    });

    test('the priority options are the normal and urgent labels, in order', () {
      expect(kPriorityOptions, [kNormalPriority, kUrgentPriority]);
      expect(kNormalPriority, 'عادی');
      expect(kUrgentPriority, 'فوری');
    });

    test('the enum covers exactly the three kinds the app stores', () {
      expect(DocumentType.values, hasLength(3));
    });
  });
}
