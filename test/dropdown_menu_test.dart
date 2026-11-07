import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/widgets/dropdown_menu.dart';
import 'package:flutter_application_1/widgets/dropdown_menu_items.dart';
import 'package:flutter_application_1/widgets/hoverablecontainer.dart';

void main() {
  Focus triggerFocus(WidgetTester tester) {
    return tester.widget<Focus>(
      find.descendant(
        of: find.byType(AppDropdown<String>),
        matching: find.byType(Focus),
      ),
    );
  }

  testWidgets('Tab reaches and passes the dropdown trigger', (tester) async {
    final secondNode = FocusNode();
    addTearDown(secondNode.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              const AppDropdown<String>(
                items: ['الف', 'ب'],
                hintText: 'انتخاب',
                onChanged: _ignore,
              ),
              HoverableContainer(
                focusNode: secondNode,
                onTap: () {},
                child: const Text('دوم'),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    expect(
      triggerFocus(tester).focusNode!.hasFocus,
      isTrue,
      reason: 'Tab must reach the dropdown trigger',
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    expect(
      secondNode.hasFocus,
      isTrue,
      reason: 'Tab must pass the trigger — it may not swallow the key',
    );
  });

  testWidgets('space opens the menu and Escape closes it again', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const AppDropdown<String>(
            items: ['الف', 'ب'],
            hintText: 'انتخاب',
            onChanged: _ignore,
          ),
        ),
      ),
    );

    triggerFocus(tester).focusNode!.requestFocus();
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(
      find.byType(DropdownMenuItemWidget),
      findsNWidgets(2),
      reason: 'space must open the menu',
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();

    expect(
      find.byType(DropdownMenuItemWidget),
      findsNothing,
      reason: 'Escape must close the open menu',
    );
  });

  testWidgets('tapping an item reports it via onChanged and closes the menu', (
    tester,
  ) async {
    String? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppDropdown<String>(
            items: const ['الف', 'ب'],
            hintText: 'انتخاب',
            onChanged: (value) => selected = value,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AppDropdown<String>));
    await tester.pump();

    await tester.tap(find.text('ب'));
    await tester.pump();

    expect(selected, 'ب');
    expect(
      find.byType(DropdownMenuItemWidget),
      findsNothing,
      reason: 'the menu must close after selecting',
    );
    expect(
      find.text('ب'),
      findsOneWidget,
      reason: 'the trigger must show the new selection',
    );
  });

  testWidgets('the open menu marks the current value as selected', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppDropdown<String>(
            items: const ['الف', 'ب'],
            hintText: 'انتخاب',
            value: 'ب',
            onChanged: _ignore,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AppDropdown<String>));
    await tester.pump();

    final items = tester.widgetList<DropdownMenuItemWidget>(
      find.byType(DropdownMenuItemWidget),
    );

    expect(items, hasLength(2));
    expect(
      items.where((item) => item.isSelected).map((item) => item.label),
      ['ب'],
    );
  });
}

void _ignore(String? _) {}
