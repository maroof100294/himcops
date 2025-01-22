import 'dart:io';

import 'package:flutter/material.dart';
import 'package:himcops/config.dart';
import 'package:himcops/pages/cgridhome.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/io_client.dart';

class CountryPage extends StatefulWidget {
  final TextEditingController controller;

  const CountryPage({super.key, required this.controller, required bool enabled});

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  String selectedCountry = 'INDIA';
  int? selectedCountryId; // Updated to int to store codeId
  List<Map<String, String>> countryDescriptions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    // if (widget.controller.text.isNotEmpty) {
    //   selectedCountryId = int.tryParse(widget.controller.text); // Initialize with codeId if available
    // }
    fetchCountry();
  }

  Future<void> fetchCountry() async {
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

        final countryUrl = '$baseUrl/androidapi/mobile/service/getCountry';
        final countryResponse = await client.get(
          Uri.parse(countryUrl),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (countryResponse.statusCode == 200) {
          final jsonResponse = json.decode(countryResponse.body);

          if (jsonResponse.containsKey('data')) {
            final data = jsonResponse['data'];

            if (data is List) {
              setState(() {
                countryDescriptions = data.map((Country) {
                  return {
                    'codeId': Country['codeId'].toString(),
                    'codeDesc': Country['codeDesc'].toString(),
                  };
                }).toList();

                 final initialCountry = countryDescriptions.firstWhere(
                  (item) => item['codeDesc']!.toUpperCase() == selectedCountry.toUpperCase(),
                  orElse: () => {'codeId': '', 'codeDesc': ''},
                );

                if (initialCountry.isNotEmpty) {
                  selectedCountry = initialCountry['codeDesc']!;
                  selectedCountryId = int.tryParse(initialCountry['codeId']!);
                  widget.controller.text = selectedCountryId.toString();
                }

                isLoading = false;
              });
            } else {
              setState(() {
                isLoading = false;
                errorMessage = 'Invalid structure: expected a list in "data"';
                _showErrorDialog('Internet Connection Slow, Please check your connection');
              });
            }
          } else {
            setState(() {
              isLoading = false;
              errorMessage = 'Key "data" not found in response.';
              _showErrorDialog('Internet Connection Slow, Please check your connection');
            });
          }
        } else {
          setState(() {
            isLoading = false;
            errorMessage = 'Error fetching Country: ${countryResponse.statusCode}';
            _showErrorDialog('Internet Connection Slow, Please check your connection');
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Error: ${response.statusCode} - ${response.body}';
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
                      builder: (context) =>
                          const CitizenGridPage(),
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
                  value: selectedCountry.isNotEmpty
                      ? countryDescriptions.firstWhere(
                          (item) => item['codeDesc'] == selectedCountry,
                          orElse: () => {'codeId': '', 'codeDesc': ''},
                        )
                      : null,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Country',
                    prefixIcon: const Icon(Icons.location_city),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: countryDescriptions.map((Map<String, String> value) {
                    return DropdownMenuItem<Map<String, String>>(
                      value: value,
                      child: Text(value['codeDesc']!),
                    );
                  }).toList(),
                  onChanged: (Map<String, String>? newValue) {
                    setState(() {
                      if (newValue != null) {
                        selectedCountry = newValue['codeDesc']!;
                        selectedCountryId = int.tryParse(newValue['codeId']!); // Parse as int
                        widget.controller.text = selectedCountryId.toString(); // Update controller
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a Country';
                    }
                    return null;
                  },
                ),
              );
  }
}
 