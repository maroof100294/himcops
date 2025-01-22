import 'package:flutter/material.dart';

class BackgroundPage extends StatefulWidget {
  const BackgroundPage({super.key});

  @override
  State<BackgroundPage> createState() => _BackgroundPageState();
}

class _BackgroundPageState extends State<BackgroundPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Color(0xFFB9DA6B),
                  // Color(0xFF036A30)
                  
                  
                  Color.fromARGB(255, 107, 150, 214),
                  Color.fromARGB(255, 186, 225, 248)
                ], // Color(0xFF036A30)
                stops: [0.23, 0.76],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
    );
  }
}