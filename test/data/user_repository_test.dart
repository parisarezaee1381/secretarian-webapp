import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import 'package:flutter_application_1/authentication/password_hasher.dart';
import 'package:flutter_application_1/authentication/user_repository.dart';
import 'package:flutter_application_1/data/database/collections/user_db.dart';
import 'package:flutter_application_1/data/database/database_service.dart';

import '../support/test_database.dart';

void main() {
  Isar? isar;

  final repository = UserRepository.instance;

  setUpAll(() async {
    if (isarSkipReason != null) return;

    isar = await openTestIsar();
    DatabaseService.instance.useDatabaseForTesting(isar);
  });

  tearDownAll(() async {
    await isar?.close(deleteFromDisk: true);
    DatabaseService.instance.useDatabaseForTesting(null);
  });

  setUp(() async {
    if (isar == null) return;
    await clearTestDatabase(isar!);
  });

  group(
    'registration',
    skip: isarSkipReason,
    () {
      test('stores the account with a hashed password, never plaintext', () async {
        await repository.registerUser(
          username: 'fakour',
          recoveryAnswer: '  آبی  ',
          password: '123456',
        );

        final user = (await isar!.userDbs.where().findAll()).single;

        expect(user.username, 'fakour');
        expect(user.email, 'آبی', reason: 'the answer is trimmed');
        expect(user.passwordHash, startsWith('v2\$'));
        expect(user.passwordHash, isNot(contains('123456')));
        expect(PasswordHasher.verify('123456', user.passwordHash), isTrue);
        expect(user.createdAt, isNotNull);
      });

      test('a duplicate username is rejected without touching the account', () async {
        await repository.registerUser(
          username: 'taken',
          recoveryAnswer: 'سبز',
          password: 'first-pass',
        );

        await expectLater(
          repository.registerUser(
            username: 'taken',
            recoveryAnswer: 'قرمز',
            password: 'second-pass',
          ),
          throwsA(
            isA<UserFacingException>().having(
              (e) => e.message,
              'message',
              'نام کاربری قبلاً ثبت شده است',
            ),
          ),
        );

        final rows = await isar!.userDbs.where().findAll();
        expect(rows, hasLength(1));
        expect(PasswordHasher.verify('first-pass', rows.single.passwordHash), isTrue);
      });

      test('a blank recovery answer is rejected', () async {
        await expectLater(
          repository.registerUser(
            username: 'someone',
            recoveryAnswer: '   ',
            password: '123456',
          ),
          throwsA(isA<UserFacingException>()),
        );

        expect(await isar!.userDbs.count(), 0);
      });
    },
  );

  group(
    'login',
    skip: isarSkipReason,
    () {
      setUp(() async {
        await repository.registerUser(
          username: 'fakour',
          recoveryAnswer: 'آبی',
          password: '123456',
        );
      });

      test('accepts the stored credentials', () async {
        final user = await repository.login(
          username: 'fakour',
          password: '123456',
        );

        expect(user, isNotNull);
        expect(user!.username, 'fakour');
      });

      test('rejects a wrong password and an unknown username', () async {
        expect(
          await repository.login(username: 'fakour', password: 'wrong'),
          isNull,
        );
        expect(
          await repository.login(username: 'nobody', password: '123456'),
          isNull,
        );
      });

      test('accepts a password below the creation minimum', () async {
        await clearTestDatabase(isar!);
        await repository.registerUser(
          username: 'legacy',
          recoveryAnswer: 'آبی',
          password: '123',
        );

        // Login deliberately has no length minimum: an account created under an
        // older rule must still be reachable.
        expect(
          await repository.login(username: 'legacy', password: '123'),
          isNotNull,
        );
      });

      test('a legacy unsalted SHA-256 row still logs in', () async {
        await clearTestDatabase(isar!);

        await isar!.writeTxn(() async {
          await isar!.userDbs.put(
            UserDb()
              ..username = 'old-timer'
              ..email = 'آبی'
              ..passwordHash = sha256.convert(utf8.encode('secret')).toString()
              ..createdAt = DateTime.now(),
          );
        });

        final user = await repository.login(
          username: 'old-timer',
          password: 'secret',
        );

        expect(user, isNotNull);
        expect(user!.passwordHash, hasLength(64), reason: 'still legacy');
      });
    },
  );

  group(
    'recovery answer',
    skip: isarSkipReason,
    () {
      test('matches the trimmed answer and ignores surrounding spaces', () async {
        await repository.registerUser(
          username: 'fakour',
          recoveryAnswer: 'آبی',
          password: '123456',
        );

        expect(
          await repository.recoveryAnswerExists(answer: '  آبی '),
          isTrue,
        );
        expect(
          await repository.recoveryAnswerExists(answer: 'قرمز'),
          isFalse,
        );
      });

      test('a blank answer is rejected rather than matched', () async {
        await repository.registerUser(
          username: 'fakour',
          recoveryAnswer: 'آبی',
          password: '123456',
        );

        await expectLater(
          repository.recoveryAnswerExists(answer: '   '),
          throwsA(isA<UserFacingException>()),
        );
      });
    },
  );

  group(
    'profile and password changes',
    skip: isarSkipReason,
    () {
      setUp(() async {
        await repository.registerUser(
          username: 'fakour',
          recoveryAnswer: 'آبی',
          password: '123456',
        );
      });

      test('updating the profile persists both editable fields', () async {
        await repository.updateUser(
          username: 'fakour2',
          recoveryAnswer: 'قرمز',
        );

        final user = (await isar!.userDbs.where().findAll()).single;
        expect(user.username, 'fakour2');
        expect(user.email, 'قرمز');
      });

      test('a blank recovery answer is rejected and nothing is written', () async {
        await expectLater(
          repository.updateUser(username: 'renamed', recoveryAnswer: '  '),
          throwsA(isA<UserFacingException>()),
        );

        final user = (await isar!.userDbs.where().findAll()).single;
        expect(user.username, 'fakour');
        expect(user.email, 'آبی');
      });

      test('changing the password upgrades the hash and verifies both ways', () async {
        await repository.changePassword(newPassword: 'new-secret');

        final user = (await isar!.userDbs.where().findAll()).single;

        expect(user.passwordHash, startsWith('v2\$'));
        expect(PasswordHasher.verify('new-secret', user.passwordHash), isTrue);
        expect(PasswordHasher.verify('123456', user.passwordHash), isFalse);
        expect(await repository.verifyCurrentPassword(currentPassword: 'new-secret'), isTrue);
        expect(await repository.verifyCurrentPassword(currentPassword: '123456'), isFalse);
      });

      test('changing a legacy hash rewrites it in the current format', () async {
        await clearTestDatabase(isar!);

        await isar!.writeTxn(() async {
          await isar!.userDbs.put(
            UserDb()
              ..username = 'old-timer'
              ..email = 'آبی'
              ..passwordHash = sha256.convert(utf8.encode('secret')).toString()
              ..createdAt = DateTime.now(),
          );
        });

        await repository.changePassword(newPassword: 'secret2');

        final user = (await isar!.userDbs.where().findAll()).single;
        expect(user.passwordHash, startsWith('v2\$'));
        expect(PasswordHasher.verify('secret2', user.passwordHash), isTrue);
      });

      test('changing the password without an account fails clearly', () async {
        await clearTestDatabase(isar!);

        await expectLater(
          repository.changePassword(newPassword: 'whatever'),
          throwsA(
            isA<UserFacingException>().having(
              (e) => e.message,
              'message',
              'کاربر پیدا نشد',
            ),
          ),
        );
      });

      test('getUser returns the only account, or null when there is none', () async {
        expect((await repository.getUser())?.username, 'fakour');

        await clearTestDatabase(isar!);

        expect(await repository.getUser(), isNull);
      });
    },
  );
}
