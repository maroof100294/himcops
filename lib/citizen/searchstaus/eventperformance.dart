import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:himcops/config.dart';
import 'package:himcops/controller/event_performance_controller/eventreqview.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/layout/formlayout.dart';
import 'package:himcops/pages/cgridhome.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';

class EventPerformanceStatusPage extends StatefulWidget {
  const EventPerformanceStatusPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EventPerformanceStatusPageState createState() =>
      _EventPerformanceStatusPageState();
}

class _EventPerformanceStatusPageState
    extends State<EventPerformanceStatusPage> {
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController srnController = TextEditingController();
  String selectedStatus = 'Registered';
  String loginId = '';
  String? email; // replate it from loginid
  String firstName = '';
  int? mobile2;
  String fullName = '';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  List<Map<String, String>> pccList = [];
  Map<String, int> statusCount = {};
  int currentPage = 0;
  int itemsPerPage = 3;
  DateTime? fromDate;
  DateTime? toDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchLoginId();
    fetchPccData();
  }

  Future<void> _fetchLoginId() async {
    final String? storedLoginId = await _storage.read(key: 'loginId');
    final String? storedemail = await _storage.read(key: 'email');
    final String? storedfirstName = await _storage.read(key: 'firstName');
    final String? storedMobile2 = await _storage.read(key: 'mobile2');
    print(
        'loginId:$storedLoginId,firstname:$storedfirstName,mobile:$storedMobile2, email:$storedemail');
    setState(() {
      loginId = storedLoginId ?? 'Unknown';
      firstName = storedfirstName ?? 'Unknown';
      mobile2 = storedMobile2 != null ? int.tryParse(storedMobile2) : null;
      email = storedemail ?? 'unknown';
      print(
          'loginId:$loginId,firstname:$firstName,mobile:$mobile2,email:$email');
    });
  }

  Future<void> fetchPccData() async {
    const url = '$baseUrl/androidapi/oauth/token';
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
        String accessToken = tokenData['access_token'];
        const fetchPccUrl =
            '$baseUrl/androidapi/mobile/service/getEventPerformanceStatusList';
        final fetchPccResponse = await client.post(
          Uri.parse(fetchPccUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode({
            "userName": "maroofchoudhury8367", //loginId,
          }),
        );

        if (fetchPccResponse.statusCode == 200) {
          final data = jsonDecode(fetchPccResponse.body);
          setState(() {
            pccList = List<Map<String, String>>.from(
              data['data'].map((item) {
                String status = item['requestStatus']?.toString() ?? '';
                if (status == 'Assigned' || status == 'Sent to e-district') {
                  status = 'In Progress';
                }
                if (status == 'Approved and Sent to Edistrict' ||
                    status == 'Approved') {
                  status = 'Complete';
                }
                return {
                  'serviceRequestNumber': item['eventSrNum']?.toString() ?? '',
                  'serviceDate': item['eventStartDtStrOut']?.toString() ?? '',
                  'applicantName': item['applicantName']?.toString() ?? '',
                  'paymentStatus': status,
                };
              }),
            );

            // Calculate status counts
            statusCount = {
              'Registered': pccList
                  .where((item) => item['paymentStatus'] == 'Registered')
                  .length,
              'In Progress': pccList
                  .where((item) => item['paymentStatus'] == 'In Progress')
                  .length,
              'Completed': pccList
                  .where((item) => item['paymentStatus'] == 'Completed')
                  .length,
            };
          });
        } else {
          print('API failed to fetch PCC data: ${fetchPccResponse.statusCode}');
          _showErrorDialog('Internet Connection Lost, Please check connection');
        }
      } else {
        print('API failed: ${response.statusCode}');
        _showErrorDialog('Technical Server issue, Try again later');
      }
    } catch (error) {
      print('Error occurred: $error');
      _showErrorDialog('Technical Server issue, Try again later');
    }
  }

  Future<void> _openView(String eventSrNum) async {
    const url = '$baseUrl/androidapi/oauth/token';
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
        String accessToken = tokenData['access_token'];

        final pdfUrl =
            '$baseUrl/androidapi/mobile/service/eventPeformViewDetails';
        final pccPdfResponse = await client.post(
          Uri.parse(pdfUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode({
            "userName": "maroofchoudhury8367", // loginId, 
            "eventSrNum": eventSrNum
          }), 
        );

        if (pccPdfResponse.statusCode == 200) {
          final responseData = jsonDecode(pccPdfResponse.body);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventReqViewPage(data: responseData),
            ),
          );
        } else {
          print('Failed to load PDF ${pccPdfResponse.statusCode}');
          _showErrorDialog('Technical Server issue, Try again later');
        }
      }
    } catch (error) {
      print('Error occurred: $error');
      _showErrorDialog('Technical Server issue, Try again later');
    }
  }

  Future<void> _downloadPdf(String eventSrNum) async {
    const url = '$baseUrl/androidapi/oauth/token';
    String credentials =
        'cctnsws:ea5be3a221d5761d0aab36bd13357b93-28920be3928b4a02611051d04a2dcef9-f1e961fadf11b03227fa71bc42a2a99a-8f3918bc211a5f27198b04cd92c9d8fe-bfa8eb4f98e1668fc608c4de2946541a';
    String basicAuth = 'Basic ${base64Encode(utf8.encode(credentials)).trim()}';

    try {
      // Step 1: Authenticate to get the token
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
        String accessToken = tokenData['access_token'];

        print('Access Token: $accessToken'); // Debugging token

        // Step 2: Fetch the PDF file
        final pdfUrl =
            '$baseUrl/androidapi/mobile/service/printModificationEvent?userName=$loginId&eventSrNo=$eventSrNum';
        print('Fetching PDF from: $pdfUrl'); // Debugging PDF URL

        final pdfResponse = await client.get(
          Uri.parse(pdfUrl),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': '*/*',
          },
        );

        print('PDF Response Status: ${pdfResponse.statusCode}');
        print('PDF Content-Type: ${pdfResponse.headers['content-type']}');
        print('Response Length: ${pdfResponse.bodyBytes.length}');

        if (pdfResponse.statusCode == 200) {
          if (pdfResponse.bodyBytes.isNotEmpty) {
            final directory = '/storage/emulated/0/Download';
            final filePath = '$directory/EventPerformanceRequest_$eventSrNum.pdf';
            final file = File(filePath);
            await file.writeAsBytes(pdfResponse.bodyBytes);
            print('File saved to: $filePath');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('PDF downloaded to $filePath')),
            );
            OpenFilex.open(filePath);
          } else {
            print('Empty file response received.');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Failed to download: Empty file received')),
            );
          }
        } else {
          print(
              'PDF API Error: ${pdfResponse.statusCode}, ${pdfResponse.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to download PDF')),
          );
        }
      } else {
        print(
            'Authentication failed: ${response.statusCode}, ${response.body}');
        _showErrorDialog('Technical Server issue, Try again later');
      }
    } catch (error) {
      print('Error occurred: $error');
      _showErrorDialog('Technical Server issue, Try again later');
    }
  }

  // here file is dowloading but in 0 bytes, but when i dowload it from postman file size is 45kb
  List<Map<String, String>> getFilteredList() {
    return pccList.where((item) {
      bool matchesStatus = item['paymentStatus'] == selectedStatus;
      bool matchesSrn = srnController.text.isEmpty ||
          item['serviceRequestNumber']?.contains(srnController.text) == true;

      bool matchesFromDate = fromDate == null ||
          tryParseDate(item['serviceDate'] ?? '').isAfter(fromDate!);
      bool matchesToDate = toDate == null ||
          tryParseDate(item['serviceDate'] ?? '').isBefore(toDate!);

      return matchesStatus && matchesSrn && matchesFromDate && matchesToDate;
    }).toList();
  }

  List<Map<String, String>> getPaginatedList() {
    var filteredList = getFilteredList();
    int startIndex = currentPage * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return filteredList.sublist(startIndex,
        endIndex > filteredList.length ? filteredList.length : endIndex);
  }

  bool get hasNextPage {
    var filteredList = getFilteredList();
    return (currentPage + 1) * itemsPerPage < filteredList.length;
  }

  bool get hasPreviousPage {
    return currentPage > 0;
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
    return WillPopScope(
      onWillPop: () async {
        bool shouldLogout = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CitizenGridPage()));
        return shouldLogout;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Event Performance Report',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
          backgroundColor: Color.fromARGB(255, 12, 100, 233),
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the menu icon color to white
          ),
        ),
        drawer: const AppDrawer(),
        body: Stack(
          children: [
            const BackgroundPage(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: myBoxDecoration(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedStatus,
                            decoration: InputDecoration(
                              labelText: 'Select Status',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedStatus = newValue!;
                                currentPage = 0;
                              });
                            },
                            items: statusCount.entries.map((entry) {
                              return DropdownMenuItem<String>(
                                value: entry.key,
                                child: Row(
                                  children: [
                                    Text('${entry.key} -'),
                                    const SizedBox(width: 10),
                                    Text(
                                      '${entry.value}',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: srnController,
                      decoration: InputDecoration(
                        labelText: 'Service Request Number',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: fromDateController,
                            decoration: InputDecoration(
                              labelText: 'From Date',
                              prefixIcon: const Icon(Icons.calendar_month),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _selectfromDate(context);
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: toDateController,
                            decoration: InputDecoration(
                              labelText: 'To Date',
                              prefixIcon: const Icon(Icons.calendar_month),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _selecttoDate(context);
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
                            setState(() {
                              currentPage = 0;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF133371),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'Search',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedStatus = 'Registered';
                              srnController.clear();
                              fromDateController.clear();
                              toDateController.clear();
                              fromDate = null;
                              toDate = null;
                              currentPage = 0;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: getFilteredList().isEmpty
                          ? const Center(
                              child: Text('No data available',
                                  style: TextStyle(fontSize: 18)))
                          : ListView.builder(
                              itemCount: getPaginatedList().length,
                              itemBuilder: (context, index) {
                                final pccItem = getPaginatedList()[index];

                                if (selectedStatus == 'Completed') {
                                  return buildPccaCard(pccItem);
                                } else if (['Registered', 'In Progress']
                                    .contains(selectedStatus)) {
                                  return buildPccvCard(pccItem);
                                } else {
                                  return Container();
                                }
                              },
                            ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: hasPreviousPage
                              ? () {
                                  setState(() {
                                    currentPage--;
                                  });
                                }
                              : null,
                          child: const Text('Previous'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: hasNextPage
                              ? () {
                                  setState(() {
                                    currentPage++;
                                  });
                                }
                              : null,
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPccaCard(Map<String, String> pccItem) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Service Request Number: ${pccItem['serviceRequestNumber']}"),
            Text("Applicant Name: ${pccItem['applicantName']}"),
            Text("Service Date: ${pccItem['serviceDate']}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: (!_isSubmitting)
                      ? () async {
                          setState(() {
                            _isSubmitting = true; // Disable the button
                          });

                          try {
                            await _downloadPdf(
                                pccItem['serviceRequestNumber'] ??
                                    ''); // Perform the registration logic
                          } finally {
                            setState(() {
                              _isSubmitting =
                                  false; // Re-enable the button after completion
                            });
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF133371),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'Download',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPccvCard(Map<String, String> pccItem) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Service Request Number: ${pccItem['serviceRequestNumber']}"),
            Text("Applicant Name: ${pccItem['applicantName']}"),
            Text("Service Date: ${pccItem['serviceDate']}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: (!_isSubmitting)
                      ? () async {
                          setState(() {
                            _isSubmitting = true; // Disable the button
                          });

                          try {
                            await _openView(pccItem['serviceRequestNumber'] ??
                                ''); // Perform the registration logic
                          } finally {
                            setState(() {
                              _isSubmitting =
                                  false; // Re-enable the button after completion
                            });
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF133371),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'View',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
        fromDateController.text = DateFormat('yyyy-MM-dd').format(picked);
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
        toDateController.text = DateFormat('yyyy-MM-dd').format(picked);
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
}
