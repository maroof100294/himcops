import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 243, 140, 5), // Text color
    shadows: [
      Shadow(
        offset: Offset(1.0, 1.0), // Position of the shadow
        blurRadius: 2.0, // Blur effect
        color: Color.fromARGB(255, 0, 0, 0), // Shadow color with opacity
      ),
    ],
  );
}
