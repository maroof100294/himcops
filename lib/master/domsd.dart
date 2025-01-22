import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:himcops/config.dart';
import 'package:himcops/pages/cgridhome.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/io_client.dart';

class DomSdPage extends StatefulWidget {
  final Function(String?) onStateSelected;
  final Function(String?) onDistrictSelected;
  final Function(String?) onPoliceStationSelected;

  const DomSdPage({
    super.key,
    required this.onStateSelected,
    required this.onDistrictSelected,
    required this.onPoliceStationSelected,
  });

  @override
  State<DomSdPage> createState() => _DomSdPageState();
}

class _DomSdPageState extends State<DomSdPage> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  int? stateCd;
  int? districtCd;

  String? selectedState;
  String? selectedDistrict;
  String? selectedPolice;

  List<Map<String, String>> stateDescriptions = [];
  List<Map<String, String>> districtDescriptions = [];
  List<Map<String, String>> policeDescriptions = [];

  bool isLoading = true;
  String errorMessage = '';
  String? accessToken;

  @override
  void initState() {
    super.initState();
    fetchAccessToken();
    _fetchLoginId();
  }

  Future<void> _fetchLoginId() async {
    final String? storedStateCd = await storage.read(key: 'stateCd');
    final String? storedDistrictCd = await storage.read(key: 'districtCd');

    setState(() {
      stateCd = storedStateCd != null ? int.tryParse(storedStateCd) : null;
      districtCd = storedDistrictCd != null ? int.tryParse(storedDistrictCd) : null;
    });
  }

  Future<void> fetchAccessToken() async {
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
        setState(() {
          accessToken = tokenData['access_token'];
        });
        fetchStates();
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              'Error fetching token: ${response.statusCode} - ${response.body}';
        });
        _showErrorDialog('Internet Connection Slow, Please check your connection');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error occurred: $e';
      });
      _showErrorDialog('Technical Problem, Please Try again later');
    }
  }

  Future<void> fetchStates() async {
    if (accessToken == null) {
      setState(() {
        errorMessage = 'Access token is missing';
      });
      _showErrorDialog('Technical Problem, Please Try again later');
      return;
    }

    final url = '$baseUrl/androidapi/mobile/service/getState';

    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(ioc);
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('data')) {
          final data = jsonResponse['data'];

          if (data is List) {
            setState(() {
              stateDescriptions = data
                  .map((state) => {
                        'codeId': state['stateCd'].toString(),
                        'codeDesc': state['codeDesc'].toString()
                      })
                  .toList();

             isLoading = false;
              if (stateCd != null) {
                final matchingState = stateDescriptions.firstWhere(
                    (state) => state['codeId'] == stateCd.toString(),
                    orElse: () => {});
                selectedState = matchingState['codeId'];
              }
            });

            if (selectedState != null) {
              await fetchDistrict(selectedState!);
            }
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
          errorMessage = 'Error fetching states: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error occurred: $e';
      });
      _showErrorDialog('Technical Problem, Please Try again later');
    }
  }

  Future<void> fetchDistrict(String stateCodeId) async {
    if (accessToken == null) {
      setState(() {
        errorMessage = 'Access token is missing';
      });
      _showErrorDialog('Technical Problem, Please Try again later');
      return;
    }

    final url = '$baseUrl/androidapi/mobile/service/getDistrict?statecd=$stateCodeId';

    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(ioc);
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
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
              if (districtCd != null) {
                final matchingDistrict = districtDescriptions.firstWhere(
                    (district) => district['codeId'] == districtCd.toString(),
                    orElse: () => {});
                selectedDistrict = matchingDistrict['codeId'];
              }
            });

            if (selectedDistrict != null) {
              await fetchPolice(selectedDistrict!);
            }
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
          errorMessage = 'Error fetching districts: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error occurred: $e';
      });
      _showErrorDialog('Technical Problem, Please Try again later');
    }
  }

  Future<void> fetchPolice(String districtCodeId) async {
    if (accessToken == null) {
      setState(() {
        errorMessage = 'Access token is missing';
      });
      _showErrorDialog('Technical Problem, Please Try again later');
      return;
    }

    final url = '$baseUrl/androidapi/mobile/service/getPoliceStation?districtcd=$districtCodeId';

    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(ioc);
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
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
                        'codeId': police['codeId'].toString(),
                        'codeDesc': police['codeDesc'].toString()
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
          errorMessage = 'Error fetching police stations: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error occurred: $e';
      });
      _showErrorDialog('Technical Problem, Please Try again later');
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
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: DropdownButtonFormField<String>(
                      value: selectedState,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'State',
                        prefixIcon: const Icon(Icons.map),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: stateDescriptions.isNotEmpty
                          ? stateDescriptions.map((state) {
                              return DropdownMenuItem<String>(
                                value: state['codeId'],
                                child: Text(state['codeDesc']!),
                              );
                            }).toList()
                          : [],
                      onChanged: (String? newValue) async {
                        setState(() {
                          selectedState = newValue;
                          districtDescriptions = [];
                          selectedDistrict = null;
                          policeDescriptions = [];
                          selectedPolice = null;
                          widget.onStateSelected(
                              newValue); // Pass the state code back
                          isLoading = true;
                        });

                        if (newValue != null) {
                          await fetchDistrict(newValue);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a State';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
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
                  const SizedBox(height: 16.0),
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
                                value:
                                    police['codeId'], // Use codeId as the value
                                child: Text(police['codeDesc']!),
                              );
                            }).toList()
                          : [],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPolice = newValue;
                          widget.onPoliceStationSelected(
                              newValue); // Pass the police station code back
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

