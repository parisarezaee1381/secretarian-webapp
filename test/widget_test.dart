import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/authentication/login.dart';
import 'package:flutter_application_1/authentication/signup.dart';
import 'package:flutter_application_1/documents/dashboard.dart';
import 'package:flutter_application_1/core/session.dart';
import 'package:flutter_application_1/core/startup.dart';

void main() {
  Future<SessionController> pumpGate(
    WidgetTester tester,
    AppPhase phase,
  ) async {
    final SessionController controller = SessionController.forTesting(phase);

    await tester.pumpWidget(SecretarianApp(controller: controller));
    await tester.pump();

    return controller;
  }

  testWidgets('with no account, the registration page is shown', (
    WidgetTester tester,
  ) async {
    await pumpGate(tester, AppPhase.noAccount);

    expect(find.byType(RegisterPage), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);
  });

  testWidgets('with an existing account, the login page is shown', (
    WidgetTester tester,
  ) async {
    await pumpGate(tester, AppPhase.signedOut);

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(RegisterPage), findsNothing);
  });

  testWidgets('when signed in, the dashboard is shown', (
    WidgetTester tester,
  ) async {
    await pumpGate(tester, AppPhase.signedIn);

    expect(find.byType(Dashboard), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);
  });

  testWidgets('while startup runs, the loading screen is shown', (
    WidgetTester tester,
  ) async {
    await pumpGate(tester, AppPhase.starting);

    expect(find.byType(StartupLoadingScreen), findsOneWidget);
    expect(find.byType(StartupErrorScreen), findsNothing);
  });

  testWidgets('a failed startup shows the retry screen', (
    WidgetTester tester,
  ) async {
    await pumpGate(tester, AppPhase.failed);

    expect(find.byType(StartupErrorScreen), findsOneWidget);
    expect(find.text('تلاش دوباره'), findsOneWidget);
  });

  testWidgets('the gate follows the session instead of navigating', (
    WidgetTester tester,
  ) async {
    final SessionController controller = await pumpGate(
      tester,
      AppPhase.signedOut,
    );

    expect(find.byType(LoginPage), findsOneWidget);

    controller.signIn();
    await tester.pump();

    expect(
      find.byType(Dashboard),
      findsOneWidget,
      reason: 'signing in should swap the gate content',
    );

    controller.signOut();
    await tester.pump();

    expect(
      find.byType(LoginPage),
      findsOneWidget,
      reason: 'signing out should return to the login page',
    );
  });
}
