import 'package:flutter/material.dart';
import 'package:himcops/drawer/drawer.dart';

class ProtestVerificationPage extends StatefulWidget {
  final String applicantName;
  final String applicantRelationType;
  final String applicationRelativeName;
  final String applicantGender;
  final String applicantDateOfBirth;
  final String applicantAge;
  final String applicantEmail;
  final String applicantMobile;
  final String orgName;
  final String orgAddress;
  final String orgCountry;
  final String orgState;
  final String orgDistrict;
  final String orgPoliceStation;
  final String protestType;
  final String briefDescription;
  final String instituteName;
  final String startAddress;
  final String startCountry;
  final String startState;
  final String startDistrict;
  final String startPoliceStation;
  final String locationNumber;
  final String locationArea;
  final String startDate;
  final String endDate;
  final String structureNature;
  final String locationName;
  final String startHours;
  final String expectedHours;
  final String startMinutes;
  final String expectedMinutes;
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

  const ProtestVerificationPage({
    super.key,
    required this.applicantName,
    required this.applicantRelationType,
    required this.applicationRelativeName,
    required this.applicantGender,
    required this.applicantDateOfBirth,
    required this.applicantAge,
    required this.applicantEmail,
    required this.applicantMobile,
    required this.orgName,
    required this.orgAddress,
    required this.orgCountry,
    required this.orgState,
    required this.orgDistrict,
    required this.orgPoliceStation,
    required this.protestType,
    required this.briefDescription,
    required this.instituteName,
    required this.startAddress,
    required this.startCountry,
    required this.startState,
    required this.startDistrict,
    required this.startPoliceStation,
    required this.locationNumber,
    required this.startDate,
    required this.endDate,
    required this.locationArea,
    required this.locationName,
    required this.structureNature,
    required this.startHours,
    required this.expectedHours,
    required this.startMinutes,
    required this.expectedMinutes,
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
  _ProtestVerificationPageState createState() =>
      _ProtestVerificationPageState();
}

class _ProtestVerificationPageState extends State<ProtestVerificationPage> {
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
                const Text('Applicant Personal Information',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Name: ${widget.applicantName}'),
                Text('Gender: ${widget.applicantGender}'),
                Text('Date Of Birth: ${widget.applicantDateOfBirth}'),
                Text('Age: ${widget.applicantAge}'),
                Text('Email: ${widget.applicantEmail}'),
                Text('Mobile Number: ${widget.applicantMobile}'),
                Text('Relation: ${widget.applicantRelationType}'),
                Text('Relative Name: ${widget.applicationRelativeName}'),

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
                const Text('Applicant Organization Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Organization Name: ${widget.orgName}'),
                Text('Address: ${widget.orgAddress}'),
                Text('Country: ${widget.orgCountry}'),
                Text('State: ${widget.orgState}'),
                Text('District: ${widget.orgDistrict}'),
                Text('Police Station: ${widget.orgPoliceStation}'),
                const SizedBox(height: 20),
                const Text('Protest/Strike Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                    'Name of Target Institution/Person : ${widget.instituteName}'),
                Text(
                    'Expected time limit for the Protest/Strike (per day): ${widget.expectedHours} Hours and ${widget.expectedMinutes} Minutes'),
                Text(
                    'Description of Protest/Strike: ${widget.briefDescription}'),
                Text('Type of Protest/Strike: ${widget.protestType}'),
                Text(
                    'Name of location(Place of Protest/Strike): ${widget.locationName}'),

                Text(
                    'Address of location(Place of Protest/Strike): ${widget.startAddress}, ${widget.startCountry}, ${widget.startState}, ${widget.startDistrict}, ${widget.startPoliceStation}'),

                Text(
                    'Location Area: ${widget.locationNumber} ${widget.locationArea}'),
                Text('Nature of structure planned: ${widget.structureNature}'),
                Text('Start Date of Procession: ${widget.startDate}'),
                Text('End Date of Procession: ${widget.endDate}'),

                Text(
                    'Starting Time of Procession: ${widget.startHours} Hours and ${widget.startMinutes} Minutes'),
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
