import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/core/app_constants.dart';
import 'package:flutter_application_1/documents/s_gharardad.dart';
import 'package:flutter_application_1/documents/s_sadere.dart';
import 'package:flutter_application_1/documents/s_varede.dart';
import 'package:flutter_application_1/widgets/buttons.dart';
import 'package:flutter_application_1/widgets/switch_button.dart';
import 'package:flutter_application_1/widgets/text_input.dart';

/// Form tests stop short of a successful save: that path needs Isar, and an
/// Isar call started inside `testWidgets` never completes. Persistence is
/// covered by `test/data/document_repository_test.dart`.
Future<void> pumpForm(WidgetTester tester, Widget form) async {
  // Tall enough that the whole form fits: taps on buttons below the fold
  // otherwise land on nothing.
  tester.view.physicalSize = const Size(1440, 3200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      builder: (_, _) => MaterialApp(home: form),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

Finder field(String label) => find.widgetWithText(AppTextField, label);

void main() {
  group('outgoing letter form', () {
    testWidgets('renders its title and the auto-filled fields', (tester) async {
      await pumpForm(tester, const OutgoingLetterFormPage());

      expect(find.text('ثبت نامه صادره'), findsOneWidget);
      expect(find.text('شماره نامه:'), findsOneWidget);
      expect(find.text('تاریخ:'), findsOneWidget);
      expect(find.text('تاریخ ثبت:'), findsOneWidget);
    });

    testWidgets('every required field reports when empty', (tester) async {
      await pumpForm(tester, const OutgoingLetterFormPage());

      await tester.ensureVisible(find.widgetWithText(CustomButton, 'ثبت'));
      await tester.pump();
      await tester.tap(find.widgetWithText(CustomButton, 'ثبت'));
      await tester.pump();

      for (final label in [
        'عنوان/خلاصه نامه:',
        'به سازمان/شرکت:',
        'گیرنده نامه:',
        'امضا کننده:',
        'اقدام کننده:',
        'شماره ثبت دبیرخانه:',
        'پوشه بایگانی:',
      ]) {
        expect(
          find.descendant(
            of: field(label),
            matching: find.text(kRequiredFieldMessage),
          ),
          findsOneWidget,
          reason: label,
        );
      }
    });

    testWidgets('text fields stop at 55 characters and warn', (tester) async {
      await pumpForm(tester, const OutgoingLetterFormPage());

      await tester.enterText(field('عنوان/خلاصه نامه:'), 'x' * 80);
      await tester.pump();

      final editable = tester.widget<EditableText>(
        find.descendant(
          of: field('عنوان/خلاصه نامه:'),
          matching: find.byType(EditableText),
        ),
      );

      expect(editable.controller.text.length, 55);
      expect(find.text('حداکثر 55 کاراکتر مجاز است'), findsOneWidget);
    });

    testWidgets('a tag is added, listed and removable', (tester) async {
      await pumpForm(tester, const OutgoingLetterFormPage());

      final tagField = find.byType(AppTextField).at(3);
      await tester.enterText(tagField, 'مالی');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(find.text('مالی'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pump();

      expect(find.text('مالی'), findsNothing);
    });

    testWidgets('the follow-up switch opens the modal and stays off on cancel', (
      tester,
    ) async {
      await pumpForm(tester, const OutgoingLetterFormPage());

      final followUpSwitch = find.byType(AppSwitch).first;

      await tester.ensureVisible(followUpSwitch);
      await tester.pump();
      await tester.tap(followUpSwitch);
      await tester.pumpAndSettle();

      expect(find.text('تاریخ پیگیری:'), findsOneWidget);
      expect(find.text('پیگیری توسط:'), findsOneWidget);

      // Dismissing the dialog leaves the switch off.
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(tester.widget<AppSwitch>(followUpSwitch).value, isFalse);
    });

    testWidgets('confirming the modal turns the switch on', (tester) async {
      await pumpForm(tester, const OutgoingLetterFormPage());

      final followUpSwitch = find.byType(AppSwitch).first;

      await tester.ensureVisible(followUpSwitch);
      await tester.pump();
      await tester.tap(followUpSwitch);
      await tester.pumpAndSettle();

      await tester.enterText(field('تاریخ پیگیری:'), '1403/09/09');
      await tester.enterText(field('پیگیری توسط:'), 'علی');
      await tester.pump();
      await tester.tap(find.text('تایید'));
      await tester.pumpAndSettle();

      expect(tester.widget<AppSwitch>(followUpSwitch).value, isTrue);
    });

    testWidgets('turning the follow-up switch off again is immediate', (tester) async {
      await pumpForm(tester, const OutgoingLetterFormPage());

      final followUpSwitch = find.byType(AppSwitch).first;

      await tester.ensureVisible(followUpSwitch);
      await tester.pump();
      await tester.tap(followUpSwitch);
      await tester.pumpAndSettle();

      await tester.enterText(field('تاریخ پیگیری:'), '1403/09/09');
      await tester.enterText(field('پیگیری توسط:'), 'علی');
      await tester.pump();
      await tester.tap(find.text('تایید'));
      await tester.pumpAndSettle();

      await tester.tap(followUpSwitch);
      await tester.pump();

      expect(tester.widget<AppSwitch>(followUpSwitch).value, isFalse);
    });

    testWidgets('the file switch toggles independently', (tester) async {
      await pumpForm(tester, const OutgoingLetterFormPage());

      final fileSwitch = find.byType(AppSwitch).at(1);

      await tester.ensureVisible(fileSwitch);
      await tester.pump();

      expect(tester.widget<AppSwitch>(fileSwitch).value, isFalse);

      await tester.tap(fileSwitch);
      await tester.pump();

      expect(tester.widget<AppSwitch>(fileSwitch).value, isTrue);
    });

    testWidgets('cancelling a pristine form leaves without a prompt', (tester) async {
      await pumpForm(tester, const OutgoingLetterFormPage());

      await tester.ensureVisible(find.widgetWithText(CustomButton, 'انصراف'));
      await tester.pump();
      await tester.tap(find.widgetWithText(CustomButton, 'انصراف'));
      await tester.pump();

      expect(find.text('انصراف از ثبت؟'), findsNothing);
      expect(find.text('عملیات لغو شد'), findsOneWidget);
    });

    testWidgets('cancelling with typed content asks first', (tester) async {
      await pumpForm(tester, const OutgoingLetterFormPage());

      await tester.enterText(field('عنوان/خلاصه نامه:'), 'متن');

      await tester.ensureVisible(find.widgetWithText(CustomButton, 'انصراف'));
      await tester.pump();
      await tester.tap(find.widgetWithText(CustomButton, 'انصراف'));
      await tester.pump();

      expect(find.text('انصراف از ثبت؟'), findsOneWidget);
      expect(find.text('اطلاعات واردشده ذخیره نمی‌شود.'), findsOneWidget);

      await tester.tap(find.text('ادامه'));
      await tester.pump();

      expect(find.text('انصراف از ثبت؟'), findsNothing);
      expect(find.byType(OutgoingLetterFormPage), findsOneWidget);
    });
  });

  group('incoming letter form', () {
    testWidgets('requires its own field set', (tester) async {
      await pumpForm(tester, const IncomingLetterFormPage());

      expect(find.text('ثبت نامه وارده'), findsOneWidget);

      await tester.ensureVisible(find.widgetWithText(CustomButton, 'ثبت'));
      await tester.pump();
      await tester.tap(find.widgetWithText(CustomButton, 'ثبت'));
      await tester.pump();

      for (final label in [
        'عنوان/خلاصه نامه:',
        'به سازمان/شرکت:',
        'شخص ارسال کننده:',
        'شماره نامه فرستنده:',
        'مخاطب:',
        'پوشه بایگانی:',
      ]) {
        expect(
          find.descendant(
            of: field(label),
            matching: find.text(kRequiredFieldMessage),
          ),
          findsOneWidget,
          reason: label,
        );
      }
    });
  });

  group('contract form', () {
    testWidgets('requires its own field set', (tester) async {
      await pumpForm(tester, const ContractFormPage());

      expect(find.text('ثبت قرارداد'), findsOneWidget);

      await tester.ensureVisible(find.widgetWithText(CustomButton, 'ثبت'));
      await tester.pump();
      await tester.tap(find.widgetWithText(CustomButton, 'ثبت'));
      await tester.pump();

      for (final label in [
        'عنوان/خلاصه نامه:',
        'شرکت طرف قرارداد:',
        'شخص طرف قرارداد:',
        'اقدام کننده:',
        'موضوع قرارداد:',
        'شماره قرارداد مرجع:',
      ]) {
        expect(
          find.descendant(
            of: field(label),
            matching: find.text(kRequiredFieldMessage),
          ),
          findsOneWidget,
          reason: label,
        );
      }
    });

    testWidgets('has no follow-up switch of its own', (tester) async {
      await pumpForm(tester, const ContractFormPage());

      // Only «ذخیره فایل» exists for contracts.
      expect(find.byType(AppSwitch), findsOneWidget);
      expect(find.text('نیاز به پیگیری:'), findsNothing);
    });
  });
}
