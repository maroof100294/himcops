import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';
import 'package:himcops/pages/cgridhome.dart';

class GenderPage extends StatefulWidget {
  final TextEditingController controller;

  const GenderPage({super.key, required this.controller});

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  String selectedGender = '';
  int? selectedGenderId;
  List<Map<String, String>> genderDescriptions = [];
  bool isLoading = true;
  String errorMessage = '';

  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isNotEmpty) {
      selectedGenderId = int.tryParse(widget.controller.text);
    }
    configureDio();
    fetchGender();
  }

  void configureDio() {
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<void> fetchGender() async {
    final url = 'https://citizenportal.hppolice.gov.in/androidapi/oauth/token';
    String credentials =
        'cctnsws:ea5be3a221d5761d0aab36bd13357b93-28920be3928b4a02611051d04a2dcef9-f1e961fadf11b03227fa71bc42a2a99a-8f3918bc211a5f27198b04cd92c9d8fe-bfa8eb4f98e1668fc608c4de2946541a';
    String basicAuth = 'Basic ${base64Encode(utf8.encode(credentials)).trim()}';

    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': basicAuth,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'grant_type': 'password',
          'username': 'icjsws',
          'password': 'cctns@123',
        },
      );

      if (response.statusCode == 200) {
        final tokenData = response.data;
        String accessToken = tokenData['access_token'];

        final genderUrl =
            'https://citizenportal.hppolice.gov.in/androidapi/mobile/service/getGender';
        final genderResponse = await dio.get(
          genderUrl,
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
        );

        if (genderResponse.statusCode == 200) {
          final jsonResponse = genderResponse.data;

          if (jsonResponse.containsKey('data')) {
            final data = jsonResponse['data'];

            if (data is List) {
              setState(() {
                genderDescriptions = data.where((gender) {
                  String codeId = gender['codeId'].toString();
                  return ['1', '2', '3', '4'].contains(codeId);
                }).map((gender) {
                  return {
                    'codeId': gender['codeId'].toString(),
                    'codeDesc': gender['codeDesc'].toString(),
                  };
                }).toList();
                isLoading = false;
              });
            } else {
              _showErrorDialog('Invalid structure: expected a list in "data"');
            }
          } else {
            _showErrorDialog('Key "data" not found in response.');
          }
        } else {
          _showErrorDialog(
              'Error fetching Gender: ${genderResponse.statusCode}');
        }
      } else {
        _showErrorDialog('Error: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      _showErrorDialog('Error occurred: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CitizenGridPage()));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: DropdownButtonFormField<Map<String, String>?>(
              value: selectedGender.isNotEmpty
                  ? genderDescriptions.firstWhere(
                      (item) => item['codeDesc'] == selectedGender,
                      orElse: () => {'codeId': '', 'codeDesc': ''},
                    )
                  : null,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Gender',
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: genderDescriptions.map((Map<String, String> value) {
                return DropdownMenuItem<Map<String, String>>(
                  value: value,
                  child: Text(value['codeDesc']!),
                );
              }).toList(),
              onChanged: (Map<String, String>? newValue) {
                setState(() {
                  if (newValue != null) {
                    selectedGender = newValue['codeDesc']!;
                    selectedGenderId = int.tryParse(newValue['codeId']!);
                    widget.controller.text = jsonEncode({
                      'codeId': selectedGenderId,
                      'codeDesc': selectedGender,
                    });
                  }
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a Gender';
                }
                return null;
              },
            ),
          );
  }
}
