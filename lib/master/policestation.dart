import 'dart:io';

import 'package:flutter/material.dart';
import 'package:himcops/config.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/io_client.dart';

class PoliceStationPage extends StatefulWidget {
  final TextEditingController controller;

  const PoliceStationPage(
      {super.key, required this.controller, required bool enabled, });

  @override
  State<PoliceStationPage> createState() => _PoliceStationPageState();
}

class _PoliceStationPageState extends State<PoliceStationPage> {
  String selectedPoliceStation = '';
  int? selectedPoliceStationId; // Updated to int to store codeId
  List<Map<String, String>> policeStationDescriptions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isNotEmpty) {
      selectedPoliceStationId = int.tryParse(
          widget.controller.text); // Initialize with codeId if available
    }
    fetchPoliceStation();
  }

  Future<void> fetchPoliceStation() async {
    final url = '$baseUrl/androidapi/oauth/token';
    String credentials =
        'cctnsws:ea5be3a221d5761d0aab36bd13357b93-28920be3928b4a02611051d04a2dcef9-f1e961fadf11b03227fa71bc42a2a99a-8f3918bc211a5f27198b04cd92c9d8fe-bfa8eb4f98e1668fc608c4de2946541a';
    String basicAuth = 'Basic ${base64Encode(utf8.encode(credentials)).trim()}';

    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(ioc);
      final response = await client.post(
        Uri.parse(url),
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

      if (response.statusCode == 200) {
        final tokenData = json.decode(response.body);
        String accessToken = tokenData['access_token'];

        final policeStationUrl =
            '$baseUrl/androidapi/mobile/service/getPoliceStation?districtcd=12251';
        final policeStationResponse = await client.get(
          Uri.parse(policeStationUrl),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (policeStationResponse.statusCode == 200) {
          final jsonResponse = json.decode(policeStationResponse.body);

          if (jsonResponse.containsKey('data')) {
            final data = jsonResponse['data'];

            if (data is List) {
              setState(() {
                policeStationDescriptions = data.map((PoliceStation) {
                  return {
                    'codeId': PoliceStation['codeId'].toString(),
                    'codeDesc': PoliceStation['codeDesc'].toString(),
                  };
                }).toList();
                isLoading = false;
              });
            } else {
              setState(() {
                isLoading = false;
                errorMessage = 'Invalid structure: expected a list in "data" ${policeStationResponse.statusCode}';
              });
            }
          } else {
            setState(() {
              isLoading = false;
              errorMessage = 'Key "data" not found in response. ${policeStationResponse.statusCode}';
            });
          }
        } else {
          setState(() {
            isLoading = false;
            errorMessage =
                'Error fetching PoliceStation: ${policeStationResponse.statusCode}';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Error: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error occurred: $e';
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
                  value: selectedPoliceStation.isNotEmpty
                      ? policeStationDescriptions.firstWhere(
                          (item) => item['codeDesc'] == selectedPoliceStation,
                          orElse: () => {'codeId': '', 'codeDesc': ''},
                        )
                      : null,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Police Station',
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: policeStationDescriptions
                      .map((Map<String, String> value) {
                    return DropdownMenuItem<Map<String, String>>(
                      value: value,
                      child: Text(value['codeDesc']!),
                    );
                  }).toList(),
                  onChanged: (Map<String, String>? newValue) {
                    setState(() {
                      if (newValue != null) {
                        selectedPoliceStation = newValue['codeDesc']!;
                        selectedPoliceStationId =
                            int.tryParse(newValue['codeId']!); // Parse as int
                        widget.controller.text = selectedPoliceStationId
                            .toString(); // Update controller
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a Police Station';
                    }
                    return null;
                  },
                ),
              );
  }
}
