
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/attachments/scanner_service.dart';

const MethodChannel channel = MethodChannel('secretarian/scanner');
const EventChannel progressChannel =
    EventChannel('secretarian/scanner/progress');

TestDefaultBinaryMessenger get messenger =>
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    messenger.setMockStreamHandler(progressChannel, null);
  });

  group('listScanners', () {
    test('maps id and name', () async {
      messenger.setMockMethodCallHandler(channel, (call) async {
        expect(call.method, 'listScanners');

        return [
          {'id': 'dev-1', 'name': 'Canon'},
          {'id': 'dev-2', 'name': 'Epson'},
        ];
      });

      final scanners = await ScannerService.listScanners();

      expect(scanners, hasLength(2));
      expect(scanners.first.id, 'dev-1');
      expect(scanners.first.name, 'Canon');
      expect(scanners.last.name, 'Epson');
    });

    test('a null result means no scanners', () async {
      messenger.setMockMethodCallHandler(channel, (call) async => null);

      expect(await ScannerService.listScanners(), isEmpty);
    });

    test('missing fields become empty strings', () async {
      messenger.setMockMethodCallHandler(channel, (call) async => [<String, Object?>{}]);

      final scanner = (await ScannerService.listScanners()).single;

      expect(scanner.id, '');
      expect(scanner.name, '');
    });

    test('a platform error surfaces as ScanFailed', () async {
      messenger.setMockMethodCallHandler(channel, (call) async {
        throw PlatformException(code: 'scanner_busy');
      });

      await expectLater(
        ScannerService.listScanners(),
        throwsA(
          isA<ScanFailed>().having((e) => e.code, 'code', 'scanner_busy'),
        ),
      );
    });

    test('a missing native implementation is reported, not swallowed', () async {
      // No handler at all: the channel answers null -> MissingPluginException.
      await expectLater(
        ScannerService.listScanners(),
        throwsA(
          isA<ScanFailed>().having((e) => e.code, 'code', 'not_implemented'),
        ),
      );
    });
  });

  group('scan', () {
    test('returns the scanned pages and sends sane arguments', () async {
      final pages = [
        Uint8List.fromList([1, 2, 3]),
        Uint8List.fromList([4, 5]),
      ];
      MethodCall? received;

      messenger.setMockMethodCallHandler(channel, (call) async {
        received = call;

        return pages;
      });

      final result = await ScannerService.scan(deviceId: 'dev-9');

      expect(result, pages);
      expect(received!.method, 'scan');
      expect(received!.arguments, {
        'id': 'dev-9',
        'dpi': 300,
        'color': false,
      });
    });

    test('the dpi is clamped to the supported range', () async {
      var arguments = <Object?, Object?>{};

      messenger.setMockMethodCallHandler(channel, (call) async {
        arguments = call.arguments as Map<Object?, Object?>;

        return <Uint8List>[];
      });

      await ScannerService.scan(dpi: 5000);
      expect(arguments['dpi'], 1200);

      await ScannerService.scan(dpi: 10);
      expect(arguments['dpi'], 100);
    });

    test('an empty device id is omitted so the native side picks the first', () async {
      var arguments = <Object?, Object?>{};

      messenger.setMockMethodCallHandler(channel, (call) async {
        arguments = call.arguments as Map<Object?, Object?>;

        return <Uint8List>[];
      });

      await ScannerService.scan(deviceId: '');

      expect(arguments.containsKey('id'), isFalse);
    });

    test('a null list is treated as no pages', () async {
      messenger.setMockMethodCallHandler(channel, (call) async => null);

      expect(await ScannerService.scan(), isEmpty);
    });

    test('native error codes map onto the Dart exception types', () async {
      Future<void> expectScan(String code, Matcher matcher) async {
        messenger.setMockMethodCallHandler(channel, (call) async {
          throw PlatformException(code: code);
        });

        await expectLater(ScannerService.scan(), throwsA(matcher));
      }

      await expectScan('scanner_not_found', isA<ScannerNotFound>());
      await expectScan('scan_cancelled', isA<ScanCancelled>());
      await expectScan('feeder_empty', isA<ScanCancelled>());
      await expectScan(
        'page_read_failed',
        isA<ScanFailed>().having((e) => e.code, 'code', 'page_read_failed'),
      );
    });

    test('an unimplemented channel is reported as not_implemented', () async {
      await expectLater(
        ScannerService.scan(),
        throwsA(
          isA<ScanFailed>().having((e) => e.code, 'code', 'not_implemented'),
        ),
      );
    });
  });

  group('progress stream', () {
    test('emits the page numbers and filters malformed events', () async {
      messenger.setMockStreamHandler(
        progressChannel,
        MockStreamHandler.inline(
          onListen: (arguments, events) {
            events.success({'page': 1});
            events.success({'page': 2});
            events.success({'page': 'three'});
            events.success('not-a-map');
            events.endOfStream();
          },
        ),
      );

      final pages = await ScannerService.onProgress.toList();

      expect(pages, [1, 2]);
    });

    test('cancelling the subscription tells the native side to stop', () async {
      var cancelled = false;

      messenger.setMockStreamHandler(
        progressChannel,
        MockStreamHandler.inline(
          onListen: (arguments, events) {},
          onCancel: (arguments) => cancelled = true,
        ),
      );

      final subscription = ScannerService.onProgress.listen((_) {});
      await subscription.cancel();

      expect(cancelled, isTrue);
    });
  });
}
