import 'dart:io';

import 'package:flutter/material.dart';
import 'package:himcops/authservice.dart';
import 'package:himcops/config.dart';
import 'package:himcops/pages/cgridhome.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/io_client.dart';

class IdentificationTypePage extends StatefulWidget {
  final TextEditingController controller;

  const IdentificationTypePage({super.key, required this.controller});

  @override
  State<IdentificationTypePage> createState() => _IdentificationTypePageState();
}

class _IdentificationTypePageState extends State<IdentificationTypePage> {
  String selectedIdentification = '';
  List<String> identificationDescriptions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();

    if (widget.controller.text.isNotEmpty) {
      selectedIdentification = widget.controller.text;
    }
    fetchIdentification();
  }

  Future<void> fetchIdentification() async {
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
      final identificationUrl =
          '$baseUrl/androidapi/mobile/service/getIdentity';
      final identificationResponse = await client.get(
        Uri.parse(identificationUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (identificationResponse.statusCode == 200) {
        final jsonResponse = json.decode(identificationResponse.body);

        if (jsonResponse.containsKey('data')) {
          final data = jsonResponse['data'];

          if (data is List) {
            setState(() {
              identificationDescriptions = data
                  .map(
                      (identification) => identification['codeDesc'].toString())
                  .toList();
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              errorMessage = 'Invalid structure: expected a list in "data"';
              _showErrorDialog(
                  'Internet Connection Slow, Please check your connection');
            });
          }
        } else {
          setState(() {
            isLoading = false;
            errorMessage = 'Key "data" not found in response.';
            _showErrorDialog(
                'Internet Connection Slow, Please check your connection');
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              'Error fetching Identification: ${identificationResponse.statusCode}';
          _showErrorDialog(
              'Internet Connection Slow, Please check your connection');
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
            return false; // Prevent dialog from closing by default behavior
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
        // : errorMessage.isNotEmpty
        //     ? Center(
        //         child: Text(
        //           errorMessage,
        //           style: TextStyle(color: Colors.red),
        //         ),
        //       )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: DropdownButtonFormField<String>(
              value: selectedIdentification.isNotEmpty
                  ? selectedIdentification
                  : null,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Identification Type',
                prefixIcon: const Icon(Icons.perm_identity),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: identificationDescriptions.isNotEmpty
                  ? identificationDescriptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()
                  : [],
              onChanged: (String? newValue) {
                setState(() {
                  selectedIdentification = newValue!;
                  widget.controller.text = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a Identification';
                }
                return null;
              },
            ),
          );
  }
}
