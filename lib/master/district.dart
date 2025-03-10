import 'dart:io';
import 'package:flutter/material.dart';
import 'package:himcops/authservice.dart';
import 'package:himcops/config.dart';
import 'package:himcops/pages/cgridhome.dart';
import 'dart:convert';
import 'package:http/io_client.dart';

class DistrictPage extends StatefulWidget {
  final Function(String?) controller;

  const DistrictPage(
      {super.key, required this.controller, required bool enabled});

  @override
  State<DistrictPage> createState() => _DistrictPageState();
}

class _DistrictPageState extends State<DistrictPage> {
  String? selectedDistrict;
  List<Map<String, String>> districtDescriptions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchDistrict();
  }

  Future<void> fetchDistrict() async {
    final token = await AuthService.getAccessToken(); // Fetch the token

    if (token == null) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to retrieve access token.';
      });
      _showErrorDialog('Technical Problem, Please Try again later');
      return;
    }

    final url = '$baseUrl/androidapi/mobile/service/getDistrict?statecd=12';

    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final client = IOClient(ioc);
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('data')) {
          final data = jsonResponse['data'];

          if (data is List) {
            setState(() {
              districtDescriptions = data
                  .map((district) => {
                        'codeId': district['codeId'].toString(),
                        'codeDesc': district['codeDesc'].toString()
                      })
                  .toList();
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              errorMessage = 'Invalid structure: expected a list in "data"';
            });
          }
        } else {
          setState(() {
            isLoading = false;
            errorMessage = 'Key "data" not found in response.';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Error fetching district: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error occurred: $e';
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
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: DropdownButtonFormField<String>(
              value: selectedDistrict,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'District',
                prefixIcon: const Icon(Icons.location_city),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: districtDescriptions.isNotEmpty
                  ? districtDescriptions.map((district) {
                      return DropdownMenuItem<String>(
                        value: district['codeId'],
                        child: Text(district['codeDesc']!),
                      );
                    }).toList()
                  : [],
              onChanged: (String? newValue) async {
                setState(() {
                  selectedDistrict = newValue;
                  widget.controller(newValue); // Pass selected value back
                  isLoading = false;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a District';
                }
                return null;
              },
            ),
          );
  }
}
