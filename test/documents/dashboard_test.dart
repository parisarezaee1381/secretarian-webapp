import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'package:flutter_application_1/data/document_repository.dart';
import 'package:flutter_application_1/documents/dashboard.dart';
import 'package:flutter_application_1/documents/document_list.dart';
import 'package:flutter_application_1/domain/documents.dart';
import 'package:flutter_application_1/widgets/buttons.dart';
import 'package:flutter_application_1/widgets/notification.dart';

String _todayJalali() {
  final today = Jalali.now();

  return '${today.year.toString().padLeft(4, '0')}/'
      '${today.month.toString().padLeft(2, '0')}/'
      '${today.day.toString().padLeft(2, '0')}';
}

OutgoingLetterDocument outgoing(
  String id, {
  required String date,
  String? subject,
  bool pendingToday = false,
}) {
  return OutgoingLetterDocument(
    id: id,
    letterNumber: '$id/ص/03',
    date: date,
    subject: subject ?? 'سند $id',
    tags: const [],
    organization: 'سازمان',
    recipient: 'گیرنده',
    signer: 'امضا',
    actionBy: 'اقدام',
    registrationNumber: '1',
    registrationDate: '1403/01/02',
    archiveFolder: 'پوشه',
    priority: kNormalPriority,
    sendMethod: 'ایمیل',
    needsFollowUp: pendingToday,
    followUpDate: pendingToday ? _todayJalali() : null,
    followUpBy: pendingToday ? 'علی' : null,
    saveFile: false,
  );
}

late String? capturedRoute;

Future<void> pumpDashboard(WidgetTester tester, {List<Document>? documents}) async {
  DocumentRepository.instance.seedForTesting(
    outgoing: (documents ?? const <Document>[])
        .whereType<OutgoingLetterDocument>()
        .toList(),
    incoming: (documents ?? const <Document>[])
        .whereType<IncomingLetterDocument>()
        .toList(),
    contracts: (documents ?? const <Document>[])
        .whereType<ContractDocument>()
        .toList(),
  );

  tester.view.physicalSize = const Size(1440, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      builder: (_, _) => MaterialApp(
        onGenerateRoute: (settings) {
          capturedRoute = settings.name;

          return MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('stub-page')),
          );
        },
        home: const Dashboard(),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  setUp(() => capturedRoute = null);

  group('latest documents', () {
    testWidgets('shows the five newest, newest first, and no more', (tester) async {
      await pumpDashboard(
        tester,
        documents: [
          outgoing('a', date: '1403/01/01'),
          outgoing('b', date: '1403/01/02'),
          outgoing('c', date: '1403/01/03'),
          outgoing('d', date: '1403/01/04'),
          outgoing('e', date: '1403/01/05'),
          outgoing('f', date: '1403/01/06'),
        ],
      );

      // The oldest one falls off the five-row table.
      expect(find.text('سند a'), findsNothing);

      for (final id in ['b', 'c', 'd', 'e', 'f']) {
        expect(find.text('سند $id'), findsOneWidget, reason: id);
      }
    });

    testWidgets('an empty repository shows an empty table', (tester) async {
      await pumpDashboard(tester);

      expect(find.text('آخرین اسناد'), findsOneWidget);
      expect(find.text('شماره'), findsOneWidget);
    });
  });

  group('new document menu', () {
    testWidgets('opens with the three kinds and closes on a second tap', (
      tester,
    ) async {
      await pumpDashboard(tester);

      expect(find.text('صادره'), findsNothing);

      await tester.tap(find.widgetWithText(CustomButton, '+ ثبت سند جدید'));
      await tester.pump();

      expect(find.text('صادره'), findsOneWidget);
      expect(find.text('وارده'), findsOneWidget);
      expect(find.text('قرارداد'), findsOneWidget);

      await tester.tap(find.widgetWithText(CustomButton, '+ ثبت سند جدید'));
      await tester.pump();

      expect(find.text('صادره'), findsNothing);
    });

    testWidgets('each item opens the matching form', (tester) async {
      await pumpDashboard(tester);

      await tester.tap(find.widgetWithText(CustomButton, '+ ثبت سند جدید'));
      await tester.pump();
      await tester.tap(find.text('قرارداد'));
      await tester.pump();

      // The form page is pushed; its title identifies which kind opened.
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('ثبت قرارداد'), findsOneWidget);
    });
  });

  group('pending shortcut', () {
    testWidgets('is hidden when nothing is due today', (tester) async {
      await pumpDashboard(
        tester,
        documents: [outgoing('x', date: '1403/01/01')],
      );

      expect(find.byType(PendingLettersButton), findsOneWidget);
      // The widget itself renders nothing at a zero count.
      expect(find.textContaining('نامه نیازمند پیگیری'), findsNothing);
    });

    testWidgets('shows the count and opens the list in pending mode', (tester) async {
      await pumpDashboard(
        tester,
        documents: [
          outgoing('p', date: '1403/01/01', pendingToday: true),
          outgoing('q', date: '1403/01/02'),
        ],
      );

      expect(find.text('1 نامه نیازمند پیگیری برای امروز'), findsOneWidget);

      await tester.tap(find.text('1 نامه نیازمند پیگیری برای امروز'));
      await tester.pumpAndSettle();

      expect(find.byType(DocumentList), findsOneWidget);
      expect(find.text('نیازمند پیگیری'), findsOneWidget);
      expect(find.text('سند q'), findsNothing);
    });
  });

  group('navigation', () {
    testWidgets('the settings icon routes to /settings', (tester) async {
      await pumpDashboard(tester);

      await tester.tap(find.bySemanticsLabel('تنظیمات'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(capturedRoute, '/settings');
      expect(find.text('stub-page'), findsOneWidget);
    });

    testWidgets('the documents button opens the full list', (tester) async {
      await pumpDashboard(
        tester,
        documents: [outgoing('z', date: '1403/01/01')],
      );

      await tester.tap(find.widgetWithText(CustomButton, 'لیست اسناد'));
      await tester.pumpAndSettle();

      expect(find.byType(DocumentList), findsOneWidget);
      expect(find.text('سند z'), findsOneWidget);
    });
  });
}
