import 'package:isar_community/isar.dart';

part 'user_db.g.dart';

@collection
class UserDb {
  Id id = Isar.autoIncrement;

  /// Unique + replace: a colliding put silently overwrites the existing row
  /// instead of failing. `UserRepository.registerUser` performs its
  /// duplicate check inside the write transaction so that cannot happen
  /// through the app.
  @Index(unique: true, replace: true)
  late String username;

  /// The forgot-password answer (the UI asks for a favorite color). Named
  /// `email` for historical reasons; renaming it would require an Isar
  /// schema migration. Stored in plain text, like any security answer.
  late String email;

  /// PBKDF2 string (see PasswordHasher). Legacy rows hold unsalted SHA-256 hex.
  late String passwordHash;

  late DateTime createdAt;
}
