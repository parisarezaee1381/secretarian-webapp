import 'package:flutter/foundation.dart';

/// Number of letters needing follow-up today.
///
/// Lives in the data layer (rather than a widget file) so the document
/// repository can update it without depending on UI code.
class PendingLettersData {
  PendingLettersData._();

  static final ValueNotifier<int> count = ValueNotifier<int>(0);
}
