import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:himcops/controller/domestic_controller/dmvaffidavit.dart';
import 'package:himcops/controller/tenant_controller/tenantaffidavit.dart';
// import 'package:himcops/controller/domestic_controller/dmvotherdetails.dart';
// import 'package:himcops/controller/tenant_controller/tenantaddressdetails.dart';
// import 'package:himcops/controller/tenant_controller/tenantownerdetails.dart';
import 'package:himcops/controller/tenant_controller/tenantpersonaldetails.dart';
import 'package:himcops/controller/tenant_controller/tenantverify.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/layout/backgroundlayout.dart';
// import 'package:himcops/layout/formlayout.dart';

class TenantVerificationPage extends StatefulWidget {
  const TenantVerificationPage({super.key});

  @override
  State<TenantVerificationPage> createState() => _TenantVerificationPageState();
}

class _TenantVerificationPageState extends State<TenantVerificationPage> {
  final _personalFormKey = GlobalKey<FormState>();
  final _affidavitFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final TextEditingController dateDobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController relationController = TextEditingController();
  TextEditingController relativeNameController = TextEditingController();
  TextEditingController paddressController = TextEditingController();
  TextEditingController pcountryController = TextEditingController();
  TextEditingController pstateController = TextEditingController();
  TextEditingController pdistrictController = TextEditingController();
  TextEditingController ppoliceStationController = TextEditingController();
  TextEditingController aCountryController = TextEditingController();
  TextEditingController aStateController = TextEditingController();
  TextEditingController aDistrictController = TextEditingController();
  TextEditingController aPoliceStationController = TextEditingController();
  TextEditingController affidavitController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController oAddressController = TextEditingController();
  TextEditingController oCountryController = TextEditingController();
  TextEditingController oStateController = TextEditingController();
  TextEditingController oDistrictController = TextEditingController();
  TextEditingController oPoliceStationController = TextEditingController();
  TextEditingController tOccupationController = TextEditingController();
  TextEditingController tenancyController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController oNameController = TextEditingController();

  // bool isOwnerFormVisible = true;
  bool isPersonalFormVisible = true;
  String selectedState = 'HIMACHAL PRADESH';
  // bool isAddressFormVisible = false;
  // bool isOtherDetailsFormVisible = false;
  bool isAffidavitFormVisible = false;
  bool isChecked = true;

  bool _criminalChanged = false;
  bool isMovingForward = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text(
          'Tenant Verification Request',
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
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 233, 240, 221),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  ),
                ],
              ),
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
                        TenantDetailsFormPage(
                          nameController: nameController,
                          tOccupationController: tOccupationController,
                          ageController: ageController,
                          genderController: genderController,
                          dateDobController: dateDobController,
                          relationController: relationController,
                          relativeNameController: relativeNameController,
                          tenancyController: tenancyController,
                        ),
                      if (isAffidavitFormVisible)
                        TenantaffidavitForm(
                          affidavitController: affidavitController,
                          onCriminalStatusChanged: (bool value) {
                            _criminalChanged = value;
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isAffidavitFormVisible,
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
            visible: !isPersonalFormVisible,
            child: Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _verifyDetails,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                backgroundColor: Colors.yellow[700],
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
    if (isAffidavitFormVisible) return _affidavitFormKey;
    return _personalFormKey;
  }

  String _getFormTitle() {
    if (isAffidavitFormVisible) return 'Affidavit Information';
    return 'Tenant Personal Details';
  }

  void _nextSection() {
    setState(() {
      if (isMovingForward) {
        if (_getCurrentFormKey().currentState!.validate()) {
          if (isPersonalFormVisible) {
            isPersonalFormVisible = false;
            isAffidavitFormVisible = true;
          }
        }
      } else {
        if (isAffidavitFormVisible) {
          isAffidavitFormVisible = false;
          isPersonalFormVisible = true;
        }
      }

      if (isAffidavitFormVisible) {
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
    final occupationData = jsonDecode(tOccupationController.text);
    final selectedOccupationCodeId = occupationData['codeId'];
    final selectedOccupationCodeDesc = occupationData['codeDesc'];
    final relationData = jsonDecode(relationController.text);
    final selectedRelationCodeId = relationData['codeId'];
    final selectedRelationCodeDesc = relationData['codeDesc'];
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TvrVerificationPage(
        name: nameController.text,
        dateOfBirth: dateDobController.text,
        gender: selectedGenderCodeDesc,
        relation: selectedRelationCodeDesc,
        relationId: selectedRelationCodeId,
        relativeName: relativeNameController.text,
        affidavit: affidavitController.text,
        tenantOccupation: selectedOccupationCodeDesc,
        isCriminal: _criminalChanged,
        tenantId: selectedOccupationCodeId,
        genderId: selectedGenderCodeId,
        tenancy: tenancyController.text,
        age: ageController.text,
        selectedState: selectedState,
      ),
    ));
  }
}
