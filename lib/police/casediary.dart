// import 'package:flutter/material.dart';
// import 'package:himcops/police/phome.dart';
// import 'package:intl/intl.dart'; // For formatting dates
// import 'package:himcops/drawer/pdrawer.dart';

// class CaseDiaryPage extends StatefulWidget {
//   const CaseDiaryPage({super.key});

//   @override
//   State<CaseDiaryPage> createState() => _CaseDiaryPageState();
// }

// class _CaseDiaryPageState extends State<CaseDiaryPage> {
//   TextEditingController firController = TextEditingController();
//   TextEditingController fromDateController = TextEditingController();
//   TextEditingController toDateController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _showFIRDialog();
//     });
//   }

//   Future<void> _selectDate(
//       BuildContext context, TextEditingController controller) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
//       });
//     }
//   }

//   void _showFIRDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return WillPopScope(
//           onWillPop: () async {
//             // Navigate to CitizenGridPage when back button is pressed
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => const PoliceHomePage(),
//               ),
//             );
//             return false; // Prevent dialog from closing by default behavior
//           },
//           child: AlertDialog(
//             title: const Text(
//                 'Search FIR for which case diary is to be prepared',
//                 textAlign: TextAlign.center),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextFormField(
//                   controller: firController,
//                   decoration: InputDecoration(
//                     labelText: 'FIR No.',
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10),
//                 TextFormField(
//                   controller: fromDateController,
//                   decoration: InputDecoration(
//                     labelText: 'Date Range From',
//                     prefixIcon: const Icon(Icons.calendar_month),
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   readOnly: true,
//                   onTap: () {
//                     FocusScope.of(context).requestFocus(FocusNode());
//                     _selectDate(context, fromDateController);
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 TextFormField(
//                   controller: toDateController,
//                   decoration: InputDecoration(
//                     labelText: 'Date Range To',
//                     prefixIcon: const Icon(Icons.calendar_month),
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   readOnly: true,
//                   onTap: () {
//                     FocusScope.of(context).requestFocus(FocusNode());
//                     _selectDate(context, toDateController);
//                   },
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   // Navigator.pop(context);
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const PoliceHomePage()),
//                   );
//                 },
//                 child: const Text('Close'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   _searchFIR();
//                 },
//                 child: const Text('Search'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _searchFIR() {
//     String firNo = firController.text;
//     String fromDate = fromDateController.text;
//     String toDate = toDateController.text;
//     Navigator.pop(context); // Close the dialog after search
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Case Diary',
//           style: TextStyle(
//               fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         backgroundColor: const Color.fromARGB(255, 12, 100, 233),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       drawer: PolAppDrawer(),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//           ],
//         ),
//       ),
//     );
//   }
// }
// there will a dummy list say 
//sr no: 1, Fir no. : 111/23, date of registration: 20/01/2024
//sr no: 2, Fir no. : 112/23, date of registration: 21/01/2024
//sr no: 3, Fir no. : 113/23, date of registration: 22/01/2024
//sr no: 4, Fir no. : 114/23, date of registration: 23/01/2024
//sr no: 5, Fir no. : 115/23, date of registration: 24/01/2024
// now when i click search it will show the list in tabular form wih one more column action and in every there will text button add case diary 



import 'package:flutter/material.dart';
import 'package:himcops/police/phome.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:himcops/drawer/pdrawer.dart';

class CaseDiaryPage extends StatefulWidget {
  const CaseDiaryPage({super.key});

  @override
  State<CaseDiaryPage> createState() => _CaseDiaryPageState();
}

class _CaseDiaryPageState extends State<CaseDiaryPage> {
  TextEditingController firController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  
  List<Map<String, String>> firList = [];
  bool isSearched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showFIRDialog();
    });
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _showFIRDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const PoliceHomePage(),
              ),
            );
            return false;
          },
          child: AlertDialog(
            title: const Text(
                'Search FIR for which case diary is to be prepared',
                textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: firController,
                  decoration: InputDecoration(
                    labelText: 'FIR No.',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: fromDateController,
                  decoration: InputDecoration(
                    labelText: 'Date Range From',
                    prefixIcon: const Icon(Icons.calendar_month),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context, fromDateController),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: toDateController,
                  decoration: InputDecoration(
                    labelText: 'Date Range To',
                    prefixIcon: const Icon(Icons.calendar_month),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context, toDateController),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PoliceHomePage()),
                  );
                },
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  _searchFIR();
                },
                child: const Text('Search'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _searchFIR() {
    setState(() {
      firList = [
        {'srNo': '1', 'firNo': '111/23', 'date': '2024-01-20'},
        {'srNo': '2', 'firNo': '112/23', 'date': '2024-01-21'},
        {'srNo': '3', 'firNo': '113/23', 'date': '2024-01-22'},
        {'srNo': '4', 'firNo': '114/23', 'date': '2024-01-23'},
        {'srNo': '5', 'firNo': '115/23', 'date': '2024-01-24'},
      ];
      isSearched = true;
    });
    Navigator.pop(context); // Close the dialog
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Case Diary',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 100, 233),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: PolAppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: isSearched
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Sr No')),
                    DataColumn(label: Text('FIR No.')),
                    DataColumn(label: Text('Date of Registration')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: firList
                      .map(
                        (fir) => DataRow(cells: [
                          DataCell(Text(fir['srNo']!)),
                          DataCell(Text(fir['firNo']!)),
                          DataCell(Text(fir['date']!)),
                          DataCell(
                            TextButton(
                              onPressed: () {
                                // Action for adding case diary
                              },
                              child: const Text('Add Case Diary'),
                            ),
                          ),
                        ]),
                      )
                      .toList(),
                ),
              )
            : const Center(
                child: Text(
                  'Search an FIR to display results',
                  style: TextStyle(fontSize: 16),
                ),
              ),
      ),
    );
  }
}
