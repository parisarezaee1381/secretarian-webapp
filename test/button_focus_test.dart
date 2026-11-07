import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/widgets/buttons.dart';
import 'package:flutter_application_1/widgets/hoverablecontainer.dart';

void main() {
  Widget wrap(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      builder: (_, _) => MaterialApp(home: child),
    );
  }

  testWidgets('space on a focused CustomButton activates it exactly once', (
    tester,
  ) async {
    var taps = 0;

    await tester.pumpWidget(
      wrap(
        Scaffold(
          body: CustomButton(
            label: 'ثبت',
            autofocus: true,
            onPressed: () => taps++,
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('Tab and Shift+Tab move focus between CustomButtons', (
    tester,
  ) async {
    final first = FocusNode();
    final second = FocusNode();
    addTearDown(first.dispose);
    addTearDown(second.dispose);

    await tester.pumpWidget(
      wrap(
        Scaffold(
          body: Row(
            children: [
              CustomButton(
                label: 'اول',
                focusNode: first,
                autofocus: true,
                onPressed: () {},
              ),
              CustomButton(
                label: 'دوم',
                focusNode: second,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(first.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    expect(
      first.hasFocus,
      isFalse,
      reason: 'Tab must leave a focused CustomButton',
    );
    expect(
      second.hasFocus,
      isTrue,
      reason: 'Tab must reach the next CustomButton',
    );

    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pump();

    expect(first.hasFocus, isTrue, reason: 'Shift+Tab must move back');
  });

  testWidgets('Tab moves focus past a focused HoverableContainer', (
    tester,
  ) async {
    final first = FocusNode();
    final second = FocusNode();
    addTearDown(first.dispose);
    addTearDown(second.dispose);

    await tester.pumpWidget(
      wrap(
        Scaffold(
          body: Row(
            children: [
              HoverableContainer(
                focusNode: first,
                autofocus: true,
                onTap: () {},
                child: const Text('الف'),
              ),
              HoverableContainer(
                focusNode: second,
                onTap: () {},
                child: const Text('ب'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(first.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    expect(
      first.hasFocus,
      isFalse,
      reason: 'Tab must leave a focused HoverableContainer',
    );
    expect(
      second.hasFocus,
      isTrue,
      reason: 'Tab must reach the next HoverableContainer',
    );
  });
}
