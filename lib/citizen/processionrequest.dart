import 'package:flutter/material.dart';
import 'package:himcops/controller/procession_controller/applicantaddressdetails.dart';
import 'package:himcops/controller/procession_controller/applicantpersonaldetails.dart';
import 'package:himcops/controller/procession_controller/organizationdetails.dart';
import 'package:himcops/controller/procession_controller/processiondetails.dart';
import 'package:himcops/controller/procession_controller/processionverify.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/layout/formlayout.dart';

class ProcessionRequestPage extends StatefulWidget {
  const ProcessionRequestPage({super.key});

  @override
  State<ProcessionRequestPage> createState() => _ProcessionRequestPageState();
}

class _ProcessionRequestPageState extends State<ProcessionRequestPage> {
  final _personalFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();
  final _orgFormKey = GlobalKey<FormState>();
  final _processionFormKey = GlobalKey<FormState>();

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
  TextEditingController processionTypeController = TextEditingController();
  TextEditingController briefDescriptionController = TextEditingController();
  TextEditingController majorParticipantNameController =
      TextEditingController();
  TextEditingController majorAddressController = TextEditingController();
  TextEditingController majorCountryController = TextEditingController();
  TextEditingController majorStateController = TextEditingController();
  TextEditingController majorDistrictController = TextEditingController();
  TextEditingController majorPoliceStationController = TextEditingController();
  TextEditingController startAddressController = TextEditingController();
  TextEditingController startCountryController = TextEditingController();
  TextEditingController startStateController = TextEditingController();
  TextEditingController startDistrictController = TextEditingController();
  TextEditingController startPoliceStationController = TextEditingController();
  TextEditingController endAddressController = TextEditingController();
  TextEditingController endCountryController = TextEditingController();
  TextEditingController endStateController = TextEditingController();
  TextEditingController endDistrictController = TextEditingController();
  TextEditingController endPoliceStationController = TextEditingController();
  TextEditingController otherAddressController = TextEditingController();
  TextEditingController otherCountryController = TextEditingController();
  TextEditingController otherStateController = TextEditingController();
  TextEditingController otherDistrictController = TextEditingController();
  TextEditingController otherPoliceStationController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController processionNumberController = TextEditingController();
  TextEditingController startHoursController = TextEditingController();
  TextEditingController expectedHoursController = TextEditingController();
  TextEditingController startMinutesController = TextEditingController();
  TextEditingController expectedMinutesController = TextEditingController();

  bool isOrgFormVisible = false;
  bool isPersonalFormVisible = true;
  bool isAddressFormVisible = false;
  bool isProcessionFormVisible = false;
  bool isChecked = true;
  bool isMovingForward = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Procession Request'),
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
                        ApplicantPersonalDetailsForm(
                          nameController: nameController,
                          ageController: ageController,
                          genderController: genderController,
                          dateDobController: dateDobController,
                          relationController: relationController,
                          relativeNameController: relativeNameController,
                          emailController: emailController,
                          mobileController: mobileController,
                        ),
                      if (isAddressFormVisible)
                        ApplicantAddressDetailsForm(
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
                      if (isOrgFormVisible)
                        ApplicantOrganizationDetailsForm(
                          orgNameController: orgNameController,
                          orgAddressController: orgAddressController,
                          orgCountryController: orgCountryController,
                          orgStateController: orgStateController,
                          orgDistrictController: orgDistrictController,
                          orgPoliceStationController:
                              orgPoliceStationController,
                        ),
                      if (isProcessionFormVisible)
                        ProcessionDetailsForm(
                          processionTypeController: processionTypeController,
                          briefDescriptionController:
                              briefDescriptionController,
                          majorParticipantNameController:
                              majorParticipantNameController,
                          majorAddressController: majorAddressController,
                          majorCountryController: majorCountryController,
                          majorStateController: majorStateController,
                          majorDistrictController: majorDistrictController,
                          majorPoliceStationController:
                              majorPoliceStationController,
                          startAddressController: startAddressController,
                          startCountryController: startCountryController,
                          startStateController: startStateController,
                          startDistrictController: startDistrictController,
                          startPoliceStationController:
                              startPoliceStationController,
                          endAddressController: endAddressController,
                          endCountryController: endCountryController,
                          endStateController: endStateController,
                          endDistrictController: endDistrictController,
                          endPoliceStationController:
                              endPoliceStationController,
                          otherAddressController: otherAddressController,
                          otherCountryController: otherCountryController,
                          otherStateController: otherStateController,
                          otherDistrictController: otherDistrictController,
                          otherPoliceStationController:
                              otherPoliceStationController,
                          startDateController: startDateController,
                          endDateController: endDateController,
                          processionNumberController:
                              processionNumberController,
                          startHoursController: startHoursController,
                          expectedHoursController: expectedHoursController,
                          startMinutesController: startMinutesController,
                          expectedMinutesController: expectedMinutesController,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isProcessionFormVisible,
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
                !isOrgFormVisible,
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
    if (isProcessionFormVisible) return _processionFormKey;
    if (isOrgFormVisible) return _orgFormKey;
    if (isAddressFormVisible) return _addressFormKey;
    return _personalFormKey;
  }

  String _getFormTitle() {
    if (isProcessionFormVisible) return 'Procession Details';
    if (isOrgFormVisible) return 'Organization Details';
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
            isOrgFormVisible = true;
          } else if (isOrgFormVisible) {
            isOrgFormVisible = false;
            isProcessionFormVisible = true;
          }
        }
      } else {
        if (isProcessionFormVisible) {
          isProcessionFormVisible = false;
          isOrgFormVisible = true;
        } else if (isOrgFormVisible) {
          isOrgFormVisible = false;
          isAddressFormVisible = true;
        } else if (isAddressFormVisible) {
          isAddressFormVisible = false;
          isPersonalFormVisible = true;
        }
      }

      if (isProcessionFormVisible) {
        isMovingForward = false;
      } else if (isPersonalFormVisible) {
        isMovingForward = true;
      }
    });
  }

  void _verifyDetails() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ProcessionVerificationPage(
        applicantName: nameController.text,
        applicantRelationType: relationController.text,
        applicationRelativeName: relativeNameController.text,
        applicantGender: genderController.text,
        applicantDateOfBirth: dateDobController.text,
        applicantAge: ageController.text,
        applicantEmail: emailController.text,
        applicantMobile: mobileController.text,
        orgName: orgNameController.text,
        orgAddress: orgAddressController.text,
        orgCountry: orgCountryController.text,
        orgState: orgStateController.text,
        orgDistrict: orgDistrictController.text,
        orgPoliceStation: orgPoliceStationController.text,
        processionType: processionTypeController.text,
        briefDescription: briefDescriptionController.text,
        majorParticipant: majorParticipantNameController.text,
        majorAddress: majorAddressController.text,
        majorCountry: majorCountryController.text,
        majorState: majorStateController.text,
        majorDistrict: majorDistrictController.text,
        majorPoliceStation: majorPoliceStationController.text,
        startAddress: startAddressController.text,
        startCountry: startCountryController.text,
        startState: startStateController.text,
        startDistrict: startDistrictController.text,
        startPoliceStation: startPoliceStationController.text,
        endAddress: endAddressController.text,
        endCountry: endCountryController.text,
        endState: endStateController.text,
        endDistrict: endDistrictController.text,
        endPoliceStation: endPoliceStationController.text,
        otherAddress: otherAddressController.text,
        otherCountry: otherCountryController.text,
        otherState: otherStateController.text,
        otherDistrict: otherDistrictController.text,
        otherPoliceStation: otherPoliceStationController.text,
        startDate: startDateController.text,
        endDate: endDateController.text,
        processionNumber: processionNumberController.text,
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
