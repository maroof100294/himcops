// import 'package:flutter/material.dart';
// import 'package:himcops/config.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class MajStateDistrictDynamicPage extends StatefulWidget {
//   final Function(String, String) onStateSelected;
//   final Function(String, String) onDistrictSelected;
//   final Function(String, String) onPoliceStationSelected;

//   const MajStateDistrictDynamicPage({
//     Key? key,
//     required this.onStateSelected,
//     required this.onDistrictSelected,
//     required this.onPoliceStationSelected,
//   }) : super(key: key);

//   @override
//   _MajStateDistrictDynamicPageState createState() =>
//       _MajStateDistrictDynamicPageState();
// }

// class _MajStateDistrictDynamicPageState
//     extends State<MajStateDistrictDynamicPage> {
//   List<Map<String, String>> states = [];
//   List<Map<String, String>> districts = [];
//   List<Map<String, String>> policeStations = [];

//   String? selectedStateCode;
//   String? selectedStateDesc;
//   String? selectedDistrictCode;
//   String? selectedDistrictDesc;
//   String? selectedPoliceCode;
//   String? selectedPoliceDesc;

//   @override
//   void initState() {
//     super.initState();
//     _fetchStates();
//   }

//   Future<void> _fetchStates() async {
//     final response = await http.get(Uri.parse('$baseUrl/androidapi/master/getStates'));
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       setState(() {
//         states = data
//             .map((item) => {'codeId': item['codeId'], 'codeDesc': item['codeDesc']})
//             .toList();
//       });
//     }
//   }

//   Future<void> _fetchDistricts(String stateCode) async {
//     final response = await http.get(Uri.parse('$baseUrl/androidapi/master/getDistricts?state=$stateCode'));
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       setState(() {
//         districts = data
//             .map((item) => {'codeId': item['codeId'], 'codeDesc': item['codeDesc']})
//             .toList();
//       });
//     }
//   }

//   Future<void> _fetchPoliceStations(String districtCode) async {
//     final response = await http.get(Uri.parse('$baseUrl/androidapi/master/getPoliceStations?district=$districtCode'));
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       setState(() {
//         policeStations = data
//             .map((item) => {'codeId': item['codeId'], 'codeDesc': item['codeDesc']})
//             .toList();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         DropdownButtonFormField<String>(
//           value: selectedStateDesc,
//           hint: const Text('Select State'),
//           items: states.map((state) {
//             return DropdownMenuItem(
//               value: state['codeDesc'],
//               child: Text(state['codeDesc']!),
//               onTap: () {
//                 selectedStateCode = state['codeId'];
//               },
//             );
//           }).toList(),
//           onChanged: (value) {
//             setState(() {
//               selectedStateDesc = value;
//               selectedDistrictDesc = null;
//               selectedPoliceDesc = null;
//               districts.clear();
//               policeStations.clear();
//             });
//             if (selectedStateCode != null) {
//               _fetchDistricts(selectedStateCode!);
//               widget.onStateSelected(selectedStateDesc!, selectedStateCode!);
//             }
//           },
//         ),
//         DropdownButtonFormField<String>(
//           value: selectedDistrictDesc,
//           hint: const Text('Select District'),
//           items: districts.map((district) {
//             return DropdownMenuItem(
//               value: district['codeDesc'],
//               child: Text(district['codeDesc']!),
//               onTap: () {
//                 selectedDistrictCode = district['codeId'];
//               },
//             );
//           }).toList(),
//           onChanged: (value) {
//             setState(() {
//               selectedDistrictDesc = value;
//               selectedPoliceDesc = null;
//               policeStations.clear();
//             });
//             if (selectedDistrictCode != null) {
//               _fetchPoliceStations(selectedDistrictCode!);
//               widget.onDistrictSelected(selectedDistrictDesc!, selectedDistrictCode!);
//             }
//           },
//         ),
//         DropdownButtonFormField<String>(
//           value: selectedPoliceDesc,
//           hint: const Text('Select Police Station'),
//           items: policeStations.map((ps) {
//             return DropdownMenuItem(
//               value: ps['codeDesc'],
//               child: Text(ps['codeDesc']!),
//               onTap: () {
//                 selectedPoliceCode = ps['codeId'];
//               },
//             );
//           }).toList(),
//           onChanged: (value) {
//             setState(() {
//               selectedPoliceDesc = value;
//             });
//             if (selectedPoliceCode != null) {
//               widget.onPoliceStationSelected(selectedPoliceDesc!, selectedPoliceCode!);
//             }
//           },
//         ),
//       ],
//     );
//   }
// }
