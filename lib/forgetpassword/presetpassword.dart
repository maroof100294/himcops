import 'package:flutter/material.dart';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/layout/buttonstyle.dart';
import 'package:himcops/layout/formlayout.dart';
import 'package:himcops/layout/headingstyle.dart';

class PoliceResetPasswordPage extends StatefulWidget {
  const PoliceResetPasswordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PoliceResetPasswordPageState createState() =>
      _PoliceResetPasswordPageState();
}

class _PoliceResetPasswordPageState extends State<PoliceResetPasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController =
      TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordMatch =false;

void validateLogin() {
    String oldPassword = oldPasswordController.text;
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;
    

    if (oldPassword.isEmpty || oldPassword.length >= 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid Password'),
        ),
      );
      return;
    }
        if (newPassword.isEmpty || newPassword.length >= 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid new password'),
        ),
      );
      return;
    }
        if (confirmPassword.isEmpty || confirmPassword.length >= 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid confirm Password'),
        ),
      );
      return;
    }    
      Navigator.pushNamed(context, '/login');
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // if need background images or color

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
                    style: AppTextStyles.headingStyle
                  ),
                  const Text(
                    'Police Service',
                    style: AppTextStyles.headingStyle
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
                            TextField(
                              controller: oldPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Old Password',
                                prefixIcon: const Icon(Icons.password),
                                filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                              ),
                              
                            ),
                            const SizedBox(height: 10),
                            TextField(
                                  controller: newPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(Icons.lock),
                                    suffixIcon: const Icon(Icons.visibility),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: confirmPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    prefixIcon: isPasswordMatch
                                        ? const Icon(Icons.check,
                                            color: Colors.green)
                                        : const Icon(Icons.close,
                                            color: Colors.red),
                                    suffixIcon: const Icon(Icons.visibility),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      isPasswordMatch =
                                          value == newPasswordController.text;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    }
                                    if (value != newPasswordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: validateLogin,
                              style: AppButtonStyles.elevatedButtonStyle,
                              child: const Text(
                                'SUBMIT',
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
