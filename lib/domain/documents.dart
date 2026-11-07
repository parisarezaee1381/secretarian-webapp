import 'package:flutter/foundation.dart' show Uint8List, listEquals;

/// The default ("normal") priority label.
///
/// Kept in one place so the list, table, and forms stay in sync if the label
/// ever changes.
const String kNormalPriority = 'عادی';

/// The "urgent" priority label — rendered with a 🔴 badge in priority dropdowns.
const String kUrgentPriority = 'فوری';

/// The priority choices offered by every priority dropdown, in display order.
///
/// Shared by the filter panel and the outgoing/incoming forms so the option
/// set can't drift between them.
const List<String> kPriorityOptions = [kNormalPriority, kUrgentPriority];

/// The three kinds of documents the app tracks.
///
/// Lives here (with the model) rather than in the filter widget so screens
/// don't have to import the widget layer for a domain concept.
enum DocumentType { outgoing, incoming, contract }

extension DocumentTypeLabel on DocumentType {
  String get label {
    switch (this) {
      case DocumentType.outgoing:
        return 'صادره';
      case DocumentType.incoming:
        return 'وارده';
      case DocumentType.contract:
        return 'قرارداد';
    }
  }
}

/// Distinguishes "parameter omitted" from "explicitly set to null" in
/// `copyWith`, so nullable fields can actually be cleared.
const _unsetValue = Object();

/// Parses a Jalali `yyyy/MM/dd` string into a comparable `yyyymmdd` integer.
///
/// Returns `null` for anything that isn't a complete, numeric date so callers
/// can fall back gracefully. Normalizing through an int makes comparisons
/// immune to zero-padding differences between code paths.
int? jalaliToComparable(String date) {
  final parts = date.trim().split('/');
  if (parts.length != 3) return null;

  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);

  if (year == null || month == null || day == null) return null;

  return year * 10000 + month * 100 + day;
}

/// Base type for every document kind shown in the app.
///
/// A common (sealed) supertype lets the UI switch over documents
/// exhaustively and type-safely instead of relying on `dynamic` + `is`
/// checks. It also carries the fields every document shares — and the
/// matching `==` / `hashCode` — so each concrete subclass only declares,
/// compares, and hashes what is unique to it.
sealed class Document {
  const Document({
    required this.id,
    required this.letterNumber,
    required this.date,
    required this.subject,
    required this.tags,
    required this.organization,
    required this.recipient,
    required this.registrationDate,
    required this.saveFile,
    this.filePath,
    this.attachments = const [],
  });

  /// Unique identifier shared by every document type.
  final String id;

  final String letterNumber;
  final String date;
  final String subject;
  final List<String> tags;

  final String organization;
  final String recipient;

  final String registrationDate;

  final bool saveFile;
  final String? filePath;

  final List<AttachmentDocument> attachments;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Document &&
          id == other.id &&
          letterNumber == other.letterNumber &&
          date == other.date &&
          subject == other.subject &&
          listEquals(tags, other.tags) &&
          organization == other.organization &&
          recipient == other.recipient &&
          registrationDate == other.registrationDate &&
          saveFile == other.saveFile &&
          filePath == other.filePath &&
          listEquals(attachments, other.attachments);

  @override
  int get hashCode => Object.hash(
        runtimeType,
        Object.hashAll([
          id,
          letterNumber,
          date,
          subject,
          organization,
          recipient,
          registrationDate,
          saveFile,
          filePath,
        ]),
        Object.hashAll(tags),
        Object.hashAll(attachments),
      );
}

/// A file attached to a document.
///
/// An attachment is backed by either [bytes] (e.g. a scanned PDF held in
/// memory) or a [path] (e.g. a picked file on disk). At least one of the two
/// should be provided for the attachment to be usable.
class AttachmentDocument {
  const AttachmentDocument({required this.name, this.path, this.bytes})
      : assert(
          path != null || bytes != null,
          'An attachment must provide at least a path or bytes',
        );

  final String name;
  final String? path;
  final Uint8List? bytes;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentDocument &&
          name == other.name &&
          path == other.path &&
          listEquals(bytes, other.bytes);

  @override
  int get hashCode => Object.hash(name, path, Object.hashAll(bytes ?? const []));

  @override
  String toString() => 'AttachmentDocument(name: $name, path: $path)';
}

class OutgoingLetterDocument extends Document {
  const OutgoingLetterDocument({
    required super.id,
    required super.letterNumber,
    required super.date,
    required super.subject,
    required super.tags,

    required super.organization,
    required super.recipient,
    required this.signer,
    required this.actionBy,

    required this.registrationNumber,
    required super.registrationDate,
    required this.archiveFolder,

    required this.priority,
    required this.sendMethod,

    required this.needsFollowUp,
    this.followUpDate,
    this.followUpBy,

    required super.saveFile,
    super.filePath,

    super.attachments = const [],
  });

  final String signer;
  final String actionBy;

  final String registrationNumber;
  final String archiveFolder;

  final String priority;
  final String sendMethod;

  final bool needsFollowUp;
  final String? followUpDate;
  final String? followUpBy;

  OutgoingLetterDocument copyWith({
    String? id,
    String? letterNumber,
    String? date,
    String? subject,
    List<String>? tags,
    String? organization,
    String? recipient,
    String? signer,
    String? actionBy,
    String? registrationNumber,
    String? registrationDate,
    String? archiveFolder,
    String? priority,
    String? sendMethod,
    bool? needsFollowUp,
    Object? followUpDate = _unsetValue,
    Object? followUpBy = _unsetValue,
    bool? saveFile,
    Object? filePath = _unsetValue,
    List<AttachmentDocument>? attachments,
  }) {
    return OutgoingLetterDocument(
      id: id ?? this.id,
      letterNumber: letterNumber ?? this.letterNumber,
      date: date ?? this.date,
      subject: subject ?? this.subject,
      tags: tags ?? this.tags,
      organization: organization ?? this.organization,
      recipient: recipient ?? this.recipient,
      signer: signer ?? this.signer,
      actionBy: actionBy ?? this.actionBy,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      registrationDate: registrationDate ?? this.registrationDate,
      archiveFolder: archiveFolder ?? this.archiveFolder,
      priority: priority ?? this.priority,
      sendMethod: sendMethod ?? this.sendMethod,
      needsFollowUp: needsFollowUp ?? this.needsFollowUp,
      followUpDate: identical(followUpDate, _unsetValue)
          ? this.followUpDate
          : followUpDate as String?,
      followUpBy: identical(followUpBy, _unsetValue)
          ? this.followUpBy
          : followUpBy as String?,
      saveFile: saveFile ?? this.saveFile,
      filePath:
          identical(filePath, _unsetValue) ? this.filePath : filePath as String?,
      attachments: attachments ?? this.attachments,
    );
  }

  @override
  bool operator ==(Object other) =>
      super == other &&
      other is OutgoingLetterDocument &&
      signer == other.signer &&
      actionBy == other.actionBy &&
      registrationNumber == other.registrationNumber &&
      archiveFolder == other.archiveFolder &&
      priority == other.priority &&
      sendMethod == other.sendMethod &&
      needsFollowUp == other.needsFollowUp &&
      followUpDate == other.followUpDate &&
      followUpBy == other.followUpBy;

  @override
  int get hashCode => Object.hash(
        super.hashCode,
        Object.hashAll([
          signer,
          actionBy,
          registrationNumber,
          archiveFolder,
          priority,
          sendMethod,
          needsFollowUp,
          followUpDate,
          followUpBy,
        ]),
      );

  @override
  String toString() =>
      'OutgoingLetterDocument(id: $id, letterNumber: $letterNumber, subject: $subject)';
}

class IncomingLetterDocument extends Document {
  const IncomingLetterDocument({
    required super.id,
    required super.letterNumber,
    required super.date,
    required super.subject,
    required super.tags,

    required super.organization,
    required this.sender,
    required this.senderLetterNumber,
    required super.recipient,

    required super.registrationDate,
    required this.archiveFolder,

    required this.priority,

    required this.needsFollowUp,
    this.followUpDate,
    this.followUpBy,

    required super.saveFile,
    super.filePath,

    super.attachments = const [],
  });

  final String sender;
  final String senderLetterNumber;
  final String archiveFolder;

  final String priority;

  final bool needsFollowUp;
  final String? followUpDate;
  final String? followUpBy;

  IncomingLetterDocument copyWith({
    String? id,
    String? letterNumber,
    String? date,
    String? subject,
    List<String>? tags,
    String? organization,
    String? sender,
    String? senderLetterNumber,
    String? recipient,
    String? registrationDate,
    String? archiveFolder,
    String? priority,
    bool? needsFollowUp,
    Object? followUpDate = _unsetValue,
    Object? followUpBy = _unsetValue,
    bool? saveFile,
    Object? filePath = _unsetValue,
    List<AttachmentDocument>? attachments,
  }) {
    return IncomingLetterDocument(
      id: id ?? this.id,
      letterNumber: letterNumber ?? this.letterNumber,
      date: date ?? this.date,
      subject: subject ?? this.subject,
      tags: tags ?? this.tags,
      organization: organization ?? this.organization,
      sender: sender ?? this.sender,
      senderLetterNumber: senderLetterNumber ?? this.senderLetterNumber,
      recipient: recipient ?? this.recipient,
      registrationDate: registrationDate ?? this.registrationDate,
      archiveFolder: archiveFolder ?? this.archiveFolder,
      priority: priority ?? this.priority,
      needsFollowUp: needsFollowUp ?? this.needsFollowUp,
      followUpDate: identical(followUpDate, _unsetValue)
          ? this.followUpDate
          : followUpDate as String?,
      followUpBy: identical(followUpBy, _unsetValue)
          ? this.followUpBy
          : followUpBy as String?,
      saveFile: saveFile ?? this.saveFile,
      filePath:
          identical(filePath, _unsetValue) ? this.filePath : filePath as String?,
      attachments: attachments ?? this.attachments,
    );
  }

  @override
  bool operator ==(Object other) =>
      super == other &&
      other is IncomingLetterDocument &&
      sender == other.sender &&
      senderLetterNumber == other.senderLetterNumber &&
      archiveFolder == other.archiveFolder &&
      priority == other.priority &&
      needsFollowUp == other.needsFollowUp &&
      followUpDate == other.followUpDate &&
      followUpBy == other.followUpBy;

  @override
  int get hashCode => Object.hash(
        super.hashCode,
        Object.hashAll([
          sender,
          senderLetterNumber,
          archiveFolder,
          priority,
          needsFollowUp,
          followUpDate,
          followUpBy,
        ]),
      );

  @override
  String toString() =>
      'IncomingLetterDocument(id: $id, letterNumber: $letterNumber, subject: $subject)';
}

class ContractDocument extends Document {
  const ContractDocument({
    required super.id,
    required super.letterNumber,
    required super.date,
    required super.subject,
    required super.tags,

    required super.organization,
    required super.recipient,
    required this.actionBy,

    required this.contractSubject,
    required super.registrationDate,
    required this.referenceContractNumber,

    required super.saveFile,
    super.filePath,

    super.attachments = const [],
  });

  final String actionBy;

  final String contractSubject;
  final String referenceContractNumber;

  ContractDocument copyWith({
    String? id,
    String? letterNumber,
    String? date,
    String? subject,
    List<String>? tags,
    String? organization,
    String? recipient,
    String? actionBy,
    String? contractSubject,
    String? registrationDate,
    String? referenceContractNumber,
    bool? saveFile,
    Object? filePath = _unsetValue,
    List<AttachmentDocument>? attachments,
  }) {
    return ContractDocument(
      id: id ?? this.id,
      letterNumber: letterNumber ?? this.letterNumber,
      date: date ?? this.date,
      subject: subject ?? this.subject,
      tags: tags ?? this.tags,
      organization: organization ?? this.organization,
      recipient: recipient ?? this.recipient,
      actionBy: actionBy ?? this.actionBy,
      contractSubject: contractSubject ?? this.contractSubject,
      registrationDate: registrationDate ?? this.registrationDate,
      referenceContractNumber:
          referenceContractNumber ?? this.referenceContractNumber,
      saveFile: saveFile ?? this.saveFile,
      filePath:
          identical(filePath, _unsetValue) ? this.filePath : filePath as String?,
      attachments: attachments ?? this.attachments,
    );
  }

  @override
  bool operator ==(Object other) =>
      super == other &&
      other is ContractDocument &&
      actionBy == other.actionBy &&
      contractSubject == other.contractSubject &&
      referenceContractNumber == other.referenceContractNumber;

  @override
  int get hashCode => Object.hash(
        super.hashCode,
        Object.hashAll([
          actionBy,
          contractSubject,
          referenceContractNumber,
        ]),
      );

  @override
  String toString() =>
      'ContractDocument(id: $id, letterNumber: $letterNumber, subject: $subject)';
}
