import 'package:flutter/material.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/layout/formlayout.dart';

class ProtestStrikeStatusPage extends StatefulWidget {
  const ProtestStrikeStatusPage({super.key});

  @override
  State<ProtestStrikeStatusPage> createState() => _ProtestStrikeStatusPageState();
}

class _ProtestStrikeStatusPageState extends State<ProtestStrikeStatusPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: const Color(0xFFB9DA6B),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          const BackgroundPage(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: myBoxDecoration(),
            ),
          ),
        ],
      ),
    );
  }
}