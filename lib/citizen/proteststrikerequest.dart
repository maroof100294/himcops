import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:himcops/controller/protest_strike_controller/applicantpersonaldetails.dart';
import 'package:himcops/controller/protest_strike_controller/protestdetails.dart';
import 'package:himcops/controller/protest_strike_controller/protestverify.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/layout/formlayout.dart';

class ProtestStrikeRequestPage extends StatefulWidget {
  const ProtestStrikeRequestPage({super.key});

  @override
  State<ProtestStrikeRequestPage> createState() =>
      _ProtestStrikeRequestPageState();
}

class _ProtestStrikeRequestPageState extends State<ProtestStrikeRequestPage> {
  final _personalFormKey = GlobalKey<FormState>();
  final _protestFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController relationController = TextEditingController();
  TextEditingController relativeNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dateDobController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
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
  TextEditingController orgNameController = TextEditingController();
  TextEditingController orgAddressController = TextEditingController();
  TextEditingController orgCountryController = TextEditingController();
  TextEditingController orgStateController = TextEditingController();
  TextEditingController orgDistrictController = TextEditingController();
  TextEditingController orgPoliceStationController = TextEditingController();
  TextEditingController instituteNameController = TextEditingController();
  TextEditingController protestTypeController = TextEditingController();
  TextEditingController briefDescriptionController = TextEditingController();
  TextEditingController startAddressController = TextEditingController();
  TextEditingController startCountryController = TextEditingController();
  TextEditingController startStateController = TextEditingController();
  TextEditingController startDistrictController = TextEditingController();
  TextEditingController startPoliceStationController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startHoursController = TextEditingController();
  TextEditingController startMinutesController = TextEditingController();
  TextEditingController expectedHoursController = TextEditingController();
  TextEditingController expectedMinutesController = TextEditingController();
  TextEditingController locationNameController = TextEditingController();
  TextEditingController locationAreaController = TextEditingController();
  TextEditingController locationNumberController = TextEditingController();
  TextEditingController structureNatureController = TextEditingController();

  bool isPersonalFormVisible = true;
  bool isProtestFormVisible = false;
  String selectedState = 'HIMACHAL PRADESH';
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
      appBar: AppBar(
        title: const Text(
          'Protest Strike Request',
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
                        ProtestApplicantPersonalDetailsForm(
                          nameController: nameController,
                          ageController: ageController,
                          genderController: genderController,
                          dateDobController: dateDobController,
                          relationController: relationController,
                          relativeNameController: relativeNameController,
                          emailController: emailController,
                          mobileController: mobileController,
                        ),
                      if (isProtestFormVisible)
                        ProtestDetailsForm(
                          instituteNameController: instituteNameController,
                          protestTypeController: protestTypeController,
                          briefDescriptionController:
                              briefDescriptionController,
                          startDateController: startDateController,
                          endDateController: endDateController,
                          startHoursController: startHoursController,
                          startMinutesController: startMinutesController,
                          expectedHoursController: expectedHoursController,
                          expectedMinutesController: expectedMinutesController,
                          locationAreaController: locationAreaController,
                          locationNumberController: locationNumberController,
                          structureNatureController: structureNatureController,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isProtestFormVisible,
            child: Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _nextSection,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: const Color(0xFF133371),
                child:
                    const Text('Next', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Visibility(
            visible: !isPersonalFormVisible,
            child: Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _verifyDetails,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                backgroundColor: const Color(0xFF133371),
                child:
                    const Text('Next', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GlobalKey<FormState> _getCurrentFormKey() {
    if (isProtestFormVisible) return _protestFormKey;
    return _personalFormKey;
  }

  String _getFormTitle() {
    if (isProtestFormVisible) return 'Protest Strike Details';
    return 'Applicant Personal Details';
  }

  void _nextSection() {
    setState(() {
      if (isMovingForward) {
        if (_getCurrentFormKey().currentState!.validate()) {
          if (isPersonalFormVisible) {
            isPersonalFormVisible = false;
            isProtestFormVisible = true;
          }
        }
      } else {
        if (isProtestFormVisible) {
          isProtestFormVisible = false;
          isPersonalFormVisible = true;
        }
      }

      if (isProtestFormVisible) {
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
    final strikeData = jsonDecode(protestTypeController.text);
    final selectedStrikeCodeId = strikeData['codeId'];
    final selectedStrikeCodeDesc = strikeData['codeDesc'];
    setState(() {
      if (_getCurrentFormKey().currentState!.validate()) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProtestVerificationPage(
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
            briefDescription: briefDescriptionController.text,
            structureNature: structureNatureController.text,
            protestType: selectedStrikeCodeDesc,
            protestStrikeId: selectedStrikeCodeId,
            startDate: startDateController.text,
            endDate: endDateController.text,
            locationArea: locationAreaController.text,
            locationNumber: locationNumberController.text,
            instituteName: instituteNameController.text,
            startHours: startHoursController.text,
            expectedHours: expectedHoursController.text,
            startMinutes: startMinutesController.text,
            expectedMinutes: expectedMinutesController.text,
            selectedState: selectedState,
          ),
        ));
      }
    });
  }
}
