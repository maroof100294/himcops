import 'package:flutter/material.dart';
import 'package:himcops/controller/event_performance_controller/eventaddressdetails.dart';
import 'package:himcops/controller/event_performance_controller/eventlocationdetails.dart';
import 'package:himcops/controller/event_performance_controller/eventotherdetails.dart';
import 'package:himcops/controller/event_performance_controller/eventperformancedetails.dart';
import 'package:himcops/controller/event_performance_controller/eventpersonaldetails.dart';
import 'package:himcops/controller/event_performance_controller/eventverify.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/layout/formlayout.dart';

class EventPerformanceRequestPage extends StatefulWidget {
  const EventPerformanceRequestPage({super.key});

  @override
  State<EventPerformanceRequestPage> createState() =>
      _EventPerformanceRequestPageState();
}

class _EventPerformanceRequestPageState
    extends State<EventPerformanceRequestPage> {
  final _personalFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();
  final _otherFormKey = GlobalKey<FormState>();
  final _locationFormKey = GlobalKey<FormState>();
  final _performanceFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController organizationNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController relationController = TextEditingController();
  TextEditingController relativeNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dateDobController = TextEditingController();
  TextEditingController ageController = TextEditingController();
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
  TextEditingController criminalController = TextEditingController();
  TextEditingController convictedController = TextEditingController();
  TextEditingController preceedingController = TextEditingController();
  TextEditingController blacklistedController = TextEditingController();
  TextEditingController locationNameController = TextEditingController();
  TextEditingController structureTypeController = TextEditingController();
  TextEditingController structureNatureController = TextEditingController();
  TextEditingController locationAreaController = TextEditingController();
  TextEditingController locationNumberController = TextEditingController();
  TextEditingController locationAddressController = TextEditingController();
  TextEditingController locationCountryController = TextEditingController();
  TextEditingController locationStateController = TextEditingController();
  TextEditingController locationDistrictController = TextEditingController();
  TextEditingController locationPoliceStationController =
      TextEditingController();
  TextEditingController eventPerformanceTypeController =
      TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startHoursController = TextEditingController();
  TextEditingController startMinutesController = TextEditingController();
  TextEditingController expectedHoursController = TextEditingController();
  TextEditingController expectedMinutesController = TextEditingController();
  TextEditingController briefDescriptionController = TextEditingController();
  TextEditingController fireClearanceController = TextEditingController();

  bool isOtherFormVisible = false;
  bool isPersonalFormVisible = true;
  bool isAddressFormVisible = false;
  bool isLocationFormVisible = false;
  bool isPerformanceFormVisible = false;
  bool isChecked = true;
  bool isMovingForward = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Performance Request'),
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
                      if (isPersonalFormVisible)
                        EventPerformanceApplicantPersonalDetailsForm(
                          nameController: nameController,
                          ageController: ageController,
                          genderController: genderController,
                          dateDobController: dateDobController,
                          relationController: relationController,
                          relativeNameController: relativeNameController,
                          emailController: emailController,
                          mobileController: mobileController,
                          organizationNameController:
                              organizationNameController,
                        ),
                      if (isAddressFormVisible)
                        EventPerformanceApplicantAddressDetailsForm(
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
                      if (isOtherFormVisible)
                        EventPerformanceOtherDetailsForm(
                          criminalController: criminalController,
                          convictedController: convictedController,
                          preceedingController: preceedingController,
                          blacklistedController: blacklistedController,
                        ),
                      if (isLocationFormVisible)
                        EventLocationDetailsForm(
                          locationNameController: locationNameController,
                          structureTypeController: structureTypeController,
                          structureNatureController: structureNatureController,
                          locationAreaController: locationAreaController,
                          locationNumberController: locationNumberController,
                          locationAddressController: locationAddressController,
                          locationCountryController: locationCountryController,
                          locationStateController: locationStateController,
                          locationDistrictController:
                              locationDistrictController,
                          locationPoliceStationController:
                              locationPoliceStationController,
                        ),
                      if (isPerformanceFormVisible)
                        EventPerformanceDetailsForm(
                          eventPerformanceTypeController:
                              eventPerformanceTypeController,
                          startDateController: startDateController,
                          endDateController: endDateController,
                          startHoursController: startHoursController,
                          startMinutesController: startMinutesController,
                          expectedHoursController: expectedHoursController,
                          expectedMinutesController: expectedMinutesController,
                          briefDescriptionController:
                              briefDescriptionController,
                          fireClearanceController: fireClearanceController,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isPerformanceFormVisible,
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
                !isOtherFormVisible &&
                !isLocationFormVisible,
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
    if (isPerformanceFormVisible) return _performanceFormKey;
    if (isLocationFormVisible) return _locationFormKey;
    if (isOtherFormVisible) return _otherFormKey;
    if (isAddressFormVisible) return _addressFormKey;
    return _personalFormKey;
  }

  String _getFormTitle() {
    if (isPerformanceFormVisible) return 'Event Performance Details';
    if (isLocationFormVisible) return 'Event Performance Location Details';
    if (isOtherFormVisible) return 'Applicant Other Details';
    if (isAddressFormVisible) return 'Applicant Address Details';
    return 'Applicant Personal Details';
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
            isOtherFormVisible = true;
          } else if (isOtherFormVisible) {
            isOtherFormVisible = false;
            isLocationFormVisible = true;
          } else if (isLocationFormVisible) {
            isLocationFormVisible = false;
            isPerformanceFormVisible = true;
          }
        }
      } else {
        if (isPerformanceFormVisible) {
          isPerformanceFormVisible = false;
          isLocationFormVisible = true;
        } else if (isLocationFormVisible) {
          isLocationFormVisible = false;
          isOtherFormVisible = true;
        } else if (isOtherFormVisible) {
          isOtherFormVisible = false;
          isAddressFormVisible = true;
        } else if (isAddressFormVisible) {
          isAddressFormVisible = false;
          isPersonalFormVisible = true;
        }
      }

      if (isPerformanceFormVisible) {
        isMovingForward = false;
      } else if (isPersonalFormVisible) {
        isMovingForward = true;
      }
    });
  }

  void _verifyDetails() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EventPerformanceVerificationPage(
        applicantName: nameController.text,
        applicantRelationType: relationController.text,
        applicationRelativeName: relativeNameController.text,
        applicantGender: genderController.text,
        applicantDateOfBirth: dateDobController.text,
        applicantAge: ageController.text,
        applicantEmail: emailController.text,
        applicantMobile: mobileController.text,
        orgName: organizationNameController.text,
        criminal: criminalController.text,
        convicted: convictedController.text,
        preceeding: preceedingController.text,
        blacklisted: blacklistedController.text,
        locationName: locationNameController.text,
        structureType: structureTypeController.text,
        structureNature: structureNatureController.text,
        locationArea: locationAreaController.text,
        locationNumber: locationNumberController.text,
        locationAddress: locationAddressController.text,
        locationCountry: locationCountryController.text,
        locationState: locationStateController.text,
        locationDistrict: locationDistrictController.text,
        locationPolice: locationPoliceStationController.text,
        eventPerformanceType: eventPerformanceTypeController.text,
        startDate: startDateController.text,
        endDate: endDateController.text,
        briefDescription: briefDescriptionController.text,
        fireClearance: fireClearanceController.text,
        startHours: startHoursController.text,
        expectedHours: expectedHoursController.text,
        startMinutes: startMinutesController.text,
        expectedMinutes: expectedMinutesController.text,
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
