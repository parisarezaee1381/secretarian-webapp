import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/authentication.dart/signup.dart';
import 'document_repository.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DocumentRepository.instance.loadOutgoingFromDatabase();
  await DocumentRepository.instance.loadIncomingFromDatabase();
  await DocumentRepository.instance.loadContractsFromDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        1440,
        1024,
      ), // ارتفاع اینجا فقط یه عدد فرمالیته‌ست، اهمیتی نداره چون .h استفاده نمی‌کنیم
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          home: const RegisterPage(),
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
