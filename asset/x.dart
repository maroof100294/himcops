// List<Map<String, String>> filteredFirList = []; // Holds filtered FIR details

// void _filterFirDetails() {
//   setState(() {
//     String firNum = firNumController.text.trim();
//     if (firNum.isEmpty) {
//       filteredFirList = firDetailsList;
//     } else {
//       filteredFirList = firDetailsList.where((fir) => fir["firNo"] == firNum).toList();
//     }
//   });
// }

// void _showFirDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (context) => Dialog(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text(
//               'Filter Options',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 20),
//             TextFormField(
//               controller: firNumController,
//               decoration: InputDecoration(
//                 labelText: 'FIR Number',
//                 prefixIcon: const Icon(Icons.note),
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: _dateFirFromController,
//                     decoration: InputDecoration(
//                       labelText: 'Date Range From',
//                       prefixIcon: const Icon(Icons.calendar_month),
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     readOnly: true,
//                     onTap: () {
//                       FocusScope.of(context).requestFocus(FocusNode());
//                       _selectfirfromDate(context);
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: TextFormField(
//                     controller: _dateFirToController,
//                     decoration: InputDecoration(
//                       labelText: 'Date Range To',
//                       prefixIcon: const Icon(Icons.calendar_month),
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     readOnly: true,
//                     onTap: () {
//                       FocusScope.of(context).requestFocus(FocusNode());
//                       _selectfirtoDate(context);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             DpPage(
//               onDistrictSelected: (districtCode) {
//                 setState(() {
//                   dsiFirDistrictCode = districtCode;
//                 });
//               },
//               onPoliceStationSelected: (policeStationCode) {
//                 setState(() {
//                   dsiFirPoliceStationCode = policeStationCode;
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     _filterFirDetails(); // Apply the filter
//                     setState(() {
//                       isFirDetailsVisible = true;
//                       isGraphDetailsVisible = false; // Show FIR details
//                     });
//                     Navigator.pop(context);
//                   },
//                   child: const Text('Search'),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Close'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// Widget _buildFirDetails() {
//   return Column(
//     children: [
//       TextFormField(
//         controller: firNumController,
//         decoration: InputDecoration(
//           labelText: 'FIR Number',
//           prefixIcon: const Icon(Icons.note),
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         onChanged: (value) => _filterFirDetails(), // Filter as the user types
//       ),
//       const SizedBox(height: 10),
//       ...filteredFirList.map((fir) => Card(
//             child: ListTile(
//               title: Text("FIR No: ${fir['firNo']}"),
//               subtitle: Text("Date: ${fir['firDate']} | District: ${fir['district']}"),
//             ),
//           )),
//     ],
//   );
// }
