import 'package:flutter/material.dart';
import 'package:himcops/drawer/drawer.dart';

class ProcessionVerificationPage extends StatefulWidget {
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
  final String processionType;
  final String briefDescription;
  final String majorParticipant;
  final String majorAddress;
  final String majorCountry;
  final String majorState;
  final String majorDistrict;
  final String majorPoliceStation;
  final String startAddress;
  final String startCountry;
  final String startState;
  final String startDistrict;
  final String startPoliceStation;
  final String endAddress;
  final String endCountry;
  final String endState;
  final String endDistrict;
  final String endPoliceStation;
  final String otherAddress;
  final String otherCountry;
  final String otherState;
  final String otherDistrict;
  final String otherPoliceStation;
  final String startDate;
  final String endDate;
  final String processionNumber;
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

  const ProcessionVerificationPage({
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
    required this.processionType,
    required this.briefDescription,
    required this.majorParticipant,
    required this.majorAddress,
    required this.majorCountry,
    required this.majorState,
    required this.majorDistrict,
    required this.majorPoliceStation,
    required this.startAddress,
    required this.startCountry,
    required this.startState,
    required this.startDistrict,
    required this.startPoliceStation,
    required this.endAddress,
    required this.endCountry,
    required this.endState,
    required this.endDistrict,
    required this.endPoliceStation,
    required this.otherAddress,
    required this.otherCountry,
    required this.otherState,
    required this.otherDistrict,
    required this.otherPoliceStation,
    required this.startDate,
    required this.endDate,
    required this.processionNumber,
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
  _ProcessionVerificationPageState createState() =>
      _ProcessionVerificationPageState();
}

class _ProcessionVerificationPageState
    extends State<ProcessionVerificationPage> {
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
                const Text('Personal Information',
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

                const Text('Present Address Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Address: ${widget.presentAddress}'),
                Text('Country: ${widget.presentCountry}'),
                Text('State: ${widget.presentState}'),
                Text('District: ${widget.presentDistrict}'),
                Text('Police Station: ${widget.presentPoliceStation}'),

                const SizedBox(height: 20),
                const Text('Permanent Address Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Address: ${widget.permanentAddress}'),
                Text('Country: ${widget.permanentCountry}'),
                Text('State: ${widget.permanentState}'),
                Text('District: ${widget.permanentDistrict}'),
                Text('Police Station: ${widget.permanentPoliceStation}'),
                const SizedBox(height: 20),
                const Text('Organization Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Organization Name: ${widget.orgName}'),
                Text('Address: ${widget.orgAddress}'),
                Text('Country: ${widget.orgCountry}'),
                Text('State: ${widget.orgState}'),
                Text('District: ${widget.orgDistrict}'),
                Text('Police Station: ${widget.orgPoliceStation}'),
                const SizedBox(height: 20),
                 const Text('Procession Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Type of Procession: ${widget.processionType}'),
                Text('Expected Time of Procession: ${widget.expectedHours} Hours and ${widget.expectedMinutes} Minutes'),
                Text('Brief Description: ${widget.briefDescription}'),
                Text('Major Head Name: ${widget.majorParticipant}'),
                Text('Major Head Address: ${widget.majorAddress}, ${widget.majorCountry}, ${widget.majorState}, ${widget.majorDistrict}, ${widget.majorPoliceStation}'),
                Text('Address of Starting Point: ${widget.startAddress}, ${widget.startCountry}, ${widget.startState}, ${widget.startDistrict}, ${widget.startPoliceStation}'),
                Text('Address of other point in route: ${widget.otherAddress}, ${widget.otherCountry}, ${widget.otherState}, ${widget.otherDistrict}, ${widget.otherPoliceStation}'),
                Text('Address of Ending point: ${widget.endAddress}, ${widget.endCountry}, ${widget.endState}, ${widget.endDistrict}, ${widget.endPoliceStation}'),
                Text('Start Date of Procession: ${widget.startDate}'),
                Text('End Date of Procession: ${widget.endDate}'),
                Text('Expected crowd to be gathered in Procession: ${widget.processionNumber}'),
                Text('Starting Time of Procession: ${widget.startHours} Hours and ${widget.startMinutes} Minutes'),
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
