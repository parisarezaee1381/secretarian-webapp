import 'package:isar_community/isar.dart';

import 'package:flutter_application_1/authentication/password_hasher.dart';
import 'package:flutter_application_1/data/database/database_service.dart';
import 'package:flutter_application_1/data/database/collections/user_db.dart';

/// An error whose message is already written for the user (Persian, safe to
/// show in a snackbar). Anything else escaping the repository is a bug or an
/// infrastructure failure: log it, show a generic message — never its text.
class UserFacingException implements Exception {
  const UserFacingException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Local account storage.
///
/// The app is single-account: the gate only offers registration while no
/// user exists, and every read and mutation below targets the first (only)
/// row. The "favorite color" the UI asks for is the forgot-password
/// recovery answer; it lives in the legacy-named `UserDb.email` column,
/// because renaming an Isar field would require a schema migration.
class UserRepository {
  UserRepository._internal();

  static final UserRepository instance = UserRepository._internal();

  Future<void> registerUser({
    required String username,
    required String recoveryAnswer,
    required String password,
  }) async {
    final db = await DatabaseService.instance.database;

    final user = UserDb()
      ..username = username
      ..email = _normalizeAnswer(recoveryAnswer)
      ..passwordHash = PasswordHasher.derive(password)
      ..createdAt = DateTime.now();

    // The duplicate check lives inside the transaction on purpose:
    // UserDb.username is a unique + replace index, so a colliding put would
    // silently overwrite the existing account instead of failing.
    await db.writeTxn(() async {
      final existing = await db.userDbs
          .filter()
          .usernameEqualTo(username)
          .build()
          .findFirst();

      if (existing != null) {
        throw UserFacingException('نام کاربری قبلاً ثبت شده است');
      }

      await db.userDbs.put(user);
    });
  }

  Future<UserDb?> login({
    required String username,
    required String password,
  }) async {
    final db = await DatabaseService.instance.database;

    final user = await db.userDbs
        .filter()
        .usernameEqualTo(username)
        .build()
        .findFirst();

    if (user == null) return null;
    if (!PasswordHasher.verify(password, user.passwordHash)) return null;

    return user;
  }

  /// Whether any user registered [answer] as their recovery answer.
  Future<bool> recoveryAnswerExists({required String answer}) async {
    final db = await DatabaseService.instance.database;

    final user = await db.userDbs
        .filter()
        .emailEqualTo(_normalizeAnswer(answer))
        .findFirst();

    return user != null;
  }

  Future<UserDb?> getUser() async {
    final db = await DatabaseService.instance.database;

    return await db.userDbs.where().findFirst();
  }

  Future<void> updateUser({
    required String username,
    required String recoveryAnswer,
  }) async {
    final db = await DatabaseService.instance.database;

    final user = await db.userDbs.where().findFirst();

    if (user == null) {
      throw UserFacingException('کاربر پیدا نشد');
    }

    user.username = username;
    user.email = _normalizeAnswer(recoveryAnswer);

    await db.writeTxn(() async {
      await db.userDbs.put(user);
    });
  }

  Future<void> changePassword({required String newPassword}) async {
    final db = await DatabaseService.instance.database;

    final user = await db.userDbs.where().findFirst();

    if (user == null) {
      throw UserFacingException('کاربر پیدا نشد');
    }

    user.passwordHash = PasswordHasher.derive(newPassword);

    await db.writeTxn(() async {
      await db.userDbs.put(user);
    });
  }

  Future<bool> verifyCurrentPassword({required String currentPassword}) async {
    final db = await DatabaseService.instance.database;

    final user = await db.userDbs.where().findFirst();

    if (user == null) return false;

    return PasswordHasher.verify(currentPassword, user.passwordHash);
  }

  /// The recovery answer may not be blank: the forgot-password flow treats
  /// it as proof of ownership, and an empty stored value would make that
  /// check trivial to pass.
  static String _normalizeAnswer(String answer) {
    final trimmed = answer.trim();

    if (trimmed.isEmpty) {
      throw UserFacingException('رنگ مورد علاقه اجباری است');
    }

    return trimmed;
  }
}
