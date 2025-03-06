// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:himcops/authservice.dart';
// import 'package:himcops/citizen/searchstaus/processionstatus.dart';
// import 'package:himcops/config.dart';
// import 'package:himcops/drawer/drawer.dart';
// import 'package:himcops/layout/buttonstyle.dart';
// import 'package:himcops/master/country.dart';
// import 'package:himcops/master/majcountry.dart';
// import 'package:himcops/master/majstatedistrict.dart';
// import 'package:himcops/master/sdp.dart';
// import 'package:himcops/pages/cgridhome.dart';
// import 'package:http/io_client.dart';
// import 'package:intl/intl.dart';

// class ProcessionVerificationPage extends StatefulWidget {

//   const ProcessionVerificationPage({
//     super.key,
//   });

//   @override
//   _ProcessionVerificationPageState createState() =>
//       _ProcessionVerificationPageState();
// }

// class _ProcessionVerificationPageState
//     extends State<ProcessionVerificationPage> {
//   final TextEditingController majorParticipantNameController =
//       TextEditingController();
//   final TextEditingController majorAddressController = TextEditingController();
//   final TextEditingController majorCountryController = TextEditingController();
//   final GlobalKey<FormState> _affidavitDetailsFormKey = GlobalKey<FormState>();
//   bool isAgree = false; // Checkbox state
//   bool _isSubmitting = false;
//   bool isChecked = false;
//   List<Map<String, String>> majorParticipants = [];

//   void _addParticipant() {
//     if (majorParticipantNameController.text.isNotEmpty &&
//         majorAddressController.text.isNotEmpty &&
//         selectedCountry != null) {
//       setState(() {
//         majorParticipants.add({
//           'name': majorParticipantNameController.text,
//           'address':
//               '${majorAddressController.text}', //,$selectedStateName,$selectedDistrictName,$selectedPoliceName,$selectedCountry
//         });

//         // Clear fields
//         majorParticipantNameController.clear();
//         majorAddressController.clear();
//         // majorCountryController.clear();
//         selectedCountry = 'INDIA';
//       });
//     }
//   }

//   void _updateCountry(String country) {
//     setState(() {
//       selectedCountry = country;
//     });
//   }

//   void _updateState(String? stateName) {
//     setState(() {
//       selectedStateName = stateName;
//     });
//   }

//   void _updateDistrict(String? districtName) {
//     setState(() {
//       selectedDistrictName = districtName;
//     });
//   }

//   void _updatePolice(String? policeStationName) {
//     setState(() {
//       selectedPoliceName = policeStationName;
//     });
//   }



//   Future<void> _registerUser() async {
//     final token = await AuthService.getAccessToken(); // Fetch the token

//     if (token == null) {
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Failed to retrieve access token.';
//       });
//       return;
//     }

//     try {
//       final ioc = HttpClient();
//       ioc.badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//       final client = IOClient(ioc);
//       final accountUrl =
//           '$baseUrl/androidapi/mobile/service/processionRequestRegistration';
//       final payloadBody = {
//         "processionMajorParticipantName": [majorParticipantNameController.text],
//         "processionMajorParticipantStatus": ["C"],
//         "processionMajorParticipantCountryCd": [80],
//         "processionMajorParticipantStateCd": [12],
//         "processionMajorParticipantDistrictCd": [12253],
//         "processionMajorParticipantVillage": [
//           "parti town post"
//         ],
//         "processionMajorParticipantPoliceStationCd": [12246002],
//       };
//       print('Request Body: \n${json.encode(payloadBody)}');

//       final accountResponse = await client.post(
//         Uri.parse(accountUrl),
//         body: json.encode(payloadBody),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (accountResponse.statusCode == 200) {
//         _showConfirmationDialog();

//       } else {
//         print('Failed to enter${accountResponse.body},$loginId,$mobile2');
//       }
//     } catch (e) {
//       setState(() {
//         print('Error occurred: $e ');
//       });
//     }
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Procession Request',
//           style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color.fromARGB(255, 255, 255, 255)),
//         ),
//         backgroundColor: Color.fromARGB(255, 12, 100, 233),
//         iconTheme: const IconThemeData(
//           color: Colors.white, // Set the menu icon color to white
//         ),
//       ),
//       drawer: const AppDrawer(),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _affidavitDetailsFormKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Expanded(
//                       child: Text(
//                         'Major Head Participant Details',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 14),
//                 TextFormField(
//                   controller: majorParticipantNameController,
//                   decoration: InputDecoration(
//                     labelText: 'Name of Major Participant',
//                     prefixIcon: const Icon(Icons.person),
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextFormField(
//                   controller: majorAddressController,
//                   decoration: InputDecoration(
//                     label: RichText(
//                       text: TextSpan(
//                         text: 'Address',
//                         style: TextStyle(
//                             color: Colors.black), // Normal label color
//                         children: [
//                           TextSpan(
//                             text: ' *',
//                             style:
//                                 TextStyle(color: Colors.red), // Red color for *
//                           ),
//                         ],
//                       ),
//                     ),
//                     prefixIcon: const Icon(Icons.home),
//                     filled: true,
//                     fillColor: Colors.white,
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(color: Colors.red),
//                     ),
//                   ),
//                   maxLines: 3,
//                 ),
//                 const SizedBox(height: 10),
//                 // Country selection
//                 MajCountryPage(
//                   controller: majorCountryController,
//                   enabled: true,
//                   onCountrySelected: _updateCountry, // Pass callback function
//                 ),
//                 const SizedBox(height: 10),

//                 MajStateDistrictDynamicPage(
//                   onStateSelected: _updateState,
//                   onDistrictSelected: _updateDistrict,
//                   onPoliceStationSelected: _updatePolice,
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: _addParticipant,
//                   child: const Text('Add Participant'),
//                 ),
//                 const SizedBox(height: 20),

//                 if (majorParticipants.isNotEmpty)
//                   Table(
//                     border: TableBorder.all(),
//                     columnWidths: const {
//                       0: FlexColumnWidth(2),
//                       1: FlexColumnWidth(4),
//                     },
//                     children: [
//                       TableRow(
//                         decoration: BoxDecoration(color: Colors.grey[300]),
//                         children: const [
//                           Padding(
//                               padding: EdgeInsets.all(8),
//                               child: Text('Name',
//                                   style:
//                                       TextStyle(fontWeight: FontWeight.bold))),
//                           Padding(
//                               padding: EdgeInsets.all(8),
//                               child: Text('Address',
//                                   style:
//                                       TextStyle(fontWeight: FontWeight.bold))),
//                         ],
//                       ),
//                       ...majorParticipants.map(
//                         (participant) => TableRow(
//                           children: [
//                             Padding(
//                                 padding: EdgeInsets.all(8),
//                                 child: Text(participant['name']!)),
//                             Padding(
//                                 padding: EdgeInsets.all(8),
//                                 child: Text(participant['address']!)),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Checkbox(
//                       value: isAgree,
//                       onChanged: (value) {
//                         setState(() {
//                           isAgree = value!;
//                         });
//                       },
//                     ),
//                     const Text(
//                         'All the information provided in the form is true'),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: (isAgree &&
//                           _affidavitDetailsFormKey.currentState!.validate() &&
//                           !_isSubmitting) // Check if not already submitting
//                       ? () async {
//                           setState(() {
//                             _isSubmitting = true; // Disable the button
//                           });

//                           try {
//                             await _registerUser(); // Perform the registration logic
//                           } finally {
//                             setState(() {
//                               _isSubmitting =
//                                   true; // Re-enable the button after completion
//                             });
//                           }
//                         }
//                       : null, // Disable button if checkbox is not checked, form is invalid, or already submitting
//                   style: AppButtonStyles.elevatedButtonStyle,
//                   child: _isSubmitting
//                       ? const CircularProgressIndicator(
//                           color: Colors.white) // Show a loader
//                       : const Text(
//                           'Submit',
//                           style: TextStyle(
//                               color: Colors.white, fontWeight: FontWeight.bold),
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// now like processionMajorParticipantName and processionMajorParticipantStatus i want also in processionMajorParticipantCountryCd for country processionMajorParticipantStateCd for state
// processionMajorParticipantDistrictCd for district ,processionMajorParticipantVillage for address and processionMajorParticipantPoliceStationCd for police station