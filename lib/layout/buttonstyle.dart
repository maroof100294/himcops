import 'package:flutter/material.dart';

class AppButtonStyles {
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 16, 143, 202), // Button background color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Rounded corners
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 50, // Horizontal padding
      vertical: 15, // Vertical padding
    ),
  );
}
