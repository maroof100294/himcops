import 'dart:io';

import 'package:flutter/material.dart';
import 'package:himcops/authservice.dart';
import 'package:himcops/config.dart';
import 'package:himcops/pages/cgridhome.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/io_client.dart';

class AddressVerificationPage extends StatefulWidget {
  final TextEditingController controller;

  const AddressVerificationPage({Key? key, required this.controller})
      : super(key: key);

  @override
  State<AddressVerificationPage> createState() =>
      _AddressVerificationPageState();
}

class _AddressVerificationPageState extends State<AddressVerificationPage> {
  String selectedAddress = '';
  int? selectedAddressId; // Updated to int to store codeId
  List<Map<String, String>> addressDescriptions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isNotEmpty) {
      selectedAddressId = int.tryParse(
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
      final addressUrl = '$baseUrl/androidapi/mobile/service/getIdentity';
      final addressResponse = await client.get(
        Uri.parse(addressUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (addressResponse.statusCode == 200) {
        final jsonResponse = json.decode(addressResponse.body);

        if (jsonResponse.containsKey('data')) {
          final data = jsonResponse['data'];

          if (data is List) {
            setState(() {
              // Filter the relation descriptions to include only codeId 1, 2, 3, and 4
              addressDescriptions = data.where((address) {
                String codeId = address['codeId'].toString();
                return ['1', '2', '3', '4', '5', '6', '8', '9']
                    .contains(codeId);
              }).map((address) {
                return {
                  'codeId': address['codeId'].toString(),
                  'codeDesc': address['codeDesc'].toString(),
                };
              }).toList();
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              errorMessage =
                  'Invalid structure: expected a list in "data" ${addressResponse.statusCode}';
              _showErrorDialog(
                  'Internet Connection Slow, Please check your connection');
            });
          }
        } else {
          setState(() {
            isLoading = false;
            errorMessage =
                'Key "data" not found in response. ${addressResponse.statusCode}';
            _showErrorDialog(
                'Internet Connection Slow, Please check your connection');
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              'Error fetching RelationType: ${addressResponse.statusCode}';
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
              value: selectedAddress.isNotEmpty
                  ? addressDescriptions.firstWhere(
                      (item) => item['codeDesc'] == selectedAddress,
                      orElse: () => {'codeId': '', 'codeDesc': ''},
                    )
                  : null,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Address Verification',
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: addressDescriptions.map((Map<String, String> value) {
                return DropdownMenuItem<Map<String, String>>(
                  value: value,
                  child: Text(value['codeDesc']!),
                );
              }).toList(),
              onChanged: (Map<String, String>? newValue) {
                setState(() {
                  if (newValue != null) {
                    selectedAddress = newValue['codeDesc']!;
                    selectedAddressId = int.tryParse(newValue['codeId']!);
                    // widget.controller.text = selectedAddressId.toString();
                    widget.controller.text = jsonEncode({
                      'codeId': selectedAddressId,
                      'codeDesc': selectedAddress,
                    });
                  }
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a Address Verification';
                }
                return null;
              },
            ),
          );
  }
}
