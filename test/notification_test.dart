import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/core/pending_letters_data.dart';
import 'package:flutter_application_1/widgets/buttons.dart';
import 'package:flutter_application_1/widgets/notification.dart';

void main() {
  Widget wrap(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      builder: (_, _) => MaterialApp(home: Scaffold(body: child)),
    );
  }

  tearDown(() => PendingLettersData.count.value = 0);

  testWidgets('renders no button while the count is zero', (tester) async {
    PendingLettersData.count.value = 0;

    await tester.pumpWidget(
      wrap(PendingLettersButton(onPressed: () {})),
    );

    expect(find.byType(PendingLettersButton), findsOneWidget);
    expect(find.byType(CustomButton), findsNothing);
  });

  testWidgets('shows the live count and follows later changes', (
    tester,
  ) async {
    PendingLettersData.count.value = 3;

    await tester.pumpWidget(
      wrap(PendingLettersButton(onPressed: () {})),
    );

    expect(
      find.widgetWithText(CustomButton, '3 نامه نیازمند پیگیری برای امروز'),
      findsOneWidget,
    );

    PendingLettersData.count.value = 0;
    await tester.pump();

    expect(find.byType(CustomButton), findsNothing);
  });
}
