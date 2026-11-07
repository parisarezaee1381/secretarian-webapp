import 'package:isar_community/isar.dart';

part 'contract_document_db.g.dart';

@embedded
class ContractAttachmentDocumentDb {
  String name = '';
  String? path;
  List<byte>? bytes;
}

@collection
class ContractDocumentDb {
  Id id = Isar.autoIncrement;

  late String documentId;
  late String letterNumber;
  late String date;
  late String subject;
  late List<String> tags;

  late String organization;
  late String recipient;
  late String actionBy;

  late String contractSubject;
  late String registrationDate;
  late String referenceContractNumber;

  late bool saveFile;
  String? filePath;

  List<ContractAttachmentDocumentDb> attachments = [];

  late DateTime createdAt;
}
