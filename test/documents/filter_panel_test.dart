import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/documents/filter.dart';
import 'package:flutter_application_1/domain/documents.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

FilterValues? lastApplied;
var clearCalls = 0;

Future<void> pumpPanel(
  WidgetTester tester, {
  FilterValues? initialValues,
}) async {
  lastApplied = null;
  clearCalls = 0;

  tester.view.physicalSize = const Size(1440, 1024);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      builder: (_, _) => MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          drawer: FilterPanel(
            initialValues: initialValues,
            onApply: (values) => lastApplied = values,
            onClear: () => clearCalls++,
          ),
          body: const SizedBox.expand(),
        ),
      ),
    ),
  );
  await tester.pump();

  scaffoldKey.currentState!.openDrawer();
  await tester.pumpAndSettle();
}

Finder textFieldAt(int index) => find.byType(TextField).at(index);

void main() {
  group('button label', () {
    testWidgets('offers to apply when nothing is filtered', (tester) async {
      await pumpPanel(tester);

      expect(find.text('اعمال فیلترها'), findsOneWidget);
      expect(find.text('پاک کردن فیلترها'), findsNothing);
    });

    testWidgets('offers to clear when filters are applied', (tester) async {
      await pumpPanel(
        tester,
        initialValues: FilterValues(
          letterNumber: '',
          fromDate: '',
          toDate: '',
          title: 'قبلی',
          organization: '',
          priority: null,
          keywords: const [],
        ),
      );

      expect(find.text('پاک کردن فیلترها'), findsOneWidget);
      expect(find.text('عنوان'), findsOneWidget);
    });
  });

  group('applying', () {
    testWidgets('collects text fields into a FilterValues', (tester) async {
      await pumpPanel(tester);

      // Panel field order: number, from, to, title, organization, keywords.
      await tester.enterText(textFieldAt(0), '3886');
      await tester.enterText(textFieldAt(3), 'عنوان آزمایشی');
      await tester.enterText(textFieldAt(4), 'سازمان');
      await tester.pump();

      await tester.tap(find.text('اعمال فیلترها'));
      await tester.pumpAndSettle();

      expect(lastApplied, isNotNull);
      expect(lastApplied!.letterNumber, '3886');
      expect(lastApplied!.title, 'عنوان آزمایشی');
      expect(lastApplied!.organization, 'سازمان');
      expect(clearCalls, 0);
    });

    testWidgets('an inverted date range blocks the apply', (tester) async {
      await pumpPanel(tester);

      await tester.enterText(textFieldAt(1), '1403/05/05');
      await tester.enterText(textFieldAt(2), '1403/01/01');
      await tester.pump();

      await tester.tap(find.text('اعمال فیلترها'));
      await tester.pump();

      expect(lastApplied, isNull);
      expect(
        find.text('تاریخ شروع نمی‌تواند بعد از تاریخ پایان باشد'),
        findsOneWidget,
      );
    });

    testWidgets('fixing the range clears the error and applies', (tester) async {
      await pumpPanel(tester);

      await tester.enterText(textFieldAt(1), '1403/05/05');
      await tester.enterText(textFieldAt(2), '1403/01/01');
      await tester.pump();
      await tester.tap(find.text('اعمال فیلترها'));
      await tester.pump();

      await tester.enterText(textFieldAt(2), '1403/06/06');
      await tester.pump();
      await tester.tap(find.text('اعمال فیلترها'));
      await tester.pumpAndSettle();

      expect(lastApplied, isNotNull);
      expect(lastApplied!.fromDate, '1403/05/05');
      expect(lastApplied!.toDate, '1403/06/06');
      expect(
        find.text('تاریخ شروع نمی‌تواند بعد از تاریخ پایان باشد'),
        findsNothing,
      );
    });

    testWidgets('a priority can be picked from the dropdown', (tester) async {
      await pumpPanel(tester);

      await tester.tap(find.text('همه'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('🔴 $kUrgentPriority'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('اعمال فیلترها'));
      await tester.pumpAndSettle();

      expect(lastApplied!.priority, kUrgentPriority);
    });
  });

  group('keywords', () {
    testWidgets('a keyword becomes a chip and is applied', (tester) async {
      await pumpPanel(tester);

      await tester.enterText(textFieldAt(5), 'مالی');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(find.text('مالی'), findsOneWidget);

      await tester.tap(find.text('اعمال فیلترها'));
      await tester.pumpAndSettle();

      expect(lastApplied!.keywords, ['مالی']);
    });

    testWidgets('the same keyword is not added twice', (tester) async {
      await pumpPanel(tester);

      await tester.enterText(textFieldAt(5), 'مالی');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      await tester.enterText(textFieldAt(5), 'مالی');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(find.byType(Chip), findsOneWidget);
    });

    testWidgets('a blank keyword is ignored', (tester) async {
      await pumpPanel(tester);

      await tester.enterText(textFieldAt(5), '   ');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(find.byType(Chip), findsNothing);
    });

    testWidgets('a chip can be removed again', (tester) async {
      await pumpPanel(tester);

      await tester.enterText(textFieldAt(5), 'مالی');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      await tester.tap(
        find.descendant(
          of: find.byType(Chip),
          matching: find.byIcon(Icons.close),
        ),
      );
      await tester.pump();

      expect(find.byType(Chip), findsNothing);
    });
  });

  group('clearing', () {
    testWidgets('the clear button resets the fields and calls onClear', (tester) async {
      await pumpPanel(
        tester,
        initialValues: FilterValues(
          letterNumber: '3886',
          fromDate: '',
          toDate: '',
          title: 'عنوان',
          organization: '',
          priority: kUrgentPriority,
          keywords: const ['مالی'],
        ),
      );

      await tester.tap(find.text('پاک کردن فیلترها'));
      await tester.pump();

      expect(clearCalls, 1);
      expect(lastApplied, isNull);
      expect(find.byType(Chip), findsNothing);
      // The label follows the *applied* values, which the owner still holds, so
      // it keeps offering to clear until the parent rebuilds with null. What
      // must be gone are the values themselves:
      expect(find.text('3886'), findsNothing);
      expect(find.text('عنوان'), findsWidgets, reason: 'still the field label');
      expect(find.text('همه'), findsOneWidget, reason: 'priority reset');
    });
  });
}
