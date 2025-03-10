import 'dart:io';
import 'package:flutter/material.dart';
import 'package:himcops/authservice.dart';
import 'package:himcops/config.dart';
import 'package:himcops/pages/cgridhome.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/io_client.dart';

class EventPerformanceTyePage extends StatefulWidget {
  final TextEditingController controller;

  const EventPerformanceTyePage(
      {Key? key, required this.controller, required bool enabled})
      : super(key: key);

  @override
  State<EventPerformanceTyePage> createState() =>
      _EventPerformanceTyePageState();
}

class _EventPerformanceTyePageState extends State<EventPerformanceTyePage> {
  String selectedEvent = '';
  int? selectedEventId; // Updated to int to store codeId
  List<Map<String, String>> EventDescriptions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isNotEmpty) {
      selectedEventId = int.tryParse(
          widget.controller.text); // Initialize with codeId if available
    }
    fetchEventType();
  }

  Future<void> fetchEventType() async {
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
      final EventUrl = '$baseUrl/androidapi/mobile/service/getEventType';
      final EventResponse = await client.get(
        Uri.parse(EventUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (EventResponse.statusCode == 200) {
        final jsonResponse = json.decode(EventResponse.body);

        if (jsonResponse.containsKey('data')) {
          final data = jsonResponse['data'];

          if (data is List) {
            setState(() {
              EventDescriptions = data.map((event) {
                return {
                  'codeId': event['codeId'].toString(),
                  'codeDesc': event['codeDesc'].toString(),
                };
              }).toList();
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              errorMessage =
                  'Invalid structure: expected a list in "data" ${EventResponse.statusCode}';
              _showErrorDialog('Technical Problem, Please Try again later');
            });
          }
        } else {
          setState(() {
            isLoading = false;
            errorMessage =
                'Key "data" not found in response. ${EventResponse.statusCode}';
            _showErrorDialog('Technical Problem, Please Try again later');
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              'Error fetching EventType: ${EventResponse.statusCode}';
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
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: DropdownButtonFormField<Map<String, String>?>(
              value: selectedEvent.isNotEmpty
                  ? EventDescriptions.firstWhere(
                      (item) => item['codeDesc'] == selectedEvent,
                      orElse: () => {'codeId': '', 'codeDesc': ''},
                    )
                  : null,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Event Type',
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: EventDescriptions.map((Map<String, String> value) {
                return DropdownMenuItem<Map<String, String>>(
                  value: value,
                  child: Text(value['codeDesc']!),
                );
              }).toList(),
              onChanged: (Map<String, String>? newValue) {
                setState(() {
                  if (newValue != null) {
                    selectedEvent = newValue['codeDesc']!;
                    selectedEventId = int.tryParse(newValue['codeId']!);
                    // widget.controller.text = selectedEventId.toString();
                    widget.controller.text = jsonEncode({
                      'codeId': selectedEventId,
                      'codeDesc': selectedEvent,
                    });
                  }
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a Event Type';
                }
                return null;
              },
            ),
          );
  }
}
