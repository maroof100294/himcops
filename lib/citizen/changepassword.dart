import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:himcops/config.dart';
import 'package:himcops/layout/buttonstyle.dart';
import 'package:himcops/layout/headingstyle.dart';
import 'package:http/http.dart' as http;
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/layout/formlayout.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool passwordMatch = false;
  bool _isPasswordVisible = false;
  String email = '';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
   @override
  void initState() {
    super.initState();
    _fetchLoginId();
  }

  Future<void> _fetchLoginId() async {
    final String? storedemail = await _storage.read(key: 'email');
    
    setState(() {
      email = storedemail ?? 'Unknown';
     
    });
  }
  String? ValidateEmail(String value) {
    if (!RegExp(
            r"^[a-zA-Z0-9._%&$!*#+-]+@(gmail\.com|yahoo\.com|hotmail\.com|outlook\.com)$")
        .hasMatch(value)) {
      return "Email should end with .com";
    }
    return null;
  }

  String? ValidatePassword(String value) {
    // ignore: valid_regexps
    if (!RegExp(r"^[a-zA-Z0-9._%&$!@*#+-]{6,15}$").hasMatch(value)) {
      return "Password should be 6-15 characters long";
    }
    return null;
  }

  Future<void> _changePassword() async {
    final url = '$baseUrl/androidapi/oauth/token';
    String credentials =
        'cctnsws:ea5be3a221d5761d0aab36bd13357b93-28920be3928b4a02611051d04a2dcef9-f1e961fadf11b03227fa71bc42a2a99a-8f3918bc211a5f27198b04cd92c9d8fe-bfa8eb4f98e1668fc608c4de2946541a';
    String basicAuth = 'Basic ${base64Encode(utf8.encode(credentials)).trim()}';

    try {
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
        final tokenData = json.decode(response.body);
        String accessToken = tokenData['access_token'];

        final accountUrl = '$baseUrl/androidapi/mobile/service/changePassword';

        final accountResponse = await http.post(
          Uri.parse(accountUrl),
          body: json.encode({
            "loginId": emailController.text,
            "loginPwdOld": oldPasswordController.text,
            "loginPwdNew": passwordController.text,
            "cpassword": confirmPasswordController.text
          }),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (accountResponse.statusCode == 200) {
          _showConfirmationDialog();
        } else {
          _showErrorDialog('Failed to Change Password');
        }
      } else {
        _showErrorDialog('Failed to fetch token');
      }
    } catch (e) {
      setState(() {
        _showErrorDialog('Error occurred: $e');
      });
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
          content: const Text('Your Password is successfully changed'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundPage(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset('asset/images/hp_logo.png', height: 100),
                const Text(
                  'Himachal Pradesh',
                  style: AppTextStyles.headingStyle,),
                const Text(
                  'Citizen Service',
                  style: AppTextStyles.headingStyle,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: myBoxDecoration(),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                const Text(
                                  'Change Password',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: emailController,
                                  //obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Login ID/Username',
                                    prefixIcon: const Icon(Icons.login),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your Login ID/Username';
                                    }
                                    return ValidateEmail(value);
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: oldPasswordController,
                                  //  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'OLd Password',
                                    prefixIcon: const Icon(Icons.password),
                                    //suffixIcon: const Icon(Icons.visibility),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return ValidatePassword(value);
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: passwordController,
                                   obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    labelText: 'New Password',
                                    prefixIcon: const Icon(Icons.lock),
                                    suffixIcon: IconButton(
                                        icon: Icon(
                                          _isPasswordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            // Toggle the visibility state
                                            _isPasswordVisible =
                                                !_isPasswordVisible;
                                          });
                                        },
                                      ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return ValidatePassword(value);
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: confirmPasswordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    prefixIcon: passwordMatch
                                        ? const Icon(Icons.check,
                                            color: Colors.green)
                                        : const Icon(Icons.close,
                                            color: Colors.red),
                                    suffixIcon: IconButton(
                                        icon: Icon(
                                          _isPasswordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            // Toggle the visibility state
                                            _isPasswordVisible =
                                                !_isPasswordVisible;
                                          });
                                        },
                                      ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      passwordMatch =
                                          value == passwordController.text;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    }
                                    if (value != passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _changePassword();
                    }
                  },
                  style: AppButtonStyles.elevatedButtonStyle,
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // ),
        ],
      ),
    );
  }
}
