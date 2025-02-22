import 'package:flutter/material.dart';
import 'package:himcops/authservice.dart';
import 'package:himcops/config.dart';
import 'package:himcops/pages/cgridhome.dart';
import 'dart:convert';
import 'package:http/io_client.dart';
import 'dart:io';

class CountryPage extends StatefulWidget {
  final TextEditingController controller;

  const CountryPage({super.key, required this.controller, required bool enabled});

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  String selectedCountry = 'INDIA';
  int? selectedCountryId;
  List<Map<String, String>> countryDescriptions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchCountry();
  }

  Future<void> fetchCountry() async {
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
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(ioc);

      final countryUrl = '$baseUrl/androidapi/mobile/service/getCountry';
      final countryResponse = await client.get(
        Uri.parse(countryUrl),
        headers: {
          'Authorization': 'Bearer $token',
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
        ? const Center(child: CircularProgressIndicator())
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
                    selectedCountryId = int.tryParse(newValue['codeId']!);
                    widget.controller.text = selectedCountryId.toString();
                  }
                });
              },
            ),
          );
  }
}
