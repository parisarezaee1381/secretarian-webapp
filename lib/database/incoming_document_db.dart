import 'package:isar/isar.dart';

part 'incoming_document_db.g.dart';

@embedded
class IncomingAttachmentDocumentDb {
  String name = '';
  String? path;
  List<byte>? bytes;
}

@collection
class IncomingDocumentDb {
  Id id = Isar.autoIncrement;

  late String documentId;
  late String letterNumber;
  late String date;
  late String subject;
  late List<String> tags;

  late String organization;
  late String sender;
  late String senderLetterNumber;
  late String recipient;

  late String registrationDate;
  late String archiveFolder;

  late String priority;

  late bool needsFollowUp;
  String? followUpDate;
  String? followUpBy;

  late bool saveFile;
  String? filePath;

  List<IncomingAttachmentDocumentDb> attachments = [];

  late DateTime createdAt;
}
