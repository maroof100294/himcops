import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:himcops/citizen/searchstaus/characterstatus.dart';
import 'package:himcops/citizen/searchstaus/dmvviewpage.dart';
import 'package:himcops/citizen/searchstaus/empviewpage.dart';
import 'package:himcops/citizen/searchstaus/pccviewpage.dart';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/citizen/domestichelpverification.dart';
import 'package:himcops/citizen/employeeverification.dart';
import 'package:himcops/citizen/policeclearance.dart';
import 'package:himcops/layout/buttonstyle.dart';
import 'package:himcops/layout/headingstyle.dart';

class CitizenHomePage extends StatefulWidget {
  const CitizenHomePage({super.key});

  @override
  State<CitizenHomePage> createState() => _CitizenHomePageState();
}

class _CitizenHomePageState extends State<CitizenHomePage> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  String loginId = "Unknown";
  String firstName = "Unknown";
  String email = "Unknown";
  int mobile2 = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    String? storedLoginId = await _secureStorage.read(key: 'loginId');
    String? storedFirstName = await _secureStorage.read(key: 'firstName');
    String? storedEmail = await _secureStorage.read(key: 'email');
    final String? storedMobile2 = await _secureStorage.read(key: 'mobile2');

    setState(() {
      loginId = storedLoginId ?? "Unknown";
      firstName = storedFirstName ?? "Unknown";
      email = storedEmail ?? "Unknown";
      mobile2 = (storedMobile2 != null ? int.tryParse(storedMobile2) : 0)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldLogout = await _showLogoutDialog(context);
        return shouldLogout;
      },
      child: Scaffold(
        body: Stack(
          children: [
            const BackgroundPage(),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'asset/images/hp_logo.png',
                      height: 150,
                    ),
                    const SizedBox(height: 20),
                    const Text('Himachal Pradesh',
                        style: AppTextStyles.headingStyle),
                    const Text('Citizen Service',
                        style: AppTextStyles.headingStyle),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Welcome ',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          TextSpan(
                            text: firstName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(214, 252, 225, 185),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Please press continue to proceed with the services',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () =>
                          showCitizenHomeDialog(context), // Show dialog on click
                      style: AppButtonStyles.elevatedButtonStyle,
                      child: const Text(
                        'Continue',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: const Color.fromARGB(255, 147, 176, 235),
          tooltip: 'Please click to view the options',
          children: [
            SpeedDialChild(
              backgroundColor: Colors.red,
              labelBackgroundColor: Colors.grey,
              labelStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              child: const Icon(Icons.logout, color: Colors.white),
              label: 'Logout',
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showLogoutDialog(BuildContext context) async {
    bool shouldLogout = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Do you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                shouldLogout = false;
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                shouldLogout = true;
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
    return shouldLogout;
  }

  void showCitizenHomeDialog(BuildContext context) {
    bool isServicesExpanded = false;
    bool isStatusExpanded = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void toggleDropdown(String type) {
              setState(() {
                if (type == 'Services Form') {
                  isServicesExpanded = !isServicesExpanded;
                  isStatusExpanded = false;
                } else if (type == 'Services Status') {
                  isStatusExpanded = !isStatusExpanded;
                  isServicesExpanded = false;
                }
              });
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'asset/images/hp_logo.png',
                      height: 50,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Select the Services',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 243, 140, 5),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildDropdownCard(
                      'Services Form',
                      isServicesExpanded,
                      () => toggleDropdown('Services Form'),
                      [
                        'Police Clearance Certificate',
                        'Employee Verification',
                        'Domestic Help Verification',
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildDropdownCard(
                      'Services Status',
                      isStatusExpanded,
                      () => toggleDropdown('Services Status'),
                      [
                        'Character Request',
                        'Police Clearance Status',
                        'Employee Status',
                        'Domestic Help Status',
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdownCard(
      String title, bool isExpanded, VoidCallback onTap, List<String> options) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            color: const Color(0xFF133371),
            child: ListTile(
              title: Text(title,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255))),
              leading: const Icon(Icons.assignment,
                  color: Color.fromARGB(255, 255, 255, 255)),
              trailing: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onTap: onTap,
            ),
          ),
          if (isExpanded)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: options
                    .map((option) => ListTile(
                          title: Text(option,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0))),
                          tileColor: const Color(0xFF133371),
                          onTap: () {
                            _navigateToService(option);
                          },
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  void _navigateToService(String service) {
    if (service == 'Domestic Help Verification') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const DomesticHelpVerificationPage()));
    } else if (service == 'Employee Verification') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const EmployeeVerificationPage()));
    } else if (service == 'Police Clearance Certificate') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const PoliceClearanceCertificatePage()));
    } else if (service == 'Character Request') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CharacterRequestStatusPage()));
    } else if (service == 'Domestic Help Status') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const DomesticHelpVerificationViewPage()));
    } else if (service == 'Employee Status') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const EmployeeVerificationViewPage()));
    } else if (service == 'Police Clearance Status') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const PoliceClearanceCertificateViewPage()));
    }
  }
}
