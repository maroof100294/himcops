import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:himcops/pages/splash.dart';
import 'package:himcops/pages/login.dart';
import 'package:himcops/citizen/chome.dart';
import 'package:himcops/police/phome.dart';
import 'package:himcops/forgetpassword/presetpassword.dart';
import 'package:himcops/citizen/changepassword.dart';
import 'package:himcops/translation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(), // Add translations
      locale: Locale('en', 'US'), // Default language
      fallbackLocale: Locale('en', 'US'),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        'citizen/chome': (context) => const CitizenHomePage(),
        'police/phome': (context) => const PoliceHomePage(),
        'forgetpassword/presetpassword': (context) => const PoliceResetPasswordPage(),
        '/changepassword': (context) => const ChangePasswordPage(),
      },
    );
  }
}
