import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:himcops/controller/domestic_controller/dmvaffidavit.dart';
import 'package:himcops/controller/domestic_controller/dmvpersonaldetails.dart';
import 'package:himcops/controller/domestic_controller/dmvverify.dart';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/layout/formlayout.dart';

class DomesticHelpVerificationPage extends StatefulWidget {
  const DomesticHelpVerificationPage({super.key});

  @override
  State<DomesticHelpVerificationPage> createState() =>
      _DomesticHelpVerificationPageState();
}

class _DomesticHelpVerificationPageState
    extends State<DomesticHelpVerificationPage> {
  final _personalFormKey = GlobalKey<FormState>();
  final _otherFormKey = GlobalKey<FormState>();
  final _affidavitFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController dateDobController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController languageSpokenController = TextEditingController();
  TextEditingController relationTypeController = TextEditingController();
  TextEditingController relativeController = TextEditingController();
  TextEditingController placeBirthController = TextEditingController();
  TextEditingController affidavitController = TextEditingController();

  bool isPersonalFormVisible = true;
  bool isOtherDetailsFormVisible = false;
  bool isAffidavitFormVisible = false;
  bool _criminalChanged = false;
  bool _workedChanged = false;
  bool isChecked = false;
  String selectedCountry = 'INDIA';
  bool isMovingForward = true;
  String? onPhotoUploadedFileName;
  String? onDocumentUploadedFileName;

  void _showWarning(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Domestic Helper Verification',
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
                        PersonalDetailsForm(
                          nameController: nameController,
                          genderController: genderController,
                          dateController: dateController,
                          dateDobController: dateDobController,
                          ageController: ageController,
                          countryController: countryController,
                          languageSpokenController: languageSpokenController,
                          relationTypeController: relationTypeController,
                          relativeController: relativeController,
                          placeBirthController: placeBirthController,
                          
                        ),
                     
                      if (isAffidavitFormVisible)
                        AffidavitForm(
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
    if (isAffidavitFormVisible) return _affidavitFormKey;
    if (isOtherDetailsFormVisible) return _otherFormKey;
    return _personalFormKey;
  }

  String _getFormTitle() {
    if (isAffidavitFormVisible) return 'Affidavit Information';
    if (isOtherDetailsFormVisible) return 'Other Details';
    return 'Helper Personal Details';
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
    final relationTypeData = jsonDecode(relationTypeController.text);
    final selectedRelationCodeId = relationTypeData['codeId'];
    final selectedRelationCodeDesc = relationTypeData['codeDesc'];
    final languagesData = jsonDecode(languageSpokenController.text);
    final selectedLanguagesCodeId = languagesData['codeId'];
    final selectedLanguagesCodeDesc = languagesData['codeDesc'];
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DmvVerificationPage(
        name: nameController.text,
        applicationDate: dateController.text,
        dateofBirth: dateDobController.text,
        age: ageController.text,
        gender: genderController.text,
        country: countryController.text,
        languageSpoken: languageSpokenController.text,
        relationType: relationTypeController.text,
        relativeName: relativeController.text,
        placeBirth: placeBirthController.text,
        affidavit: affidavitController.text,
        isCriminal: _criminalChanged,
        isChecked: isChecked,
        isWorked: _workedChanged,
        selectedCountry: selectedCountry,
        genderId: selectedGenderCodeId,
        genderDescription: selectedGenderCodeDesc,
        relationId: selectedRelationCodeId,
        relationDescription: selectedRelationCodeDesc,
        languagesId: selectedLanguagesCodeId,
        languagesDescription: selectedLanguagesCodeDesc,
      ),
    ));
  }
}
