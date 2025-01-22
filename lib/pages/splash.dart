import 'package:flutter/material.dart';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/pages/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Start the animation
    _controller.forward();
    _navigateToHome();
  }

  // Navigate to the LoginPage after animation completes
  _navigateToHome() async {
    await _controller.forward().then((_) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundPage(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Apply the scaling animation to the logo
                ScaleTransition(
                  scale: _animation,
                  child: Image.asset(
                    'asset/images/hp_logo.png',
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  'Welcome To',
                  style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 6, 28, 153), // Text color
                        shadows: [
                          Shadow(
                            offset: Offset(1.0, 1.0), // Position of the shadow
                            blurRadius: 1.0, // Blur effect
                            color: Color.fromARGB(255, 199, 199, 199), // Shadow color with opacity
                          ),
                        ],
                      ),
                ),
                const Text(
                  'Himachal Pradesh Police',
                  style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 6, 28, 153), // Text color
                        shadows: [
                          Shadow(
                            offset: Offset(1.0, 1.0), // Position of the shadow
                            blurRadius: 1.0, // Blur effect
                            color: Color.fromARGB(255, 199, 199, 199), // Shadow color with opacity
                          ),
                        ],
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
