import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:himcops/controller/police_clearance_controller/pccaffidavitdetails.dart';
import 'package:himcops/controller/police_clearance_controller/pccpersonaldetails.dart';
import 'package:himcops/controller/police_clearance_controller/pccverify.dart';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/drawer/drawer.dart';

class PoliceClearanceCertificatePage extends StatefulWidget {
  const PoliceClearanceCertificatePage({super.key});

  @override
  State<PoliceClearanceCertificatePage> createState() =>
      _PoliceClearanceCertificatePageState();
}

class _PoliceClearanceCertificatePageState
    extends State<PoliceClearanceCertificatePage> {
  // ignore: non_constant_identifier_names
  final _PccAffidavitDetailsFormKey = GlobalKey<FormState>();
  final _personalFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController relationTypeController = TextEditingController();
  final TextEditingController descriptionServiceController =
      TextEditingController();
  final TextEditingController relativeNameController = TextEditingController();
  final TextEditingController modeReceivingController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dateDobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aCountryController = TextEditingController();
  final TextEditingController paddressController = TextEditingController();
  final TextEditingController pcountryController = TextEditingController();
  final TextEditingController affidavitController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  bool isPersonalFormVisible = true;
  bool isAddressFormVisible = false;
  bool ispccAffidavitDetailsFormVisible = false;
  bool isMovingForward = true;
  bool _criminalChanged = false;
  bool isChecked = false;
  String? onPhotoUploadedFileName;
  String? onDocumentUploadedFileName;
  String selectedCountry = 'INDIA';
  String? onStateSelected;
  String? onDistrictSelected;
  String? onPoliceStationSelected;
  String? presentStateCode;
  String? presentDistrictCode;
  String? presentPoliceStationCode;
  String? permanentStateCode;
  String? permanentDistrictCode;
  String? permanentPoliceStationCode;
  String? presentStateDesc;
  String? presentDistrictDesc;
  String? presentPoliceStationDesc;
  String? permanentStateDesc;
  String? permanentDistrictDesc;
  String? permanentPoliceStationDesc;

  // ignore: unused_element
  void _showWarning(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Police Clearance Certificate',
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
                        PccPersonalDetailsForm(
                          nameController: nameController,
                          pccRelationTypeController: relationTypeController,
                          pccDescriptionServiceController:
                              descriptionServiceController,
                          pccRelativeNameController: relativeNameController,
                          pccModeReceivingController: modeReceivingController,
                          genderController: genderController,
                          dateDobController: dateDobController,
                          ageController: ageController,
                        ),
                      if (ispccAffidavitDetailsFormVisible)
                        PccAffidavitDetailsForm(
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
            visible: !ispccAffidavitDetailsFormVisible,
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
    if (ispccAffidavitDetailsFormVisible) return _PccAffidavitDetailsFormKey;
    return _personalFormKey;
  }

  String _getFormTitle() {
    if (ispccAffidavitDetailsFormVisible) return 'Affidavit Details';
    return 'Personal Information';
  }

  void _nextSection() {
    setState(() {
      if (isMovingForward) {
        if (_getCurrentFormKey().currentState!.validate()) {
        if (isPersonalFormVisible) {
          isPersonalFormVisible = false;
          ispccAffidavitDetailsFormVisible = true;
        }
        }
      } else {
        if (ispccAffidavitDetailsFormVisible) {
          ispccAffidavitDetailsFormVisible = false;
          isPersonalFormVisible = true;
        }
      }

      if (ispccAffidavitDetailsFormVisible) {
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
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => VerificationPage(
        name: nameController.text,
        relationType: relationTypeController.text,
        descriptionService: descriptionServiceController.text,
        relativeName: relativeNameController.text,
        modeReceiving: modeReceivingController.text,
        gender: genderController.text,
        dateOfBirth: dateDobController.text,
        age: ageController.text,
        affidavitDetails: affidavitController.text,
        isCriminal: _criminalChanged,
        isChecked: isChecked,
        selectedCountry: selectedCountry,
        genderId: selectedGenderCodeId,
        genderDescription: selectedGenderCodeDesc,
        relationId: selectedRelationCodeId,
        relationDescription: selectedRelationCodeDesc,
      ),
    ));
  }
}
