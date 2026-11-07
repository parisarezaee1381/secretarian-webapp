import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show SemanticsNode;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/domain/documents.dart';
import 'package:flutter_application_1/widgets/buttons.dart';
import 'package:flutter_application_1/widgets/filter_button.dart';

/// Whether a semantics node reports the "on" state set by `Semantics(toggled:)`.
bool _isToggled(SemanticsNode node) =>
    node.flagsCollection.isToggled.toBoolOrNull() ?? false;

/// Minimal parent that owns the selection, mirroring `document_list.dart`.
class _FilterHarness extends StatefulWidget {
  const _FilterHarness({this.onChanged});

  final ValueChanged<Set<DocumentType>>? onChanged;

  @override
  State<_FilterHarness> createState() => _FilterHarnessState();
}

class _FilterHarnessState extends State<_FilterHarness> {
  Set<DocumentType> _selected = <DocumentType>{};

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      builder: (_, _) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: DocumentTypeFilterButtons(
              selected: _selected,
              onChanged: (next) {
                widget.onChanged?.call(next);
                setState(() => _selected = next);
              },
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('toggling reports a copy, never the incoming set', (tester) async {
    final reports = <Set<DocumentType>>[];

    await tester.pumpWidget(_FilterHarness(onChanged: reports.add));

    await tester.tap(find.widgetWithText(CustomButton, 'صادره'));
    await tester.pump();

    expect(reports, hasLength(1));
    expect(reports.single, {DocumentType.outgoing});

    await tester.tap(find.widgetWithText(CustomButton, 'وارده'));
    await tester.pump();

    expect(reports.last, {DocumentType.outgoing, DocumentType.incoming});
    expect(
      reports.first,
      {DocumentType.outgoing},
      reason: 'an earlier report must not mutate when the widget toggles '
          'again — callers own the sets they receive',
    );
    expect(
      reports.first,
      isNot(same(reports.last)),
      reason: 'every toggle must hand out a fresh set instance',
    );
  });

  testWidgets('toggling an already-selected type removes it', (tester) async {
    final reports = <Set<DocumentType>>[];

    await tester.pumpWidget(_FilterHarness(onChanged: reports.add));

    await tester.tap(find.widgetWithText(CustomButton, 'صادره'));
    await tester.pump();
    await tester.tap(find.widgetWithText(CustomButton, 'صادره'));
    await tester.pump();

    expect(reports.last, isEmpty);
  });

  testWidgets('the trio wraps instead of overflowing narrow widths',
      (tester) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_FilterHarness());

    expect(tester.takeException(), isNull);
    expect(find.text('صادره'), findsOneWidget);
    expect(find.text('وارده'), findsOneWidget);
    expect(find.text('قرارداد'), findsOneWidget);
  });

  testWidgets('selection is exposed to semantics as toggled', (tester) async {
    await tester.pumpWidget(_FilterHarness());

    expect(_isToggled(tester.getSemantics(find.text('صادره'))), isFalse);

    await tester.tap(find.widgetWithText(CustomButton, 'صادره'));
    await tester.pump();

    expect(_isToggled(tester.getSemantics(find.text('صادره'))), isTrue);
    expect(_isToggled(tester.getSemantics(find.text('وارده'))), isFalse);
  });
}
