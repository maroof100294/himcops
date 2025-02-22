import 'dart:io';

import 'package:flutter/material.dart';
import 'package:himcops/authservice.dart';
import 'package:himcops/config.dart';
import 'package:himcops/pages/cgridhome.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/io_client.dart';

class StatePage extends StatefulWidget {
  final TextEditingController controller;

  const StatePage({Key? key, required this.controller}) : super(key: key);

  @override
  State<StatePage> createState() => _StatePageState();
}

class _StatePageState extends State<StatePage> {
  String selectedState = '';
  int? selectedStateId;
  List<Map<String, String>> stateDescriptions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isNotEmpty) {
      selectedStateId = int.tryParse(widget.controller.text);
    }
    fetchState();
  }

  Future<void> fetchState() async {
    final stateUrl = '$baseUrl/androidapi/mobile/service/getState';
    final token = await AuthService.getAccessToken(); // Fetch the token

    if (token == null) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to retrieve access token.';
      });
      _showErrorDialog('Technical Problem, Please Try again later');
      return;
    }

    try {
      // Request for access token
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final client = IOClient(ioc);

      // Fetch states with the access token
      final stateResponse = await client.get(
        Uri.parse(stateUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (stateResponse.statusCode == 200) {
        final data = json.decode(stateResponse.body)['data'];

        if (data is List) {
          setState(() {
            stateDescriptions = data
                .map((state) => {
                      'codeId': state['codeId'].toString(),
                      'codeDesc': state['codeDesc'].toString(),
                    })
                .toList();
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Unexpected data format received';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage =
              'Failed to load states. Error ${stateResponse.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
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
              const SizedBox(height: 8),
              const Text(
                'Himachal Pradesh',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Citizen Service',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CitizenGridPage(),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    ).then((_) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const CitizenGridPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : errorMessage.isNotEmpty
            ? Center(
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: DropdownButtonFormField<Map<String, String>?>(
                  value: stateDescriptions.firstWhere(
                    (item) => item['codeId'] == selectedStateId.toString(),
                    orElse: () => {'codeId': '', 'codeDesc': 'Select State'},
                  ),
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'State',
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: stateDescriptions.map((Map<String, String> state) {
                    return DropdownMenuItem<Map<String, String>>(
                      value: state,
                      child: Text(state['codeDesc']!),
                    );
                  }).toList(),
                  onChanged: (Map<String, String>? newState) {
                    setState(() {
                      if (newState != null) {
                        selectedState = newState['codeDesc']!;
                        selectedStateId = int.tryParse(newState['codeId']!);
                        widget.controller.text = selectedStateId.toString();
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null || value['codeDesc'] == 'Select State') {
                      return 'Please select a State';
                    }
                    return null;
                  },
                ),
              );
  }
}
