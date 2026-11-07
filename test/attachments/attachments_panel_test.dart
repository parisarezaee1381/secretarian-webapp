
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import 'package:flutter_application_1/attachments/attached_item.dart';
import 'package:flutter_application_1/attachments/attachments_panel.dart';

const MethodChannel scannerChannel = MethodChannel('secretarian/scanner');

TestDefaultBinaryMessenger get messenger =>
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

/// Minimal stand-in for the platform picker. Subclassing [FilePicker] keeps the
/// plugin's platform-interface token valid, so `FilePicker.platform = …` works.
class FakeFilePicker extends FilePicker {
  FakeFilePicker(this.onPick);

  final Future<FilePickerResult?> Function() onPick;

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = true,
    int compressionQuality = 30,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) {
    return onPick();
  }
}

Uint8List tinyPng() {
  final image = img.Image(width: 4, height: 4);

  return Uint8List.fromList(img.encodePng(image));
}

List<AttachedItem> lastItems = [];

Future<void> pumpPanel(
  WidgetTester tester, {
  List<AttachedItem> initial = const [],
}) async {
  lastItems = initial;

  tester.view.physicalSize = const Size(1440, 1024);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      builder: (_, _) => MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: AttachmentsPanel(
              initialItems: initial,
              onChanged: (items) => lastItems = items,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

/// Advances a bounded amount of time instead of `pumpAndSettle`: while a scan
/// runs the panel shows a non-dismissible progress dialog with a spinner, so
/// "wait until no frame is scheduled" would never come true.
Future<void> pumpScan(WidgetTester tester) async {
  for (var i = 0; i < 60; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FilePicker originalPicker;

  setUp(() {
    originalPicker = FilePicker.platform;
    messenger.setMockMethodCallHandler(scannerChannel, null);
  });

  tearDown(() {
    FilePicker.platform = originalPicker;
    messenger.setMockMethodCallHandler(scannerChannel, null);
  });

  group('existing attachments', () {
    testWidgets('an image renders a preview, a document renders an icon', (
      tester,
    ) async {
      await pumpPanel(
        tester,
        initial: [
          AttachedItem(name: 'photo.png', bytes: tinyPng()),
          AttachedItem(name: 'letter.pdf', path: '/tmp/letter.pdf'),
        ],
      );

      expect(find.byType(Image), findsOneWidget);
      expect(find.byIcon(Icons.insert_drive_file), findsOneWidget);
      expect(find.text('letter.pdf'), findsOneWidget);
    });

    testWidgets('removing one reports the remaining items', (tester) async {
      await pumpPanel(
        tester,
        initial: [
          AttachedItem(name: 'a.png', bytes: tinyPng()),
          AttachedItem(name: 'b.pdf', path: '/tmp/b.pdf'),
        ],
      );

      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pump();

      expect(lastItems, hasLength(1));
      expect(lastItems.single.name, 'b.pdf');
    });
  });

  group('picking a file', () {
    testWidgets('adds the picked file and reports it', (tester) async {
      FilePicker.platform = FakeFilePicker(
        () async => FilePickerResult([
          PlatformFile(
            name: 'contract.pdf',
            size: 4,
            bytes: Uint8List.fromList([1, 2, 3, 4]),
          ),
        ]),
      );

      await pumpPanel(tester);

      await tester.tap(find.text('+ افزودن پیوست'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(lastItems, hasLength(1));
      expect(lastItems.single.name, 'contract.pdf');
      expect(lastItems.single.bytes, [1, 2, 3, 4]);
      expect(find.text('contract.pdf'), findsOneWidget);
    });

    testWidgets('cancelling the picker changes nothing', (tester) async {
      FilePicker.platform = FakeFilePicker(() async => null);

      await pumpPanel(tester);

      await tester.tap(find.text('+ افزودن پیوست'));
      await tester.pump();

      expect(lastItems, isEmpty);
      expect(find.byIcon(Icons.insert_drive_file), findsNothing);
    });

    testWidgets('a picker failure is reported to the user', (tester) async {
      FilePicker.platform = FakeFilePicker(() async => throw Exception('boom'));

      await pumpPanel(tester);

      await tester.tap(find.text('+ افزودن پیوست'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('خطا در انتخاب فایل'), findsOneWidget);
      expect(lastItems, isEmpty);
    });
  });

  group('scanning', () {
    testWidgets('with no scanner attached the user is told so', (tester) async {
      messenger.setMockMethodCallHandler(scannerChannel, (call) async {
        if (call.method == 'listScanners') return <Map<String, String>>[];

        return null;
      });

      await pumpPanel(tester);

      await tester.tap(find.text('اسکن سند'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.text('اسکنری یافت نشد. لطفاً اسکنر را روشن و متصل کرده و دوباره تلاش کنید.'),
        findsOneWidget,
      );
    });

    testWidgets('a single scanner is used and the scan becomes a PDF', (tester) async {
      final png = tinyPng();

      messenger.setMockMethodCallHandler(scannerChannel, (call) async {
        if (call.method == 'listScanners') {
          return [
            {'id': 'dev-1', 'name': 'Canon'},
          ];
        }
        if (call.method == 'scan') {
          return <Uint8List>[png];
        }

        return null;
      });

      await pumpPanel(tester);

      await tester.tap(find.text('اسکن سند'));
      await pumpScan(tester);

      expect(lastItems, hasLength(1));
      expect(lastItems.single.name, startsWith('scan-'));
      expect(lastItems.single.name, endsWith('.pdf'));
      expect(lastItems.single.bytes, isNotNull);
      expect(
        String.fromCharCodes(lastItems.single.bytes!.take(4)),
        '%PDF',
      );
    });

    testWidgets('several scanners are offered in a chooser', (tester) async {
      final scannedIds = <String>[];

      messenger.setMockMethodCallHandler(scannerChannel, (call) async {
        if (call.method == 'listScanners') {
          return [
            {'id': 'dev-1', 'name': 'Canon'},
            {'id': 'dev-2', 'name': 'Epson'},
          ];
        }
        if (call.method == 'scan') {
          scannedIds.add((call.arguments as Map)['id'] as String);

          return <Uint8List>[tinyPng()];
        }

        return null;
      });

      await pumpPanel(tester);

      await tester.tap(find.text('اسکن سند'));
      await pumpScan(tester);

      expect(find.text('انتخاب اسکنر'), findsOneWidget);
      expect(find.text('Canon'), findsOneWidget);
      expect(find.text('Epson'), findsOneWidget);

      await tester.tap(find.text('Epson'));
      await pumpScan(tester);

      expect(scannedIds, ['dev-2']);
      expect(lastItems.single.name, endsWith('.pdf'));
    });

    testWidgets('cancelling the chooser scans nothing', (tester) async {
      var scanned = false;

      messenger.setMockMethodCallHandler(scannerChannel, (call) async {
        if (call.method == 'listScanners') {
          return [
            {'id': 'dev-1', 'name': 'Canon'},
            {'id': 'dev-2', 'name': 'Epson'},
          ];
        }
        if (call.method == 'scan') {
          scanned = true;

          return <Uint8List>[tinyPng()];
        }

        return null;
      });

      await pumpPanel(tester);

      await tester.tap(find.text('اسکن سند'));
      await pumpScan(tester);
      await tester.tap(find.text('انصراف'));
      await pumpScan(tester);

      expect(scanned, isFalse);
      expect(lastItems, isEmpty);
    });

    testWidgets('a cancelled scan is reported as such', (tester) async {
      messenger.setMockMethodCallHandler(scannerChannel, (call) async {
        if (call.method == 'listScanners') {
          return [
            {'id': 'dev-1', 'name': 'Canon'},
          ];
        }
        if (call.method == 'scan') {
          throw PlatformException(code: 'scan_cancelled');
        }

        return null;
      });

      await pumpPanel(tester);

      await tester.tap(find.text('اسکن سند'));
      await pumpScan(tester);

      expect(find.text('اسکن لغو شد.'), findsOneWidget);
      expect(lastItems, isEmpty);
    });

    testWidgets('a missing scanner connection is reported', (tester) async {
      messenger.setMockMethodCallHandler(scannerChannel, (call) async {
        if (call.method == 'listScanners') {
          return [
            {'id': 'dev-1', 'name': 'Canon'},
          ];
        }
        if (call.method == 'scan') {
          throw PlatformException(code: 'scanner_not_found');
        }

        return null;
      });

      await pumpPanel(tester);

      await tester.tap(find.text('اسکن سند'));
      await pumpScan(tester);

      expect(
        find.text('اسکنری یافت نشد. اتصال اسکنر را بررسی کنید.'),
        findsOneWidget,
      );
    });

    testWidgets('other scan failures carry their native code', (tester) async {
      messenger.setMockMethodCallHandler(scannerChannel, (call) async {
        if (call.method == 'listScanners') {
          return [
            {'id': 'dev-1', 'name': 'Canon'},
          ];
        }
        if (call.method == 'scan') {
          throw PlatformException(code: 'scan_timeout');
        }

        return null;
      });

      await pumpPanel(tester);

      await tester.tap(find.text('اسکن سند'));
      await pumpScan(tester);

      expect(find.text('خطا در اسکن سند (scan_timeout).'), findsOneWidget);
    });
  });
}
