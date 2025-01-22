import 'package:flutter/material.dart';
import 'package:himcops/controller/domestic_controller/dmvaffidavit.dart';
import 'package:himcops/controller/domestic_controller/dmvotherdetails.dart';
import 'package:himcops/controller/tenant_controller/tenantaddressdetails.dart';
import 'package:himcops/controller/tenant_controller/tenantownerdetails.dart';
import 'package:himcops/controller/tenant_controller/tenantpersonaldetails.dart';
import 'package:himcops/controller/tenant_controller/tenantverify.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/layout/formlayout.dart';

class TenantVerificationPage extends StatefulWidget {
  const TenantVerificationPage({super.key});

  @override
  State<TenantVerificationPage> createState() => _TenantVerificationPageState();
}

class _TenantVerificationPageState extends State<TenantVerificationPage> {
  final _personalFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();
  final _ownerFormKey = GlobalKey<FormState>();
  final _otherFormKey = GlobalKey<FormState>();
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

  bool isOwnerFormVisible = true;
  bool isPersonalFormVisible = false;
  bool isAddressFormVisible = false;
  bool isOtherDetailsFormVisible = false;
  bool isAffidavitFormVisible = false;
  bool isChecked = true;
  bool isMovingForward = true;
  bool _filesUploaded = false;
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
        title: const Text('Tenant Verification Request'),
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
                      if (isOwnerFormVisible)
                        TenantOwnerDetailsFormPage(
                          oNameController: oNameController,
                          occupationController: occupationController,
                          oAddressController: oAddressController,
                          mobileController: mobileController,
                          emailController: emailController,
                          oCountryController: oCountryController,
                          oStateController: oStateController,
                          oDistrictController: oDistrictController,
                          oPoliceStationController: oPoliceStationController,
                        ),
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
                      if (isAddressFormVisible)
                        TenentAddressDetailsForm(
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
                      if (isOtherDetailsFormVisible)
                        OtherDetailsForm(
                          onFilesUploaded: (uploaded) {
                            setState(() {
                              _filesUploaded = uploaded;
                            });
                          },
                          onPhotoUploaded: (fileName) {
                            onPhotoUploadedFileName = fileName;
                          },
                          onDocumentUploaded: (fileName) {
                            onDocumentUploadedFileName = fileName;
                          },
                        ),
                      if (isAffidavitFormVisible)
                        AffidavitForm(
                          affidavitController: affidavitController, onCriminalStatusChanged: (bool value) {  },
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
            visible: !isOwnerFormVisible && !isPersonalFormVisible &&
                !isAddressFormVisible &&
                !isOtherDetailsFormVisible,
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
    if (isAffidavitFormVisible) return _affidavitFormKey;
    if (isOtherDetailsFormVisible) return _otherFormKey;
    if (isAddressFormVisible) return _addressFormKey;
    if (isPersonalFormVisible) return _personalFormKey;
    return _ownerFormKey;
  }

  String _getFormTitle() {
    if (isAffidavitFormVisible) return 'Affidavit Information';
    if (isOtherDetailsFormVisible) return 'Tenant Document Upload';
    if (isAddressFormVisible) return 'Tenant Address Details';
    if (isPersonalFormVisible) return 'Tenant Personal Details';
    return 'Owner Details';
  }

  void _nextSection() {
    setState(() {
      if (isMovingForward) {
        if (_getCurrentFormKey().currentState!.validate()) {
          if (isOwnerFormVisible) {
            isOwnerFormVisible = false;
            isPersonalFormVisible = true;
          } else if (isPersonalFormVisible) {
            isPersonalFormVisible = false;
            isAddressFormVisible = true;
          } else if (isAddressFormVisible) {
            isAddressFormVisible = false;
            isOtherDetailsFormVisible = true;
          } else if (isOtherDetailsFormVisible) {
            if (!_filesUploaded) {
              _showWarning(
                  'Please upload both the photo and identification document.');
              return;
            }
            isOtherDetailsFormVisible = false;
            isAffidavitFormVisible = true;
          }
        }
      } else {
        if (isAffidavitFormVisible) {
          isAffidavitFormVisible = false;
          isOtherDetailsFormVisible = true;
        } else if (isOtherDetailsFormVisible) {
          isOtherDetailsFormVisible = false;
          isAddressFormVisible = true;
        } else if (isAddressFormVisible) {
          isAddressFormVisible = false;
          isPersonalFormVisible = true;
        } else if (isPersonalFormVisible) {
          isPersonalFormVisible = false;
          isOwnerFormVisible = true;
        }
      }

      if (isAffidavitFormVisible) {
        isMovingForward = false;
      } else if (isOwnerFormVisible) {
        isMovingForward = true;
      }
    });
  }

  void _verifyDetails() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => tvrVerificationPage(
        name: nameController.text,
        dateOfBirth: dateDobController.text,
        gender: genderController.text,
        relation: relationController.text,
        relativeName: relativeNameController.text,
        affidavit: affidavitController.text,
        email: emailController.text,
        mobile: mobileController.text,
        ownerOccupation: occupationController.text,
        ownerAddress: oAddressController.text,
        ownerCountry: oCountryController.text,
        ownerState: oStateController.text,
        ownerDistrict: oDistrictController.text,
        ownerPoliceStation: oPoliceStationController.text,
        ownerName: oNameController.text,
        tenantOccupation: tOccupationController.text,
        tenancy: tenancyController.text,
        age: ageController.text,
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
        photoFileName: '$onPhotoUploadedFileName',
        documentFileName: '$onDocumentUploadedFileName',
      ),
    ));
  }
}
