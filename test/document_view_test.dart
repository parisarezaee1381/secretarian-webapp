import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/documents/document_view.dart';
import 'package:flutter_application_1/widgets/buttons.dart';

void main() {
  Widget wrap(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      builder: (_, _) => MaterialApp(home: child),
    );
  }

  void setWidth(WidgetTester tester, double width) {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('detail rows stack below the wide breakpoint', (tester) async {
    setWidth(tester, 500);

    await tester.pumpWidget(
      wrap(
        const Scaffold(
          body: DocumentDetailRow(label: 'برچسب', value: 'مقدار'),
        ),
      ),
    );

    expect(find.text('برچسب'), findsOneWidget);
    expect(find.text('مقدار'), findsOneWidget);

    expect(
      find.descendant(
        of: find.byType(DocumentDetailRow),
        matching: find.byType(Row),
      ),
      findsNothing,
    );

    expect(
      find.descendant(
        of: find.byType(DocumentDetailRow),
        matching: find.byType(Container),
      ),
      findsOneWidget,
    );
  });

  testWidgets('detail rows sit side by side at the wide breakpoint', (
    tester,
  ) async {
    setWidth(tester, 1200);

    await tester.pumpWidget(
      wrap(
        const Scaffold(
          body: DocumentDetailRow(label: 'برچسب', value: 'مقدار'),
        ),
      ),
    );

    expect(
      find.descendant(
        of: find.byType(DocumentDetailRow),
        matching: find.byType(Row),
      ),
      findsOneWidget,
    );
  });

  testWidgets('empty values render as a dash', (tester) async {
    setWidth(tester, 500);

    await tester.pumpWidget(
      wrap(
        const Scaffold(body: DocumentDetailRow(label: 'برچسب', value: '')),
      ),
    );

    expect(find.text('-'), findsOneWidget);
  });

  testWidgets('print is disabled and edit invokes the callback', (
    tester,
  ) async {
    setWidth(tester, 1200);

    var edited = false;

    await tester.pumpWidget(
      wrap(
        DocumentViewScaffold(
          title: 'تست',
          onEdit: () => edited = true,
          children: const [],
        ),
      ),
    );

    final printButton = tester.widget<CustomButton>(
      find.widgetWithText(CustomButton, 'چاپ'),
    );
    expect(printButton.onPressed, isNull);

    await tester.tap(find.widgetWithText(CustomButton, 'ویرایش'));
    await tester.pump();

    expect(edited, isTrue);
  });
}
