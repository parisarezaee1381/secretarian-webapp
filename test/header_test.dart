import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/widgets/header.dart';
import 'package:flutter_application_1/widgets/hoverablecontainer.dart';

void main() {
  testWidgets(
      'the settings leading is reachable and activatable by keyboard',
      (tester) async {
    var presses = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppHeader(
            title: 'تست',
            leading: HeaderLeading.settings,
            onLeadingPressed: () => presses++,
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    final focus = tester.widget<Focus>(
      find.descendant(
        of: find.byType(HoverableContainer),
        matching: find.byType(Focus),
      ),
    );
    expect(
      focus.focusNode!.hasFocus,
      isTrue,
      reason: 'Tab must reach the settings button',
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(presses, 1, reason: 'space must activate the settings button');
  });
}
