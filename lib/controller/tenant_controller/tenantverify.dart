import 'package:flutter/material.dart';
import 'package:himcops/drawer/drawer.dart';

class tvrVerificationPage extends StatefulWidget {
        final String name;
        final String dateOfBirth;
        final String gender;
        final String relation;
        final String relativeName;
        final String affidavit;
        final String email;
        final String mobile;
        final String ownerOccupation;
        final String ownerAddress;
        final String ownerCountry;
        final String ownerState;
        final String ownerDistrict;
        final String ownerPoliceStation;
        final String ownerName;
        final String tenantOccupation;
        final String tenancy;
        final String age;
        final String presentAddress;
        final String presentCountry;
        final String presentState;
        final String presentDistrict;
        final String presentPoliceStation;
        final String permanentAddress;
        final String permanentCountry;
        final String permanentState;
        final String permanentDistrict;
        final String permanentPoliceStation;
        final String photoFileName;
        final String documentFileName;

  const tvrVerificationPage({
    super.key,
     required this.name,
        required this.dateOfBirth,
        required this.gender,
        required this.relation,
        required this.relativeName,
        required this.affidavit,
        required this.email,
        required this.mobile,
        required this.ownerOccupation,
        required this.ownerAddress,
        required this.ownerCountry,
        required this.ownerState,
        required this.ownerDistrict,
        required this.ownerPoliceStation,
        required this.ownerName,
        required this.tenantOccupation,
        required this.tenancy,
        required this.age,
        required this.presentAddress,
        required this.presentCountry,
        required this.presentState,
        required this.presentDistrict,
        required this.presentPoliceStation,
        required this.permanentAddress,
        required this.permanentCountry,
        required this.permanentState,
        required this.permanentDistrict,
        required this.permanentPoliceStation,
        required this.photoFileName,
        required this.documentFileName,

  });

  @override
  _tvrVerificationPageState createState() => _tvrVerificationPageState();
}

class _tvrVerificationPageState extends State<tvrVerificationPage> {
  final GlobalKey<FormState> _affidavitDetailsFormKey = GlobalKey<FormState>();
  bool isAgree = false; // Checkbox state

  // Function to open files using the path_provider to locate the file
  // Future<void> _openFile(String fileName) async {
  //   try {
  //     final Directory appDocDir = await getApplicationDocumentsDirectory();
  //     String galleryPath = '${appDocDir.path}/Gallery';
  //     final filePath = '$galleryPath/$fileName';

  //     print('File path: $filePath'); // Debug print
  //     if (await File(filePath).exists()) {
  //       final result = await OpenFilex.open(filePath);
  //       if (result.type != ResultType.done) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Error opening file: ${result.message}')),
  //         );
  //       }
  //     } else {
  //       print('File does not exist at: $filePath'); // More detailed debug print
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('File does not exist')),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error: $e'); // Debug print for the error
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Details'),
        backgroundColor: const Color(0xFFB9DA6B),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _affidavitDetailsFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 const Text('Owner Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Name: ${widget.ownerName}'),
                Text('Email ID: ${widget.email}'),
                Text('Mobile Number: ${widget.mobile}'),
                Text('Occupation: ${widget.ownerOccupation}'),
                Text('Address: ${widget.ownerAddress}'),
                Text('Country: ${widget.ownerCountry}'),
                Text('State: ${widget.ownerState}'),
                Text('District: ${widget.ownerDistrict}'),
                Text('Police Station: ${widget.ownerPoliceStation}'),
                const SizedBox(height: 20),
                const Text('Personal Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Name: ${widget.name}'),
                Text('Gender: ${widget.gender}'),
                Text('Date Of Birth: ${widget.dateOfBirth}'),
                Text('Age: ${widget.age}'),
                Text('Relation: ${widget.relation}'),
                Text('Relative Name: ${widget.relativeName}'),
                Text('Occupation: ${widget.tenantOccupation}'),
                Text('Tenancy Type: ${widget.tenancy}'),
                const SizedBox(height: 20),
               
               
                const Text('Present Address Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Address: ${widget.presentAddress}'),
                Text('Country: ${widget.presentCountry}'),
                Text('State: ${widget.presentState}'),
                Text('District: ${widget.presentDistrict}'),
                Text('Police Station: ${widget.presentPoliceStation}'),
                
                const SizedBox(height: 20),
                 const Text('Permanent Address Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Address: ${widget.permanentAddress}'),
                Text('Country: ${widget.permanentCountry}'),
                Text('State: ${widget.permanentState}'),
                Text('District: ${widget.permanentDistrict}'),
                Text('Police Station: ${widget.permanentPoliceStation}'),
                const SizedBox(height: 20),
                 const Text('Uploaded Files',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                
                // Display and make photo clickable if present
                // if (widget.photoFileName.isNotEmpty)
                //   GestureDetector(
                //     onTap: () => _openFile(widget.photoFileName),
                //     child: Text('${widget.photoFileName}', style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                //   ),
                
                // // Display and make document clickable if present
                // if (widget.documentFileName.isNotEmpty)
                //   GestureDetector(
                //     onTap: () => _openFile(widget.documentFileName),
                //     child: Text('${widget.documentFileName}', style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                //   ),
                
                const SizedBox(height: 20),
                const Text('Affidavit Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Affidavit: ${widget.affidavit}'),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: isAgree,
                      onChanged: (value) {
                        setState(() {
                          isAgree = value!;
                        });
                      },
                    ),
                    const Text('I agree to the terms and conditions'),
                  ],
                ),
                const SizedBox(height: 20),
                // Edit Button
                ElevatedButton(
                  onPressed: () {
                    // Implement your edit functionality here
                    // For example, you can navigate to an edit page or open a form
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Blue color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.white), // White text
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (isAgree &&
                          _affidavitDetailsFormKey.currentState!.validate())
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Submission Successful'),
                                content: const Text(
                                  'Thank you for submitting your Verification details. Proceeding to payment.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // Navigator.of(context).push(
                                      //   // MaterialPageRoute(
                                      //   //   builder: (context) =>
                                      //   //       const PaymentPage(mercid: '', bdorderid: '', rdata: '',),
                                      //   // ),
                                      // );
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      : null, // Disable button if checkbox is not checked
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF3AC00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
