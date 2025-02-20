import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:himcops/config.dart';
import 'package:himcops/drawer/pdrawer.dart';
import 'package:himcops/master/sdp.dart';
import 'package:himcops/pages/cgridhome.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';

class DSIMobileHomePage extends StatefulWidget {
  const DSIMobileHomePage({super.key});

  @override
  State<DSIMobileHomePage> createState() => _DSIMobileHomePageState();
}

class _DSIMobileHomePageState extends State<DSIMobileHomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController firNumController = TextEditingController();
  final TextEditingController _dateFromController = TextEditingController();
  final TextEditingController _dateToController = TextEditingController();
  final TextEditingController _dateFirFromController = TextEditingController();
  final TextEditingController _dateFirToController = TextEditingController();

  int totalFIR = 0;
  int specialCases = 0;
  DateTime? fromDate;
  DateTime? toDate;
  String? dsiDistrictCode;
  String? dsiPoliceStationCode;
  DateTime? firFromDate;
  DateTime? firToDate;
  String? dsiFirDistrictCode;
  String? dsiFirPoliceStationCode;
  String? headDistrictCode;
  String? headDistrictName;
  String? headDsiCode;
  String? headDsiName;
  int? selectedIndex;
  late TabController _tabController;
  bool isFirDetailsVisible = false;
  bool isGraphDetailsVisible = true;
  int currentPage = 0;
  final int itemsPerPage = 2;
  int currentHeadPage = 0;
  final int itemsHeadPerPage = 6;
  List<String> crimeHeadList = ['ALL', 'Theft', 'Assault', 'Burglary', 'Fraud'];
  String? selectedCrimeHead;
  String? selectedHead;
  List<Map<String, String>> headDescriptions = [];
  bool isLoading = true;
  Dio dio = Dio();
  String? selectedDistrict;
  List<Map<String, String>> districtDescriptions = [];
  String errorMessage = '';
  String? accessToken;

  Map<String, List<Map<String, dynamic>>> crimeData = {
    'Theft': List.generate(
        10, (index) => {'PoliceStation': 'PS A$index', 'TotalCount': 30}),
    'Assault': List.generate(
        10, (index) => {'PoliceStation': 'PS B$index', 'TotalCount': 25}),
    'Burglary': List.generate(
        10, (index) => {'PoliceStation': 'PS C$index', 'TotalCount': 20}),
    'Fraud': List.generate(
        10, (index) => {'PoliceStation': 'PS D$index', 'TotalCount': 15}),
  };

// Function to get filtered data based on selection
  List<Map<String, dynamic>> getFilteredData() {
    if (selectedCrimeHead == null || selectedCrimeHead == 'ALL') {
      return crimeData.values
          .expand((e) => e)
          .toList(); // Merge all crime types
    }
    return crimeData[selectedCrimeHead] ?? [];
  }

  int getTotalCrimeCount() {
    if (selectedCrimeHead == null || selectedCrimeHead == 'ALL') {
      return crimeData.values
          .expand((e) => e)
          .fold<int>(0, (sum, item) => sum + (item['TotalCount'] as int? ?? 0));
    }
    return crimeData[selectedCrimeHead]?.fold<int>(
            0, (sum, item) => sum + (item['TotalCount'] as int? ?? 0)) ??
        0;
  }

  @override
  void initState() {
    super.initState();
    configureDio();
    fetchHead();
    fetchAccessToken();
    _dateFromController.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: 1)));
    _dateToController.text = DateTime.now().toString().split(' ')[0];
    _tabController = TabController(length: 4, vsync: this);
    _dateFirFromController.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: 1)));
    _dateFirToController.text = DateTime.now().toString().split(' ')[0];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showListDialog(context);
      // _showTooltip();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _search() {
    setState(() {
      totalFIR = 42;
      specialCases = 10;
    });
  }

  void configureDio() {
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<void> fetchAccessToken() async {
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
        setState(() {
          accessToken = tokenData['access_token'];
        });
        fetchDistrict();
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Error fetching token: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error occurred: $e';
      });
    }
  }

  Future<void> fetchDistrict() async {
    if (accessToken == null) {
      setState(() {
        errorMessage = 'Access token is missing';
      });
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
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('data')) {
          final data = jsonResponse['data'];

          if (data is List) {
            setState(() {
              districtDescriptions = [
                {'codeId': 'ALL', 'codeDesc': 'ALL'}, // Add "ALL" option
                ...data.map((district) {
                  String codeDesc = district['codeDesc'].toString();

                  // Replace long names with shorter versions for UI
                  if (codeDesc.contains(
                      "STATE VIGILANCE AND ANTI-CORRUPTION  BUREAU (SV & ACB)")) {
                    codeDesc = "SV&ACB";
                  } else if (codeDesc.contains("POLICE DISTRICT NURPUR")) {
                    codeDesc = "NURPUR";
                  } else if (codeDesc.contains("LAHAUL & SPITI")) {
                    codeDesc = "LAHAUL/SPITI";
                  } else if (codeDesc.contains("GOVT. RLY POLICE")) {
                    codeDesc = "GRP";
                  } else if (codeDesc.contains("BADDI POLICE DISTT")) {
                    codeDesc = "BADDI";
                  }

                  return {
                    'codeId': district['codeId'].toString(),
                    'codeDesc': codeDesc
                  };
                }).toList()
              ];
              selectedDistrict = 'ALL'; // Default selection
              // widget.controller('ALL', 'ALL');
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

  /*---------------------------------------- */

  Future<void> fetchHead() async {
    try {
      final url = '$baseUrl/androidapi/oauth/token';
      String credentials =
          'cctnsws:ea5be3a221d5761d0aab36bd13357b93-28920be3928b4a02611051d04a2dcef9-f1e961fadf11b03227fa71bc42a2a99a-8f3918bc211a5f27198b04cd92c9d8fe-bfa8eb4f98e1668fc608c4de2946541a';
      String basicAuth =
          'Basic ${base64Encode(utf8.encode(credentials)).trim()}';

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

        final headUrl = '$baseUrl/androidapi/mobile/service/getLocalHead';
        final headResponse = await dio.get(
          headUrl,
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
        );

        if (headResponse.statusCode == 200) {
          final jsonResponse = headResponse.data;
          if (jsonResponse.containsKey('data') &&
              jsonResponse['data'] is List) {
            final data = jsonResponse['data'] as List;
            setState(() {
              headDescriptions = [
                {'codeId': 'ALL', 'codeDesc': 'ALL'},
                ...data.map((head) => {
                      'codeId': head['codeId'].toString(),
                      'codeDesc': head['codeDesc'].toString(),
                    })
              ];
              selectedHead = 'ALL';
              // widget.controller('ALL', 'ALL');
              isLoading = false;
            });
          } else {
            _showErrorDialog('Invalid structure: expected a list in "data"');
          }
        } else {
          _showErrorDialog('Error fetching Head: ${headResponse.statusCode}');
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
              Image.asset('asset/images/hp_logo.png', height: 50),
              const SizedBox(height: 8),
              const Text('Himachal Pradesh',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text('Citizen Service',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

  Future<void> _selectfromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        fromDate = picked;
        _dateFromController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selecttoDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        toDate = picked;
        _dateToController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectfirfromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        firFromDate = picked;
        _dateFirFromController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectfirtoDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        firToDate = picked;
        _dateFirToController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  DateTime tryParseDate(String dateStr) {
    DateTime? parsedDate;

    try {
      parsedDate = DateFormat('yyyy-MM-dd').parseStrict(dateStr);
    } catch (e) {
      try {
        parsedDate = DateFormat('dd/MM/yyyy').parseStrict(dateStr);
      } catch (e) {
        parsedDate = DateTime(1900, 1, 1);
      }
    }

    return parsedDate;
  }

//DSIList Begin
  void _showListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Please Select Anyone to View',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setDialogState(() => selectedIndex = 0);
                            setState(() {}); // Update UI in main screen
                            Navigator.pop(context);
                            _showGraphDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedIndex == 0
                                ? Colors.blue[900]
                                : Colors.grey[300],
                            foregroundColor: selectedIndex == 0
                                ? Colors.white
                                : Colors.black,
                          ),
                          child: const Text('Graphical View'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setDialogState(() => selectedIndex = 1);
                            setState(() {});
                            Navigator.pop(context);
                            _showFirDialog(context); // Update UI in main screen
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedIndex == 1
                                ? Colors.blue[900]
                                : Colors.grey[300],
                            foregroundColor: selectedIndex == 1
                                ? Colors.white
                                : Colors.black,
                          ),
                          child: const Text('FIR Details View'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setDialogState(() => selectedIndex = 2);
                            setState(() {}); // Update UI in main screen
                            Navigator.pop(context);
                            _showHeadDialog(
                              context,
                              headDsiCode,
                              headDsiName,
                              headDistrictCode,
                              headDistrictName,
                              (districtCode, districtName) {
                                setState(() {
                                  headDistrictCode = districtCode;
                                  headDistrictName = districtName;
                                });
                              },
                              (headCode, headName) {
                                setState(() {
                                  headDsiCode = headCode;
                                  headDsiName = headName;
                                });
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedIndex == 2
                                ? Colors.blue[900]
                                : Colors.grey[300],
                            foregroundColor: selectedIndex == 2
                                ? Colors.white
                                : Colors.black,
                          ),
                          child: const Text('Local Head Count View'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
//DSIList end

/*----------------one content start------------------*/

//GraphicalView begin
//graphFilter begin
  void _showGraphDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Filter Options',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateFromController,
                      decoration: InputDecoration(
                        labelText: 'Date Range From',
                        prefixIcon: const Icon(Icons.calendar_month),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      readOnly: true,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _selectfromDate(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _dateToController,
                      decoration: InputDecoration(
                        labelText: 'Date Range To',
                        prefixIcon: const Icon(Icons.calendar_month),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      readOnly: true,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _selecttoDate(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DpPage(
                onDistrictSelected: (districtCode) {
                  setState(() {
                    dsiDistrictCode = districtCode;
                  });
                },
                onPoliceStationSelected: (policeStationCode) {
                  setState(() {
                    dsiPoliceStationCode = policeStationCode;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isFirDetailsVisible = false;
                        isGraphDetailsVisible = true; // Show FIR details
                      });
                      Navigator.pop(context);
                      _search();
                    },
                    child: const Text('Search'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

//graphFilter end
//graphDesign begin
  Widget _buildGraph(String title, List<Map<String, dynamic>> data) {
    int touchedIndex = -1;
    return Scaffold(
      body: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 300,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -10;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        sectionsSpace: 1,
                        centerSpaceRadius: 0,
                        startDegreeOffset: 180,
                        borderData: FlBorderData(show: false),
                        sections: List.generate(
                          data.length,
                          (i) {
                            final isTouched = i == touchedIndex;
                            final double radius = isTouched ? 150 : 140;
                            final sectionData = data[i];
                            return PieChartSectionData(
                              value: sectionData['value'].toDouble(),
                              title: '${sectionData['value']}',
                              radius: radius,
                              color: sectionData['color'],
                              titleStyle: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(color: Colors.black, blurRadius: 2)
                                ],
                              ),
                              borderSide: isTouched
                                  ? const BorderSide(
                                      color: Colors.white, width: 6)
                                  : BorderSide(color: Colors.transparent),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Header',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Total Count',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const Divider(),
                      ...data.map((section) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: section['color'],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        headDsiName = section['label'];
                                        isFirDetailsVisible = false;
                                        isGraphDetailsVisible = false;
                                      });
                                    },
                                    child: Text('${section['label']}'),
                                  ),
                                ],
                              ),
                              Text('${section['value']}'),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//graphDesign end
//graphPage Begin
  Widget _buildGraphSelector() {
    final graphs = [
      _buildGraph(
        'Total FIR $totalFIR\n(${_dateFromController.text} to ${_dateToController.text})',
        [
          {'label': 'Abetment to Suicide', 'value': 20, 'color': Colors.blue},
          {'label': 'Attempt to Murder', 'value': 30, 'color': Colors.red},
          {'label': 'Murder', 'value': 40, 'color': Colors.green},
          {'label': 'Accident', 'value': 10, 'color': Colors.orange},
          {
            'label': 'Abetment to Suicide',
            'value': 20,
            'color': const Color.fromARGB(255, 240, 243, 33)
          },
          {
            'label': 'Attempt to Murder',
            'value': 30,
            'color': const Color.fromARGB(255, 190, 54, 244)
          },
          {
            'label': 'Murder',
            'value': 40,
            'color': const Color.fromARGB(255, 78, 67, 2)
          },
          {
            'label': 'Accident',
            'value': 10,
            'color': const Color.fromARGB(255, 255, 0, 98)
          },
        ],
      ),
      _buildGraph(
        'Special Cases $specialCases\n(${_dateFromController.text} to ${_dateToController.text})',
        [
          {'label': 'Abetment to Suicide', 'value': 25, 'color': Colors.blue},
          {'label': 'Attempt to Murder', 'value': 35, 'color': Colors.red},
          {'label': 'Murder', 'value': 30, 'color': Colors.green},
          {'label': 'Accident', 'value': 10, 'color': Colors.orange},
        ],
      ),
      _buildGraph(
        'Total FIR\n(Current Year)',
        [
          {'label': 'Abetment to Suicide', 'value': 20, 'color': Colors.blue},
          {'label': 'Attempt to Murder', 'value': 25, 'color': Colors.red},
          {'label': 'Murder', 'value': 45, 'color': Colors.green},
          {'label': 'Accident', 'value': 10, 'color': Colors.orange},
        ],
      ),
      _buildGraph(
        'Special Cases\n(Current Year)',
        [
          {'label': 'Abetment to Suicide', 'value': 15, 'color': Colors.blue},
          {'label': 'Attempt to Murder', 'value': 35, 'color': Colors.red},
          {'label': 'Murder', 'value': 40, 'color': Colors.green},
          {'label': 'Accident', 'value': 10, 'color': Colors.orange},
        ],
      ),
    ];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                controller: _dateFromController,
                decoration: InputDecoration(
                  labelText: 'Date Range From',
                  prefixIcon: const Icon(Icons.calendar_month),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectfromDate(context);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _dateToController,
                decoration: InputDecoration(
                  labelText: 'Date Range To',
                  prefixIcon: const Icon(Icons.calendar_month),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selecttoDate(context);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DpPage(
          onDistrictSelected: (districtCode) {
            setState(() {
              dsiDistrictCode = districtCode;
            });
          },
          onPoliceStationSelected: (policeStationCode) {
            setState(() {
              dsiPoliceStationCode = policeStationCode;
            });
          },
        ),
        const SizedBox(height: 20),
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Total FIR'),
            Tab(text: 'Special Cases'),
            Tab(text: 'Total FIR'),
            Tab(text: 'Special Cases'),
          ],
        ),
        SizedBox(
          height: 650,
          child: TabBarView(
            controller: _tabController,
            children: graphs,
          ),
        ),
      ],
    );
  }
//graphPage end
//Graphical view end

/*----------------one content end------------------*/

/*----------------second content start------------------*/
//FIRDetailsView begin
  List<Map<String, String>> firDetailsList = [
    {
      "firNo": "12345",
      "firDate": "2023-01-01",
      "gdNo": "12345110",
      "district": "District A",
      "policeStation": "Police A",
      "ioName": "IO A",
    },
    {
      "firNo": "12346",
      "firDate": "2023-01-02",
      "gdNo": "12346111",
      "district": "District B",
      "policeStation": "Police B",
      "ioName": "IO B",
    },
    {
      "firNo": "12347",
      "firDate": "2023-01-03",
      "gdNo": "12347112",
      "district": "District A",
      "policeStation": "Police A",
      "ioName": "IO A",
    },
    {
      "firNo": "12348",
      "firDate": "2023-01-04",
      "gdNo": "12348113",
      "district": "District A",
      "policeStation": "Police A",
      "ioName": "IO A",
    },
    {
      "firNo": "12349",
      "firDate": "2023-01-05",
      "gdNo": "12349114",
      "district": "District A",
      "policeStation": "Police A",
      "ioName": "IO A",
    },
  ];
  List<Map<String, String>> filteredFirList = [];
  void _filterFirDetails() {
    setState(() {
      String firNum = firNumController.text.trim();
      if (firNum.isEmpty) {
        filteredFirList = firDetailsList;
      } else {
        filteredFirList =
            firDetailsList.where((fir) => fir["firNo"] == firNum).toList();
      }
    });
  }
//FIRFilter begin
  void _showFirDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Filter Options',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: firNumController,
                      decoration: InputDecoration(
                        labelText: 'FIR Number',
                        prefixIcon: const Icon(Icons.note),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateFirFromController,
                      decoration: InputDecoration(
                        labelText: 'Date Range From',
                        prefixIcon: const Icon(Icons.calendar_month),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      readOnly: true,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _selectfirfromDate(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _dateFirToController,
                      decoration: InputDecoration(
                        labelText: 'Date Range To',
                        prefixIcon: const Icon(Icons.calendar_month),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      readOnly: true,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _selectfirtoDate(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DpPage(
                onDistrictSelected: (districtCode) {
                  setState(() {
                    dsiFirDistrictCode = districtCode;
                  });
                },
                onPoliceStationSelected: (policeStationCode) {
                  setState(() {
                    dsiFirPoliceStationCode = policeStationCode;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _filterFirDetails();
                      setState(() {
                        isFirDetailsVisible = true;
                        isGraphDetailsVisible = false; // Show FIR details
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Search'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

//FIRFilter ends
//FIRDetails begins

  Widget _buildFirDetails() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: firNumController,
                decoration: InputDecoration(
                  labelText: 'FIR Number',
                  prefixIcon: const Icon(Icons.note),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) => _filterFirDetails(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _dateFirFromController,
                decoration: InputDecoration(
                  labelText: 'Date Range From',
                  prefixIcon: const Icon(Icons.calendar_month),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectfirfromDate(context);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _dateFirToController,
                decoration: InputDecoration(
                  labelText: 'Date Range To',
                  prefixIcon: const Icon(Icons.calendar_month),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectfirtoDate(context);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DpPage(
          onDistrictSelected: (districtCode) {
            setState(() {
              dsiFirDistrictCode = districtCode;
            });
          },
          onPoliceStationSelected: (policeStationCode) {
            setState(() {
              dsiFirPoliceStationCode = policeStationCode;
            });
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

//in these both widget function has same filter field if user enter FIR Number then only that FIR number details will display, in showFirDialog user enter the FIR Number and then press the search button to display that FIR number Details, and
//in buildFirDetails user type the FIR number and it will display the details of that FIR NUMBER
//FIRDetails end
//FIRViewPage begins
  Widget _buildFirList() {
    int startIndex = currentPage * itemsPerPage;
    int endIndex = (startIndex + itemsPerPage).clamp(0, firDetailsList.length);
    List<Map<String, String>> paginatedList =
        firDetailsList.sublist(startIndex, endIndex);

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics:
              NeverScrollableScrollPhysics(), // Prevents internal scrolling
          itemCount: paginatedList.length,
          itemBuilder: (context, index) {
            return buildDsiFirCard(paginatedList[index]);
          },
        ),
        const SizedBox(height: 10),
        _buildPaginationControls(),
      ],
    );
  }

  Widget _buildPaginationControls() {
    int totalPages = (firDetailsList.length / itemsPerPage).ceil();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: currentPage > 0
              ? () {
                  setState(() {
                    currentPage--;
                  });
                }
              : null,
        ),
        Text('Page ${currentPage + 1} of $totalPages'),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: currentPage < totalPages - 1
              ? () {
                  setState(() {
                    currentPage++;
                  });
                }
              : null,
        ),
      ],
    );
  }

  Widget buildDsiFirCard(Map<String, String> dsiFirItem) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FIR Details:-',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Table(
              border: TableBorder.all(color: Colors.black),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(3),
              },
              children: [
                _buildTableRow('FIR No.', dsiFirItem['firNo'] ?? '', 'FIR Date',
                    dsiFirItem['firDate'] ?? ''),
                _buildTableRow('GD No.', dsiFirItem['gdNo'] ?? '', 'GD Date',
                    dsiFirItem['gdDate'] ?? ''),
                _buildTableRow('District', dsiFirItem['district'] ?? '',
                    'Police Station', dsiFirItem['policeStation'] ?? ''),
                _buildTableRow('IO Name', dsiFirItem['ioName'] ?? '',
                    'IO Mobile', dsiFirItem['ioMobile'] ?? ''),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      showComplaintDetailsDialog(context);
                    },
                    child: Text('Complaint Details')),
                const SizedBox(width: 16),
                ElevatedButton(
                    onPressed: () {
                      showActSectionDetailsDialog(context);
                    },
                    child: Text('Fir Act and Section'))
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      showFirContentDetailsDialog(context);
                    },
                    child: Text('Fir Content')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showFirContentDetailsDialog(BuildContext context) {
    final Map<String, dynamic> dsiFirItem = {
      'FIR Content':
          ' GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest',
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'FIR Content:-',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: SingleChildScrollView(
                        child: _buildFirContentTable(dsiFirItem),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFirContentTable(Map<String, dynamic> dsiFirItem) {
    String content =
        dsiFirItem['FIR Content']?.toString() ?? 'No Data Available';

    Widget table = Table(
      border: TableBorder.all(color: Colors.black),
      columnWidths: const {0: FlexColumnWidth(1)},
      children: [
        _buildFirContentRow('Content', content),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: constraints.maxHeight > 600 ? 600 : double.infinity,
          ),
          child: SingleChildScrollView(
            physics: constraints.maxHeight > 600
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            child: IntrinsicHeight(
              child: table,
            ),
          ),
        );
      },
    );
  }

  TableRow _buildFirContentRow(String title, String content) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            content,
            textAlign: TextAlign.left,
            softWrap: true,
          ),
        ),
      ],
    );
  }

  void showComplaintDetailsDialog(BuildContext context) {
    final Map<String, dynamic> dsiFirItem = {
      'srNo': '001',
      'name': 'John Doe',
      'age': '30',
      'gen': 'Male',
      'rel': 'Father: David Doe',
      'add': '123 Main St, City, Country',
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Complainant Details:-',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Table(
                      border: TableBorder.all(color: Colors.black),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(3),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(3),
                      },
                      children: [
                        _buildHeaderRow('Sr.No.', dsiFirItem['srNo'] ?? '',
                            'Name', dsiFirItem['name'] ?? ''),
                        _buildHeaderRow('Age', dsiFirItem['age'] ?? '',
                            'Gender', dsiFirItem['gen'] ?? ''),
                        _buildHeaderRow(
                            'Relative Name',
                            dsiFirItem['rel'] ?? '',
                            'Address',
                            dsiFirItem['add'] ?? ''),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showActSectionDetailsDialog(BuildContext context) {
    final List<Map<String, dynamic>> dsiFirItems = List.generate(
      3, // Change this number to test different row counts
      (index) => {
        'srNo': '${index + 1}',
        'act': 'THE BHARATIYA NYAYA SANHITA (BNS), 2023',
        'section': '${200 + index}',
      },
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // ignore: unused_local_variable
                    double maxHeight = constraints.maxHeight * 0.7;
                    double tableHeight = dsiFirItems.length * 50;
                    bool isScrollable = tableHeight > 500;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'FIR Act and Section:-',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        isScrollable
                            ? SizedBox(
                                height: 500, // Restrict max height
                                child: SingleChildScrollView(
                                  child: _buildActSectionTable(dsiFirItems),
                                ),
                              )
                            : _buildActSectionTable(
                                dsiFirItems), // Show table without scrolling
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActSectionTable(List<Map<String, dynamic>> dsiFirItems) {
    return Table(
      border: TableBorder.all(color: Colors.black),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(2),
      },
      children: [
        _buildActSectionRow('Sr.No.', 'Act', 'Section'), // Header Row
        for (var item in dsiFirItems)
          _buildActSectionRow(item['srNo'], item['act'], item['section']),
      ],
    );
  }

  TableRow _buildActSectionRow(String srNo, String act, String section) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(srNo, textAlign: TextAlign.center),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(act, textAlign: TextAlign.center),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(section, textAlign: TextAlign.center),
      ),
    ]);
  }

  TableRow _buildHeaderRow(
      String key1, String value1, String key2, String value2) {
    return TableRow(
      children: [
        _buildTableCells(key1, isHeader: true),
        _buildTableCells(value1),
        _buildTableCells(key2, isHeader: true),
        _buildTableCells(value2),
      ],
    );
  }

  Widget _buildTableCells(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  TableRow _buildTableRow(
      String label1, String value1, String label2, String value2) {
    return TableRow(children: [
      _buildTableCell(label1, isBold: true),
      _buildTableCell(value1),
      _buildTableCell(label2, isBold: true),
      _buildTableCell(value2),
    ]);
  }

  Widget _buildTableCell(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style:
            TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
//FIRViewPage ends
//FIRDetailView ends

/* ---------------------second Content ends----------------------------- */

/* ---------------------third Content Starts----------------------------- */

//CrimeHeadViewPage Begins
//CrimeHeadFilter Starts

  void _showHeadDialog(
    BuildContext context,
    String? currentHeadCode,
    String? currentHeadName,
    String? currentDistrictCode,
    String? currentDistrictName,
    Function(String, String) onDistrictSelected,
    Function(String, String) onCrimeHeadSelected,
  ) {
    String? selectedHead = currentHeadCode; // Preserve current selection
    String? selectedHeadName = currentHeadName;
    String? selectedDistrictCode = currentDistrictCode;
    String? selectedDistrictName = currentDistrictName;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Filter Options',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedHead,
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'Crime Head',
                            prefixIcon: const Icon(Icons.list),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          items: headDescriptions.map((head) {
                            return DropdownMenuItem<String>(
                              value: head['codeId'],
                              child: Text(head['codeDesc']!),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setDialogState(() {
                                selectedHead = newValue;
                                selectedHeadName = headDescriptions.firstWhere(
                                  (head) => head['codeId'] == newValue,
                                  orElse: () => {'codeDesc': 'Unknown'},
                                )['codeDesc'];
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedDistrictCode, // Corrected variable
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'District',
                            prefixIcon: const Icon(Icons.list),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          items: districtDescriptions.map((district) {
                            return DropdownMenuItem<String>(
                              value: district['codeId'],
                              child: Text(district['codeDesc']!),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setDialogState(() {
                                selectedDistrictCode = newValue;
                                selectedDistrictName =
                                    districtDescriptions.firstWhere(
                                  (district) => district['codeId'] == newValue,
                                  orElse: () => {'codeDesc': 'Unknown'},
                                )['codeDesc'];
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _dateFirFromController,
                          decoration: InputDecoration(
                            labelText: 'Date Range From',
                            prefixIcon: const Icon(Icons.calendar_month),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          readOnly: true,
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _selectfirfromDate(context);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _dateFirToController,
                          decoration: InputDecoration(
                            labelText: 'Date Range To',
                            prefixIcon: const Icon(Icons.calendar_month),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          readOnly: true,
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _selectfirtoDate(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (selectedHead != null &&
                              selectedHeadName != null) {
                            onCrimeHeadSelected(
                                selectedHead!, selectedHeadName!);
                          }
                          if (selectedDistrictCode != null &&
                              selectedDistrictName != null) {
                            onDistrictSelected(
                                selectedDistrictCode!, selectedDistrictName!);
                          }
                          setState(() {
                            isFirDetailsVisible = false;
                            isGraphDetailsVisible = false;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Search'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeadSelector() {
    return Column(
      children: [
        TextField(
          enabled: false, // Makes the TextField non-editable
          decoration: InputDecoration(
            hintText: "Please tap to the text for changing the category",
            hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 13, // Set font size to 8
            ),
            prefixIcon: Icon(
              Icons.info, // Change to your preferred icon
              color: Colors.red,
            ),
          ),
        ),

        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _dateFirFromController,
                decoration: InputDecoration(
                  labelText: 'Date Range From',
                  prefixIcon: const Icon(Icons.calendar_month),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectfirfromDate(context);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _dateFirToController,
                decoration: InputDecoration(
                  labelText: 'Date Range To',
                  prefixIcon: const Icon(Icons.calendar_month),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectfirtoDate(context);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Crime Head and District Table
        Table(
          border: TableBorder.all(color: Colors.black, width: 2),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[100]),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Crime Head',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'District',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                GestureDetector(
                  onTap: () {
                    _showHeadDialog(
                      context,
                      headDsiCode,
                      headDsiName,
                      headDistrictCode,
                      headDistrictName,
                      (districtCode, districtName) {
                        headDistrictCode = districtCode;
                        headDistrictName = districtName;
                      },
                      (headCode, headName) {
                        headDsiCode = headCode;
                        headDsiName = headName;
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        headDsiName ?? "All",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showHeadDialog(
                      context,
                      headDsiCode,
                      headDsiName,
                      headDistrictCode,
                      headDistrictName,
                      (districtCode, districtName) {
                        headDistrictCode = districtCode;
                        headDistrictName = districtName;
                      },
                      (headCode, headName) {
                        headDsiCode = headCode;
                        headDsiName = headName;
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        headDistrictName ?? "Not Selected",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Total Count Table
        Table(
          border: TableBorder.all(color: Colors.black, width: 2),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[100]),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Total Count',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      '${getTotalCrimeCount()}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Divider(),
        const SizedBox(height: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: Text(
              'DSI Crime Head Police Station Wise Count', // Header text
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ]),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PoliceStation',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('TotalCount', style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),

        const SizedBox(height: 8),
        _buildHeadList(),
      ],
    );
  }

  Widget _buildHeadList() {
    List<Map<String, dynamic>> filteredList = getFilteredData();
    int startIndex = currentHeadPage * itemsHeadPerPage;
    int endIndex =
        (startIndex + itemsHeadPerPage).clamp(0, filteredList.length);
    List<Map<String, dynamic>> paginatedList =
        filteredList.sublist(startIndex, endIndex);

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: paginatedList.length,
          itemBuilder: (context, index) {
            return buildDsiHeadCard(paginatedList[index]);
          },
        ),
        const SizedBox(height: 10),
        _buildHeadPaginationControls(filteredList.length),
      ],
    );
  }

// Pagination controls
  Widget _buildHeadPaginationControls(int totalItems) {
    int totalPages = (totalItems / itemsHeadPerPage).ceil();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: currentHeadPage > 0
              ? () {
                  setState(() {
                    currentHeadPage--;
                  });
                }
              : null,
        ),
        Text('Page ${currentHeadPage + 1} of $totalPages'),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: currentHeadPage < totalPages - 1
              ? () {
                  setState(() {
                    currentHeadPage++;
                  });
                }
              : null,
        ),
      ],
    );
  }

// Function to build a card with two columns
  Widget buildDsiHeadCard(Map<String, dynamic> dsiHeadItem) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dsiHeadItem['PoliceStation'],
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(dsiHeadItem['TotalCount'].toString(),
                style: TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }
  // Widget buildDsiHeadCard(Map<String, dynamic> dsiHeadItem) {
  //   return Card(
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: DataTable(
  //         columnSpacing: 20, // Adjust spacing if needed
  //         headingRowHeight: 40, // Adjust heading height
  //         columns: [
  //           DataColumn(
  //               label: Text('Police Station',
  //                   style: TextStyle(fontWeight: FontWeight.bold))),
  //           DataColumn(
  //               label: Text('Total Count',
  //                   style: TextStyle(fontWeight: FontWeight.bold))),
  //         ],
  //         rows: [
  //           DataRow(cells: [
  //             DataCell(Text(dsiHeadItem['PoliceStation'] ?? 'N/A')),
  //             DataCell(Text(dsiHeadItem['TotalCount']?.toString() ?? '0',
  //                 style: TextStyle(color: Colors.blue))),
  //           ]),
  //         ],
  //       ),
  //     ),
  //   );
  // } // header will be avobe the card

//CrimeHeadDetails end
//CrimeHeadviewPage ends

/* ---------------------third Content ends----------------------------- */

/* ---------------------Main Content Starts----------------------------- */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DSI Dashboard',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 100, 233),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded,
                color: Colors.white, size: 30),
            onPressed: () => _showListDialog(context),
          ),
        ],
      ),
      drawer: PolAppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Conditional visibility
            if (isFirDetailsVisible) ...[
              _buildFirDetails(),
              _buildFirList(),
            ] else if (isGraphDetailsVisible) ...[
              _buildGraphSelector(),
            ] else ...[
              _buildHeadSelector(),
            ],
          ],
        ),
      ),
    );
  }

/* ---------------------Main Content Starts----------------------------- */
}
