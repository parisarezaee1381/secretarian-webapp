import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/core/routes.dart';
import 'package:flutter_application_1/core/session.dart';
import 'package:flutter_application_1/settings/changepassword.dart';
import 'package:flutter_application_1/settings/edit_setting.dart';
import 'package:flutter_application_1/settings/settingview.dart';
import 'package:flutter_application_1/widgets/buttons.dart';
import 'package:flutter_application_1/widgets/text_input.dart';

/// The settings page reads the account through Isar, which cannot complete
/// inside `testWidgets`; these tests therefore cover what the screen does
/// without a database (its failure message, sign-out and navigation), plus the
/// edit form's validation, which never reaches the database.
Future<SessionController> pumpSettings(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1440, 1024);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final session = SessionController.forTesting(AppPhase.signedIn);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      builder: (_, _) => MaterialApp(
        locale: const Locale('fa'),
        supportedLocales: const [Locale('fa')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        onGenerateRoute: onGenerateAppRoute,
        home: SessionScope(controller: session, child: const SettingsViewPage()),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));

  return session;
}

Finder field(String label) => find.widgetWithText(AppTextField, label);

void main() {
  // The page asks `path_provider` for a directory before opening Isar. In the
  // test binding that channel is unimplemented and simply never answers, so the
  // load would hang; pointing it at a temp directory turns it into the fast
  // failure this test is about (IsarCore is not initialised here).
  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => Directory.systemTemp.path,
        );
  });

  group('settings view', () {
    testWidgets('reports the load failure and still offers its actions', (
      tester,
    ) async {
      await pumpSettings(tester);

      expect(find.text('خطا در دریافت اطلاعات کاربر'), findsOneWidget);
      expect(find.widgetWithText(CustomButton, 'خروج از حساب'), findsOneWidget);
    });

    testWidgets('signing out asks first and then leaves the account', (tester) async {
      final session = await pumpSettings(tester);

      await tester.tap(find.text('خروج از حساب'));
      await tester.pump();

      expect(find.text('از حساب کاربری خارج می‌شوید؟'), findsOneWidget);

      await tester.tap(find.text('لغو'));
      await tester.pump();

      expect(session.phase, AppPhase.signedIn);

      await tester.tap(find.text('خروج از حساب'));
      await tester.pump();
      await tester.tap(find.text('خروج'));
      await tester.pump();

      expect(session.phase, AppPhase.signedOut);
    });

    testWidgets('the edit button opens the profile form', (tester) async {
      await pumpSettings(tester);

      await tester.tap(find.text('ویرایش'));
      await tester.pumpAndSettle();

      expect(find.byType(EditProfilePage), findsOneWidget);
      expect(find.text('ویرایش تنظیمات'), findsOneWidget);
    });
  });

  group('edit profile form', () {
    Future<void> pumpEdit(WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1440, 1024),
          minTextAdapt: true,
          builder: (_, _) => MaterialApp(
            locale: const Locale('fa'),
            supportedLocales: const [Locale('fa')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            onGenerateRoute: onGenerateAppRoute,
            home: const EditProfilePage(
              initialUsername: 'fakour',
              initialRecoveryAnswer: 'آبی',
            ),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('prefills the stored values', (tester) async {
      await pumpEdit(tester);

      expect(find.text('fakour'), findsOneWidget);
      expect(find.text('آبی'), findsOneWidget);
    });

    testWidgets('a blank username is rejected', (tester) async {
      await pumpEdit(tester);

      await tester.enterText(field('نام کاربری'), '   ');
      await tester.tap(find.text('ثبت'));
      await tester.pump();

      expect(find.text('نام کاربری را وارد کنید'), findsOneWidget);
    });

    testWidgets('a blank recovery answer is rejected', (tester) async {
      await pumpEdit(tester);

      await tester.enterText(field('رنگ مورد علاقه'), '   ');
      await tester.tap(find.text('ثبت'));
      await tester.pump();

      expect(find.text('رنگ مورد علاقه را وارد کنید'), findsOneWidget);
    });

    testWidgets('the change-password button opens its page', (tester) async {
      await pumpEdit(tester);

      await tester.tap(find.text('تغییر رمز عبور'));
      await tester.pumpAndSettle();

      expect(find.byType(ChangePasswordPage), findsOneWidget);
    });

    testWidgets('cancel closes the form', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1440, 1024),
          minTextAdapt: true,
          builder: (_, _) => MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const EditProfilePage(
                          initialUsername: 'a',
                          initialRecoveryAnswer: 'b',
                        ),
                      ),
                    ),
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.byType(EditProfilePage), findsOneWidget);

      await tester.tap(find.text('لغو'));
      await tester.pumpAndSettle();

      expect(find.byType(EditProfilePage), findsNothing);
    });
  });
}
