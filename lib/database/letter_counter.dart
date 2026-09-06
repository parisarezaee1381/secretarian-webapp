import 'package:isar/isar.dart';

part 'letter_counter.g.dart';

@collection
class LetterCounter {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String type;

  int value = 0;
}
