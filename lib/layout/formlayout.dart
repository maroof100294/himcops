import 'package:flutter/material.dart';

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    color: const Color.fromARGB(255, 233, 240, 221),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: const Color.fromARGB(255, 243, 140, 5), // Border color
      width: 3.5, // Border width (optional, default is 1.0)
    ),
    boxShadow: const [
      BoxShadow(
        color: Color.fromARGB(255, 5, 142, 255),
        blurRadius: 8,
         offset: Offset(4, 4),
      ),
    ],
  );
}
