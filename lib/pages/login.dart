import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:himcops/forgetpassword/pforgetpassword.dart';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/layout/buttonstyle.dart';
import 'package:himcops/layout/formlayout.dart';
import 'package:himcops/pages/cgridhome.dart';
// import 'package:himcops/pages/cgridhome.dart';
// import 'package:himcops/pages/cgridhome.dart';
// import 'package:himcops/pages/cgridhome.dart';
// import 'package:himcops/pages/cgridhome.dart';
import 'package:himcops/pages/sso.dart';
import 'package:himcops/police/phome.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? loginId;
  String? firstname;
  String? fullName;
  String? email;
  int? mobile2;
  int? age;
  bool isUser = true;

  bool isAgree = false;
  bool _isPasswordVisible = false;
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController loginIdController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldLogout = await _showExitDialog(context);
        return shouldLogout;
      },
      child: Scaffold(
        body: Stack(
          children: [
            const BackgroundPage(),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'asset/images/hp_logo.png',
                      height: 150,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'welcome'.tr,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 6, 28, 153), // Text color
                        shadows: [
                          Shadow(
                            offset: Offset(1.0, 1.0), // Position of the shadow
                            blurRadius: 1.0, // Blur effect
                            color: Color.fromARGB(255, 199, 199,
                                199), // Shadow color with opacity
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'police'.tr,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 6, 28, 153), // Text color
                        shadows: [
                          Shadow(
                            offset: Offset(1.0, 1.0), // Position of the shadow
                            blurRadius: 1.0, // Blur effect
                            color: Color.fromARGB(255, 199, 199,
                                199), // Shadow color with opacity
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: myBoxDecoration(),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                'login'.tr,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: RadioListTile(
                                      value: true,
                                      groupValue: isUser,
                                      onChanged: (val) {
                                        setState(() {
                                          isUser = val as bool;
                                        });
                                      },
                                      title: Text(
                                        'citizen'.tr,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.031,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textScaleFactor: MediaQuery.of(context)
                                            .textScaleFactor
                                            .clamp(1.0, 2.0),
                                      ),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile(
                                      value: false,
                                      groupValue: isUser,
                                      onChanged: (val) {
                                        setState(() {
                                          isUser = val as bool;
                                        });
                                      },
                                      title: Text(
                                        'police_officer'.tr,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.031,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textScaleFactor: MediaQuery.of(context)
                                            .textScaleFactor
                                            .clamp(1.0, 2.0),
                                      ),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                              const SizedBox(height: 20),
                              if (isUser) ...[
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isAgree,
                                      onChanged: (value) {
                                        setState(() {
                                          isAgree = value!;
                                        });
                                      },
                                    ),
                                    Text('privacy_policy'.tr),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: (isAgree)
                                          ? () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const CitizenGridPage()
                                                        // const SSOPage()
                                                        ),
                                              );
                                            }
                                          : null,
                                      style:
                                          AppButtonStyles.elevatedButtonStyle,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.login,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'login_sso'.tr,
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                            textScaleFactor:
                                                MediaQuery.of(context)
                                                    .textScaleFactor
                                                    .clamp(1.0, 2.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ] else
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: loginIdController,
                                      decoration: InputDecoration(
                                        labelText: 'login_id'.tr,
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        suffixIcon: const Icon(Icons.login),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: passwordController,
                                      obscureText: !_isPasswordVisible,
                                      decoration: InputDecoration(
                                        labelText: 'password'.tr,
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isPasswordVisible =
                                                  !_isPasswordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PoliceHomePage(), // change to function from API
                                          ),
                                        );
                                      },
                                      style:
                                          AppButtonStyles.elevatedButtonStyle,
                                      child: Text(
                                        'login'.tr,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (!isUser)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    // const CitizenGridPage()
                                    const PoliceForgetPasswordPage()),
                          );
                        },
                        child: Text(
                          'forgot_password'.tr,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        var locale = Get.locale!.languageCode == 'en'
                            ? const Locale('hi',
                                'IN') // Switch to Hindi if currently in English
                            : const Locale('en',
                                'US'); // Switch to English if currently in Hindi

                        // Update locale dynamically
                        Get.updateLocale(locale);
                      },
                      child: Text('change_language'
                          .tr), // Translated text for the button
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    bool shouldLogout = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Exit"),
          content: Text("Are you sure, You want to exit?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                shouldLogout = false; // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                exit(0);
                // shouldLogout = true; // Exit the app
              },
              child: Text("Exit"),
            ),
          ],
        );
      },
    );
    return shouldLogout;
  }
}
