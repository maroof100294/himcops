import 'package:flutter/material.dart';

import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/layout/headingstyle.dart';


class PoliceHomePage extends StatefulWidget {
  const PoliceHomePage({super.key});

  @override
  State<PoliceHomePage> createState() => _PoliceHomePageState();
}

class _PoliceHomePageState extends State<PoliceHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const Text(
                    'Himachal Pradesh',
                    style: AppTextStyles.headingStyle
                  ),
                  const Text(
                    'Police Service',
                    style: AppTextStyles.headingStyle
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Get Ready, Coming Soon',
                    style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 20),
                  /*OutlinedButton(
                    onPressed: () =>
                        showPoliceHomeDialog(context), // Show dialog on click
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3AC00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 20,
              right: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // if (showSOSOptions)...[
                  //   _buildSOSButton('112',Colors.blue, () => _makeCall('112')),
                  //   const SizedBox(height: 10),
                  // ],
                  FloatingActionButton(
                    onPressed:() {
                     Navigator.pushNamed(context, '/login'); //logout function api will add here
                    },
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.logout,color: Colors.white)
                    ),
                ],
              ),
            ),
            /*Positioned(
              bottom: 50,
              right: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // if (showSOSOptions)...[
                  //   _buildSOSButton('112',Colors.blue, () => _makeCall('112')),
                  //   const SizedBox(height: 10),
                  // ],
                  FloatingActionButton(
                    onPressed:() {
                     //Navigator.pushNamed(context, '/login'); //logout function api will add here
                    },
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: const Color.fromARGB(255, 244, 231, 54),
                    child: const Icon(Icons.language,color: Colors.white)
                    ),
                ],
              ),
            ),*/
        ],
      ),
    );
  }

  /*void showPoliceHomeDialog(BuildContext context) {
    bool _isServicesExpanded = false;
    bool _isStatusExpanded = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void _toggleDropdown(String type) {
              setState(() {
                if (type == 'Select Services') {
                  _isServicesExpanded = !_isServicesExpanded;
                  _isStatusExpanded = false;
                } else if (type == 'Search/View Services') {
                  _isStatusExpanded = !_isStatusExpanded;
                  _isServicesExpanded = false;
                }
              });
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor:
                  const Color(0xFFFFFFFF), // Dialog background color
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select the Services',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF133371),                                  
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDropdownCard(
                      'Select Services',
                      _isServicesExpanded,
                      () => _toggleDropdown('Select Services'),
                      [
                        'Domestic Help Verification',
                        'Employee Verification',
                        'Police Clearance Certificate'
                      ], // Add more list for Citizen Services if needed
                    ),
                    const SizedBox(height: 10),
                    _buildDropdownCard(
                      'Search/View Services',
                      _isStatusExpanded,
                      () => _toggleDropdown('Search/View Services'),
                      [
                        'Character Request Status'
                      ], // add more list here for Search/view Services if need
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }*/

  /*Widget _buildDropdownCard(
      String title, bool isExpanded, VoidCallback onTap, List<String> options) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.yellow, // Card background color
            child: ListTile(
              title: Text(title, style: const TextStyle(color: Colors.black)),
              leading: const Icon(Icons.assignment, color: Colors.black),
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
                              style: const TextStyle(color: Colors.black)),
                          tileColor: Colors.yellow,
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
  }*/

  // navigation based on selected subtitle

  /*void _navigateToService(String service) {
    if (service == 'Domestic Help Verification') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const DomesticHelpVerificationPage()));
    } else if (service == 'Employee Verification') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const EmployeeVerificationPage()));
    } else if (service == 'Police Clearance Certificate') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const PoliceClearanceCertificatePage()));
    } else if (service == 'Character Request Status') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const CharacterRequestStatusPage()));
    }
  }*/
}
