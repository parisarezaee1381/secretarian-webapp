import 'package:flutter/material.dart';

import '../authentication/forgetpassword.dart';
import '../settings/changepassword.dart';
import '../settings/settingview.dart';

/// Names for the screens that are **pushed** onto the navigator.
///
/// Sign in, registration and the dashboard are not routes: they are phases of
/// [SessionController], rendered in place by the gate in `app.dart`. That is
/// why no screen navigates to the dashboard any more.
///
/// Screens that carry a live object (a document, the profile fields) are still
/// opened through their constructor: putting a `Document` behind
/// [RouteSettings.arguments] would turn a compile-time check into a runtime
/// cast for no gain.
abstract final class AppRoutes {
  static const String forgotPassword = '/forgot-password';
  static const String settings = '/settings';
  static const String changePassword = '/settings/change-password';
}

/// Builds the page for a named route.
///
/// Returns null for a name this app does not define, so Flutter reports the
/// unknown route instead of silently showing some other screen.
Route<dynamic>? onGenerateAppRoute(RouteSettings settings) {
  final Widget? page = switch (settings.name) {
    AppRoutes.forgotPassword => const ForgotPasswordPage(),
    AppRoutes.settings => const SettingsViewPage(),
    AppRoutes.changePassword => const ChangePasswordPage(),
    _ => null,
  };

  if (page == null) return null;

  return MaterialPageRoute<dynamic>(
    builder: (_) => page,
    settings: settings,
  );
}
