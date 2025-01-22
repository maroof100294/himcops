import 'package:flutter/material.dart';
import 'package:himcops/drawer/drawer.dart';

class EventPerformanceVerificationPage extends StatefulWidget {
  final String applicantName;
  final String applicantRelationType;
  final String applicationRelativeName;
  final String applicantGender;
  final String applicantDateOfBirth;
  final String applicantAge;
  final String applicantEmail;
  final String applicantMobile;
  final String criminal;
  final String briefDescription;
  final String convicted;
  final String startDate;
  final String endDate;
  final String preceeding;
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
  final String blacklisted;
  final String locationName;
  final String locationNumber;
  final String locationAddress;
  final String locationCountry;
  final String locationState;
  final String locationDistrict;
  final String locationPolice;
  final String structureType;
  final String structureNature;
  final String locationArea;
  final String eventPerformanceType;
  final String fireClearance;
  final String orgName;

  const EventPerformanceVerificationPage({
    super.key,
    required this.applicantName,
    required this.applicantRelationType,
    required this.applicationRelativeName,
    required this.applicantGender,
    required this.applicantDateOfBirth,
    required this.applicantAge,
    required this.applicantEmail,
    required this.applicantMobile,
    required this.criminal,
    required this.briefDescription,
    required this.startDate,
    required this.endDate,
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
    required this.convicted,
    required this.preceeding,
    required this.blacklisted,
    required this.locationName,
    required this.structureType,
    required this.structureNature,
    required this.locationArea,
    required this.locationNumber,
    required this.locationAddress,
    required this.locationCountry,
    required this.locationState,
    required this.locationDistrict,
    required this.locationPolice,
    required this.eventPerformanceType,
    required this.fireClearance,
    required this.orgName,
  });

  @override
  _EventPerformanceVerificationPageState createState() =>
      _EventPerformanceVerificationPageState();
}

class _EventPerformanceVerificationPageState
    extends State<EventPerformanceVerificationPage> {
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
                Text('Relative Name: ${widget.orgName}'),

                const SizedBox(height: 20),

                const Text(' Applicant Present Address Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Address: ${widget.presentAddress}'),
                Text('Country: ${widget.presentCountry}'),
                Text('State: ${widget.presentState}'),
                Text('District: ${widget.presentDistrict}'),
                Text('Police Station: ${widget.presentPoliceStation}'),

                const SizedBox(height: 20),
                const Text(' Applicant Permanent Address Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Address: ${widget.permanentAddress}'),
                Text('Country: ${widget.permanentCountry}'),
                Text('State: ${widget.permanentState}'),
                Text('District: ${widget.permanentDistrict}'),
                Text('Police Station: ${widget.permanentPoliceStation}'),
                const SizedBox(height: 20),
                const Text('Applicant Other Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Criminal Description: ${widget.criminal}'),
                Text('Convicted Description: ${widget.convicted}'),
                Text('Preceeding Description: ${widget.preceeding}'),
                Text('Blacklisted Description: ${widget.blacklisted}'),
                const SizedBox(height: 20),
                const Text('Event Performance Location Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Location Name: ${widget.locationName}'),
                Text(
                    'Address of the location: ${widget.locationAddress}, ${widget.locationCountry}, ${widget.locationState}, ${widget.locationDistrict}, ${widget.locationPolice}'),
                Text(
                    'Location Area: ${widget.locationNumber} ${widget.locationArea}'),
                Text('Nature of structure: ${widget.structureNature}'),
                Text('Type of structure planned: ${widget.structureType}'),
                const SizedBox(height: 20),
                const Text('Event Performance Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                    'Type of Event/Performance: ${widget.eventPerformanceType}'),
                Text(
                    'Start Date of the Event/Performance: ${widget.startDate}'),
                Text(
                    'Start time of the event/performance: ${widget.startHours} Hours and ${widget.startMinutes} Minutes'),
                Text('End Date of the Event / Performance: ${widget.endDate}'),

                Text(
                    'Proposed time limit of the show: ${widget.expectedHours} Hours and ${widget.expectedMinutes} Minutes'),
                Text(
                    'Fire department clearance obtained/applied: ${widget.fireClearance}'),
                Text(
                    'Brief Synopsis of the performance containing the content of the show(s) (Artist details etc): ${widget.briefDescription}'),

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
