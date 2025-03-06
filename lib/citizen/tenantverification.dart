import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:himcops/controller/tenant_controller/tenantaffidavit.dart';
import 'package:himcops/controller/tenant_controller/tenantpersonaldetails.dart';
import 'package:himcops/controller/tenant_controller/tenantverify.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/layout/backgroundlayout.dart';

class TenantVerificationPage extends StatefulWidget {
  const TenantVerificationPage({super.key});

  @override
  State<TenantVerificationPage> createState() => _TenantVerificationPageState();
}

class _TenantVerificationPageState extends State<TenantVerificationPage> {
  final _personalFormKey = GlobalKey<FormState>();
  final _affidavitFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController dateDobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController relationController = TextEditingController();
  TextEditingController relativeNameController = TextEditingController();
  TextEditingController affidavitController = TextEditingController();
  TextEditingController tOccupationController = TextEditingController();
  TextEditingController tenancyController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController commercialDetailsController = TextEditingController();

  bool isPersonalFormVisible = true;
  bool isAffidavitFormVisible = false;
  bool isMovingForward = true;
  bool _criminalChanged = false;

  String selectedState = 'HIMACHAL PRADESH';
  String selectedTenancy = '';

  @override
  void initState() {
    super.initState();
    
    // Ensure tenancyController.text stores 'Commercial' or 'Residential'
    if (tenancyController.text == 'C') {
      tenancyController.text = 'Commercial';
    } else if (tenancyController.text == 'R') {
      tenancyController.text = 'Residential';
    }

    selectedTenancy = tenancyController.text; // Assign correct value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tenant Verification Request',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 100, 233),
        iconTheme: const IconThemeData(color: Colors.white),
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
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
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
                        style: const TextStyle(color: Color(0xFF133371), fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      const Text('All fields are mandatory', style: TextStyle(color: Colors.red, fontSize: 12)),
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
                          commercialDetailsController: commercialDetailsController,
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                backgroundColor: const Color(0xFF133371),
                child: const Text('Next', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          Visibility(
            visible: !isPersonalFormVisible,
            child: Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _verifyDetails,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                backgroundColor: const Color(0xFF133371),
                child: const Text('Next', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GlobalKey<FormState> _getCurrentFormKey() {
    return isAffidavitFormVisible ? _affidavitFormKey : _personalFormKey;
  }

  String _getFormTitle() {
    return isAffidavitFormVisible ? 'Affidavit Information' : 'Tenant Personal Details';
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
    // Ensure tenancyController.text contains valid value before navigating
    if (tenancyController.text == 'C') {
      tenancyController.text = 'Commercial';
    } else if (tenancyController.text == 'R') {
      tenancyController.text = 'Residential';
    }

    selectedTenancy = tenancyController.text;

    // Extract necessary values from controllers
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
        commercial: commercialDetailsController.text,
        selectedTenancy: selectedTenancy,
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
