import 'package:isar/isar.dart';

part 'outgoing_document_db.g.dart';

@embedded
class AttachmentDocumentDb {
  String name = '';
  String? path;
  List<byte>? bytes;
}

@collection
class OutgoingDocumentDb {
  Id id = Isar.autoIncrement;

  late String documentId;
  late String letterNumber;
  late String date;
  late String subject;
  late List<String> tags;

  late String organization;
  late String recipient;
  late String signer;
  late String actionBy;

  late String registrationNumber;
  late String registrationDate;
  late String archiveFolder;

  late String priority;
  late String sendMethod;

  late bool needsFollowUp;
  String? followUpDate;
  String? followUpBy;

  late bool saveFile;
  String? filePath;

  List<AttachmentDocumentDb> attachments = [];

  late DateTime createdAt;
}
