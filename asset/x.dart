// List<Map<String, String>> firDetailsList = [
//     {
//       "firNo": "12345",
//       "firDate": "2023-01-01",
//       "gdNo": "12345110",
//       "district": "District A",
//       "policeStation": "Police A",
//       "ioName": "IO A",
//     },
//     {
//       "firNo": "12346",
//       "firDate": "2023-01-02",
//       "gdNo": "12346111",
//       "district": "District B",
//       "policeStation": "Police B",
//       "ioName": "IO B",
//     },
//     {
//       "firNo": "12347",
//       "firDate": "2023-01-03",
//       "gdNo": "12347112",
//       "district": "District A",
//       "policeStation": "Police A",
//       "ioName": "IO A",
//     },
//     {
//       "firNo": "12348",
//       "firDate": "2023-01-04",
//       "gdNo": "12348113",
//       "district": "District A",
//       "policeStation": "Police A",
//       "ioName": "IO A",
//     },
//     {
//       "firNo": "12349",
//       "firDate": "2023-01-05",
//       "gdNo": "12349114",
//       "district": "District A",
//       "policeStation": "Police A",
//       "ioName": "IO A",
//     },
//   ];
//   List<Map<String, String>> filteredFirList = [];

// //FIRFilter begin
//   void _showFirDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const Text(
//                 'Filter Options',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: firNumController,
//                       decoration: InputDecoration(
//                         labelText: 'FIR Number',
//                         prefixIcon: const Icon(Icons.note),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: _dateFirFromController,
//                       decoration: InputDecoration(
//                         labelText: 'Date Range From',
//                         prefixIcon: const Icon(Icons.calendar_month),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       readOnly: true,
//                       onTap: () {
//                         FocusScope.of(context).requestFocus(FocusNode());
//                         _selectfirfromDate(context);
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: TextFormField(
//                       controller: _dateFirToController,
//                       decoration: InputDecoration(
//                         labelText: 'Date Range To',
//                         prefixIcon: const Icon(Icons.calendar_month),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       readOnly: true,
//                       onTap: () {
//                         FocusScope.of(context).requestFocus(FocusNode());
//                         _selectfirtoDate(context);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               PolDpPage(
//                 onDistrictSelected: (districtCode) {
//                   setState(() {
//                     dsiFirDistrictCode = districtCode;
//                   });
//                 },
//                 onPoliceStationSelected: (policeStationCode) {
//                   setState(() {
//                     dsiFirPoliceStationCode = policeStationCode;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
                
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         isFirDetailsVisible = true;
//                         isGraphDetailsVisible = false;
//                         filteredFirList = firDetailsList.where((fir) {
//                           bool matchesFirNo = firNumController.text.isEmpty ||
//                               fir['firNo'] == firNumController.text;

                          
//                           return matchesFirNo;
//                         }).toList();
//                       });

//                       Navigator.pop(context);
//                     },
//                     child: const Text('Search'),
//                   ),

//                   const SizedBox(width: 10),
//                   ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Close'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFirDetails() {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: TextFormField(
//                 controller: firNumController,
//                 decoration: InputDecoration(
//                   labelText: 'FIR Number',
//                   prefixIcon: const Icon(Icons.note),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Row(
//           children: [
//             Expanded(
//               child: TextFormField(
//                 controller: _dateFirFromController,
//                 decoration: InputDecoration(
//                   labelText: 'Date Range From',
//                   prefixIcon: const Icon(Icons.calendar_month),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 readOnly: true,
//                 onTap: () {
//                   FocusScope.of(context).requestFocus(FocusNode());
//                   _selectfirfromDate(context);
//                 },
//               ),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: TextFormField(
//                 controller: _dateFirToController,
//                 decoration: InputDecoration(
//                   labelText: 'Date Range To',
//                   prefixIcon: const Icon(Icons.calendar_month),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 readOnly: true,
//                 onTap: () {
//                   FocusScope.of(context).requestFocus(FocusNode());
//                   _selectfirtoDate(context);
//                 },
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         PolDpPage(
//           onDistrictSelected: (districtCode) {
//             setState(() {
//               dsiFirDistrictCode = districtCode;
//             });
//           },
//           onPoliceStationSelected: (policeStationCode) {
//             setState(() {
//               dsiFirPoliceStationCode = policeStationCode;
//             });
//           },
//         ),
//         const SizedBox(height: 20),
//       ],
//     );
//   }

//   Widget _buildFirList() {
//     int startIndex = currentPage * itemsPerPage;
//     int endIndex = (startIndex + itemsPerPage).clamp(0, filteredFirList.length);
//     List<Map<String, String>> paginatedList =
//         filteredFirList.sublist(startIndex, endIndex);

//     return Column(
//       children: [
//         ListView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: paginatedList.length,
//           itemBuilder: (context, index) {
//             return buildDsiFirCard(paginatedList[index]);
//           },
//         ),
//         const SizedBox(height: 10),
//         _buildPaginationControls(),
//       ],
//     );
//   }
// Widget _buildPaginationControls() {
//   int totalPages = (firDetailsList.length / itemsPerPage).ceil();

//   // Hide pagination controls when there's only one page
//   if (totalPages <= 1) return const SizedBox.shrink();

//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       IconButton(
//         icon: const Icon(Icons.arrow_back),
//         onPressed: currentPage > 0
//             ? () {
//                 setState(() {
//                   currentPage--;
//                 });
//               }
//             : null,
//       ),
//       Text('Page ${currentPage + 1} of $totalPages'),
//       IconButton(
//         icon: const Icon(Icons.arrow_forward),
//         onPressed: currentPage < totalPages - 1
//             ? () {
//                 setState(() {
//                   currentPage++;
//                 });
//               }
//             : null,
//       ),
//     ],
//   );
// }
//   Widget buildDsiFirCard(Map<String, String> dsiFirItem) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'FIR Details:-',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             const SizedBox(height: 10),
//             Table(
//               border: TableBorder.all(color: Colors.black),
//               columnWidths: const {
//                 0: FlexColumnWidth(2),
//                 1: FlexColumnWidth(3),
//                 2: FlexColumnWidth(2),
//                 3: FlexColumnWidth(3),
//               },
//               children: [
//                 _buildTableRow('FIR No.', dsiFirItem['firNo'] ?? '', 'FIR Date',
//                     dsiFirItem['firDate'] ?? ''),
//                 _buildTableRow('GD No.', dsiFirItem['gdNo'] ?? '', 'GD Date',
//                     dsiFirItem['gdDate'] ?? ''),
//                 _buildTableRow('District', dsiFirItem['district'] ?? '',
//                     'Police Station', dsiFirItem['policeStation'] ?? ''),
//                 _buildTableRow('IO Name', dsiFirItem['ioName'] ?? '',
//                     'IO Mobile', dsiFirItem['ioMobile'] ?? ''),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                     onPressed: () {
//                       showComplaintDetailsDialog(context);
//                     },
//                     child: Text('Complaint Details')),
//                 const SizedBox(width: 16),
//                 ElevatedButton(
//                     onPressed: () {
//                       showActSectionDetailsDialog(context);
//                     },
//                     child: Text('Fir Act and Section'))
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                     onPressed: () {
//                       showFirContentDetailsDialog(context);
//                     },
//                     child: Text('Fir Content')),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// here i want that when i search with FIR Number only fir details of that number should display and with that pagination will define or get disable