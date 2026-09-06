import 'package:isar/isar.dart';

part 'user_db.g.dart';

@collection
class UserDb {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String username;

  late String email;

  late String passwordHash;

  late DateTime createdAt;
}
