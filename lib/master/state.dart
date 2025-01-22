import 'dart:io';

import 'package:flutter/material.dart';
import 'package:himcops/config.dart';
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
    final tokenUrl = '$baseUrl/androidapi/oauth/token';
    final stateUrl = '$baseUrl/androidapi/mobile/service/getState';
    String credentials =
        'cctnsws:ea5be3a221d5761d0aab36bd13357b93-28920be3928b4a02611051d04a2dcef9-f1e961fadf11b03227fa71bc42a2a99a-8f3918bc211a5f27198b04cd92c9d8fe-bfa8eb4f98e1668fc608c4de2946541a';
    String basicAuth = 'Basic ${base64Encode(utf8.encode(credentials)).trim()}';

    try {
      // Request for access token
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(ioc);
      final tokenResponse = await client.post(
        Uri.parse(tokenUrl),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'password',
          'username': 'icjsws',
          'password': 'cctns@123',
        },
      );

      if (tokenResponse.statusCode == 200) {
        final tokenData = json.decode(tokenResponse.body);
        String accessToken = tokenData['access_token'];

        // Fetch states with the access token
        final stateResponse = await client.get(
          Uri.parse(stateUrl),
          headers: {
            'Authorization': 'Bearer $accessToken',
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
            errorMessage = 'Failed to load states. Error ${stateResponse.statusCode}';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to authenticate. Error ${tokenResponse.statusCode}';
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
