import 'package:flutter/material.dart';
import 'package:himcops/controller/complaint_controller/compaddressdetails.dart';
import 'package:himcops/controller/complaint_controller/compcomplaintdetails.dart';
import 'package:himcops/controller/complaint_controller/compersonaldetails.dart';
import 'package:himcops/controller/complaint_controller/compincidentdetails.dart';
import 'package:himcops/controller/complaint_controller/complaintverify.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/layout/formlayout.dart';

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final _personalFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();
  final _compFormKey = GlobalKey<FormState>();
  final _incidentFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController dateDobController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController complaintNatureController = TextEditingController();
  TextEditingController identifyController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController aCountryController = TextEditingController();
  TextEditingController aStateController = TextEditingController();
  TextEditingController aDistrictController = TextEditingController();
  TextEditingController aPoliceStationController = TextEditingController();
  TextEditingController paddressController = TextEditingController();
  TextEditingController pcountryController = TextEditingController();
  TextEditingController pdistrictController = TextEditingController();
  TextEditingController pstateController = TextEditingController();
  TextEditingController ppoliceStationController = TextEditingController();
  TextEditingController incidentDateTimeFromController =
      TextEditingController();
  TextEditingController incidentDateTimeToController = TextEditingController();
  TextEditingController incidentPlaceController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController complaintDescriptionController =
      TextEditingController();
  TextEditingController accusedNameController = TextEditingController();
  TextEditingController accusedAddressController = TextEditingController();
  TextEditingController accusedCountryController = TextEditingController();
  TextEditingController accusedStateController = TextEditingController();
  TextEditingController accusedDistrictController = TextEditingController();
  TextEditingController accusedPoliceStationController =
      TextEditingController();
  TextEditingController submissionPoliceController = TextEditingController();
  TextEditingController submissionDistrictController = TextEditingController();
  TextEditingController submissionOfficeController = TextEditingController();

  bool isCompFormVisible = false;
  bool isPersonalFormVisible = true;
  bool isAddressFormVisible = false;
  bool isIncidentFormVisible = false;
  bool isChecked = true;
  bool isMovingForward = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint'),
        backgroundColor: const Color(0xFFB9DA6B),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          const BackgroundPage(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: myBoxDecoration(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _getCurrentFormKey(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getFormTitle(),
                        style: const TextStyle(
                          color: Color(0xFF133371),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'All fields are mandatory',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.normal,
                            fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      if (isIncidentFormVisible)
                        ComplaintIncidentDetailsForm(
                          incidentDateTimeFromController:
                              incidentDateTimeFromController,
                          incidentDateTimeToController:
                              incidentDateTimeToController,
                          incidentPlaceController: incidentPlaceController,
                        ),
                      if (isAddressFormVisible)
                        ComplainantAddressDetailsForm(
                          addressController: addressController,
                          aCountryController: aCountryController,
                          aStateController: aStateController,
                          aDistrictController: aDistrictController,
                          aPoliceStationController: aPoliceStationController,
                          paddressController: paddressController,
                          pcountryController: pcountryController,
                          pstateController: pstateController,
                          pdistrictController: pdistrictController,
                          ppoliceStationController: ppoliceStationController,
                        ),
                      if (isCompFormVisible)
                        CompComplaintDetailsForm(
                          dateController: dateController,
                          complaintDescriptionController:
                              complaintDescriptionController,
                          accusedNameController: accusedNameController,
                          accusedAddressController: accusedAddressController,
                          accusedCountryController: accusedCountryController,
                          accusedStateController: accusedStateController,
                          accusedDistrictController: accusedDistrictController,
                          accusedPoliceStationController:
                              accusedPoliceStationController,
                          submissionPoliceController:
                              submissionPoliceController,
                          submissionDistrictController:
                              submissionDistrictController,
                          submissionOfficeController:
                              submissionOfficeController,
                        ),
                      if (isPersonalFormVisible)
                        ComplaintPersonalDetailsForm(
                          nameController: nameController,
                          dateDobController: dateDobController,
                          ageController: ageController,
                          mobileController: mobileController,
                          emailController: emailController,
                          complaintNatureController: complaintNatureController,
                          identifyController: identifyController,
                          idNumberController: idNumberController,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isCompFormVisible,
            child: Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _nextSection,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.yellow[700],
                child:
                    const Text('Next', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Visibility(
            visible: !isPersonalFormVisible &&
                !isAddressFormVisible &&
                !isIncidentFormVisible,
            child: Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _verifyDetails,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                backgroundColor: Colors.yellow[700],
                child:
                    const Text('Verify', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GlobalKey<FormState> _getCurrentFormKey() {
    if (isCompFormVisible) return _compFormKey;
    if (isIncidentFormVisible) return _incidentFormKey;
    if (isAddressFormVisible) return _addressFormKey;

    return _personalFormKey;
  }

  String _getFormTitle() {
    if (isCompFormVisible) return 'Complaint Details';
    if (isIncidentFormVisible) return 'Incident Details';
    if (isAddressFormVisible) return 'Complainant Address Details';
    return 'Complainant Personal Details';
  }

  void _nextSection() {
    setState(() {
      if (isMovingForward) {
        if (_getCurrentFormKey().currentState!.validate()) {
          if (isPersonalFormVisible) {
            isPersonalFormVisible = false;
            isAddressFormVisible = true;
          } else if (isAddressFormVisible) {
            isAddressFormVisible = false;
            isIncidentFormVisible = true;
          } else if (isIncidentFormVisible) {
            isIncidentFormVisible = false;
            isCompFormVisible = true;
          }
        }
      } else {
        if (isCompFormVisible) {
          isCompFormVisible = false;
          isIncidentFormVisible = true;
        } else if (isIncidentFormVisible) {
          isIncidentFormVisible = false;
          isAddressFormVisible = true;
        } else if (isAddressFormVisible) {
          isAddressFormVisible = false;
          isPersonalFormVisible = true;
        }
      }

      if (isCompFormVisible) {
        isMovingForward = false;
      } else if (isPersonalFormVisible) {
        isMovingForward = true;
      }
    });
  }

  void _verifyDetails() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ComplaintVerificationPage(
        name: nameController.text,
        dateDob: dateDobController.text,
        age: ageController.text,
        mobile: mobileController.text,
        email: emailController.text,
        complaintNature: complaintNatureController.text,
        identify: identifyController.text,
        idNumber: idNumberController.text,
        incidentDateTimeFrom: incidentDateTimeFromController.text,
        incidentDateTimeTo: incidentDateTimeToController.text,
        incidentPlace: incidentPlaceController.text,
        date: dateController.text,
        complaintDescription: complaintDescriptionController.text,
        accusedName: accusedNameController.text,
        accusedAddress: accusedAddressController.text,
        accusedCountry: accusedCountryController.text,
        accusedState: accusedStateController.text,
        accusedDistrict: accusedDistrictController.text,
        accusedPoliceStation: accusedPoliceStationController.text,
        submissionPolice: submissionPoliceController.text,
        submissionDistrict: submissionDistrictController.text,
        submissionOffice: submissionOfficeController.text,
        presentAddress: paddressController.text,
        presentCountry: pcountryController.text,
        presentState: pstateController.text,
        presentDistrict: pdistrictController.text,
        presentPoliceStation: ppoliceStationController.text,
        permanentAddress:
            isChecked ? paddressController.text : addressController.text,
        permanentCountry:
            isChecked ? pcountryController.text : aCountryController.text,
        permanentState:
            isChecked ? pstateController.text : aStateController.text,
        permanentDistrict:
            isChecked ? pdistrictController.text : aDistrictController.text,
        permanentPoliceStation: isChecked
            ? ppoliceStationController.text
            : aPoliceStationController.text,
      ),
    ));
  }
}
