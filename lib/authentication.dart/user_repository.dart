import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';

import 'package:flutter_application_1/database/database_service.dart';
import 'package:flutter_application_1/database/user_db.dart';

class UserRepository {
  UserRepository._internal();

  static final UserRepository instance = UserRepository._internal();

  String _hash(String raw) {
    return sha256.convert(utf8.encode(raw)).toString();
  }

  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    final db = await DatabaseService.instance.database;

    final existing = await db.userDbs
        .filter()
        .usernameEqualTo(username)
        .build()
        .findFirst();

    if (existing != null) {
      throw Exception('نام کاربری قبلاً ثبت شده است');
    }

    final user = UserDb()
      ..username = username
      ..email = email
      ..passwordHash = _hash(password)
      ..createdAt = DateTime.now();

    await db.writeTxn(() async {
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
    if (user.passwordHash != _hash(password)) return null;

    return user;
  }

  Future<bool> emailExists({required String email}) async {
    final db = await DatabaseService.instance.database;

    final user = await db.userDbs.filter().emailEqualTo(email).findFirst();

    return user != null;
  }

  Future<UserDb?> getUser() async {
    final db = await DatabaseService.instance.database;

    return await db.userDbs.where().findFirst();
  }

  Future<void> updateUser({
    required String username,
    required String email,
  }) async {
    final db = await DatabaseService.instance.database;

    final user = await db.userDbs.where().findFirst();

    if (user == null) {
      throw Exception('کاربر پیدا نشد');
    }

    user.username = username;
    user.email = email;

    await db.writeTxn(() async {
      await db.userDbs.put(user);
    });
  }

  Future<void> changePassword({required String newPassword}) async {
    final db = await DatabaseService.instance.database;

    final user = await db.userDbs.where().findFirst();

    if (user == null) {
      throw Exception('کاربر پیدا نشد');
    }

    user.passwordHash = _hash(newPassword);

    await db.writeTxn(() async {
      await db.userDbs.put(user);
    });
  }

  Future<bool> verifyCurrentPassword({required String currentPassword}) async {
    final db = await DatabaseService.instance.database;

    final user = await db.userDbs.where().findFirst();

    if (user == null) return false;

    return user.passwordHash == _hash(currentPassword);
  }
}
