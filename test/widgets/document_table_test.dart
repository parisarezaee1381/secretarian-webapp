import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/widgets/table.dart';

Future<void> pumpTable(WidgetTester tester, Widget table) async {
  tester.view.physicalSize = const Size(1600, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      builder: (_, _) => MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: table)),
      ),
    ),
  );
  await tester.pump();
}

DocumentTableRow row(int index, {bool hasAttachments = false}) {
  return DocumentTableRow(
    number: 'N$index',
    organization: 'ORG$index',
    title: 'TITLE$index',
    priority: 'عادی',
    hasAttachments: hasAttachments,
  );
}

List<DocumentTableRow> rows(int count) =>
    List.generate(count, (i) => row(i));

void main() {
  group('layout', () {
    testWidgets('renders the five Persian headers in order', (tester) async {
      await pumpTable(tester, DocumentTable(rows: rows(1)));

      for (final header in [
        'شماره',
        'سازمان/شرکت',
        'عنوان/خلاصه',
        'اولویت',
        'عملیات',
      ]) {
        expect(find.text(header), findsOneWidget, reason: header);
      }
    });

    testWidgets('renders the row cells', (tester) async {
      await pumpTable(tester, DocumentTable(rows: rows(2)));

      expect(find.text('N0'), findsOneWidget);
      expect(find.text('ORG0'), findsOneWidget);
      expect(find.text('TITLE0'), findsOneWidget);
      expect(find.text('N1'), findsOneWidget);
    });

    testWidgets('an empty table renders headers only', (tester) async {
      await pumpTable(tester, DocumentTable(rows: const []));

      expect(find.text('شماره'), findsOneWidget);
      expect(find.text('N0'), findsNothing);
    });
  });

  group('paging', () {
    testWidgets('a page holds at most rowsPerPage rows', (tester) async {
      await pumpTable(
        tester,
        DocumentTable(rows: rows(12), rowsPerPage: 10),
      );

      expect(find.text('TITLE9'), findsOneWidget);
      expect(find.text('TITLE10'), findsNothing);
    });

    testWidgets('the slice follows currentPage', (tester) async {
      await pumpTable(
        tester,
        DocumentTable(rows: rows(12), rowsPerPage: 10, currentPage: 2),
      );

      expect(find.text('TITLE10'), findsOneWidget);
      expect(find.text('TITLE11'), findsOneWidget);
      expect(find.text('TITLE0'), findsNothing);
    });

    testWidgets('the page bar is hidden unless asked for', (tester) async {
      await pumpTable(tester, DocumentTable(rows: rows(2), rowsPerPage: 10));

      expect(find.byTooltip('صفحه بعد'), findsNothing);
    });

    testWidgets('previous and next are disabled at the ends', (tester) async {
      var previous = 0;
      var next = 0;

      await pumpTable(
        tester,
        DocumentTable(
          rows: rows(25),
          rowsPerPage: 10,
          showPagination: true,
          currentPage: 1,
          totalPages: 3,
          onPreviousPage: () => previous++,
          onNextPage: () => next++,
        ),
      );

      IconButton button(String tooltip) => tester.widget<IconButton>(
        find.ancestor(
          of: find.byTooltip(tooltip),
          matching: find.byType(IconButton),
        ),
      );

      expect(button('صفحه قبل').onPressed, isNull);
      expect(button('صفحه بعد').onPressed, isNotNull);
    });

    testWidgets('tapping a page number reports it, the current one does not', (
      tester,
    ) async {
      int? selected;

      await pumpTable(
        tester,
        DocumentTable(
          rows: rows(25),
          rowsPerPage: 10,
          showPagination: true,
          currentPage: 1,
          totalPages: 3,
          onPageSelected: (page) => selected = page,
        ),
      );

      await tester.ensureVisible(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();

      expect(selected, 2);

      await tester.tap(find.text('1'));
      await tester.pump();

      expect(selected, 2, reason: 'the current page is inert');
    });
  });

  group('operations column', () {
    testWidgets('shows an attachment badge when the row has attachments', (
      tester,
    ) async {
      await pumpTable(
        tester,
        DocumentTable(rows: [row(0, hasAttachments: true)]),
      );

      expect(find.byIcon(Icons.attach_file), findsOneWidget);
      expect(find.byTooltip('افزودن پیوست'), findsNothing);
    });

    testWidgets('offers an add-attachment button otherwise', (tester) async {
      var added = 0;

      await pumpTable(
        tester,
        DocumentTable(
          rows: [
            DocumentTableRow(
              number: 'N',
              organization: 'O',
              title: 'T',
              priority: 'عادی',
              onAddAttachment: () => added++,
            ),
          ],
        ),
      );

      await tester.tap(find.byTooltip('افزودن پیوست'));
      await tester.pump();

      expect(added, 1);
    });

    testWidgets('the delete dialog runs the callback on «بله»', (tester) async {
      var deleted = 0;

      await pumpTable(
        tester,
        DocumentTable(
          rows: [
            DocumentTableRow(
              number: 'N',
              organization: 'O',
              title: 'T',
              priority: 'عادی',
              onDelete: () async => deleted++,
            ),
          ],
        ),
      );

      await tester.tap(find.byTooltip('حذف'));
      await tester.pumpAndSettle();

      expect(find.text('آیا از حذف سند مطمئن هستید؟'), findsOneWidget);

      await tester.tap(find.text('بله'));
      await tester.pumpAndSettle();

      expect(deleted, 1);
    });

    testWidgets('the delete dialog leaves the row alone on «خیر»', (tester) async {
      var deleted = 0;

      await pumpTable(
        tester,
        DocumentTable(
          rows: [
            DocumentTableRow(
              number: 'N',
              organization: 'O',
              title: 'T',
              priority: 'عادی',
              onDelete: () async => deleted++,
            ),
          ],
        ),
      );

      await tester.tap(find.byTooltip('حذف'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('خیر'));
      await tester.pumpAndSettle();

      expect(deleted, 0);
      expect(find.text('آیا از حذف سند مطمئن هستید؟'), findsNothing);
    });

    testWidgets('a row without a delete callback has it disabled', (tester) async {
      await pumpTable(tester, DocumentTable(rows: [row(0)]));

      final button = tester.widget<IconButton>(
        find.ancestor(
          of: find.byTooltip('حذف'),
          matching: find.byType(IconButton),
        ),
      );

      expect(button.onPressed, isNull);
    });
  });
}
