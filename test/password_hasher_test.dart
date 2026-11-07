import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/authentication/password_hasher.dart';

void main() {
  test('derive produces a v2 hash that verifies the original password', () {
    final stored = PasswordHasher.derive('secret-123');

    expect(stored, startsWith('v2\$'));
    expect(PasswordHasher.verify('secret-123', stored), isTrue);
  });

  test('verify rejects a wrong password', () {
    final stored = PasswordHasher.derive('secret-123');

    expect(PasswordHasher.verify('not-the-password', stored), isFalse);
  });

  test('each derive uses a fresh salt', () {
    expect(
      PasswordHasher.derive('same-input'),
      isNot(PasswordHasher.derive('same-input')),
    );
  });

  test('legacy unsalted SHA-256 hashes still verify', () {
    final legacy = sha256.convert(utf8.encode('old-password')).toString();

    expect(PasswordHasher.verify('old-password', legacy), isTrue);
    expect(PasswordHasher.verify('wrong', legacy), isFalse);
  });

  test('malformed v2 hashes fail closed', () {
    expect(PasswordHasher.verify('x', 'v2\$100000\$abc'), isFalse);
    expect(PasswordHasher.verify('x', 'v2\$100000\$zzz\$00'), isFalse);
    expect(PasswordHasher.verify('x', 'v2\$100000\$ab\$'), isFalse);
  });
}
