import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:himcops/authservice.dart';
import 'package:himcops/config.dart';
import 'package:himcops/controller/domestic_controller/dmvreqview.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/layout/formlayout.dart';
import 'package:himcops/pages/cgridhome.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:open_file/open_file.dart';

class DomesticHelpVerificationViewPage extends StatefulWidget {
  const DomesticHelpVerificationViewPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DomesticHelpVerificationViewPageState createState() =>
      _DomesticHelpVerificationViewPageState();
}

class _DomesticHelpVerificationViewPageState
    extends State<DomesticHelpVerificationViewPage> {
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController srnController = TextEditingController();
  String selectedStatus = 'Registered';
  String loginId = '';
  String? email; // replate it from loginid
  String firstname = '';
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
    // fetchPccData();
    _fetchEmp();
  }

  Future<void> _fetchLoginId() async {
    final String? storedLoginId = await _storage.read(key: 'loginId');
    final String? storedemail = await _storage.read(key: 'email');
    final String? storedfirstname = await _storage.read(key: 'firstname');
    final String? storedMobile2 = await _storage.read(key: 'mobile2');
    final String? storedfullName = await _storage.read(key: 'fullName');
    print(
        'loginId:$storedLoginId,firstname:$storedfirstname,mobile:$storedMobile2,fullname:$storedfullName, email:$storedemail');
    setState(() {
      loginId = storedLoginId ?? 'Unknown';
      firstname = storedfirstname ?? 'Unknown';
      mobile2 = storedMobile2 != null ? int.tryParse(storedMobile2) : null;
      fullName = storedfullName ?? 'Unknown';
      email = storedemail ?? 'unknown';
      print(
          'loginId:$loginId,firstname:$firstname,mobile:$mobile2,fullname:$fullName, email:$email');
    });
  }

  Future<void> _fetchEmp() async {
    final token = await AuthService.getAccessToken(); // Fetch the token

    if (token == null) {
      setState(() {
        // isLoading = false;
        // errorMessage = 'Failed to retrieve access token.';
      });
      _showErrorDialog('Technical Problem, Please Try again later');
      return;
    }

    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final client = IOClient(ioc);

      final fetchDomUrl =
          '$baseUrl/androidapi/mobile/service/searchAndViewStatusList';
      final fetchDomResponse = await client.post(
        Uri.parse(fetchDomUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"uid": loginId}),
      );

      if (fetchDomResponse.statusCode == 200) {
        final data = jsonDecode(fetchDomResponse.body);
        setState(() {
          pccList = List<Map<String, String>>.from(
            data['data'].map((item) {
              String status = item['serviceReqStatus']?.toString() ?? '';
              if (status == 'Approved' ||
                  status == 'Assigned' ||
                  status == 'SendBack' ||
                  status == 'SavedRecord' ||
                  status ==
                      'Verification Report Submitted By Enquiry Officer') {
                status = 'In Progress';
              }
              if (status == 'Rejected' || status == 'Completed') {
                status = 'Complete';
              }
              return {
                'serviceRequestNumber':
                    item['serviceRequestNo']?.toString() ?? '',
                'serviceDate': item['applicationDate']?.toString() ?? '',
                'applicantName': item['applicantName']?.toString() ?? '',
                'paymentStatus': status,
              };
            }),
          );
          statusCount = {
            'Registered': pccList
                .where((item) => item['paymentStatus'] == 'Registered')
                .length,
            'In Progress': pccList
                .where((item) => item['paymentStatus'] == 'In Progress')
                .length,
            'Complete': pccList
                .where((item) => item['paymentStatus'] == 'Complete')
                .length,
          };
        });
      } else {
        print('API failed to fetch data: ${fetchDomResponse.statusCode}');
        _showErrorDialog('Internet Connection Lost, Please check connection');
      }
    } catch (error) {
      print('Error occurred: $error');
      _showErrorDialog('Technical Server issue, Try again later');
    }
  }

  Future<void> _openView(String reqno) async {
    final token = await AuthService.getAccessToken(); // Fetch the token

    if (token == null) {
      setState(() {
        // isLoading = false;
        // errorMessage = 'Failed to retrieve access token.';
      });
      _showErrorDialog('Technical Problem, Please Try again later');
      return;
    }
    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final client = IOClient(ioc);

      final pdfUrl =
          '$baseUrl/androidapi/mobile/service/searchAndViewStatusDetails';
      final dhvPdfResponse = await client.post(
        Uri.parse(pdfUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"uid": "$loginId", "tempreqno": reqno}),
      );

      if (dhvPdfResponse.statusCode == 200) {
        final responseData = jsonDecode(dhvPdfResponse.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DhvReqViewPage(data: responseData),
          ),
        );
      }
    } catch (error) {
      print('Error occurred: $error');
      _showErrorDialog('Technical Server issue, Try again later');
    }
  }

  Future<void> _downloadPdf(String reqno) async {
    final token = await AuthService.getAccessToken(); // Fetch the token

    if (token == null) {
      setState(() {
        // isLoading = false;
        // errorMessage = 'Failed to retrieve access token.';
      });
      _showErrorDialog('Technical Problem, Please Try again later');
      return;
    }

    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final client = IOClient(ioc);

      final pdfUrl =
          '$baseUrl/androidapi/mobile/service/printDomesticVerification?uid=$loginId&domesticSrNo=$reqno';
      final pdfResponse = await client.get(
        Uri.parse(pdfUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': '*/*',
        },
      );
      print('PDF Response Status: ${pdfResponse.statusCode}');
      print('PDF Content-Type: ${pdfResponse.headers['content-type']}');
      print('Response Length: ${pdfResponse.bodyBytes.length}');

      if (pdfResponse.statusCode == 200) {
        if (pdfResponse.bodyBytes.isNotEmpty) {
          final directory = '/storage/emulated/0/Download';
          final filePath = '$directory/Domestic_verification_$reqno.pdf';

          // Step 4: Save the file
          final file = File(filePath);
          await file.writeAsBytes(pdfResponse.bodyBytes);
          print('File saved to: $filePath');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('PDF downloaded to $filePath')),
          );

          // Step 5: Open the file
          // OpenFilex.open(filePath);
          OpenFile.open(filePath);

        } else {
          print('Empty file response received.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to download: Empty file received')),
          );
        }
      } else {
        print('PDF API Error: ${pdfResponse.statusCode}, ${pdfResponse.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download PDF')),
        );
      }
    } catch (error) {
      print('Error occurred: $error');
      _showErrorDialog('Technical Server issue, Try again later');
    }
  }

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
            'Domestic Helper Verification Report',
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
                        SizedBox(width: 10),
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
                                if (selectedStatus == 'Complete') {
                                  return buildPccaCard(pccItem);
                                } else if ([
                                  'Registered',
                                  'In Progress',
                                ].contains(selectedStatus)) {
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
