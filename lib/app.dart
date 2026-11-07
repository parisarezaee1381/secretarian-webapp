import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'authentication/login.dart';
import 'authentication/signup.dart';
import 'documents/dashboard.dart';
import 'core/routes.dart';
import 'core/session.dart';
import 'core/startup.dart';
import 'core/theme.dart';

/// The app shell: theme, Persian locale, named routes and the screen gate.
class SecretarianApp extends StatelessWidget {
  const SecretarianApp({super.key, this.controller});

  /// Defaults to [SessionController.instance]; tests pass their own.
  final SessionController? controller;

  @override
  Widget build(BuildContext context) {
    final SessionController session = controller ?? SessionController.instance;

    return SessionScope(
      controller: session,

      child: ScreenUtilInit(
        designSize: const Size(1440, 1024),
        minTextAdapt: true,

        builder: (_, _) {
          return MaterialApp(
            theme: appTheme,

            // The app is Persian only. Pinning the locale makes the whole tree
            // RTL and gives Material's own strings (dates, dialogs, semantics
            // labels) Persian text instead of English.
            locale: const Locale('fa'),
            supportedLocales: const [Locale('fa')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,

            // Screens that are pushed, such as the password flows. Sign in and
            // the dashboard are gate phases here, not routes.
            onGenerateRoute: onGenerateAppRoute,

            home: AppGate(controller: session),

            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

/// Renders the screen that matches the current [AppPhase].
///
/// This is the single place that decides what "signed in" looks like, so no
/// screen has to navigate to the dashboard or back to the login page.
class AppGate extends StatelessWidget {
  const AppGate({super.key, required this.controller});

  final SessionController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,

      builder: (context, _) {
        return switch (controller.phase) {
          AppPhase.starting => const StartupLoadingScreen(),

          AppPhase.failed => StartupErrorScreen(
            error: controller.error,
            onRetry: controller.start,
          ),

          AppPhase.noAccount => const RegisterPage(),
          AppPhase.signedOut => const LoginPage(),
          AppPhase.signedIn => const Dashboard(),
        };
      },
    );
  }
}
