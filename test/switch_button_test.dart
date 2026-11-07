import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/widgets/switch_button.dart';

/// The switch's focus node lives inside its subtree (`LayoutBuilder` →
/// `MouseRegion` → `Focus`).
FocusNode _switchFocusNode(WidgetTester tester) {
  return tester
      .widget<Focus>(
        find
            .descendant(
              of: find.byType(AppSwitch),
              matching: find.byType(Focus),
            )
            .first,
      )
      .focusNode!;
}

void main() {
  testWidgets('Tab moves focus through the switch instead of trapping it', (
    tester,
  ) async {
    final nodeA = FocusNode();
    final nodeB = FocusNode();
    addTearDown(nodeA.dispose);
    addTearDown(nodeB.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TextField(focusNode: nodeA),
              AppSwitch(value: false, onChanged: (_) {}),
              TextField(focusNode: nodeB),
            ],
          ),
        ),
      ),
    );

    nodeA.requestFocus();
    await tester.pump();

    final switchFocus = _switchFocusNode(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(switchFocus.hasPrimaryFocus, isTrue, reason: 'Tab reaches the switch');

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(
      switchFocus.hasPrimaryFocus,
      isFalse,
      reason: 'Tab must leave the switch (no keyboard trap)',
    );
    expect(nodeB.hasPrimaryFocus, isTrue, reason: 'focus continues down the form');
  });

  testWidgets('space and enter toggle the focused switch once per press', (
    tester,
  ) async {
    final toggles = <bool>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: AppSwitch(value: false, onChanged: toggles.add)),
      ),
    );

    final switchFocus = _switchFocusNode(tester);
    switchFocus.requestFocus();
    await tester.pump();

    // One sendKeyEvent = key-down + key-up: the up event is consumed but
    // must not fire a second toggle.
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(toggles, [true]);

    // Rebuild with the switch ON so the next press toggles it back off.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: AppSwitch(value: true, onChanged: toggles.add)),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(toggles, [true, false]);

    // Non-activation keys are not claimed: focus and toggle count stay put.
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(switchFocus.hasPrimaryFocus, isTrue);
    expect(toggles, [true, false]);
  });

  testWidgets('a disabled switch is skipped by keyboard traversal', (
    tester,
  ) async {
    final nodeA = FocusNode();
    final nodeB = FocusNode();
    addTearDown(nodeA.dispose);
    addTearDown(nodeB.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TextField(focusNode: nodeA),
              const AppSwitch(value: false, onChanged: null),
              TextField(focusNode: nodeB),
            ],
          ),
        ),
      ),
    );

    nodeA.requestFocus();
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    expect(nodeA.hasPrimaryFocus, isFalse);
    expect(
      nodeB.hasPrimaryFocus,
      isTrue,
      reason: 'the disabled switch must be skipped, not focused',
    );
  });
}
