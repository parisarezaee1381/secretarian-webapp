import 'dart:typed_data';

class AttachmentDocument {
  final String name;
  final String? path;
  final Uint8List? bytes;

  const AttachmentDocument({
    required this.name,
    this.path,
    this.bytes,
  });
}

class OutgoingLetterDocument {
  final String id;    
  final String letterNumber;
  final String date;
  final String subject;
  final List<String> tags;

  final String organization;
  final String recipient;
  final String signer;
  final String actionBy;

  final String registrationNumber;
  final String registrationDate;
  final String archiveFolder;

  final String priority;
  final String sendMethod;

  final bool needsFollowUp;
  final String? followUpDate;
  final String? followUpBy;

  final bool saveFile;
  final String? filePath;

  final List<AttachmentDocument> attachments;

  const OutgoingLetterDocument({
    required this.id,  
    required this.letterNumber,
    required this.date,
    required this.subject,
    required this.tags,

    required this.organization,
    required this.recipient,
    required this.signer,
    required this.actionBy,

    required this.registrationNumber,
    required this.registrationDate,
    required this.archiveFolder,

    required this.priority,
    required this.sendMethod,

    required this.needsFollowUp,
    this.followUpDate,
    this.followUpBy,

    required this.saveFile,
    this.filePath,

    this.attachments = const [],
  });
}

class IncomingLetterDocument {
   final String id;  
  final String letterNumber;
  final String date;
  final String subject;
  final List<String> tags;

  final String organization;
  final String sender;
  final String senderLetterNumber;
  final String recipient;

  final String registrationDate;
  final String archiveFolder;

  final String priority;

  final bool needsFollowUp;
  final String? followUpDate;
  final String? followUpBy;

  final bool saveFile;
  final String? filePath;

  final List<AttachmentDocument> attachments;

  const IncomingLetterDocument({
    required this.id,  
    required this.letterNumber,
    required this.date,
    required this.subject,
    required this.tags,

    required this.organization,
    required this.sender,
    required this.senderLetterNumber,
    required this.recipient,

    required this.registrationDate,
    required this.archiveFolder,

    required this.priority,

    required this.needsFollowUp,
    this.followUpDate,
    this.followUpBy,

    required this.saveFile,
    this.filePath,

    this.attachments = const [],
  });
}

class ContractDocument {
  final String id; 
  final String letterNumber;
  final String date;
  final String subject;
  final List<String> tags;
  final String organization;
  final String recipient;
  final String actionBy;
  final String contractSubject;
  final String registrationDate;
  final String referenceContractNumber;
  final bool saveFile;
  final String? filePath;
  final List<AttachmentDocument> attachments;

  const ContractDocument({
    required this.id,   
    required this.letterNumber,
    required this.date,
    required this.subject,
    required this.tags,
    required this.organization,
    required this.recipient,
    required this.actionBy,
    required this.contractSubject,
    required this.registrationDate,
    required this.referenceContractNumber,
    required this.saveFile,
    this.filePath,
    this.attachments = const [],
  });
}