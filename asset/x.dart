// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:himcops/authservice.dart';
// // import 'package:himcops/config.dart';
// // import 'package:himcops/drawer/drawer.dart';
// // import 'package:himcops/layout/buttonstyle.dart';
// // import 'package:himcops/master/majcountry.dart';
// // import 'package:himcops/master/majstatedistrict.dart';
// // import 'package:himcops/pages/cgridhome.dart';
// // import 'package:http/io_client.dart';
// // class ProcessionVerificationPage extends StatefulWidget {
// //   const ProcessionVerificationPage({
// //     super.key,
// //   });
// //   @override
// //   _ProcessionVerificationPageState createState() =>
// //       _ProcessionVerificationPageState();
// // }
// // class _ProcessionVerificationPageState
// //     extends State<ProcessionVerificationPage> {
// //   final TextEditingController majorParticipantNameController =
// //       TextEditingController();
// //   final TextEditingController majorAddressController = TextEditingController();
// //   final TextEditingController majorCountryController = TextEditingController();
// //   final GlobalKey<FormState> _affidavitDetailsFormKey = GlobalKey<FormState>();
// //   bool isAgree = false; // Checkbox state
// //   bool _isSubmitting = false;
// //   bool isChecked = false;
// //   String? majStateCode;
// //   String? majDistrictCode;
// //   String? majPoliceStationCode;
// //   String? selectedCountry = 'INDIA';
// //   String? selectedStateName;
// //   String? selectedDistrictName;
// //   String? selectedPoliceName; // Default selected country is India
// //   List<Map<String, String>> majorParticipants = [];
// //   void _addParticipant() {
// //     if (majorParticipantNameController.text.isNotEmpty &&
// //         majorAddressController.text.isNotEmpty &&
// //         selectedCountry != null) {
// //       setState(() {
// //         majorParticipants.add({
// //           'name': majorParticipantNameController.text,
// //           'address': '${majorAddressController.text}',
// //           'state': '$selectedStateName',
// //           'district': '$selectedDistrictName',
// //           'ps': '$selectedPoliceName'
// //         });
// //         majorParticipantNameController.clear();
// //         majorAddressController.clear();
// //         selectedCountry = 'INDIA';
// //       });
// //     }
// //   }

// //   void _updateCountry(String country) {
// //     setState(() {
// //       selectedCountry = country;
// //     });
// //   }

// //   void _updateState(String? stateName) {
// //     setState(() {
// //       selectedStateName = stateName;
// //     });
// //   }

// //   void _updateDistrict(String? districtName) {
// //     setState(() {
// //       selectedDistrictName = districtName;
// //     });
// //   }

// //   void _updatePolice(String? policeStationName) {
// //     setState(() {
// //       selectedPoliceName = policeStationName;
// //     });
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //   }

// //   Future<void> _registerUser() async {
// //     final token = await AuthService.getAccessToken(); // Fetch the token

// //     if (token == null) {
// //       return;
// //     }
// //     try {
// //       final ioc = HttpClient();
// //       ioc.badCertificateCallback =
// //           (X509Certificate cert, String host, int port) => true;
// //       final client = IOClient(ioc);
// //       final accountUrl =
// //           '$baseUrl/androidapi/mobile/service/processionRequestRegistration';
// //       List<String> participantNames =
// //           majorParticipants.map((participant) => participant['name']!).toList();
// //       List<String> participantAddress = majorParticipants
// //           .map((participant) => participant['address']!)
// //           .toList();
// //       List<String> participantState = majorParticipants
// //           .map((participant) => participant['state']!)
// //           .toList();
// //       List<String> participantDistrict = majorParticipants
// //           .map((participant) => participant['district']!)
// //           .toList();
// //       List<String> participantPs =
// //           majorParticipants.map((participant) => participant['ps']!).toList();
// //       final payloadBody = {
// //         "processionMajorParticipantName": participantNames, // Send all names
// //         "processionMajorParticipantStatus":
// //             List.filled(participantNames.length, "C"),
// //         "processionMajorParticipantCountryCd":
// //             List.filled(participantNames.length, "80"),
// //         "processionMajorParticipantStateCd":
// //             // participantState,
// //             List.filled(participantNames.length, selectedStateName),
// //         "processionMajorParticipantDistrictCd":
// //             // participantDistrict,
// //             List.filled(participantNames.length, selectedDistrictName),
// //         "processionMajorParticipantVillage": participantAddress,
// //         "processionMajorParticipantPoliceStationCd":
// //             // participantPs,
// //             List.filled(participantNames.length, selectedPoliceName),
// //       };
// //       final accountResponse = await client.post(
// //         Uri.parse(accountUrl),
// //         body: json.encode(payloadBody),
// //         headers: {
// //           'Content-Type': 'application/json',
// //           'Authorization': 'Bearer $token',
// //         },
// //       );
// //       if (accountResponse.statusCode == 200) {
// //       } else {}
// //     } catch (e) {
// //       setState(() {});
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return WillPopScope(
// //       onWillPop: () async {
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (context) => const CitizenGridPage()),
// //         );
// //         return false; // Prevent default back navigation
// //       },
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: const Text(
// //             'Procession Request',
// //             style: TextStyle(
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.bold,
// //                 color: Color.fromARGB(255, 255, 255, 255)),
// //           ),
// //           backgroundColor: Color.fromARGB(255, 12, 100, 233),
// //           iconTheme: const IconThemeData(
// //             color: Colors.white, // Set the menu icon color to white
// //           ),
// //         ),
// //         drawer: const AppDrawer(),
// //         body: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: SingleChildScrollView(
// //             child: Form(
// //               key: _affidavitDetailsFormKey,
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   const Text('Please Fill the Mandatory Details first',
// //                       style: TextStyle(
// //                           fontSize: 14,
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.red)),
// //                   const SizedBox(height: 20),
// //                   Row(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const Expanded(
// //                         child: Text(
// //                           'Major Head Participant Details',
// //                           style: TextStyle(fontWeight: FontWeight.bold),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 14),
// //                   TextFormField(
// //                     controller: majorParticipantNameController,
// //                     decoration: InputDecoration(
// //                       labelText: 'Name of Major Participant',
// //                       prefixIcon: const Icon(Icons.person),
// //                       filled: true,
// //                       fillColor: Colors.white,
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 10),
// //                   TextFormField(
// //                     controller: majorAddressController,
// //                     decoration: InputDecoration(
// //                       label: RichText(
// //                         text: TextSpan(
// //                           text: 'Address',
// //                           style: TextStyle(
// //                               color: Colors.black), // Normal label color
// //                           children: [
// //                             TextSpan(
// //                               text: ' *',
// //                               style: TextStyle(
// //                                   color: Colors.red), // Red color for *
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       prefixIcon: const Icon(Icons.home),
// //                       filled: true,
// //                       fillColor: Colors.white,
// //                       enabledBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                       focusedBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(10),
// //                         borderSide: BorderSide(color: Colors.red),
// //                       ),
// //                     ),
// //                     maxLines: 3,
// //                   ),
// //                   const SizedBox(height: 10),

// //                   // Country selection
// //                   MajCountryPage(
// //                     controller: majorCountryController,
// //                     enabled: true,
// //                     onCountrySelected: _updateCountry, // Pass callback function
// //                   ),
// //                   const SizedBox(height: 10),
// //                   MajStateDistrictDynamicPage(
// //                     onStateSelected: _updateState,
// //                     onDistrictSelected: _updateDistrict,
// //                     onPoliceStationSelected: _updatePolice,
// //                   ),
// //                   if (selectedStateName != null)
// //                     Padding(
// //                       padding: const EdgeInsets.only(top: 8.0),
// //                       child: Text(
// //                         'Selected State: $selectedStateName',
// //                         style: const TextStyle(fontWeight: FontWeight.bold),
// //                       ),
// //                     ),
// //                   if (selectedDistrictName != null)
// //                     Padding(
// //                       padding: const EdgeInsets.only(top: 8.0),
// //                       child: Text(
// //                         'Selected District: $selectedDistrictName',
// //                         style: const TextStyle(fontWeight: FontWeight.bold),
// //                       ),
// //                     ),
// //                   if (selectedPoliceName != null)
// //                     Padding(
// //                       padding: const EdgeInsets.only(top: 8.0),
// //                       child: Text(
// //                         'Selected Police Station: $selectedPoliceName',
// //                         style: const TextStyle(fontWeight: FontWeight.bold),
// //                       ),
// //                     ),
// //                   const SizedBox(height: 10),
// //                   ElevatedButton(
// //                     onPressed: _addParticipant,
// //                     child: const Text('Add Participant'),
// //                   ),
// //                   const SizedBox(height: 20),

// //                   if (majorParticipants.isNotEmpty)
// //                     Table(
// //                       border: TableBorder.all(),
// //                       columnWidths: const {
// //                         0: FlexColumnWidth(1),
// //                         1: FlexColumnWidth(1),
// //                         2: FlexColumnWidth(1),
// //                         3: FlexColumnWidth(1),
// //                         4: FlexColumnWidth(1),
// //                       },
// //                       children: [
// //                         TableRow(
// //                           decoration: BoxDecoration(color: Colors.grey[300]),
// //                           children: const [
// //                             Padding(
// //                                 padding: EdgeInsets.all(8),
// //                                 child: Text('Name',
// //                                     style: TextStyle(
// //                                         fontWeight: FontWeight.bold))),
// //                             Padding(
// //                                 padding: EdgeInsets.all(8),
// //                                 child: Text('Address',
// //                                     style: TextStyle(
// //                                         fontWeight: FontWeight.bold))),
// //                             Padding(
// //                                 padding: EdgeInsets.all(8),
// //                                 child: Text('State',
// //                                     style: TextStyle(
// //                                         fontWeight: FontWeight.bold))),
// //                             Padding(
// //                                 padding: EdgeInsets.all(8),
// //                                 child: Text('District',
// //                                     style: TextStyle(
// //                                         fontWeight: FontWeight.bold))),
// //                             Padding(
// //                                 padding: EdgeInsets.all(8),
// //                                 child: Text('PS',
// //                                     style: TextStyle(
// //                                         fontWeight: FontWeight.bold))),
// //                           ],
// //                         ),
// //                         ...majorParticipants.map(
// //                           (participant) => TableRow(
// //                             children: [
// //                               Padding(
// //                                   padding: EdgeInsets.all(8),
// //                                   child: Text(participant['name']!)),
// //                               Padding(
// //                                   padding: EdgeInsets.all(8),
// //                                   child: Text(participant['address']!)),
// //                               Padding(
// //                                   padding: EdgeInsets.all(8),
// //                                   child: Text(participant['state']!)),
// //                               Padding(
// //                                   padding: EdgeInsets.all(8),
// //                                   child: Text(participant['district']!)),
// //                               Padding(
// //                                   padding: EdgeInsets.all(8),
// //                                   child: Text(participant['ps']!)),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   Row(
// //                     children: [
// //                       Checkbox(
// //                         value: isAgree,
// //                         onChanged: (value) {
// //                           setState(() {
// //                             isAgree = value!;
// //                           });
// //                         },
// //                       ),
// //                       const Text(
// //                           'All the information provided in the form is true'),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 20),
// //                   ElevatedButton(
// //                     onPressed: (isAgree &&
// //                             _affidavitDetailsFormKey.currentState!.validate() &&
// //                             !_isSubmitting) // Check if not already submitting
// //                         ? () async {
// //                             setState(() {
// //                               _isSubmitting = true; // Disable the button
// //                             });

// //                             try {
// //                               await _registerUser(); // Perform the registration logic
// //                             } finally {
// //                               setState(() {
// //                                 _isSubmitting =
// //                                     true; // Re-enable the button after completion
// //                               });
// //                             }
// //                           }
// //                         : null, // Disable button if checkbox is not checked, form is invalid, or already submitting
// //                     style: AppButtonStyles.elevatedButtonStyle,
// //                     child: _isSubmitting
// //                         ? const CircularProgressIndicator(
// //                             color: Colors.white) // Show a loader
// //                         : const Text(
// //                             'Submit',
// //                             style: TextStyle(
// //                                 color: Colors.white,
// //                                 fontWeight: FontWeight.bold),
// //                           ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// // // Here From MajStateDistrictDynamicPage selectedStateName, selectedDistrictName, selectedPoliceName, is giving codeId here
// // /* if (selectedStateName != null)
// //                     Padding(
// //                       padding: const EdgeInsets.only(top: 8.0),
// //                       child: Text(
// //                         'Selected State: $selectedStateName',
// //                         style: const TextStyle(fontWeight: FontWeight.bold),
// //                       ),
// //                     ),
// //                   if (selectedDistrictName != null)
// //                     Padding(
// //                       padding: const EdgeInsets.only(top: 8.0),
// //                       child: Text(
// //                         'Selected District: $selectedDistrictName',
// //                         style: const TextStyle(fontWeight: FontWeight.bold),
// //                       ),
// //                     ),
// //                   if (selectedPoliceName != null)
// //                     Padding(
// //                       padding: const EdgeInsets.only(top: 8.0),
// //                       child: Text(
// //                         'Selected Police Station: $selectedPoliceName',
// //                         style: const TextStyle(fontWeight: FontWeight.bold),
// //                       ),
// //                     ),
// //           but i want codeDesc here  and codeId in API Json body
// //           Please give me modified code of ProcessionVerificationPage and MajStateDistrictDynamicPage
// // */ 



// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:himcops/authservice.dart';
// import 'package:himcops/config.dart';
// import 'package:himcops/drawer/drawer.dart';
// import 'package:himcops/master/majstatedistrict.dart';
// import 'package:http/io_client.dart';

// class ProcessionVerificationPage extends StatefulWidget {
//   const ProcessionVerificationPage({super.key});

//   @override
//   _ProcessionVerificationPageState createState() =>
//       _ProcessionVerificationPageState();
// }

// class _ProcessionVerificationPageState extends State<ProcessionVerificationPage> {
//   final TextEditingController majorParticipantNameController = TextEditingController();
//   final TextEditingController majorAddressController = TextEditingController();
//   final GlobalKey<FormState> _affidavitDetailsFormKey = GlobalKey<FormState>();
  
//   bool _isSubmitting = false;

//   String? selectedStateCode;
//   String? selectedStateDesc;
//   String? selectedDistrictCode;
//   String? selectedDistrictDesc;
//   String? selectedPoliceCode;
//   String? selectedPoliceDesc;

//   List<Map<String, String>> majorParticipants = [];

//   void _addParticipant() {
//     if (majorParticipantNameController.text.isNotEmpty &&
//         majorAddressController.text.isNotEmpty) {
//       setState(() {
//         majorParticipants.add({
//           'name': majorParticipantNameController.text,
//           'address': majorAddressController.text,
//           'state': selectedStateDesc ?? '',
//           'stateCode': selectedStateCode ?? '',
//           'district': selectedDistrictDesc ?? '',
//           'districtCode': selectedDistrictCode ?? '',
//           'ps': selectedPoliceDesc ?? '',
//           'psCode': selectedPoliceCode ?? ''
//         });
//         majorParticipantNameController.clear();
//         majorAddressController.clear();
//       });
//     }
//   }

//   Future<void> _registerUser() async {
//     final token = await AuthService.getAccessToken();
//     if (token == null) return;

//     try {
//       final ioc = HttpClient();
//       ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//       final client = IOClient(ioc);

//       final accountUrl = '$baseUrl/androidapi/mobile/service/processionRequestRegistration';

//       final payloadBody = {
//         "processionMajorParticipantName": majorParticipants.map((p) => p['name']).toList(),
//         "processionMajorParticipantStatus": List.filled(majorParticipants.length, "C"),
//         "processionMajorParticipantCountryCd": List.filled(majorParticipants.length, "80"),
//         "processionMajorParticipantStateCd": majorParticipants.map((p) => p['stateCode']).toList(),
//         "processionMajorParticipantDistrictCd": majorParticipants.map((p) => p['districtCode']).toList(),
//         "processionMajorParticipantVillage": majorParticipants.map((p) => p['address']).toList(),
//         "processionMajorParticipantPoliceStationCd": majorParticipants.map((p) => p['psCode']).toList(),
//       };

//       await client.post(
//         Uri.parse(accountUrl),
//         body: json.encode(payloadBody),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//     } catch (e) {
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Procession Request'),
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
//                 TextFormField(
//                   controller: majorParticipantNameController,
//                   decoration: InputDecoration(labelText: 'Participant Name'),
//                 ),
//                 TextFormField(
//                   controller: majorAddressController,
//                   decoration: InputDecoration(labelText: 'Address'),
//                   maxLines: 3,
//                 ),
//                 MajStateDistrictDynamicPage(
//                   onStateSelected: (desc, code) {
//                     setState(() {
//                       selectedStateDesc = desc;
//                       selectedStateCode = code;
//                     });
//                   },
//                   onDistrictSelected: (desc, code) {
//                     setState(() {
//                       selectedDistrictDesc = desc;
//                       selectedDistrictCode = code;
//                     });
//                   },
//                   onPoliceStationSelected: (desc, code) {
//                     setState(() {
//                       selectedPoliceDesc = desc;
//                       selectedPoliceCode = code;
//                     });
//                   },
//                 ),
//                 ElevatedButton(
//                   onPressed: _addParticipant,
//                   child: const Text('Add Participant'),
//                 ),
//                 if (majorParticipants.isNotEmpty)
//                   Table(
//                     border: TableBorder.all(),
//                     columnWidths: const {
//                       0: FlexColumnWidth(2),
//                       1: FlexColumnWidth(2),
//                       2: FlexColumnWidth(1),
//                       3: FlexColumnWidth(1),
//                       4: FlexColumnWidth(1),
//                     },
//                     children: [
//                       TableRow(
//                         decoration: BoxDecoration(color: Colors.grey[300]),
//                         children: const [
//                           Padding(padding: EdgeInsets.all(8), child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
//                           Padding(padding: EdgeInsets.all(8), child: Text('Address', style: TextStyle(fontWeight: FontWeight.bold))),
//                           Padding(padding: EdgeInsets.all(8), child: Text('State', style: TextStyle(fontWeight: FontWeight.bold))),
//                           Padding(padding: EdgeInsets.all(8), child: Text('District', style: TextStyle(fontWeight: FontWeight.bold))),
//                           Padding(padding: EdgeInsets.all(8), child: Text('PS', style: TextStyle(fontWeight: FontWeight.bold))),
//                         ],
//                       ),
//                       ...majorParticipants.map(
//                         (participant) => TableRow(
//                           children: [
//                             Padding(padding: EdgeInsets.all(8), child: Text(participant['name']!)),
//                             Padding(padding: EdgeInsets.all(8), child: Text(participant['address']!)),
//                             Padding(padding: EdgeInsets.all(8), child: Text(participant['state']!)),
//                             Padding(padding: EdgeInsets.all(8), child: Text(participant['district']!)),
//                             Padding(padding: EdgeInsets.all(8), child: Text(participant['ps']!)),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ElevatedButton(
//                   onPressed: _registerUser,
//                   child: _isSubmitting ? const CircularProgressIndicator() : const Text('Submit'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
