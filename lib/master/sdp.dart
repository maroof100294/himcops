import 'dart:io';

import 'package:flutter/material.dart';
import 'package:himcops/authservice.dart';
import 'package:himcops/config.dart';
import 'package:himcops/pages/cgridhome.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/io_client.dart';

class DpPage extends StatefulWidget {
  final Function(String?) onDistrictSelected;
  final Function(String?) onPoliceStationSelected;

  const DpPage({
    super.key,
    required this.onDistrictSelected,
    required this.onPoliceStationSelected,
  });

  @override
  State<DpPage> createState() => _DpPageState();
}

class _DpPageState extends State<DpPage> {
  String? selectedState;
  String? selectedDistrict;
  String? selectedPolice;
  List<Map<String, String>> stateDescriptions = [];
  List<Map<String, String>> districtDescriptions = [];
  List<Map<String, String>> policeDescriptions = [];
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
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
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
          errorMessage = 'Error fetching district: ${response.statusCode}';
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

  Future<void> fetchPolice(String districtCodeId) async {
   final token = await AuthService.getAccessToken(); // Fetch the token

    if (token == null) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to retrieve access token.';
      });
      _showErrorDialog('Technical Problem, Please Try again later');
      return;
    }

    final url =
        '$baseUrl/androidapi/mobile/service/getPoliceStation?districtcd=$districtCodeId';

    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
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
              policeDescriptions = data
                  .map((police) => {
                        'codeId': police['codeId'].toString(), // Store codeId
                        'codeDesc':
                            police['codeDesc'].toString() // Store codeDesc
                      })
                  .toList();
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
          errorMessage =
              'Error fetching police station: ${response.statusCode}';
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
            : Column(
                children: [
                  Padding(
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
                          policeDescriptions = [];
                          selectedPolice = null; // Reset police selection
                          widget.onDistrictSelected(
                              newValue); // Pass the district code back
                          isLoading = true;
                        });

                        if (newValue != null) {
                          await fetchPolice(newValue);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a District';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: DropdownButtonFormField<String>(
                      value: selectedPolice,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Police Station',
                        prefixIcon: const Icon(Icons.local_police),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: policeDescriptions.isNotEmpty
                          ? policeDescriptions.map((police) {
                              return DropdownMenuItem<String>(
                                value: police['codeId'],
                                child: Text(police['codeDesc']!),
                              );
                            }).toList()
                          : [],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPolice = newValue;
                          widget.onPoliceStationSelected(newValue);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a Police Station';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              );
  }
}
