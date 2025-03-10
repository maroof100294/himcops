import 'dart:io';

import 'package:flutter/material.dart';
import 'package:himcops/authservice.dart';
import 'package:himcops/config.dart';
import 'package:himcops/pages/cgridhome.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/io_client.dart';

class LanguagesSpokenPage extends StatefulWidget {
  final TextEditingController controller;

  const LanguagesSpokenPage({super.key, required this.controller});

  @override
  State<LanguagesSpokenPage> createState() => _LanguagesSpokenPageState();
}

class _LanguagesSpokenPageState extends State<LanguagesSpokenPage> {
  String selectedLanguages = '';
  int? selectedLanguagesId;
  List<Map<String, String>> LanguagesDescriptions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isNotEmpty) {
      selectedLanguagesId = int.tryParse(
          widget.controller.text); // Initialize with codeId if available
    }

    fetchLanguages();
  }

  Future<void> fetchLanguages() async {
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

      final languagesUrl =
          '$baseUrl/androidapi/mobile/service/getLanguageDialect';
      final languagesResponse = await client.get(
        Uri.parse(languagesUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (languagesResponse.statusCode == 200) {
        final jsonResponse = json.decode(languagesResponse.body);

        if (jsonResponse.containsKey('data')) {
          final data = jsonResponse['data'];
          if (data is List) {
            setState(() {
              LanguagesDescriptions = data.map((languages) {
                return {
                  'codeId': languages['codeId'].toString(),
                  'codeDesc': languages['codeDesc'].toString(),
                };
              }).toList();
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              errorMessage =
                  'Invalid structure: expected a list in "data" ${languagesResponse.statusCode}';
              _showErrorDialog(
                  'Internet Connection Slow, Please check your connection');
            });
          }
        } else {
          setState(() {
            isLoading = false;
            errorMessage =
                'Key "data" not found in response. ${languagesResponse.statusCode}';
            _showErrorDialog(
                'Internet Connection Slow, Please check your connection');
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              'Error fetching languages: ${languagesResponse.statusCode}';
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
            child: DropdownButtonFormField<Map<String, String>?>(
              value: selectedLanguages.isNotEmpty
                  ? LanguagesDescriptions.firstWhere(
                      (item) => item['codeDesc'] == selectedLanguages,
                      orElse: () => {'codeId': '', 'codeDesc': ''},
                    )
                  : null,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Languages Spoken',
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: LanguagesDescriptions.map((Map<String, String> value) {
                return DropdownMenuItem<Map<String, String>>(
                  value: value,
                  child: Text(value['codeDesc']!),
                );
              }).toList(),
              onChanged: (Map<String, String>? newValue) {
                setState(() {
                  if (newValue != null) {
                    selectedLanguages = newValue['codeDesc']!;
                    selectedLanguagesId = int.tryParse(newValue['codeId']!);
                    // widget.controller.text = selectedLanguagesId.toString();
                    widget.controller.text = jsonEncode({
                      'codeId': selectedLanguagesId,
                      'codeDesc': selectedLanguages,
                    });
                  }
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a Language';
                }
                return null;
              },
            ),
          );
  }
}
