import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'outgoing_document_db.dart';
import 'incoming_document_db.dart';
import 'contract_document_db.dart';
import 'letter_counter.dart';
import 'user_db.dart'; // <-- جدید

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  Isar? _isar;

  Future<Isar> get database async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }

    final directory = await getApplicationDocumentsDirectory();

    _isar = await Isar.open([
      OutgoingDocumentDbSchema,
      IncomingDocumentDbSchema,
      ContractDocumentDbSchema,
      LetterCounterSchema,
      UserDbSchema,
    ], directory: directory.path);

    return _isar!;
  }
}
