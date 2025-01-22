import 'package:flutter/material.dart';

BoxDecoration myGridBoxDecoration() {
  return BoxDecoration(
     gradient: LinearGradient(
                colors: [
                  // Color(0xFFB9DA6B),
                  // Color(0xFF036A30)
                  
                  
                  Color.fromARGB(255, 255, 255, 255),
                  Color(0XFFAAD1E7)
                ], // Color(0xFF036A30)
                stops: [0.33, 0.66],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
    //  color: const Color(0XFFAAD1E7),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: const Color.fromARGB(255, 255, 255, 255), // Border color
      width: 1.5, // Border width (optional, default is 1.0)
    ),
    boxShadow: const [
      BoxShadow(
        color: Color.fromARGB(253, 75, 174, 255),
        blurRadius: 8,
        offset: Offset(4, 4),
      ),
    ],
  );
}
