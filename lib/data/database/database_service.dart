import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'collections/outgoing_document_db.dart';
import 'collections/incoming_document_db.dart';
import 'collections/contract_document_db.dart';
import 'collections/letter_counter.dart';
import 'collections/user_db.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  Isar? _isar;

  /// The open that is currently in flight, shared by every caller.
  ///
  /// Startup loads documents in parallel, so without this each of them would
  /// call `Isar.open` at the same time. It is cleared when the attempt finishes
  /// so a failed (or timed-out) open can be retried instead of reused forever.
  Future<Isar>? _opening;

  Future<Isar> get database {
    final Isar? open = _isar;

    if (open != null && open.isOpen) {
      return Future.value(open);
    }

    return _opening ??= _open();
  }

  /// Points the service at an already-open [isar] — or forgets it again — so
  /// tests can exercise the repositories without `path_provider` and without
  /// writing into the real documents directory.
  @visibleForTesting
  void useDatabaseForTesting(Isar? isar) {
    _isar = isar;
    _opening = null;
  }

  Future<Isar> _open() async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      final isar = await Isar.open([
        OutgoingDocumentDbSchema,
        IncomingDocumentDbSchema,
        ContractDocumentDbSchema,
        LetterCounterSchema,
        UserDbSchema,
      ], directory: directory.path);

      _isar = isar;

      return isar;
    } finally {
      // Either way the attempt is over: success is cached in [_isar], failure
      // must be retryable.
      _opening = null;
    }
  }
}
