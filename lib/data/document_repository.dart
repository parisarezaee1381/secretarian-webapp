import 'package:isar_community/isar.dart';
import 'package:flutter/foundation.dart';

import '../domain/documents.dart';
import '../core/pending_letters_data.dart';
import 'database/database_service.dart';

import 'package:shamsi_date/shamsi_date.dart';

import 'database/collections/outgoing_document_db.dart';
import 'database/collections/incoming_document_db.dart';
import 'database/collections/contract_document_db.dart';

String _todayJalaliFormatted() {
  final today = Jalali.now();
  final year = today.year.toString().padLeft(4, '0');
  final month = today.month.toString().padLeft(2, '0');
  final day = today.day.toString().padLeft(2, '0');
  return '$year/$month/$day';
}

AttachmentDocumentDb _toOutgoingAttachmentDb(AttachmentDocument attachment) {
  return AttachmentDocumentDb()
    ..name = attachment.name
    ..path = attachment.path
    ..bytes = attachment.bytes?.toList();
}

IncomingAttachmentDocumentDb _toIncomingAttachmentDb(
  AttachmentDocument attachment,
) {
  return IncomingAttachmentDocumentDb()
    ..name = attachment.name
    ..path = attachment.path
    ..bytes = attachment.bytes?.toList();
}

ContractAttachmentDocumentDb _toContractAttachmentDb(
  AttachmentDocument attachment,
) {
  return ContractAttachmentDocumentDb()
    ..name = attachment.name
    ..path = attachment.path
    ..bytes = attachment.bytes?.toList();
}

/// Converts one stored attachment, dropping rows that are unusable (no path
/// and no bytes) so loading can never trip the `AttachmentDocument` assert.
AttachmentDocument? _tryAttachmentFromDb({
  required String name,
  required String? path,
  required List<int>? bytes,
}) {
  if (path == null && bytes == null) return null;

  return AttachmentDocument(
    name: name,
    path: path,
    bytes: bytes != null ? Uint8List.fromList(bytes) : null,
  );
}

/// Model -> row mappings, one per document type.
///
/// Each is shared by add (applied to a fresh row, Isar id 0) and update
/// (applied to the already-loaded row, preserving its id and createdAt), so a
/// field can never be persisted on create but silently dropped on edit.
/// Deliberately does not touch `id` (Isar-managed) or `createdAt`.
void _applyOutgoingToDb(OutgoingLetterDocument doc, OutgoingDocumentDb target) {
  target
    ..documentId = doc.id
    ..letterNumber = doc.letterNumber
    ..date = doc.date
    ..subject = doc.subject
    ..tags = List<String>.from(doc.tags)
    ..organization = doc.organization
    ..recipient = doc.recipient
    ..signer = doc.signer
    ..actionBy = doc.actionBy
    ..registrationNumber = doc.registrationNumber
    ..registrationDate = doc.registrationDate
    ..archiveFolder = doc.archiveFolder
    ..priority = doc.priority
    ..sendMethod = doc.sendMethod
    ..needsFollowUp = doc.needsFollowUp
    ..followUpDate = doc.followUpDate
    ..followUpBy = doc.followUpBy
    ..saveFile = doc.saveFile
    ..filePath = doc.filePath
    ..attachments = doc.attachments.map(_toOutgoingAttachmentDb).toList();
}

/// Row -> model mapping used by `loadOutgoingFromDatabase`.
OutgoingLetterDocument _outgoingFromDb(OutgoingDocumentDb saved) {
  return OutgoingLetterDocument(
    id: saved.documentId,
    letterNumber: saved.letterNumber,
    date: saved.date,
    subject: saved.subject,
    tags: List<String>.from(saved.tags),
    organization: saved.organization,
    recipient: saved.recipient,
    signer: saved.signer,
    actionBy: saved.actionBy,
    registrationNumber: saved.registrationNumber,
    registrationDate: saved.registrationDate,
    archiveFolder: saved.archiveFolder,
    priority: saved.priority,
    sendMethod: saved.sendMethod,
    needsFollowUp: saved.needsFollowUp,
    followUpDate: saved.followUpDate,
    followUpBy: saved.followUpBy,
    saveFile: saved.saveFile,
    filePath: saved.filePath,
    attachments: saved.attachments
        .map((a) => _tryAttachmentFromDb(
              name: a.name,
              path: a.path,
              bytes: a.bytes,
            ))
        .whereType<AttachmentDocument>()
        .toList(),
  );
}

void _applyIncomingToDb(IncomingLetterDocument doc, IncomingDocumentDb target) {
  target
    ..documentId = doc.id
    ..letterNumber = doc.letterNumber
    ..date = doc.date
    ..subject = doc.subject
    ..tags = List<String>.from(doc.tags)
    ..organization = doc.organization
    ..sender = doc.sender
    ..senderLetterNumber = doc.senderLetterNumber
    ..recipient = doc.recipient
    ..registrationDate = doc.registrationDate
    ..archiveFolder = doc.archiveFolder
    ..priority = doc.priority
    ..needsFollowUp = doc.needsFollowUp
    ..followUpDate = doc.followUpDate
    ..followUpBy = doc.followUpBy
    ..saveFile = doc.saveFile
    ..filePath = doc.filePath
    ..attachments = doc.attachments.map(_toIncomingAttachmentDb).toList();
}

IncomingLetterDocument _incomingFromDb(IncomingDocumentDb saved) {
  return IncomingLetterDocument(
    id: saved.documentId,
    letterNumber: saved.letterNumber,
    date: saved.date,
    subject: saved.subject,
    tags: List<String>.from(saved.tags),
    organization: saved.organization,
    sender: saved.sender,
    senderLetterNumber: saved.senderLetterNumber,
    recipient: saved.recipient,
    registrationDate: saved.registrationDate,
    archiveFolder: saved.archiveFolder,
    priority: saved.priority,
    needsFollowUp: saved.needsFollowUp,
    followUpDate: saved.followUpDate,
    followUpBy: saved.followUpBy,
    saveFile: saved.saveFile,
    filePath: saved.filePath,
    attachments: saved.attachments
        .map((a) => _tryAttachmentFromDb(
              name: a.name,
              path: a.path,
              bytes: a.bytes,
            ))
        .whereType<AttachmentDocument>()
        .toList(),
  );
}

void _applyContractToDb(ContractDocument doc, ContractDocumentDb target) {
  target
    ..documentId = doc.id
    ..letterNumber = doc.letterNumber
    ..date = doc.date
    ..subject = doc.subject
    ..tags = List<String>.from(doc.tags)
    ..organization = doc.organization
    ..recipient = doc.recipient
    ..actionBy = doc.actionBy
    ..contractSubject = doc.contractSubject
    ..registrationDate = doc.registrationDate
    ..referenceContractNumber = doc.referenceContractNumber
    ..saveFile = doc.saveFile
    ..filePath = doc.filePath
    ..attachments = doc.attachments.map(_toContractAttachmentDb).toList();
}

ContractDocument _contractFromDb(ContractDocumentDb saved) {
  return ContractDocument(
    id: saved.documentId,
    letterNumber: saved.letterNumber,
    date: saved.date,
    subject: saved.subject,
    tags: List<String>.from(saved.tags),
    organization: saved.organization,
    recipient: saved.recipient,
    actionBy: saved.actionBy,
    contractSubject: saved.contractSubject,
    registrationDate: saved.registrationDate,
    referenceContractNumber: saved.referenceContractNumber,
    saveFile: saved.saveFile,
    filePath: saved.filePath,
    attachments: saved.attachments
        .map((a) => _tryAttachmentFromDb(
              name: a.name,
              path: a.path,
              bytes: a.bytes,
            ))
        .whereType<AttachmentDocument>()
        .toList(),
  );
}

class DocumentRepository extends ChangeNotifier {
  DocumentRepository._internal();

  static final DocumentRepository instance = DocumentRepository._internal();

  final List<OutgoingLetterDocument> _outgoingLetters = [];
  final List<IncomingLetterDocument> _incomingLetters = [];
  final List<ContractDocument> _contracts = [];

  final List<Document> _allDocuments = [];

  /// Read-only views of the stored documents.
  ///
  /// Exposed as unmodifiable copies so UI code can only change repository
  /// state through the add/update/delete methods (which notify listeners).
  List<OutgoingLetterDocument> get outgoingLetters =>
      List.unmodifiable(_outgoingLetters);

  List<IncomingLetterDocument> get incomingLetters =>
      List.unmodifiable(_incomingLetters);

  List<ContractDocument> get contracts => List.unmodifiable(_contracts);

  /// Replaces the in-memory lists without touching the database.
  ///
  /// Widget tests run under a fake-async binding, where an Isar call never
  /// completes, so they need to render documents without opening one.
  @visibleForTesting
  void seedForTesting({
    List<OutgoingLetterDocument> outgoing = const [],
    List<IncomingLetterDocument> incoming = const [],
    List<ContractDocument> contracts = const [],
  }) {
    _outgoingLetters
      ..clear()
      ..addAll(outgoing);
    _incomingLetters
      ..clear()
      ..addAll(incoming);
    _contracts
      ..clear()
      ..addAll(contracts);

    _rebuildAllDocuments();
    _recalculatePendingCount();

    notifyListeners();
  }

  Future<void> addOutgoing(OutgoingLetterDocument doc) async {
    // The in-memory lists mirror the DB, so a duplicate here would become a
    // duplicate row on the next load — skip instead.
    if (_outgoingLetters.any((d) => d.id == doc.id)) return;

    final db = await DatabaseService.instance.database;

    final dbDoc = OutgoingDocumentDb()..createdAt = DateTime.now();
    _applyOutgoingToDb(doc, dbDoc);

    await db.writeTxn(() async {
      await db.outgoingDocumentDbs.put(dbDoc);
    });

    // Only mutate in-memory state after the write succeeds, so a failed
    // write can't leave the UI showing a document that was never saved.
    _outgoingLetters.add(doc);
    _allDocuments.add(doc);

    _recalculatePendingCount();

    notifyListeners();
  }

  Future<void> updateOutgoing(String id, OutgoingLetterDocument updated) async {
    final db = await DatabaseService.instance.database;

    final existing = await db.outgoingDocumentDbs
        .filter()
        .documentIdEqualTo(id)
        .findFirst();

    if (existing == null) {
      // Nothing to persist to — surface the inconsistency instead of
      // updating in-memory state that would revert on the next load.
      throw StateError('Outgoing document $id not found in database');
    }

    // Reuses the loaded row so its Isar id and createdAt are preserved.
    _applyOutgoingToDb(updated, existing);

    await db.writeTxn(() async {
      await db.outgoingDocumentDbs.put(existing);
    });

    // Replace in-memory copies only after the write succeeds, so a failed
    // write can't leave the lists showing an update that never persisted.
    final index = _outgoingLetters.indexWhere((d) => d.id == id);
    if (index != -1) {
      _outgoingLetters[index] = updated;
    }

    final allIndex = _allDocuments.indexWhere(
      (d) => d is OutgoingLetterDocument && d.id == id,
    );
    if (allIndex != -1) {
      _allDocuments[allIndex] = updated;
    }

    _recalculatePendingCount();

    notifyListeners();
  }

  Future<void> deleteOutgoing(String id) async {
    final db = await DatabaseService.instance.database;

    final existing = await db.outgoingDocumentDbs
        .filter()
        .documentIdEqualTo(id)
        .findFirst();

    if (existing != null) {
      await db.writeTxn(() async {
        await db.outgoingDocumentDbs.delete(existing.id);
      });
    }

    // Remove from memory only after the delete succeeds (or the row was
    // already gone), so a failed write can't drop a document the DB still
    // holds.
    _outgoingLetters.removeWhere((doc) => doc.id == id);
    _allDocuments.removeWhere(
      (doc) => doc is OutgoingLetterDocument && doc.id == id,
    );

    _recalculatePendingCount();

    notifyListeners();
  }

  Future<void> loadOutgoingFromDatabase() async {
    final db = await DatabaseService.instance.database;

    final savedDocuments = await db.outgoingDocumentDbs
        .where()
        .build()
        .findAll();

    final loaded = <OutgoingLetterDocument>[];
    for (final saved in savedDocuments) {
      loaded.add(_outgoingFromDb(saved));
    }

    // Swap only after the whole load succeeds, so a mid-loop error can't
    // leave the list partially replaced.
    _outgoingLetters
      ..clear()
      ..addAll(loaded);

    _rebuildAllDocuments();
    _recalculatePendingCount();

    notifyListeners();
  }

  Future<void> addIncoming(IncomingLetterDocument doc) async {
    // The in-memory lists mirror the DB, so a duplicate here would become a
    // duplicate row on the next load — skip instead.
    if (_incomingLetters.any((d) => d.id == doc.id)) return;

    final db = await DatabaseService.instance.database;

    final dbDoc = IncomingDocumentDb()..createdAt = DateTime.now();
    _applyIncomingToDb(doc, dbDoc);

    await db.writeTxn(() async {
      await db.incomingDocumentDbs.put(dbDoc);
    });

    // Only mutate in-memory state after the write succeeds, so a failed
    // write can't leave the UI showing a document that was never saved.
    _incomingLetters.add(doc);
    _allDocuments.add(doc);

    _recalculatePendingCount();

    notifyListeners();
  }

  Future<void> updateIncoming(String id, IncomingLetterDocument updated) async {
    final db = await DatabaseService.instance.database;

    final existing = await db.incomingDocumentDbs
        .filter()
        .documentIdEqualTo(id)
        .findFirst();

    if (existing == null) {
      // Nothing to persist to — surface the inconsistency instead of
      // updating in-memory state that would revert on the next load.
      throw StateError('Incoming document $id not found in database');
    }

    // Reuses the loaded row so its Isar id and createdAt are preserved.
    _applyIncomingToDb(updated, existing);

    await db.writeTxn(() async {
      await db.incomingDocumentDbs.put(existing);
    });

    // Replace in-memory copies only after the write succeeds, so a failed
    // write can't leave the lists showing an update that never persisted.
    final index = _incomingLetters.indexWhere((d) => d.id == id);
    if (index != -1) {
      _incomingLetters[index] = updated;
    }

    final allIndex = _allDocuments.indexWhere(
      (d) => d is IncomingLetterDocument && d.id == id,
    );
    if (allIndex != -1) {
      _allDocuments[allIndex] = updated;
    }

    _recalculatePendingCount();

    notifyListeners();
  }

  Future<void> deleteIncoming(String id) async {
    final db = await DatabaseService.instance.database;

    final existing = await db.incomingDocumentDbs
        .filter()
        .documentIdEqualTo(id)
        .findFirst();

    if (existing != null) {
      await db.writeTxn(() async {
        await db.incomingDocumentDbs.delete(existing.id);
      });
    }

    // Remove from memory only after the delete succeeds (or the row was
    // already gone), so a failed write can't drop a document the DB still
    // holds.
    _incomingLetters.removeWhere((doc) => doc.id == id);
    _allDocuments.removeWhere(
      (doc) => doc is IncomingLetterDocument && doc.id == id,
    );

    _recalculatePendingCount();

    notifyListeners();
  }

  Future<void> loadIncomingFromDatabase() async {
    final db = await DatabaseService.instance.database;

    final savedDocuments = await db.incomingDocumentDbs
        .where()
        .build()
        .findAll();

    final loaded = <IncomingLetterDocument>[];
    for (final saved in savedDocuments) {
      loaded.add(_incomingFromDb(saved));
    }

    // Swap only after the whole load succeeds, so a mid-loop error can't
    // leave the list partially replaced.
    _incomingLetters
      ..clear()
      ..addAll(loaded);

    _rebuildAllDocuments();
    _recalculatePendingCount();

    notifyListeners();
  }

  Future<void> addContract(ContractDocument doc) async {
    // The in-memory lists mirror the DB, so a duplicate here would become a
    // duplicate row on the next load — skip instead.
    if (_contracts.any((d) => d.id == doc.id)) return;

    final db = await DatabaseService.instance.database;

    final dbDoc = ContractDocumentDb()..createdAt = DateTime.now();
    _applyContractToDb(doc, dbDoc);

    await db.writeTxn(() async {
      await db.contractDocumentDbs.put(dbDoc);
    });

    // Only mutate in-memory state after the write succeeds, so a failed
    // write can't leave the UI showing a document that was never saved.
    _contracts.add(doc);
    _allDocuments.add(doc);

    notifyListeners();
  }

  Future<void> updateContract(String id, ContractDocument updated) async {
    final db = await DatabaseService.instance.database;

    final existing = await db.contractDocumentDbs
        .filter()
        .documentIdEqualTo(id)
        .findFirst();

    if (existing == null) {
      // Nothing to persist to — surface the inconsistency instead of
      // updating in-memory state that would revert on the next load.
      throw StateError('Contract $id not found in database');
    }

    // Reuses the loaded row so its Isar id and createdAt are preserved.
    _applyContractToDb(updated, existing);

    await db.writeTxn(() async {
      await db.contractDocumentDbs.put(existing);
    });

    // Replace in-memory copies only after the write succeeds, so a failed
    // write can't leave the lists showing an update that never persisted.
    final index = _contracts.indexWhere((d) => d.id == id);
    if (index != -1) {
      _contracts[index] = updated;
    }

    final allIndex = _allDocuments.indexWhere(
      (d) => d is ContractDocument && d.id == id,
    );
    if (allIndex != -1) {
      _allDocuments[allIndex] = updated;
    }

    notifyListeners();
  }

  Future<void> deleteContract(String id) async {
    final db = await DatabaseService.instance.database;

    final existing = await db.contractDocumentDbs
        .filter()
        .documentIdEqualTo(id)
        .findFirst();

    if (existing != null) {
      await db.writeTxn(() async {
        await db.contractDocumentDbs.delete(existing.id);
      });
    }

    // Remove from memory only after the delete succeeds (or the row was
    // already gone), so a failed write can't drop a document the DB still
    // holds.
    _contracts.removeWhere((doc) => doc.id == id);
    _allDocuments.removeWhere(
      (doc) => doc is ContractDocument && doc.id == id,
    );

    notifyListeners();
  }

  Future<void> loadContractsFromDatabase() async {
    final db = await DatabaseService.instance.database;

    final savedDocuments = await db.contractDocumentDbs
        .where()
        .build()
        .findAll();

    final loaded = <ContractDocument>[];
    for (final saved in savedDocuments) {
      loaded.add(_contractFromDb(saved));
    }

    // Swap only after the whole load succeeds, so a mid-loop error can't
    // leave the list partially replaced.
    _contracts
      ..clear()
      ..addAll(loaded);

    _rebuildAllDocuments();

    notifyListeners();
  }

  void _rebuildAllDocuments() {
    _allDocuments
      ..clear()
      ..addAll(_outgoingLetters)
      ..addAll(_incomingLetters)
      ..addAll(_contracts);
  }

  /// The [count] most recent documents, newest first, regardless of type.
  ///
  /// Sorted by date so the dashboard's "latest" panel isn't skewed by the
  /// type-grouped insertion order in the underlying list.
  List<Document> getLatest(int count) {
    final indexed = _allDocuments.asMap().entries.toList()
      ..sort((a, b) {
        final byDate = b.value.date.compareTo(a.value.date);
        // Tie-break on insertion order so equal dates stay deterministic.
        return byDate != 0 ? byDate : b.key.compareTo(a.key);
      });

    return indexed.take(count).map((entry) => entry.value).toList();
  }

  void _recalculatePendingCount() {
    final today = _todayJalaliFormatted();

    final outgoingPending = _outgoingLetters.where((doc) {
      return doc.followUpBy != null &&
          doc.followUpBy!.trim().isNotEmpty &&
          doc.followUpDate == today;
    }).length;

    final incomingPending = _incomingLetters.where((doc) {
      return doc.followUpBy != null &&
          doc.followUpBy!.trim().isNotEmpty &&
          doc.followUpDate == today;
    }).length;

    PendingLettersData.count.value = outgoingPending + incomingPending;
  }
}
