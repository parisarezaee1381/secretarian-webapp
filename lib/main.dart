import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/foundation.dart' show FlutterExceptionHandler;
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/session.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  _installErrorHandlers();

  final SessionController session = SessionController.instance;

  // Starts the database work and returns immediately: the gate shows a loading
  // screen until it resolves, or the error screen if it fails or times out.
  unawaited(session.start());

  runApp(SecretarianApp(controller: session));
}

/// Makes failures that escape a widget or an async gap visible, instead of
/// leaving them in the console with nothing on screen.
void _installErrorHandlers() {
  final FlutterExceptionHandler? previous = FlutterError.onError;

  FlutterError.onError = (FlutterErrorDetails details) {
    previous?.call(details);
    debugPrint('Uncaught framework error: ${details.exceptionAsString()}');
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint('Uncaught async error: $error\n$stack');
    return true;
  };
}
