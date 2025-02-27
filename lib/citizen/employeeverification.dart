import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:himcops/controller/employee_controller/empaffidavit.dart';
import 'package:himcops/controller/employee_controller/empbasicdetails.dart';
import 'package:himcops/controller/employee_controller/empverify.dart';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/drawer/drawer.dart';

class EmployeeVerificationPage extends StatefulWidget {
  const EmployeeVerificationPage({super.key});

  @override
  State<EmployeeVerificationPage> createState() =>
      _EmployeeVerificationPageState();
}

class _EmployeeVerificationPageState extends State<EmployeeVerificationPage> {
  final _basicFormKey = GlobalKey<FormState>();
  final _empAffidavitFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController dateDobController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController placeBirthController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController employeeAffidavitController =
      TextEditingController();
  final TextEditingController employeeAddressVerificationController =
      TextEditingController();
  final TextEditingController employeePoliceStationController =
      TextEditingController();
  final TextEditingController docController = TextEditingController();

  bool isPersonalFormVisible = false;
  bool isAddressFormVisible = false;
  bool isRelativeAddressFormVisible = false;
  bool isCurrentEmployerFormVisible = false;

  bool isOtherDetailsFormVisible = false;
  bool isbasicDetailsFormVisible = true;
  bool isEmpAffidavitDetailsFormVisible = false;
  bool isMovingForward = true;
  bool _criminalChanged = false;
  bool isChecked = false;
  String selectedCountry = 'INDIA';

  String selectedState = 'HIMACHAL PRADESH';
  String? presentStateCode;
  String? presentDistrictCode;
  String? presentPoliceStationCode;
  String? employerStateCode;
  String? employerDistrictCode;
  String? employerPoliceStationCode;
  String? permanentStateCode;
  String? permanentDistrictCode;
  String? permanentPoliceStationCode;
  String? relativeStateCode;
  String? relativeDistrictCode;
  String? relativePoliceStationCode;

  // ignore: unused_element
  void _showWarning(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee Verification',
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
                      if (isbasicDetailsFormVisible)
                        EmployeeBasicDetailsForm(
                          departmentController: departmentController,
                          dateController: dateController,
                          nameController: nameController,
                          genderController: genderController,
                          dateDobController: dateDobController,
                          ageController: ageController,
                          placeBirthController: placeBirthController,
                          employeeAddressVerificationController:
                              employeeAddressVerificationController,
                          docController: docController,
                        ),
                      if (isEmpAffidavitDetailsFormVisible)
                        EmpAffidavitForm(
                          employeeAffidavitController:
                              employeeAffidavitController,
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
            visible: !isEmpAffidavitDetailsFormVisible,
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
            visible: !isbasicDetailsFormVisible,
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
    if (isEmpAffidavitDetailsFormVisible) return _empAffidavitFormKey;
    return _basicFormKey;
  }

  String _getFormTitle() {
    if (isEmpAffidavitDetailsFormVisible) return 'Employee Affidavit';
    return 'Employee Basic Details';
  }

  void _nextSection() {
    setState(() {
      if (isMovingForward) {
        if (_getCurrentFormKey().currentState!.validate()) {
          if (isbasicDetailsFormVisible) {
            isbasicDetailsFormVisible = false;
            isEmpAffidavitDetailsFormVisible = true;
          }
        }
      } else {
        if (isEmpAffidavitDetailsFormVisible) {
          isEmpAffidavitDetailsFormVisible = false;
          isbasicDetailsFormVisible = true;
        }
      }

      if (isEmpAffidavitDetailsFormVisible) {
        isMovingForward = false;
      } else if (isbasicDetailsFormVisible) {
        isMovingForward = true;
      }
    });
  }

  void _verifyDetails() {
    final genderData = jsonDecode(genderController.text);
    final selectedGenderCodeId = genderData['codeId'];
    final selectedGenderCodeDesc = genderData['codeDesc'];
    final employeeAddressVerificationControllerData =
        jsonDecode(employeeAddressVerificationController.text);
    final selectedAddressCodeId =
        employeeAddressVerificationControllerData['codeId'];
    final selectedAddressCodeDesc =
        employeeAddressVerificationControllerData['codeDesc'];
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EmpVerificationPage(
        name: nameController.text,
        gender: genderController.text,
        dateOfBirth: dateDobController.text,
        age: ageController.text,
        placeBirth: placeBirthController.text,
        department: departmentController.text,
        employeeAffidavit: employeeAffidavitController.text,
        employeeAddressVerification: employeeAddressVerificationController.text,
        employeePoliceStation: employeePoliceStationController.text,
        documentNo: docController.text,
        applicationDate: dateController.text,
        isCriminal: _criminalChanged,
        isChecked: isChecked,
        selectedCountry: selectedCountry,
        selectedState: selectedState,
        genderId: selectedGenderCodeId,
        genderDescription: selectedGenderCodeDesc,
        addressId: selectedAddressCodeId,
        addressDescription: selectedAddressCodeDesc,
      ),
    ));
  }
}
