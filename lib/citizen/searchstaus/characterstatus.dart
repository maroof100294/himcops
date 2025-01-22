import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:himcops/config.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/layout/formlayout.dart';
import 'package:himcops/pages/cgridhome.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart';

class CharacterRequestStatusPage extends StatefulWidget {
  const CharacterRequestStatusPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CharacterRequestStatusPageState createState() =>
      _CharacterRequestStatusPageState();
}

class _CharacterRequestStatusPageState
    extends State<CharacterRequestStatusPage> {
  final TextEditingController srnController = TextEditingController();
  String? statusMessage;
  String loginId = '';
  String? email; 
  String firstname = '';
  int? mobile2;
  String fullName = '';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchLoginId();
    // fetchPccData();
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

  Future<void> fetchPccData() async {
    final url = '$baseUrl/androidapi/oauth/token';
    String credentials =
        'cctnsws:ea5be3a221d5761d0aab36bd13357b93-28920be3928b4a02611051d04a2dcef9-f1e961fadf11b03227fa71bc42a2a99a-8f3918bc211a5f27198b04cd92c9d8fe-bfa8eb4f98e1668fc608c4de2946541a';
    String basicAuth = 'Basic ${base64Encode(utf8.encode(credentials)).trim()}';

    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(ioc);
      // Get access token
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
        final fetchPccUrl =
            '$baseUrl/androidapi/mobile/service/viewCharacterStatus?applicationNo=${srnController.text}';
        final fetchEmpResponse = await client.get(
          Uri.parse(fetchPccUrl),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (fetchEmpResponse.statusCode == 200) {
          setState(() {
            statusMessage =
                'Appliction Number: ${srnController.text}\nStatus:\n${fetchEmpResponse.body}';
          });
          showCharacterRequestStatus('$statusMessage');
        } else {
          setState(() {
            statusMessage =
                'No record found for applicationNo: ${srnController.text}';
          });
          showCharacterRequestStatus('$statusMessage');
        }
      } else {
        setState(() {
          statusMessage = 'Internet Connection Slow, Please check your connection';
        });
      }
    } catch (error) {
      setState(() {
        statusMessage = 'Technical Problem, Please Try again later';
      });
    }
  }

  void showCharacterRequestStatus(String statusMessage) {
    showDialog(
      context: context,
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
              const SizedBox(height: 10),
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                statusMessage,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  srnController.clear();
                });
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFF3AC00),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
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
            'Character Request Status',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
          backgroundColor: Color.fromARGB(255, 12, 100, 233),
          iconTheme: const IconThemeData(
            color: Colors.white,
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
                    Row(children: [
                      ElevatedButton(
                        onPressed: fetchPccData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF133371),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'Know your Status',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// when i click back button its exit the app if i open this from CitizenGridPage, it should go to the same page