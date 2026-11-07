import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

/// Result of [ScannerService.listScanners].
class ScannerDeviceInfo {
  final String id;
  final String name;

  const ScannerDeviceInfo({required this.id, required this.name});

  @override
  String toString() => 'ScannerDeviceInfo($id, $name)';
}

/// Thrown when no scanner is installed / reachable.
class ScannerNotFound implements Exception {
  final String message;
  ScannerNotFound([this.message = 'scanner_not_found']);
  @override
  String toString() => 'ScannerNotFound: $message';
}

/// Thrown when the user cancels the scan at the device or the device
/// reports an intervention requirement (paper jam, out of paper...).
class ScanCancelled implements Exception {
  final String message;
  ScanCancelled([this.message = 'scan_cancelled']);
  @override
  String toString() => 'ScanCancelled: $message';
}

/// Generic scan failure carrying the native error code.
class ScanFailed implements Exception {
  final String code;
  ScanFailed(this.code);
  @override
  String toString() => 'ScanFailed($code)';
}

/// Dart bridge to the native Windows scanner channel
/// (`windows/runner/scanner.cpp`).
class ScannerService {
  ScannerService._();

  static const MethodChannel _channel = MethodChannel('secretarian/scanner');
  static const EventChannel _progressChannel =
      EventChannel('secretarian/scanner/progress');

  /// Subscribe to receive scan progress events ({'page': int}).
  ///
  /// On non-Windows platforms (or before the native side is ready) this
  /// stream simply never emits.
  static Stream<int> get onProgress {
    if (kIsWeb || !Platform.isWindows) {
      return const Stream<int>.empty();
    }
    return _progressChannel
        .receiveBroadcastStream()
        .where((event) => event is Map && event['page'] is int)
        .map((event) => event['page'] as int);
  }

  /// Lists installed scanners. Empty list means none available.
  static Future<List<ScannerDeviceInfo>> listScanners() async {
    try {
      final result = await _channel.invokeListMethod<Map>('listScanners');
      if (result == null) return const [];
      return result
          .map((entry) => ScannerDeviceInfo(
                id: entry['id']?.toString() ?? '',
                name: entry['name']?.toString() ?? '',
              ))
          .toList();
    } on PlatformException catch (e) {
      throw ScanFailed(e.code);
    } on MissingPluginException {
      throw ScanFailed('not_implemented');
    }
  }

  /// Scans one or more pages and returns them as PNG byte arrays.
  ///
  /// [deviceId] selects a scanner (first available when null/empty).
  /// [dpi] is clamped to 100..1200 (default 300).
  /// [color] enables color mode (default: grayscale, ideal for documents).
  ///
  /// Throws [ScannerNotFound], [ScanCancelled] or [ScanFailed].
  static Future<List<Uint8List>> scan({
    String? deviceId,
    int dpi = 300,
    bool color = false,
  }) async {
    try {
      final result = await _channel.invokeListMethod<Uint8List>(
        'scan',
        {
          if (deviceId != null && deviceId.isNotEmpty) 'id': deviceId,
          'dpi': dpi.clamp(100, 1200),
          'color': color,
        },
      );
      return result ?? const [];
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'scanner_not_found':
          throw ScannerNotFound(e.message ?? e.code);
        case 'scan_cancelled':
        case 'feeder_empty':
          throw ScanCancelled(e.code);
        default:
          throw ScanFailed(e.code);
      }
    } on MissingPluginException {
      throw ScanFailed('not_implemented');
    }
  }
}
