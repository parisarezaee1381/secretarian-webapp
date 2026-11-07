import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import 'package:flutter_application_1/authentication/user_repository.dart';
import 'package:flutter_application_1/core/session.dart';
import 'package:flutter_application_1/data/database/database_service.dart';
import 'package:flutter_application_1/data/document_repository.dart';

import '../support/test_database.dart';

void main() {
  Isar? isar;

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
    await DocumentRepository.instance.loadOutgoingFromDatabase();
    await DocumentRepository.instance.loadIncomingFromDatabase();
    await DocumentRepository.instance.loadContractsFromDatabase();
  });

  group(
    'startup',
    skip: isarSkipReason,
    () {
      test('an empty database lands on the registration phase', () async {
        final session = SessionController();

        await session.start();

        expect(session.phase, AppPhase.noAccount);
        expect(session.error, isNull);
      });

      test('an existing account lands on the signed-out phase', () async {
        await UserRepository.instance.registerUser(
          username: 'fakour',
          recoveryAnswer: 'آبی',
          password: '123456',
        );

        final session = SessionController();
        await session.start();

        expect(session.phase, AppPhase.signedOut);
      });

      test('concurrent calls share one run', () async {
        final session = SessionController();

        final first = session.start();
        final second = session.start();

        expect(identical(first, second), isTrue);

        await first;
        expect(session.phase, isIn([AppPhase.noAccount, AppPhase.signedOut]));
      });

      test('starting again after a run works and re-decides the phase', () async {
        final session = SessionController();

        await session.start();
        expect(session.phase, AppPhase.noAccount);

        await UserRepository.instance.registerUser(
          username: 'fakour',
          recoveryAnswer: 'آبی',
          password: '123456',
        );

        await session.start();
        expect(session.phase, AppPhase.signedOut);
      });

      test('a failed open reports the error instead of hanging', () async {
        DatabaseService.instance.useDatabaseForTesting(null);

        final session = SessionController(startupTimeout: const Duration(seconds: 2));

        try {
          await session.start();

          expect(session.phase, AppPhase.failed);
          expect(session.error, isNotNull);
        } finally {
          DatabaseService.instance.useDatabaseForTesting(isar);
        }
      });

      test('retrying after a failure can succeed', () async {
        DatabaseService.instance.useDatabaseForTesting(null);

        final session = SessionController(startupTimeout: const Duration(seconds: 2));

        await session.start();
        expect(session.phase, AppPhase.failed);

        DatabaseService.instance.useDatabaseForTesting(isar);

        await session.start();

        expect(session.phase, AppPhase.noAccount);
        expect(session.error, isNull);
      });
    },
  );

  group('phase changes', () {
    test('signIn and signOut move between the signed-in states', () {
      final session = SessionController.forTesting(AppPhase.signedOut);

      session.signIn();
      expect(session.phase, AppPhase.signedIn);

      session.signOut();
      expect(session.phase, AppPhase.signedOut);
    });

    test('each real phase change notifies exactly once', () {
      final session = SessionController.forTesting(AppPhase.signedOut);

      var notifications = 0;
      session.addListener(() => notifications++);

      session.signIn();
      session.signIn();
      session.signOut();

      expect(notifications, 2);
    });

    test('the test factory parks the controller without starting up', () {
      final session = SessionController.forTesting(AppPhase.signedIn);

      expect(session.phase, AppPhase.signedIn);
      expect(session.error, isNull);
    });
  });
}
