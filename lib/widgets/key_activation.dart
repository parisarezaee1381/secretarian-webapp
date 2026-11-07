import 'package:flutter/services.dart';

/// True for the key events a button-like widget must claim as activation:
/// space/enter key-down (fire the action) and key-up (consume so the key
/// doesn't leak elsewhere). Everything else — Tab, arrows, app shortcuts —
/// must stay unhandled so focus traversal and global shortcuts keep
/// working.
bool isActivationKeyEvent(KeyEvent event) {
  if (event is! KeyDownEvent && event is! KeyUpEvent) return false;

  return event.logicalKey == LogicalKeyboardKey.space ||
      event.logicalKey == LogicalKeyboardKey.enter;
}
