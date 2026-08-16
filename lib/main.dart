import 'package:flutter/material.dart';
import 'package:flutter_application_1/s_sadere.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: LetterFormPage(), // صفحه اصلی از فایل دیگر
      ),
    );
  }
}