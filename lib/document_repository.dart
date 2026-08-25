import 'package:isar/isar.dart';

import 'documents.dart';
import 'widgets.dart/notification.dart';
import 'database/database_service.dart';

import 'package:shamsi_date/shamsi_date.dart';

import 'database/outgoing_document_db.dart';
import 'database/incoming_document_db.dart';
import 'database/contract_document_db.dart';

String _todayJalaliFormatted() {
  final today = Jalali.now();
  final year = today.year.toString();
  final month = today.month.toString().padLeft(2, '0');
  final day = today.day.toString().padLeft(2, '0');
  return '$year/$month/$day';
}

class DocumentRepository {
  DocumentRepository._internal();

  static final DocumentRepository instance =
      DocumentRepository._internal();

  final List<OutgoingLetterDocument> outgoingLetters = [];
  final List<IncomingLetterDocument> incomingLetters = [];
  final List<ContractDocument> contracts = [];

  final List<dynamic> allDocuments = [];

  // ------------------------------------------------------------
  // OUTGOING
  // ------------------------------------------------------------

  Future<void> addOutgoing(OutgoingLetterDocument doc) async {
    outgoingLetters.add(doc);
    allDocuments.add(doc);

    final db = await DatabaseService.instance.database;

    final dbDoc = OutgoingDocumentDb()
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
      ..createdAt = DateTime.now();

    await db.writeTxn(() async {
      await db.outgoingDocumentDbs.put(dbDoc);
    });

    _recalculatePendingCount();
  }

  Future<void> updateOutgoing(
    String id,
    OutgoingLetterDocument updated,
  ) async {
    final index = outgoingLetters.indexWhere((d) => d.id == id);

    if (index != -1) {
      outgoingLetters[index] = updated;
    }

    final allIndex = allDocuments.indexWhere(
      (d) => d is OutgoingLetterDocument && d.id == id,
    );

    if (allIndex != -1) {
      allDocuments[allIndex] = updated;
    }

    final db = await DatabaseService.instance.database;

    final existing = await db.outgoingDocumentDbs
        .filter()
        .documentIdEqualTo(id)
        .findFirst();

    if (existing != null) {
      existing
        ..documentId = updated.id
        ..letterNumber = updated.letterNumber
        ..date = updated.date
        ..subject = updated.subject
        ..tags = List<String>.from(updated.tags)
        ..organization = updated.organization
        ..recipient = updated.recipient
        ..signer = updated.signer
        ..actionBy = updated.actionBy
        ..registrationNumber = updated.registrationNumber
        ..registrationDate = updated.registrationDate
        ..archiveFolder = updated.archiveFolder
        ..priority = updated.priority
        ..sendMethod = updated.sendMethod
        ..needsFollowUp = updated.needsFollowUp
        ..followUpDate = updated.followUpDate
        ..followUpBy = updated.followUpBy
        ..saveFile = updated.saveFile
        ..filePath = updated.filePath;

      await db.writeTxn(() async {
        await db.outgoingDocumentDbs.put(existing);
      });
    }

    _recalculatePendingCount();
  }

  // ------------------------------------------------------------
  // LOAD OUTGOING FROM ISAR
  // ------------------------------------------------------------

  Future<void> loadOutgoingFromDatabase() async {
    final db = await DatabaseService.instance.database;

    final savedDocuments =
        await db.outgoingDocumentDbs.where().build().findAll();

    outgoingLetters.clear();

    for (final saved in savedDocuments) {
      final document = OutgoingLetterDocument(
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
      );

      outgoingLetters.add(document);
    }

    _rebuildAllDocuments();
    _recalculatePendingCount();
  }

  // ------------------------------------------------------------
  // INCOMING
  // ------------------------------------------------------------

  Future<void> addIncoming(IncomingLetterDocument doc) async {
  incomingLetters.add(doc);
  allDocuments.add(doc);

  final db = await DatabaseService.instance.database;

  final dbDoc = IncomingDocumentDb()
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
    ..createdAt = DateTime.now();

  await db.writeTxn(() async {
    await db.incomingDocumentDbs.put(dbDoc);
  });

  _recalculatePendingCount();
 }

  Future<void> updateIncoming(
  String id,
  IncomingLetterDocument updated,
) async {
  final index = incomingLetters.indexWhere((d) => d.id == id);

  if (index != -1) {
    incomingLetters[index] = updated;
  }

  final allIndex = allDocuments.indexWhere(
    (d) => d is IncomingLetterDocument && d.id == id,
  );

  if (allIndex != -1) {
    allDocuments[allIndex] = updated;
  }

  final db = await DatabaseService.instance.database;

  final existing = await db.incomingDocumentDbs
      .filter()
      .documentIdEqualTo(id)
      .build()
      .findFirst();

   if (existing != null) {
    existing
      ..documentId = updated.id
      ..letterNumber = updated.letterNumber
      ..date = updated.date
      ..subject = updated.subject
      ..tags = List<String>.from(updated.tags)
      ..organization = updated.organization
      ..sender = updated.sender
      ..senderLetterNumber = updated.senderLetterNumber
      ..recipient = updated.recipient
      ..registrationDate = updated.registrationDate
      ..archiveFolder = updated.archiveFolder
      ..priority = updated.priority
      ..needsFollowUp = updated.needsFollowUp
      ..followUpDate = updated.followUpDate
      ..followUpBy = updated.followUpBy
      ..saveFile = updated.saveFile
      ..filePath = updated.filePath;

    await db.writeTxn(() async {
      await db.incomingDocumentDbs.put(existing);
    });
  }

  _recalculatePendingCount();
 }

 Future<void> loadIncomingFromDatabase() async {
  final db = await DatabaseService.instance.database;

  final savedDocuments =
      await db.incomingDocumentDbs.where().build().findAll();

  incomingLetters.clear();

  for (final saved in savedDocuments) {
    final document = IncomingLetterDocument(
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
    );

    incomingLetters.add(document);
  }

  _rebuildAllDocuments();
  _recalculatePendingCount();
}

  // ------------------------------------------------------------
  // CONTRACT
  // ------------------------------------------------------------

  Future<void> addContract(ContractDocument doc) async {
  contracts.add(doc);
  allDocuments.add(doc);

  final db = await DatabaseService.instance.database;

  final dbDoc = ContractDocumentDb()
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
    ..createdAt = DateTime.now();

  await db.writeTxn(() async {
    await db.contractDocumentDbs.put(dbDoc);
  });
 }

  Future<void> updateContract(
  String id,
  ContractDocument updated,
) async {
  final index = contracts.indexWhere((d) => d.id == id);

  if (index != -1) {
    contracts[index] = updated;
  }

  final allIndex = allDocuments.indexWhere(
    (d) => d is ContractDocument && d.id == id,
  );

  if (allIndex != -1) {
    allDocuments[allIndex] = updated;
  }

  final db = await DatabaseService.instance.database;

  final existing = await db.contractDocumentDbs
      .filter()
      .documentIdEqualTo(id)
      .build()
      .findFirst();

   if (existing != null) {
    existing
      ..documentId = updated.id
      ..letterNumber = updated.letterNumber
      ..date = updated.date
      ..subject = updated.subject
      ..tags = List<String>.from(updated.tags)
      ..organization = updated.organization
      ..recipient = updated.recipient
      ..actionBy = updated.actionBy
      ..contractSubject = updated.contractSubject
      ..registrationDate = updated.registrationDate
      ..referenceContractNumber = updated.referenceContractNumber
      ..saveFile = updated.saveFile
      ..filePath = updated.filePath;

    await db.writeTxn(() async {
      await db.contractDocumentDbs.put(existing);
    });
  }

  _recalculatePendingCount();
 }

 Future<void> loadContractsFromDatabase() async {
  final db = await DatabaseService.instance.database;

  final savedDocuments =
      await db.contractDocumentDbs.where().build().findAll();

  contracts.clear();

  for (final saved in savedDocuments) {
    final document = ContractDocument(
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
    );

    contracts.add(document);
  }

  _rebuildAllDocuments();
}

  // ------------------------------------------------------------
  // ALL DOCUMENTS
  // ------------------------------------------------------------

  void _rebuildAllDocuments() {
    allDocuments
      ..clear()
      ..addAll(outgoingLetters)
      ..addAll(incomingLetters)
      ..addAll(contracts);
  }

  List<dynamic> getLatest(int count) {
    if (allDocuments.length <= count) {
      return allDocuments.reversed.toList();
    }

    return allDocuments
        .sublist(allDocuments.length - count)
        .reversed
        .toList();
  }

  // ------------------------------------------------------------
  // PENDING
  // ------------------------------------------------------------

  void _recalculatePendingCount() {
    final today = _todayJalaliFormatted();

    final outgoingPending = outgoingLetters.where((doc) {
      return doc.followUpBy != null &&
          doc.followUpBy!.trim().isNotEmpty &&
          doc.followUpDate == today;
    }).length;

    final incomingPending = incomingLetters.where((doc) {
      return doc.followUpBy != null &&
          doc.followUpBy!.trim().isNotEmpty &&
          doc.followUpDate == today;
    }).length;

    PendingLettersData.count.value =
        outgoingPending + incomingPending;
  }
}