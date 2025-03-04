import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  // bool isCompFormVisible = false;
  bool isPersonalFormVisible = true;
  // bool isAddressFormVisible = false;
  bool isIncidentFormVisible = false; 
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
        title: const Text('Add Complaint',
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
                      if (isIncidentFormVisible)
                        ComplaintIncidentDetailsForm(
                          incidentDateTimeFromController:
                              incidentDateTimeFromController,
                          incidentDateTimeToController:
                              incidentDateTimeToController,
                          incidentPlaceController: incidentPlaceController,
                          dateController: dateController,
                          complaintDescriptionController:
                              complaintDescriptionController,
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
            visible: !isIncidentFormVisible,
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
                    const Text('Verify', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GlobalKey<FormState> _getCurrentFormKey() {
    if (isIncidentFormVisible) return _incidentFormKey;

    return _personalFormKey;
  }

  String _getFormTitle() {
    if (isIncidentFormVisible) return 'Incident Details';
    return 'Complainant Personal Details';
  }

  void _nextSection() {
    setState(() {
      if (isMovingForward) {
        if (_getCurrentFormKey().currentState!.validate()) {
          if (isPersonalFormVisible) {
            isPersonalFormVisible = false;
            isIncidentFormVisible = true;
          }
        }
      } else {
        if (isIncidentFormVisible) {
          isIncidentFormVisible = false;
          isPersonalFormVisible = true;
        }
      }

      if (isIncidentFormVisible) {
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
        selectedState: selectedState,

      ),
    ));
  }
}
