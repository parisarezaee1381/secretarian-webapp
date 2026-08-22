import '../../documents.dart';

enum PdfDocumentType {
  outgoing,
  incoming,
  contract,
}

class PdfDocumentData {

  final PdfDocumentType type;

  final String letterNumber;
  final String date;
  final String subject;
  final List<String> tags;

  final String organization;
  final String recipient;

  final String registrationDate;

  final String? signer;
  final String? outgoingActionBy;
  final String? sendMethod;

  final String? sender;
  final String? senderLetterNumber;

  final String? archiveFolder;
  final String? priority;

  final bool needsFollowUp;
  final String? followUpDate;
  final String? followUpBy;

  final String? contractSubject;
  final String? referenceContractNumber;
  final String? contractActionBy;

  const PdfDocumentData({
    required this.type,
    required this.letterNumber,
    required this.date,
    required this.subject,
    required this.tags,
    required this.organization,
    required this.recipient,
    required this.registrationDate,

    this.signer,
    this.outgoingActionBy,
    this.sendMethod,

    this.sender,
    this.senderLetterNumber,

    this.archiveFolder,
    this.priority,

    this.needsFollowUp = false,
    this.followUpDate,
    this.followUpBy,

    this.contractSubject,
    this.referenceContractNumber,
    this.contractActionBy,
  });

  factory PdfDocumentData.fromOutgoing(
    OutgoingLetterDocument document,
  ) {
    return PdfDocumentData(
      type: PdfDocumentType.outgoing,

      letterNumber: document.letterNumber,
      date: document.date,
      subject: document.subject,
      tags: List<String>.from(document.tags),

      organization: document.organization,
      recipient: document.recipient,

      registrationDate: document.registrationDate,

      signer: document.signer,
      outgoingActionBy: document.actionBy,
      sendMethod: document.sendMethod,

      archiveFolder: document.archiveFolder,
      priority: document.priority,

      needsFollowUp: document.needsFollowUp,
      followUpDate: document.followUpDate,
      followUpBy: document.followUpBy,
    );
  }

  factory PdfDocumentData.fromIncoming(
    IncomingLetterDocument document,
  ) {
    return PdfDocumentData(
      type: PdfDocumentType.incoming,

      letterNumber: document.letterNumber,
      date: document.date,
      subject: document.subject,
      tags: List<String>.from(document.tags),

      organization: document.organization,
      recipient: document.recipient,

      registrationDate: document.registrationDate,

      sender: document.sender,
      senderLetterNumber: document.senderLetterNumber,

      archiveFolder: document.archiveFolder,
      priority: document.priority,

      needsFollowUp: document.needsFollowUp,
      followUpDate: document.followUpDate,
      followUpBy: document.followUpBy,
    );
  }

  factory PdfDocumentData.fromContract(
    ContractDocument document,
  ) {
    return PdfDocumentData(
      type: PdfDocumentType.contract,

      letterNumber: document.letterNumber,
      date: document.date,
      subject: document.subject,
      tags: List<String>.from(document.tags),

      organization: document.organization,
      recipient: document.recipient,

      registrationDate: document.registrationDate,

      contractActionBy: document.actionBy,
      contractSubject: document.contractSubject,
      referenceContractNumber: document.referenceContractNumber,
    );
  }

  String get documentTitle {
    switch (type) {
      case PdfDocumentType.outgoing:
        return 'نامه صادره';

      case PdfDocumentType.incoming:
        return 'نامه وارده';

      case PdfDocumentType.contract:
        return 'قرارداد';
    }
  }
}