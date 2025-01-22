import 'package:flutter/material.dart';
import 'package:himcops/drawer/drawer.dart';

class ComplaintVerificationPage extends StatefulWidget {
  final String name;
  final String dateDob;
  final String age;
  final String mobile;
  final String email;
  final String complaintNature;
  final String identify;
  final String idNumber;
  final String incidentDateTimeFrom;
  final String incidentDateTimeTo;
  final String incidentPlace;
  final String date;
  final String complaintDescription;
  final String accusedName;
  final String accusedAddress;
  final String accusedCountry;
  final String accusedState;
  final String accusedDistrict;
  final String accusedPoliceStation;
  final String submissionPolice;
  final String submissionDistrict;
  final String submissionOffice;
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

  const ComplaintVerificationPage({
    super.key,
    required this.name,
    required this.dateDob,
    required this.age,
    required this.mobile,
    required this.email,
    required this.complaintNature,
    required this.identify,
    required this.idNumber,
    required this.incidentDateTimeFrom,
    required this.incidentDateTimeTo,
    required this.incidentPlace,
    required this.date,
    required this.complaintDescription,
    required this.accusedName,
    required this.accusedAddress,
    required this.accusedCountry,
    required this.accusedState,
    required this.accusedDistrict,
    required this.accusedPoliceStation,
    required this.submissionPolice,
    required this.submissionDistrict,
    required this.submissionOffice,
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
  });

  @override
  _ComplaintVerificationPageState createState() =>
      _ComplaintVerificationPageState();
}

class _ComplaintVerificationPageState extends State<ComplaintVerificationPage> {
  final GlobalKey<FormState> _affidavitDetailsFormKey = GlobalKey<FormState>();
  bool isAgree = false; // Checkbox state

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
                const Text('Complainant Personal Information',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Name: ${widget.name}'),
                Text('Date Of Birth: ${widget.dateDob}'),
                Text('Age: ${widget.age}'),
                Text('Email: ${widget.email}'),
                Text('Mobile Number: ${widget.mobile}'),
                Text('Nature of complaint: ${widget.complaintNature}'),
                Text('Identification: ${widget.identify}'),
                Text('Identification Number: ${widget.idNumber}'),

                const SizedBox(height: 20),

                const Text('Applicant Present Address Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Address: ${widget.presentAddress}'),
                Text('Country: ${widget.presentCountry}'),
                Text('State: ${widget.presentState}'),
                Text('District: ${widget.presentDistrict}'),
                Text('Police Station: ${widget.presentPoliceStation}'),

                const SizedBox(height: 20),
                const Text('Applicant Permanent Address Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Address: ${widget.permanentAddress}'),
                Text('Country: ${widget.permanentCountry}'),
                Text('State: ${widget.permanentState}'),
                Text('District: ${widget.permanentDistrict}'),
                Text('Police Station: ${widget.permanentPoliceStation}'),
                const SizedBox(height: 20),
                const Text('Incident Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Incident Place: ${widget.incidentPlace}'),
                Text(
                    'Incident Date and Time from: ${widget.incidentDateTimeFrom}'),
                Text('Incident Date and Time to: ${widget.incidentDateTimeTo}'),
                const SizedBox(height: 20),
                const Text('Complaint Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Complaint Date : ${widget.date}'),
                Text('Complaint Description : ${widget.complaintDescription}'),
                const SizedBox(height: 20),
                const Text('Accused Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Accused Name : ${widget.accusedName}'),
                Text(
                    'Accused Address : ${widget.accusedAddress} ${widget.accusedCountry} ${widget.accusedState} ${widget.accusedDistrict} ${widget.accusedPoliceStation}'),

                const SizedBox(height: 20),
                const Text('Complaint Submission Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('District Name : ${widget.submissionDistrict}'),
                Text('Police Station Name : ${widget.submissionPolice}'),
                Text('Office Name : ${widget.submissionOffice}'),

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
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         const PaymentPage(mercid: '', bdorderid: '', rdata: '',),
                                      //   ),
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
