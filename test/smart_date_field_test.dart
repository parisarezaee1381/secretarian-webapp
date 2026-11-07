import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/widgets/smart_date_field.dart';

void main() {
  Widget host(TextEditingController controller) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      builder: (_, _) => MaterialApp(
        home: Scaffold(body: SmartDateField(controller: controller)),
      ),
    );
  }

  testWidgets('formats digits as yyyy/MM/dd and caps at eight digits', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(host(controller));

    final field = find.byType(TextField);

    // Pasted with sloppy separators: digits are extracted and re-slashed.
    await tester.enterText(field, '1403/5/2');
    expect(controller.text, '1403/52');

    // Raw digits: separators are inserted as they are typed, and only the
    // first eight digits (one Jalali date) are kept.
    await tester.enterText(field, '1403011234');
    expect(controller.text, '1403/01/12');
  });

  testWidgets('keeps the caret beside the digit being edited', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(host(controller));

    final field = find.byType(TextField);

    await tester.showKeyboard(field);
    controller.text = '1403/01/12';
    controller.selection = const TextSelection.collapsed(offset: 4);
    await tester.pump();

    // Type '5' after the year: the formatter re-slashes the whole value
    // (and truncates the tail past eight digits) but must leave the caret
    // right after the typed digit, not at the end.
    tester.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '14035/01/12',
        selection: TextSelection.collapsed(offset: 5),
      ),
    );
    await tester.pump();

    expect(controller.text, '1403/50/11');
    expect(controller.selection.baseOffset, 6);
  });
}
