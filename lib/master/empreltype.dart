import 'dart:io';

import 'package:flutter/material.dart';
import 'package:himcops/authservice.dart';
import 'package:himcops/config.dart';
import 'package:himcops/pages/cgridhome.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/io_client.dart';

class EmpRelationTypePage extends StatefulWidget {
  final TextEditingController controller;

  const EmpRelationTypePage({Key? key, required this.controller})
      : super(key: key);

  @override
  State<EmpRelationTypePage> createState() => _EmpRelationTypePageState();
}

class _EmpRelationTypePageState extends State<EmpRelationTypePage> {
  String selectedRelation = '';
  int? selectedRelationId; // Updated to int to store codeId
  List<Map<String, String>> relationDescriptions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isNotEmpty) {
      selectedRelationId = int.tryParse(
          widget.controller.text); // Initialize with codeId if available
    }
    fetchRelationType();
  }

  Future<void> fetchRelationType() async {
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
      final relationUrl = '$baseUrl/androidapi/mobile/service/getRelationType';
      final relationResponse = await client.get(
        Uri.parse(relationUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (relationResponse.statusCode == 200) {
        final jsonResponse = json.decode(relationResponse.body);

        if (jsonResponse.containsKey('data')) {
          final data = jsonResponse['data'];

          if (data is List) {
            setState(() {
              // Filter the relation descriptions to include only codeId 1, 2, 3, and 4
              relationDescriptions = data.where((relation) {
                String codeId = relation['codeId'].toString();
                return ['5', '7', '6', '8', '9'].contains(codeId);
              }).map((relation) {
                return {
                  'codeId': relation['codeId'].toString(),
                  'codeDesc': relation['codeDesc'].toString(),
                };
              }).toList();
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
          errorMessage =
              'Error fetching RelationType: ${relationResponse.statusCode}';
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
                  value: selectedRelation.isNotEmpty
                      ? relationDescriptions.firstWhere(
                          (item) => item['codeDesc'] == selectedRelation,
                          orElse: () => {'codeId': '', 'codeDesc': ''},
                        )
                      : null,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Relation Type',
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: relationDescriptions.map((Map<String, String> value) {
                    return DropdownMenuItem<Map<String, String>>(
                      value: value,
                      child: Text(value['codeDesc']!),
                    );
                  }).toList(),
                  onChanged: (Map<String, String>? newValue) {
                    setState(() {
                      if (newValue != null) {
                        selectedRelation = newValue['codeDesc']!;
                        selectedRelationId = int.tryParse(newValue['codeId']!);
                        widget.controller.text = selectedRelationId.toString();
                        // widget.controller.text = jsonEncode({
                        //   'codeId': selectedRelationId,
                        //   'codeDesc': selectedRelation,
                        // });
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a Relation Type';
                    }
                    return null;
                  },
                ),
              );
  }
}
