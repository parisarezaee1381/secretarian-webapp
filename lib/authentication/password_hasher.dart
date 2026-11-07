import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Password hashing for the local account.
///
/// The current storage format (`v2$…`) is PBKDF2-HMAC-SHA-256 with a
/// per-user random salt. Accounts written before the upgrade hold a plain
/// unsalted SHA-256 hex string; [PasswordHasher.verify] still accepts those
/// so existing installs keep working — the stored hash moves to the current
/// format the next time the password is changed.
abstract final class PasswordHasher {
  /// PBKDF2 work factor. Stored hashes carry their own iteration count, so
  /// raising this keeps old hashes verifiable.
  static const int _iterations = 100000;

  static const int _saltBytes = 16;
  static const int _keyBytes = 32;

  /// SHA-256 output size in bytes.
  static const int _digestBytes = 32;

  static final Random _secureRandom = Random.secure();

  /// Returns the storage string for [raw].
  static String derive(String raw) {
    final salt = List<int>.generate(
      _saltBytes,
      (_) => _secureRandom.nextInt(256),
    );
    final key = _pbkdf2(utf8.encode(raw), salt, _iterations, _keyBytes);

    return 'v2\$$_iterations\$${_toHex(salt)}\$${_toHex(key)}';
  }

  /// Whether [raw] matches the stored [hash]. Understands both the current
  /// `v2$…` format and legacy unsalted SHA-256 hex.
  static bool verify(String raw, String hash) {
    final parts = hash.split('\$');

    if (parts.length == 4 && parts[0] == 'v2') {
      final iterations = int.tryParse(parts[1]);
      final salt = _fromHex(parts[2]);
      final expected = _fromHex(parts[3]);

      if (iterations == null ||
          iterations <= 0 ||
          salt == null ||
          expected == null ||
          expected.isEmpty) {
        return false;
      }

      final actual = _pbkdf2(utf8.encode(raw), salt, iterations, expected.length);
      return _constantTimeEquals(actual, expected);
    }

    // Legacy format: unsalted SHA-256 hex.
    return hash == sha256.convert(utf8.encode(raw)).toString();
  }

  /// Standard PBKDF2 (RFC 2898) over HMAC-SHA-256.
  static Uint8List _pbkdf2(
    List<int> password,
    List<int> salt,
    int iterations,
    int byteLength,
  ) {
    final hmac = Hmac(sha256, password);
    final blocks = (byteLength / _digestBytes).ceil();

    final out = <int>[];

    for (var block = 1; block <= blocks; block++) {
      var u = hmac
          .convert(<int>[
            ...salt,
            (block >> 24) & 0xff,
            (block >> 16) & 0xff,
            (block >> 8) & 0xff,
            block & 0xff,
          ])
          .bytes;
      final t = List<int>.from(u);

      for (var i = 1; i < iterations; i++) {
        u = hmac.convert(u).bytes;
        for (var j = 0; j < t.length; j++) {
          t[j] ^= u[j];
        }
      }

      out.addAll(t);
    }

    return Uint8List.fromList(out.sublist(0, byteLength));
  }

  static String _toHex(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  static List<int>? _fromHex(String hex) {
    if (hex.length.isOdd) return null;

    final out = List<int>.filled(hex.length ~/ 2, 0);

    for (var i = 0; i < out.length; i++) {
      final byte = int.tryParse(hex.substring(i * 2, i * 2 + 2), radix: 16);
      if (byte == null) return null;
      out[i] = byte;
    }

    return out;
  }

  /// Compares two byte lists without leaking where they differ.
  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;

    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}
