import 'package:flutter_application_1/domain/documents.dart';

/// Point-in-time copy of a document's fields, ready for PDF rendering.
///
/// Speaks the domain [DocumentType] directly; fields a given kind does not
/// model stay null (contracts have no follow-up, for example).
class PdfDocumentData {
  final DocumentType type;

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

  /// Shared mapping for the seven fields every document kind carries;
  /// each public factory adds its own kind-specific group on top.
  PdfDocumentData._fromDocument(
    Document document, {
    required this.type,
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
  })  : letterNumber = document.letterNumber,
        date = document.date,
        subject = document.subject,
        tags = List<String>.from(document.tags),
        organization = document.organization,
        recipient = document.recipient,
        registrationDate = document.registrationDate;

  factory PdfDocumentData.fromOutgoing(OutgoingLetterDocument document) {
    return PdfDocumentData._fromDocument(
      document,
      type: DocumentType.outgoing,

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

  factory PdfDocumentData.fromIncoming(IncomingLetterDocument document) {
    return PdfDocumentData._fromDocument(
      document,
      type: DocumentType.incoming,

      sender: document.sender,
      senderLetterNumber: document.senderLetterNumber,

      archiveFolder: document.archiveFolder,
      priority: document.priority,

      needsFollowUp: document.needsFollowUp,
      followUpDate: document.followUpDate,
      followUpBy: document.followUpBy,
    );
  }

  factory PdfDocumentData.fromContract(ContractDocument document) {
    return PdfDocumentData._fromDocument(
      document,
      type: DocumentType.contract,

      contractActionBy: document.actionBy,
      contractSubject: document.contractSubject,
      referenceContractNumber: document.referenceContractNumber,
    );
  }

  String get documentTitle {
    switch (type) {
      case DocumentType.outgoing:
        return 'نامه صادره';

      case DocumentType.incoming:
        return 'نامه وارده';

      case DocumentType.contract:
        return 'قرارداد';
    }
  }
}
