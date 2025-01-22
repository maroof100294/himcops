import 'package:flutter/material.dart';
import 'package:himcops/config.dart';
import 'package:himcops/layout/buttonstyle.dart';
import 'package:himcops/layout/headingstyle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/layout/formlayout.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CitizenForgetPasswordPage extends StatefulWidget {
  const CitizenForgetPasswordPage({super.key});

  @override
  _CitizenForgetPasswordPageState createState() =>
      _CitizenForgetPasswordPageState();
}

class _CitizenForgetPasswordPageState extends State<CitizenForgetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  bool isButtonDisabled = false; // Track button state
  String accessToken = '';

  String? ValidateEmail(String value) {
    if (!RegExp(
            r"^[a-zA-Z0-9._%&$!*#+-]+@(gmail\.com|yahoo\.com|hotmail\.com|outlook\.com)$")
        .hasMatch(value)) {
      return "Email should end with .com";
    }
    return null;
  }

  Future<void> fetchAccessToken() async {
    const url = '$baseUrl/androidapi/oauth/token';
    const credentials =
        'cctnsws:ea5be3a221d5761d0aab36bd13357b93-28920be3928b4a02611051d04a2dcef9-f1e961fadf11b03227fa71bc42a2a99a-8f3918bc211a5f27198b04cd92c9d8fe-bfa8eb4f98e1668fc608c4de2946541a';
    final basicAuth = 'Basic ${base64Encode(utf8.encode(credentials)).trim()}';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'password',
        'username': 'icjsws',
        'password': 'cctns@123',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        accessToken = data['access_token'];
      });
    } else {
      showError('Failed to get access token');
    }
  }

  Future<void> getEmail() async {
    setState(() {
      isButtonDisabled = true; // Disable button after click
    });

    await fetchAccessToken();
    final url = '$baseUrl/androidapi/mobile/service/forgetPassword';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': emailController.text,
        'user': 'CITIZEN',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['messages'] == 'Email send to mail id') {
        showEmailDialog();
      } else {
        setState(() {
          isButtonDisabled = false; // Re-enable button if failed
        });
        showError("Email ID is not exist, Please enter valid Email ID");
      }
    } else {
      setState(() {
        isButtonDisabled = false; // Re-enable button if failed
      });
      showError("Please enter your Email ID");
    }
  }

  void showEmailDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Column(
            children: [
              Image.asset(
                'asset/images/hp_logo.png',
                height: 50,
              ),
              const SizedBox(height: 10),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Password sent to your mail ID: ${emailController.text}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    isButtonDisabled = false; // Re-enable button
                  });
                  Navigator.pushNamed(context, '/changepassword');
                },
                style: AppButtonStyles.elevatedButtonStyle,
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Column(
            children: [
              Image.asset(
                'asset/images/hp_logo.png',
                height: 50,
              ),
              const SizedBox(height: 10),
              const Text(
                'Himachal Pradesh',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Citizen Service',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const Text(
                    'Himachal Pradesh',
                    style: AppTextStyles.headingStyle,
                  ),
                  const Text(
                    'Citizen Service',
                    style: AppTextStyles.headingStyle,
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
                            const Text(
                              'Forget Password',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email Id',
                                prefixIcon: const Icon(Icons.email),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return ValidateEmail(value);
                              },
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: isButtonDisabled ? null : getEmail,
                              style: AppButtonStyles.elevatedButtonStyle,
                              child: const Text(
                                'SEND',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
