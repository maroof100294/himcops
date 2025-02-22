import 'dart:io';
import 'package:flutter/material.dart';
import 'package:himcops/authservice.dart';
import 'package:himcops/config.dart';
import 'package:himcops/pages/cgridhome.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/io_client.dart';

class ProtestPage extends StatefulWidget {
  final TextEditingController controller;

  const ProtestPage({Key? key, required this.controller, required bool enabled})
      : super(key: key);

  @override
  State<ProtestPage> createState() => _ProtestPageState();
}

class _ProtestPageState extends State<ProtestPage> {
  String selectedStrike = '';
  int? selectedStrikeId; // Updated to int to store codeId
  List<Map<String, String>> StrikeDescriptions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isNotEmpty) {
      selectedStrikeId = int.tryParse(
          widget.controller.text); // Initialize with codeId if available
    }
    fetchStrikeType();
  }

  Future<void> fetchStrikeType() async {
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
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final client = IOClient(ioc);

      final StrikeUrl = '$baseUrl/androidapi/mobile/service/getStrikeType';
      final StrikeResponse = await client.get(
        Uri.parse(StrikeUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (StrikeResponse.statusCode == 200) {
        final jsonResponse = json.decode(StrikeResponse.body);

        if (jsonResponse.containsKey('data')) {
          final data = jsonResponse['data'];

          if (data is List) {
            setState(() {
              StrikeDescriptions = data.map((strike) {
                return {
                  'codeId': strike['codeId'].toString(),
                  'codeDesc': strike['codeDesc'].toString(),
                };
              }).toList();
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              errorMessage =
                  'Invalid structure: expected a list in "data" ${StrikeResponse.statusCode}';
              _showErrorDialog('Technical Problem, Please Try again later');
            });
          }
        } else {
          setState(() {
            isLoading = false;
            errorMessage =
                'Key "data" not found in response. ${StrikeResponse.statusCode}';
            _showErrorDialog('Technical Problem, Please Try again later');
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              'Error fetching StrikeType: ${StrikeResponse.statusCode}';
          _showErrorDialog('Technical Problem, Please Try again later');
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error occurred: $e';
        _showErrorDialog('Technical Problem, Please Try again later');
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing by tapping outside
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            // Navigate to CitizenHomePage when back button is pressed
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CitizenGridPage(),
              ),
            );
            return false; // PrStrike dialog from closing by default behavior
          },
          child: AlertDialog(
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
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Citizen Service',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
          ),
        );
      },
    ).then((_) {
      // When dialog is dismissed (tap outside), navigate to CitizenHomePage
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
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: DropdownButtonFormField<Map<String, String>?>(
              value: selectedStrike.isNotEmpty
                  ? StrikeDescriptions.firstWhere(
                      (item) => item['codeDesc'] == selectedStrike,
                      orElse: () => {'codeId': '', 'codeDesc': ''},
                    )
                  : null,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Protest/Strike Type',
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: StrikeDescriptions.map((Map<String, String> value) {
                return DropdownMenuItem<Map<String, String>>(
                  value: value,
                  child: Text(value['codeDesc']!),
                );
              }).toList(),
              onChanged: (Map<String, String>? newValue) {
                setState(() {
                  if (newValue != null) {
                    selectedStrike = newValue['codeDesc']!;
                    selectedStrikeId = int.tryParse(newValue['codeId']!);
                    // widget.controller.text = selectedStrikeId.toString();
                    widget.controller.text = jsonEncode({
                      'codeId': selectedStrikeId,
                      'codeDesc': selectedStrike,
                    });
                  }
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a Strike Type';
                }
                return null;
              },
            ),
          );
  }
}
