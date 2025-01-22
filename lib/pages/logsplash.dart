import 'package:flutter/material.dart';
import 'package:himcops/pages/cgridhome.dart';

class LogSplashScreen extends StatefulWidget {
  const LogSplashScreen({super.key});

  @override
  _LogSplashScreenState createState() => _LogSplashScreenState();
}

class _LogSplashScreenState extends State<LogSplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToCHome();
  }

  // Navigate to the CitizenHomePage after 4 seconds
  _navigateToCHome() async {
    await Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CitizenGridPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  color: Color.fromARGB(255, 0, 0, 0), // Loader color
                  strokeWidth: 2.0, // Thickness of the loader
                ),
                SizedBox(height: 14.0), // Space between loader and text
                Text(
                  'Loading, Please Wait',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 0, 0, 0), // Text color
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
