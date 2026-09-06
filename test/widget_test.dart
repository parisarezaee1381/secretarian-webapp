import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/authentication.dart/signup.dart';
import 'package:flutter_application_1/authentication.dart/login.dart';

void main() {
  testWidgets('صفحه شروع برنامه را بررسی می کند', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(hasUser: false));

    // Verify that the register page is shown.
    expect(find.byType(RegisterPage), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);
  });

  testWidgets('وقتی کاربر وجود دارد صفحه ورود نمایش داده می شود', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(hasUser: true));

    // Verify that the login page is shown.
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(RegisterPage), findsNothing);
  });
}
