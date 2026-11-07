import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/authentication/forgetpassword.dart';
import 'package:flutter_application_1/authentication/login.dart';
import 'package:flutter_application_1/authentication/signup.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:flutter_application_1/core/session.dart';
import 'package:flutter_application_1/settings/changepassword.dart';
import 'package:flutter_application_1/widgets/text_input.dart';

/// These tests deliberately stop at form validation.
///
/// The account flows then call `UserRepository`, i.e. Isar, and an Isar call
/// started inside `testWidgets` never completes (the fake-async binding blocks
/// the native completion — verified with a probe, `runAsync` included). The
/// persistence side of every flow is covered instead by
/// `test/data/user_repository_test.dart`, and the phase decisions by
/// `test/core/session_controller_test.dart`.
Future<SessionController> pumpPage(
  WidgetTester tester,
  Widget page, {
  GlobalKey<NavigatorState>? navigatorKey,
}) async {
  tester.view.physicalSize = const Size(1440, 1024);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final session = SessionController.forTesting(AppPhase.signedOut);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      builder: (_, _) => MaterialApp(
        navigatorKey: navigatorKey,
        locale: const Locale('fa'),
        supportedLocales: const [Locale('fa')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        onGenerateRoute: onGenerateAppRoute,
        home: SessionScope(controller: session, child: page),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));

  return session;
}

Finder field(String label) => find.widgetWithText(AppTextField, label);

void main() {
  group('registration page', () {
    testWidgets('empty submit reports every required field', (tester) async {
      await pumpPage(tester, const RegisterPage());

      await tester.tap(find.text('ثبت نام'));
      await tester.pump();

      expect(find.text('نام کاربری را وارد کنید'), findsOneWidget);
      expect(find.text('رمز عبور را وارد کنید'), findsOneWidget);
      expect(find.text('تکرار رمز عبور را وارد کنید'), findsOneWidget);
      expect(find.text('رنگ مورد علاقه را وارد کنید'), findsOneWidget);
    });

    testWidgets('a short password is rejected', (tester) async {
      await pumpPage(tester, const RegisterPage());

      await tester.enterText(field('نام کاربری'), 'fakour');
      await tester.enterText(field('رمز عبور'), '12345');
      await tester.enterText(field('تکرار رمز عبور'), '12345');
      await tester.enterText(field('رنگ مورد علاقه'), 'آبی');

      await tester.tap(find.text('ثبت نام'));
      await tester.pump();

      expect(find.text('رمز عبور باید حداقل 6 کاراکتر باشد'), findsOneWidget);
    });

    testWidgets('mismatched confirmation is rejected', (tester) async {
      await pumpPage(tester, const RegisterPage());

      await tester.enterText(field('نام کاربری'), 'fakour');
      await tester.enterText(field('رمز عبور'), '123456');
      await tester.enterText(field('تکرار رمز عبور'), '654321');
      await tester.enterText(field('رنگ مورد علاقه'), 'آبی');

      await tester.tap(find.text('ثبت نام'));
      await tester.pump();

      expect(find.text('با رمز عبور یکسان نیست'), findsOneWidget);
    });

    testWidgets('a whitespace-only field counts as empty', (tester) async {
      await pumpPage(tester, const RegisterPage());

      await tester.enterText(field('نام کاربری'), '   ');
      await tester.enterText(field('رمز عبور'), '123456');
      await tester.enterText(field('تکرار رمز عبور'), '123456');
      await tester.enterText(field('رنگ مورد علاقه'), '   ');

      await tester.tap(find.text('ثبت نام'));
      await tester.pump();

      expect(find.text('نام کاربری را وارد کنید'), findsOneWidget);
      expect(find.text('رنگ مورد علاقه را وارد کنید'), findsOneWidget);
    });

    testWidgets('the password fields start obscured and can be revealed', (tester) async {
      await pumpPage(tester, const RegisterPage());

      EditableTextState editableAt(Finder finder) {
        return tester.state<EditableTextState>(
          find.descendant(of: finder, matching: find.byType(EditableText)),
        );
      }

      expect(editableAt(field('رمز عبور')).widget.obscureText, isTrue);

      await tester.tap(
        find.descendant(
          of: field('رمز عبور'),
          matching: find.byIcon(Icons.visibility_off),
        ),
      );
      await tester.pump();

      expect(editableAt(field('رمز عبور')).widget.obscureText, isFalse);
    });
  });

  group('login page', () {
    testWidgets('empty submit reports both required fields', (tester) async {
      await pumpPage(tester, const LoginPage());

      await tester.tap(find.text('ورود'));
      await tester.pump();

      expect(find.text('نام کاربری را وارد کنید'), findsOneWidget);
      expect(find.text('رمز عبور را وارد کنید'), findsOneWidget);
    });

    testWidgets('the forgot-password link opens the recovery page', (tester) async {
      await pumpPage(tester, const LoginPage());

      await tester.tap(find.text('فراموشی رمز'));
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPasswordPage), findsOneWidget);
    });
  });

  group('password recovery', () {
    testWidgets('empty submit reports all three fields', (tester) async {
      await pumpPage(tester, const ForgotPasswordPage());

      await tester.tap(find.text('بازنشانی رمز'));
      await tester.pump();

      expect(find.text('رنگ مورد علاقه را وارد کنید'), findsOneWidget);
      expect(find.text('رمز عبور جدید را وارد کنید'), findsOneWidget);
      expect(find.text('تکرار رمز عبور را وارد کنید'), findsOneWidget);
    });

    testWidgets('a short new password is rejected', (tester) async {
      await pumpPage(tester, const ForgotPasswordPage());

      await tester.enterText(field('رنگ مورد علاقه'), 'آبی');
      await tester.enterText(field('رمز عبور جدید'), '123');
      await tester.enterText(field('تکرار رمز عبور جدید'), '123');

      await tester.tap(find.text('بازنشانی رمز'));
      await tester.pump();

      expect(find.text('رمز عبور باید حداقل 6 کاراکتر باشد'), findsOneWidget);
    });

    testWidgets('a mismatched confirmation is rejected', (tester) async {
      await pumpPage(tester, const ForgotPasswordPage());

      await tester.enterText(field('رنگ مورد علاقه'), 'آبی');
      await tester.enterText(field('رمز عبور جدید'), 'new-secret');
      await tester.enterText(field('تکرار رمز عبور جدید'), 'other');

      await tester.tap(find.text('بازنشانی رمز'));
      await tester.pump();

      expect(find.text('با رمز عبور یکسان نیست'), findsOneWidget);
    });
  });

  group('change password page', () {
    Future<Future<bool?>> openPage(WidgetTester tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      await pumpPage(
        tester,
        const Scaffold(body: SizedBox.shrink()),
        navigatorKey: navigatorKey,
      );

      final result = navigatorKey.currentState!.push<bool>(
        MaterialPageRoute<bool>(builder: (_) => const ChangePasswordPage()),
      );
      await tester.pumpAndSettle();

      return result;
    }

    testWidgets('every field is required', (tester) async {
      await openPage(tester);

      await tester.tap(find.text('تأیید'));
      await tester.pump();

      expect(find.text('رمز عبور را وارد کنید'), findsOneWidget);
      expect(find.text('رمز عبور جدید را وارد کنید'), findsOneWidget);
      expect(find.text('تکرار رمز عبور جدید را وارد کنید'), findsOneWidget);
    });

    testWidgets('the new password must differ from the current one', (tester) async {
      await openPage(tester);

      await tester.enterText(field('رمز عبور قبلی'), '123456');
      await tester.enterText(field('رمز عبور جدید'), '123456');
      await tester.enterText(field('تکرار رمز عبور جدید'), '123456');

      await tester.tap(find.text('تأیید'));
      await tester.pump();

      expect(
        find.text('رمز عبور جدید باید با رمز عبور قبلی متفاوت باشد'),
        findsOneWidget,
      );
    });

    testWidgets('the confirmation must match', (tester) async {
      await openPage(tester);

      await tester.enterText(field('رمز عبور قبلی'), '123456');
      await tester.enterText(field('رمز عبور جدید'), 'new-secret');
      await tester.enterText(field('تکرار رمز عبور جدید'), 'other');

      await tester.tap(find.text('تأیید'));
      await tester.pump();

      expect(
        find.text('رمز عبور جدید و تکرار آن یکسان نیستند'),
        findsOneWidget,
      );
    });

    testWidgets('cancel pops false without saving', (tester) async {
      final result = await openPage(tester);

      await tester.tap(find.text('لغو'));
      await tester.pumpAndSettle();

      expect(await result, isFalse);
    });
  });
}
