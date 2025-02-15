import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:himcops/config.dart';
import 'package:himcops/pages/cgridhome.dart';
import 'package:http/io_client.dart';

class MajStateDistrictDynamicPage extends StatefulWidget {
  final Function(String?) onStateSelected;
  final Function(String?) onDistrictSelected;
  final Function(String?) onPoliceStationSelected;

  const MajStateDistrictDynamicPage({
    super.key,
    required this.onStateSelected,
    required this.onDistrictSelected,
    required this.onPoliceStationSelected,
  });

  @override
  State<MajStateDistrictDynamicPage> createState() =>
      _MajStateDistrictDynamicPageState();
}

class _MajStateDistrictDynamicPageState extends State<MajStateDistrictDynamicPage> {
  String? selectedState;
  String? selectedDistrict;
  String? selectedPolice;
  String? selectedStateName;
  String? selectedDistrictName;
  String? selectedPoliceName;

  List<Map<String, String>> stateDescriptions = [];
  List<Map<String, String>> districtDescriptions = [];
  List<Map<String, String>> policeDescriptions = [];
  bool isLoading = true;
  String errorMessage = '';
  String? accessToken;

  @override
  void initState() {
    super.initState();
    fetchStates();
  }

  Future<String?> getAccessToken() async {
    if (accessToken != null) {
      return accessToken;
    }

    final url = '$baseUrl/androidapi/oauth/token';
    String credentials =
        'cctnsws:ea5be3a221d5761d0aab36bd13357b93-28920be3928b4a02611051d04a2dcef9-f1e961fadf11b03227fa71bc42a2a99a-8f3918bc211a5f27198b04cd92c9d8fe-bfa8eb4f98e1668fc608c4de2946541a';
    String basicAuth = 'Basic ${base64Encode(utf8.encode(credentials)).trim()}';

    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
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
        accessToken =
            tokenData['access_token'];
        return accessToken;
      } else {
        _showErrorDialog('Internet Connection Slow, Please check your connection');
        return null;
      }
    } catch (e) {
      _showErrorDialog('Technical Problem, Please Try again later');
      return null;
    }
  }

  Future<void> fetchStates() async {
    String? token = await getAccessToken();
    if (token == null) return;

    final url = '$baseUrl/androidapi/mobile/service/getState';

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
        if (jsonResponse.containsKey('data') && jsonResponse['data'] is List) {
          setState(() {
            stateDescriptions = (jsonResponse['data'] as List)
                .map((state) => {
                      'codeId': state['codeId'].toString(),
                      'codeDesc': state['codeDesc'].toString()
                    })
                .toList();
            isLoading = false;
          });
        } else {
          _showErrorDialog('Invalid response format');
        }
      } else {
        _showErrorDialog('Error fetching states');
      }
    } catch (e) {
      _showErrorDialog('Technical Problem, Please Try again later');
    }
  }

  Future<void> fetchDistrict(String stateCodeId) async {
    String? token = await getAccessToken();
    if (token == null) return;

    final url =
        '$baseUrl/androidapi/mobile/service/getDistrict?statecd=$stateCodeId';

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
        if (jsonResponse.containsKey('data') && jsonResponse['data'] is List) {
          setState(() {
            districtDescriptions = (jsonResponse['data'] as List)
                .map((district) => {
                      'codeId': district['codeId'].toString(),
                      'codeDesc': district['codeDesc'].toString()
                    })
                .toList();
            isLoading = false;
          });
        } else {
          _showErrorDialog('Invalid response format');
        }
      } else {
        _showErrorDialog('Error fetching district');
      }
    } catch (e) {
      _showErrorDialog('Technical Problem, Please Try again later');
    }
  }

  Future<void> fetchPolice(String districtCodeId) async {
    String? token = await getAccessToken();
    if (token == null) return;

    final url =
        '$baseUrl/androidapi/mobile/service/getPoliceStation?districtcd=$districtCodeId';

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
        if (jsonResponse.containsKey('data') && jsonResponse['data'] is List) {
          setState(() {
            policeDescriptions = (jsonResponse['data'] as List)
                .map((police) => {
                      'codeId': police['codeId'].toString(),
                      'codeDesc': police['codeDesc'].toString()
                    })
                .toList();
            isLoading = false;
          });
        } else {
          _showErrorDialog('Invalid response format');
        }
      } else {
        _showErrorDialog('Error fetching police station');
      }
    } catch (e) {
      _showErrorDialog('Technical Problem, Please Try again later');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CitizenGridPage(),
              ),
            );
            return false;
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
                      selectedStateName = stateDescriptions
                          .firstWhere((state) =>
                              state['codeId'] == newValue)['codeDesc'];
                      districtDescriptions = [];
                      selectedDistrict = null;
                      policeDescriptions = [];
                      selectedPolice = null;
                      widget.onStateSelected(newValue);
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
                      selectedDistrictName = districtDescriptions
                          .firstWhere((district) =>
                              district['codeId'] == newValue)['codeDesc'];
                      policeDescriptions = [];
                      selectedPolice = null;
                      widget.onDistrictSelected(newValue);
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
                            value: police['codeId'],
                            child: Text(police['codeDesc']!),
                          );
                        }).toList()
                      : [],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPolice = newValue;
                      selectedPoliceName = policeDescriptions
                          .firstWhere((police) =>
                              police['codeId'] == newValue)['codeDesc'];
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
