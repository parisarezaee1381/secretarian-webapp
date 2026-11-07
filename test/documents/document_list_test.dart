import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/data/document_repository.dart';
import 'package:flutter_application_1/documents/document_list.dart';
import 'package:flutter_application_1/domain/documents.dart';
import 'package:flutter_application_1/widgets/buttons.dart';

OutgoingLetterDocument outgoing(
  String id, {
  String subject = 'موضوع',
  String date = '1403/01/01',
  String organization = 'سازمان',
  String priority = kNormalPriority,
  List<String> tags = const [],
  bool needsFollowUp = false,
}) {
  return OutgoingLetterDocument(
    id: id,
    letterNumber: '38$id/ص/03',
    date: date,
    subject: subject,
    tags: tags,
    organization: organization,
    recipient: 'گیرنده',
    signer: 'امضا',
    actionBy: 'اقدام',
    registrationNumber: '1',
    registrationDate: '1403/01/02',
    archiveFolder: 'پوشه',
    priority: priority,
    sendMethod: 'ایمیل',
    needsFollowUp: needsFollowUp,
    saveFile: false,
  );
}

IncomingLetterDocument incoming(String id, {String subject = 'موضوع وارده'}) {
  return IncomingLetterDocument(
    id: id,
    letterNumber: '39$id/و/03',
    date: '1403/01/03',
    subject: subject,
    tags: const [],
    organization: 'سازمان ب',
    sender: 'فرستنده',
    senderLetterNumber: '7',
    recipient: 'مخاطب',
    registrationDate: '1403/01/04',
    archiveFolder: 'پوشه',
    priority: kUrgentPriority,
    needsFollowUp: false,
    saveFile: false,
  );
}

ContractDocument contract(String id, {String subject = 'موضوع قرارداد'}) {
  return ContractDocument(
    id: id,
    letterNumber: '10/ق/03',
    date: '1403/01/05',
    subject: subject,
    tags: const [],
    organization: 'شرکت پ',
    recipient: 'طرف',
    actionBy: 'اقدام',
    contractSubject: 'خرید',
    registrationDate: '1403/01/06',
    referenceContractNumber: '9',
    saveFile: false,
  );
}

Future<void> pumpList(WidgetTester tester, {bool pendingOnly = false}) async {
  tester.view.physicalSize = const Size(1440, 1024);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      builder: (_, _) => MaterialApp(
        home: DocumentList(initialPendingOnly: pendingOnly),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

Finder typeButton(String label) => find.widgetWithText(CustomButton, label);

/// The list scrolls, and the page bar sits below the fold, so controls have to
/// be scrolled into view before a tap can land on them.
Future<void> tapInView(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await tester.pump();
}

void main() {
  setUp(() {
    // No database: the list only reads the repository's in-memory lists.
    DocumentRepository.instance.seedForTesting(
      outgoing: [
        outgoing('1', subject: 'صادره الف', date: '1403/01/05'),
        outgoing(
          '2',
          subject: 'صادره ب',
          date: '1403/01/07',
          organization: 'وزارت',
          priority: kUrgentPriority,
          tags: const ['مالی'],
          needsFollowUp: true,
        ),
        outgoing('3', subject: 'صادره ج', date: '1403/01/06'),
      ],
      incoming: [incoming('4')],
      contracts: [contract('5')],
    );
  });

  group('listing', () {
    testWidgets('shows every document when nothing is filtered', (tester) async {
      await pumpList(tester);

      expect(find.text('صادره الف'), findsOneWidget);
      expect(find.text('صادره ب'), findsOneWidget);
      expect(find.text('صادره ج'), findsOneWidget);
      expect(find.text('موضوع وارده'), findsOneWidget);
      expect(find.text('موضوع قرارداد'), findsOneWidget);
    });

    testWidgets('a type button narrows the list to that kind', (tester) async {
      await pumpList(tester);

      await tester.tap(typeButton('صادره'));
      await tester.pump();

      expect(find.text('صادره الف'), findsOneWidget);
      expect(find.text('موضوع وارده'), findsNothing);
      expect(find.text('موضوع قرارداد'), findsNothing);
    });

    testWidgets('selecting several types shows their union', (tester) async {
      await pumpList(tester);

      await tester.tap(typeButton('وارده'));
      await tester.pump();
      await tester.tap(typeButton('قرارداد'));
      await tester.pump();

      expect(find.text('موضوع وارده'), findsOneWidget);
      expect(find.text('موضوع قرارداد'), findsOneWidget);
      expect(find.text('صادره الف'), findsNothing);
    });

    testWidgets('deselecting every type restores the whole list', (tester) async {
      await pumpList(tester);

      await tester.tap(typeButton('صادره'));
      await tester.pump();
      await tester.tap(typeButton('صادره'));
      await tester.pump();

      expect(find.text('موضوع وارده'), findsOneWidget);
      expect(find.text('موضوع قرارداد'), findsOneWidget);
    });

    testWidgets('a selected type appears as a removable chip', (tester) async {
      await pumpList(tester);

      await tester.tap(typeButton('وارده'));
      await tester.pump();

      // The chip and the filter button both carry the label; the chip is the
      // one that can be deleted.
      final chip = find.byType(Chip);
      expect(chip, findsOneWidget);

      await tester.tap(
        find.descendant(of: chip, matching: find.byIcon(Icons.close)),
      );
      await tester.pump();

      expect(find.byType(Chip), findsNothing);
      expect(find.text('صادره الف'), findsOneWidget);
    });
  });

  group('pending filter', () {
    testWidgets('opening in pending mode shows only letters needing follow-up',
        (tester) async {
      await pumpList(tester, pendingOnly: true);

      expect(find.text('صادره ب'), findsOneWidget);
      expect(find.text('صادره الف'), findsNothing);
      expect(find.text('موضوع قرارداد'), findsNothing);
      expect(find.text('نیازمند پیگیری'), findsOneWidget);
    });

    testWidgets('the pending chip clears the filter', (tester) async {
      await pumpList(tester, pendingOnly: true);

      final chip = find.ancestor(
        of: find.text('نیازمند پیگیری'),
        matching: find.byType(Chip),
      );

      await tester.tap(
        find.descendant(of: chip, matching: find.byIcon(Icons.close)),
      );
      await tester.pump();

      expect(find.text('صادره الف'), findsOneWidget);
      expect(find.text('نیازمند پیگیری'), findsNothing);
    });
  });

  group('filter panel', () {
    testWidgets('applying a letter number filters and shows a chip', (tester) async {
      await pumpList(tester);

      await tester.tap(find.widgetWithText(CustomButton, 'فیلتر'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '382');
      await tester.pump();

      await tester.tap(find.text('اعمال فیلترها'));
      await tester.pumpAndSettle();

      expect(find.text('صادره ب'), findsOneWidget);
      expect(find.text('صادره الف'), findsNothing);
      expect(find.textContaining('شماره نامه: 382'), findsOneWidget);
    });

    testWidgets('an inverted date range is refused with a message', (tester) async {
      await pumpList(tester);

      await tester.tap(find.widgetWithText(CustomButton, 'فیلتر'));
      await tester.pumpAndSettle();

      final dateFields = find.byType(TextField);
      // Field order in the panel: number, from, to, title, organization…
      await tester.enterText(dateFields.at(1), '1403/05/05');
      await tester.enterText(dateFields.at(2), '1403/01/01');
      await tester.pump();

      await tester.tap(find.text('اعمال فیلترها'));
      await tester.pump();

      expect(
        find.text('تاریخ شروع نمی‌تواند بعد از تاریخ پایان باشد'),
        findsOneWidget,
      );
      // The panel stays open and the list is untouched.
      expect(find.text('صادره الف'), findsOneWidget);
    });

    testWidgets('a single day range keeps only that day', (tester) async {
      await pumpList(tester);

      await tester.tap(find.widgetWithText(CustomButton, 'فیلتر'));
      await tester.pumpAndSettle();

      final dateFields = find.byType(TextField);
      await tester.enterText(dateFields.at(1), '1403/01/06');
      await tester.enterText(dateFields.at(2), '1403/01/06');
      await tester.pump();

      await tester.tap(find.text('اعمال فیلترها'));
      await tester.pumpAndSettle();

      expect(find.text('صادره ج'), findsOneWidget);
      expect(find.text('صادره الف'), findsNothing);
      expect(find.text('صادره ب'), findsNothing);
    });
  });

  group('pagination', () {
    setUp(() {
      DocumentRepository.instance.seedForTesting(
        outgoing: List.generate(
          12,
          (i) => outgoing('$i', subject: 'سند $i', date: '1403/01/0${(i % 9) + 1}'),
        ),
      );
    });

    testWidgets('ten rows per page with a second page', (tester) async {
      await pumpList(tester);

      expect(find.text('سند 0'), findsOneWidget);
      expect(find.text('سند 9'), findsOneWidget);
      expect(find.text('سند 10'), findsNothing);

      await tapInView(tester, find.byTooltip('صفحه بعد'));

      expect(find.text('سند 10'), findsOneWidget);
      expect(find.text('سند 11'), findsOneWidget);
      expect(find.text('سند 0'), findsNothing);
    });

    testWidgets('previous is disabled on the first page, next on the last', (tester) async {
      await pumpList(tester);

      // `find.byTooltip` matches the Tooltip itself; the callback lives on the
      // IconButton wrapping it.
      IconButton button(String tooltip) => tester.widget<IconButton>(
        find.ancestor(
          of: find.byTooltip(tooltip),
          matching: find.byType(IconButton),
        ),
      );

      expect(button('صفحه قبل').onPressed, isNull);
      expect(button('صفحه بعد').onPressed, isNotNull);

      await tapInView(tester, find.byTooltip('صفحه بعد'));

      expect(button('صفحه قبل').onPressed, isNotNull);
      expect(button('صفحه بعد').onPressed, isNull);
    });

    testWidgets('changing the filter jumps back to the first page', (tester) async {
      await pumpList(tester);

      await tapInView(tester, find.byTooltip('صفحه بعد'));
      expect(find.text('سند 10'), findsOneWidget);

      await tapInView(tester, typeButton('صادره'));

      expect(find.text('سند 0'), findsOneWidget);
    });
  });
}
