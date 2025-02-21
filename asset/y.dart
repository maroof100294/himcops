// //graphFilter begin
//   void _showGraphDialog(BuildContext context) {
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
//                       controller: _dateFromController,
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
//                         _selectfromDate(context);
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: TextFormField(
//                       controller: _dateToController,
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
//                         _selecttoDate(context);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               PolDpPage(
//                 onDistrictSelected: (districtCode) {
//                   setState(() {
//                     dsiDistrictCode = districtCode;
//                   });
//                 },
//                 onPoliceStationSelected: (policeStationCode) {
//                   setState(() {
//                     dsiPoliceStationCode = policeStationCode;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         isFirDetailsVisible = false;
//                         isGraphDetailsVisible = true; // Show FIR details
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

// //graphFilter end
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

//                         // Apply filtering logic
//                         filteredFirList = firDetailsList.where((fir) {
//                           bool matchesFirNo = firNumController.text.isEmpty ||
//                               fir['firNo'] == firNumController.text;

//                           return matchesFirNo;
//                         }).toList();

//                         // Reset pagination when filtering
//                         currentPage = 0;
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

// //FIRFilter ends