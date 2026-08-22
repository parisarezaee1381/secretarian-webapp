import 'documents.dart';
import 'widgets.dart/notification.dart';
import 'package:shamsi_date/shamsi_date.dart';

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

  void addOutgoing(OutgoingLetterDocument doc) {
    outgoingLetters.add(doc);
    allDocuments.add(doc);
    _recalculatePendingCount();
  }

  void addIncoming(IncomingLetterDocument doc) {
    incomingLetters.add(doc);
    allDocuments.add(doc);
    _recalculatePendingCount();
  }

  void addContract(ContractDocument doc) {
    contracts.add(doc);
    allDocuments.add(doc);
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

  PendingLettersData.count.value = outgoingPending + incomingPending;
}
}