import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_application_1/authentication.dart/signup.dart';
import 'package:flutter_application_1/authentication.dart/login.dart';
import 'package:flutter_application_1/authentication.dart/user_repository.dart';

import 'document_repository.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ----------------------------------------------------------
  // بارگذاری اسناد از دیتابیس
  // ----------------------------------------------------------

  await DocumentRepository.instance.loadOutgoingFromDatabase();
  await DocumentRepository.instance.loadIncomingFromDatabase();
  await DocumentRepository.instance.loadContractsFromDatabase();

  // ----------------------------------------------------------
  // بررسی وجود کاربر
  // ----------------------------------------------------------

  final user = await UserRepository.instance.getUser();

  // ----------------------------------------------------------
  // اجرای برنامه
  // ----------------------------------------------------------

  runApp(MyApp(hasUser: user != null));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.hasUser});

  final bool hasUser;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,

      builder: (context, child) {
        return MaterialApp(
          home: hasUser ? const LoginPage() : const RegisterPage(),

          scaffoldMessengerKey: rootScaffoldMessengerKey,

          debugShowCheckedModeBanner: false,

          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child ?? const SizedBox(),
            );
          },
        );
      },
    );
  }
}
