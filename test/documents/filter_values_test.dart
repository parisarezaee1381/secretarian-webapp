import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/documents/filter.dart';
import 'package:flutter_application_1/domain/documents.dart';

FilterValues values({
  String letterNumber = '',
  String fromDate = '',
  String toDate = '',
  String title = '',
  String organization = '',
  String? priority,
  List<String> keywords = const [],
}) {
  return FilterValues(
    letterNumber: letterNumber,
    fromDate: fromDate,
    toDate: toDate,
    title: title,
    organization: organization,
    priority: priority,
    keywords: keywords,
  );
}

void main() {
  group('FilterValues.isEmpty', () {
    test('is true when nothing is set', () {
      expect(values().isEmpty, isTrue);
    });

    test('is false for each field on its own', () {
      expect(values(letterNumber: '1').isEmpty, isFalse);
      expect(values(fromDate: '1403/01/01').isEmpty, isFalse);
      expect(values(toDate: '1403/01/01').isEmpty, isFalse);
      expect(values(title: 'عنوان').isEmpty, isFalse);
      expect(values(organization: 'سازمان').isEmpty, isFalse);
      expect(values(priority: kUrgentPriority).isEmpty, isFalse);
      expect(values(keywords: ['مالی']).isEmpty, isFalse);
    });
  });

  group('FilterValues equality', () {
    test('two instances with the same values are equal', () {
      final a = values(title: 'x', keywords: ['a', 'b']);
      final b = values(title: 'x', keywords: ['a', 'b']);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('any difference breaks equality', () {
      final base = values(title: 'x', keywords: ['a']);

      expect(base == values(title: 'y', keywords: ['a']), isFalse);
      expect(base == values(title: 'x', keywords: ['b']), isFalse);
      expect(base == values(title: 'x', keywords: ['a', 'b']), isFalse);
      expect(base == values(title: 'x', keywords: ['a'], priority: 'عادی'), isFalse);
    });

    test('keyword order matters', () {
      expect(
        values(keywords: ['a', 'b']) == values(keywords: ['b', 'a']),
        isFalse,
      );
    });
  });

  group('FilterValues.keywords', () {
    test('is an unmodifiable copy of the list it was built from', () {
      final working = ['a'];
      final snapshot = values(keywords: working);

      working.add('b');

      expect(snapshot.keywords, ['a'], reason: 'not aliased');
      expect(() => snapshot.keywords.add('c'), throwsUnsupportedError);
    });
  });
}
