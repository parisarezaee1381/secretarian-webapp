import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/widgets/buttons.dart';
import 'package:flutter_application_1/widgets/modal.dart';

void main() {
  /// Pumps a bare host, mirroring how the letter forms open the modal.
  Future<void> pumpHost(WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(1440, 1024),
        minTextAdapt: true,
        builder: (_, _) =>
            const MaterialApp(home: Scaffold(body: SizedBox())),
      ),
    );
  }

  /// Opens the dialog and returns the future the caller would consume in
  /// `.then(...)` — typed, and `null` when the dialog is dismissed.
  Future<Object?> openDialog(WidgetTester tester) {
    return showDialog<Object>(
      context: tester.element(find.byType(Scaffold)),
      builder: (context) => const CustomModal(),
    );
  }

  testWidgets('confirming returns a typed FollowUpResult with the entries', (
    tester,
  ) async {
    await pumpHost(tester);
    final future = openDialog(tester);
    await tester.pumpAndSettle();

    expect(find.byType(CustomModal), findsOneWidget);

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(2));

    await tester.enterText(fields.at(0), '1403/05/14');
    await tester.enterText(fields.at(1), 'احمدی');
    await tester.pump();

    await tester.tap(find.widgetWithText(CustomButton, 'تایید'));
    await tester.pumpAndSettle();

    expect(find.byType(CustomModal), findsNothing);

    final result = await future;
    expect(result, isA<FollowUpResult>());
    result as FollowUpResult;
    expect(result.date, '1403/05/14');
    expect(result.followUpBy, 'احمدی');
  });

  testWidgets('validation blocks an empty date, close button pops null', (
    tester,
  ) async {
    await pumpHost(tester);
    final future = openDialog(tester);
    await tester.pumpAndSettle();

    expect(find.byType(CustomModal), findsOneWidget);

    final fields = find.byType(TextField);

    // Only the follower is filled: the date error must appear and the
    // dialog must stay open.
    await tester.enterText(fields.at(1), 'احمدی');
    await tester.pump();

    await tester.tap(find.widgetWithText(CustomButton, 'تایید'));
    await tester.pump();

    expect(find.byType(CustomModal), findsOneWidget);
    expect(find.text('لطفا این فیلد را پر کنید'), findsOneWidget);

    // The close button carries a spoken name for screen readers.
    expect(tester.getSemantics(find.byIcon(Icons.close)).label, 'بستن');

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.byType(CustomModal), findsNothing);
    expect(await future, isNull);
  });
}
