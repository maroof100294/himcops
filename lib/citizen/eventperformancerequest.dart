import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:himcops/controller/event_performance_controller/eventaddressdetails.dart';
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
  final _otherFormKey = GlobalKey<FormState>();
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
  bool isPerformanceFormVisible = false;
   String selectedState = 'HIMACHAL PRADESH';
  bool _criminalChanged = false;
  bool _convictedChanged = false;
  bool _preceedingChanged = false;
  bool _blacklistedChanged = false;
  bool isChecked = true;
  bool isMovingForward = true; 
  String loginId = '';
  String firstName = '';
  String fullName = '';
  String email = '';
  String addressLine1 = '';
  String addressLine2 = '';
  String addressLine3 = '';
  String tehsil = '';
  String village = '';
  int? mobile2;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> _fetchLoginId() async {
    final String? storedLoginId = await _storage.read(key: 'loginId');
    final String? storedfirstName = await _storage.read(key: 'firstName');
    final String? storedfullName = await _storage.read(key: 'fullName');
    final String? storedemail = await _storage.read(key: 'email');
    final String? storedaddressLine1 = await _storage.read(key: 'addressLine1');
    final String? storedaddressLine2 = await _storage.read(key: 'addressLine2');
    final String? storedaddressLine3 = await _storage.read(key: 'addressLine3');
    final String? storedtehsil = await _storage.read(key: 'tehsil');
    final String? storedvillage = await _storage.read(key: 'village');
    final String? storedMobile2 = await _storage.read(key: 'mobile2');
    print(
        'loginID:$storedLoginId, firstname:$storedfirstName, fullname:$storedfullName, email:$storedemail');
    setState(() {
      loginId = storedLoginId ?? 'Unknown';
      firstName = storedfirstName ?? 'Unknown';
      fullName = storedfullName ?? 'Unknown';
      email = storedemail ?? 'Unknown';
      addressLine1 = storedaddressLine1 ?? ' ';
      addressLine2 = storedaddressLine2 ?? ' ';
      addressLine3 = storedaddressLine3 ?? ' ';
      tehsil = storedtehsil ?? ' ';
      village = storedvillage ?? ' ';
      mobile2 = storedMobile2 != null ? int.tryParse(storedMobile2) : 0;
      nameController.text = firstName;
      emailController.text = email;
      mobileController.text = mobile2 != null ? mobile2.toString() : '';
    });
  }
  @override
  void initState() {
    super.initState();
    _fetchLoginId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:AppBar(
        title: const Text(
          'Event Performanace Request',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Color.fromARGB(255, 12, 100, 233),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the menu icon color to white
        ),
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
                      if (isOtherFormVisible)
                        EventPerformanceOtherDetailsForm(
                          criminalController: criminalController,
                          convictedController: convictedController,
                          preceedingController: preceedingController,
                          blacklistedController: blacklistedController,
                          onCriminalStatusChanged: (bool value) {
                            _criminalChanged = value;
                          },
                          onConvictedStatusChanged: (bool value) {
                            _convictedChanged = value;
                          },
                          onPreceedingStatusChanged: (bool value) {
                            _preceedingChanged = value;
                          },
                          onBlacklistedStatusChanged: (bool value) {
                            _blacklistedChanged = value;
                          },
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
                !isOtherFormVisible,
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
    if (isOtherFormVisible) return _otherFormKey;
    return _personalFormKey;
  }

  String _getFormTitle() {
    if (isPerformanceFormVisible) return 'Event Performance Details';
    if (isOtherFormVisible) return 'Applicant Other Details';
    return 'Applicant Personal Details';
  }

  void _nextSection() {
    setState(() {
      if (isMovingForward) {
         if (_getCurrentFormKey().currentState!.validate()) {
          if (isPersonalFormVisible) {
            isPersonalFormVisible = false;
            isOtherFormVisible = true;
          } else if (isOtherFormVisible) {
            isOtherFormVisible = false;
            isPerformanceFormVisible = true;
          }
         }
      } else {
        if (isPerformanceFormVisible) {
          isPerformanceFormVisible = false;
          isOtherFormVisible = true;
        } else if (isOtherFormVisible) {
          isOtherFormVisible = false;
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
    final genderData = jsonDecode(genderController.text);
    final selectedGenderCodeId = genderData['codeId'];
    final selectedGenderCodeDesc = genderData['codeDesc'];
    final relationData = jsonDecode(relationController.text);
    final selectedRelationCodeId = relationData['codeId'];
    final selectedRelationCodeDesc = relationData['codeDesc'];
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EventPerformanceVerificationPage(
        applicantName: nameController.text,
        applicantRelationType: selectedRelationCodeDesc,
        applicantRelationId: selectedRelationCodeId,
        applicationRelativeName: relativeNameController.text,
        applicantGender: selectedGenderCodeDesc,
        applicantGenderId: selectedGenderCodeId,
        applicantDateOfBirth: dateDobController.text,
        applicantAge: ageController.text,
        applicantEmail: emailController.text,
        applicantMobile: mobileController.text,
        orgName: organizationNameController.text,
        criminal: criminalController.text,
        convicted: convictedController.text,
        preceeding: preceedingController.text,
        blacklisted: blacklistedController.text,
        eventPerformanceType: eventPerformanceTypeController.text,//eventtype dropdown from master table 
        startDate: startDateController.text,
        endDate: endDateController.text,
        briefDescription: briefDescriptionController.text,
        fireClearance: fireClearanceController.text,
        startHours: startHoursController.text,
        expectedHours: expectedHoursController.text,
        startMinutes: startMinutesController.text,
        expectedMinutes: expectedMinutesController.text,
        isCriminal: _criminalChanged,
        isConvicted: _convictedChanged,
        isPreceeding: _preceedingChanged,
        isBlacklisted: _blacklistedChanged,
        selectedState: selectedState,
      ),
    ));
  }
}
