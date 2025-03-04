import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:himcops/authservice.dart';
// import 'package:get/get.dart';
import 'package:himcops/citizen/searchstaus/proteststrikestatus.dart';
import 'package:himcops/config.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/layout/buttonstyle.dart';
import 'package:himcops/master/country.dart';
import 'package:himcops/master/sdp.dart';
import 'package:himcops/pages/cgridhome.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';

class ProtestVerificationPage extends StatefulWidget {
  final String applicantName;
  final String applicantRelationType;
  final String applicationRelativeName;
  final String applicantGender;
  final String applicantDateOfBirth;
  final String applicantAge;
  final String applicantEmail;
  final String applicantMobile;
  final String protestType;
  final String briefDescription;
  final String instituteName;
  final String locationNumber;
  final String locationArea;
  final String startDate;
  final String endDate;
  final String structureNature;
  final String startHours;
  final String expectedHours;
  final String startMinutes;
  final String expectedMinutes;
  final String selectedState;
  final int applicantGenderId;
  final int applicantRelationId;
  final int protestStrikeId;

  const ProtestVerificationPage({
    super.key,
    required this.applicantName,
    required this.applicantRelationType,
    required this.applicationRelativeName,
    required this.applicantGender,
    required this.applicantDateOfBirth,
    required this.applicantAge,
    required this.applicantEmail,
    required this.applicantMobile,
    required this.protestType,
    required this.briefDescription,
    required this.instituteName,
    required this.locationNumber,
    required this.startDate,
    required this.endDate,
    required this.locationArea,
    required this.structureNature,
    required this.startHours,
    required this.expectedHours,
    required this.startMinutes,
    required this.expectedMinutes,
    required this.selectedState,
    required this.applicantGenderId,
    required this.applicantRelationId,
    required this.protestStrikeId,
  });

  @override
  _ProtestVerificationPageState createState() =>
      _ProtestVerificationPageState();
}

class _ProtestVerificationPageState extends State<ProtestVerificationPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aCountryController = TextEditingController();
  final TextEditingController paddressController = TextEditingController();
  final TextEditingController pcountryController = TextEditingController();
  final TextEditingController locationNameController = TextEditingController();
  final TextEditingController startAddressController = TextEditingController();
  final TextEditingController startCountryController = TextEditingController();
  final TextEditingController orgNameController = TextEditingController();
  final TextEditingController orgAddressController = TextEditingController();
  final TextEditingController orgCountryController = TextEditingController();
  final GlobalKey<FormState> _affidavitDetailsFormKey = GlobalKey<FormState>();
  bool isAgree = false; // Checkbox state
  bool _isSubmitting = false;
  bool isChecked = false;
  int? selectedStateId;
  int? selectedDistrictId;
  String? selectedStateCode;
  String? selectedDistrictCode;
  String? selectedPoliceStationCode;
  String? permanentStateCode;
  String? permanentDistrictCode;
  String? permanentPoliceStationCode;
  String? presentStateCode;
  String? presentDistrictCode;
  String? presentPoliceStationCode;
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
    });
  }

  String? locationStateCode;
  String? locationDistrictCode;
  String? locationPoliceStationCode;
  String? orgStateCode;
  String? orgDistrictCode;
  String? orgPoliceStationCode;

  String? ValidateFullName(String value) {
    if (!RegExp(r"^[a-zA-Z\s]{1,50}$").hasMatch(value)) {
      return "Full name should only contain alphabets\nand not exceed 50 words";
    }
    return null;
  }

  String? ValidateMobile(String value) {
    if (!RegExp(r"^[0-9]{10}$").hasMatch(value)) {
      return "Mobile Number should not exceed 10 digits";
    }
    return null;
  }

  late TextEditingController applicantNameController;
  late TextEditingController applicantRelationTypeController;
  late TextEditingController applicationRelativeNameController;
  late TextEditingController applicantGenderController;
  late TextEditingController applicantDateOfBirthController;
  late TextEditingController applicantAgeController;
  late TextEditingController applicantEmailController;
  late TextEditingController applicantMobileController;
  late TextEditingController protestTypeController;
  late TextEditingController briefDescriptionController;
  late TextEditingController instituteNameController;
  late TextEditingController locationNumberController;
  late TextEditingController locationAreaController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController structureNatureController;
  late TextEditingController startHoursController;
  late TextEditingController expectedHoursController;
  late TextEditingController startMinutesController;
  late TextEditingController expectedMinutesController;

  @override
  void initState() {
    super.initState();

    applicantNameController = TextEditingController(text: widget.applicantName);
    applicantRelationTypeController =
        TextEditingController(text: widget.applicantRelationType);
    applicationRelativeNameController =
        TextEditingController(text: widget.applicationRelativeName);
    applicantGenderController =
        TextEditingController(text: widget.applicantGender);
    applicantDateOfBirthController =
        TextEditingController(text: widget.applicantDateOfBirth);
    applicantAgeController = TextEditingController(text: widget.applicantAge);
    applicantEmailController =
        TextEditingController(text: widget.applicantEmail);
    applicantMobileController =
        TextEditingController(text: widget.applicantMobile);
    protestTypeController = TextEditingController(text: widget.protestType);
    briefDescriptionController =
        TextEditingController(text: widget.briefDescription);
    instituteNameController = TextEditingController(text: widget.instituteName);
    locationNumberController =
        TextEditingController(text: widget.locationNumber);
    locationAreaController = TextEditingController(text: widget.locationArea);
    startDateController = TextEditingController(text: widget.startDate);
    endDateController = TextEditingController(text: widget.endDate);
    structureNatureController =
        TextEditingController(text: widget.structureNature);
    startHoursController = TextEditingController(text: widget.startHours);
    expectedHoursController = TextEditingController(text: widget.expectedHours);
    startMinutesController = TextEditingController(text: widget.startMinutes);
    expectedMinutesController =
        TextEditingController(text: widget.expectedMinutes);

    _fetchLoginId();
  }

  Future<void> _registerUser() async {
    final token = await AuthService.getAccessToken(); // Fetch the token

    if (token == null) {
      setState(() {
        // isLoading = false;
        // errorMessage = 'Failed to retrieve access token.';
      });
      _showErrorDialog('Technical Problem, Please Try again later');
      return;
    }
    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final client = IOClient(ioc);
      final accountUrl =
          '$baseUrl/androidapi/mobile/service/protestStrikeRequestRegistration';
      final DateTime dob = DateTime.parse(widget
          .applicantDateOfBirth); // Parse the date string into DateTime object
      final String formattedDob =
          DateFormat('dd/MM/yyyy').format(dob); // Format the DateTime object
      final DateTime startDate = DateTime.parse(
          widget.startDate); // Parse the date string into DateTime object
      final String formattedSDate = DateFormat('dd/MM/yyyy').format(startDate);
      final DateTime endDate = DateTime.parse(
          widget.endDate); // Parse the date string into DateTime object
      final String formattedEDate = DateFormat('dd/MM/yyyy').format(endDate);
      final payloadBody = {
        "userName": loginId,
        "applicant": {
          "firstName": widget.applicantName, //"Maroof Ahmed Choudhury",
          "gender": widget.applicantGenderId, //3,
          "lastName": "",
          "mobile1": "91",
          "mobile2": widget.applicantMobile, //"8473951198",
          "mRelationType": widget.applicantRelationId, //5,
          "landLine1": "91",
          "relativeName": widget.applicationRelativeName, //"sdfsdfsf",
          "email": widget.applicantEmail, //"maroofahmed04@gmail.com",
          "permanentAddressFormBean": {
            "countryCd": 80,
            "stateCd": 12,
            "districtCd": isChecked //12253
                ? int.tryParse(presentDistrictCode!)
                : int.tryParse(permanentDistrictCode!),
            "village": isChecked
                ? paddressController.text
                : addressController.text, //"per town",
            "policeStationCd": isChecked
                ? int.tryParse(presentPoliceStationCode!)
                : int.tryParse(permanentPoliceStationCode!)
          },
          "presentAddressFormBean": {
            "countryCd": 80,
            "stateCd": 12,
            "districtCd": int.tryParse(presentDistrictCode!), //12253,
            "village": paddressController.text, //"pre town",
            "policeStationCd": int.tryParse(presentPoliceStationCode!)
          }
        },
        "protestStrikeApplicant": {
          "commonPaneldateOfBirth": formattedDob, //"07/02/2007",
          "commonPanelAgeYear": widget.applicantAge
        },
        "isClickedSubmit": 0,
        "sameAsPermanant": isChecked ? 'Y' : 'N', //"Y",
        "orgName": orgNameController.text, //"SCRBgfdgfdgdf",
        "orgPhoneNo1": "91",
        "orgMobileNo1": "91",
        "organization": {
          "countryCd": 80,
          "stateCd": 12,
          "districtCd": int.tryParse(orgDistrictCode!), //12253,
          "village": orgAddressController.text, //"town",
          "policeStationCd": int.tryParse(orgPoliceStationCode!),
        },
        "protestStrikeLocationAddress": {
          "countryCd": 80,
          "stateCd": 12,
          "districtCd": int.tryParse(
              locationDistrictCode!), //12253,//issue here int.tryParse(locationDistrictCode!),
          "village": startAddressController.text, //"striketown",
          "policeStationCd":
              int.tryParse(locationPoliceStationCode!), //12253025,
          "pincode": ""
        },
        "targetInstituteOrPersonName": widget.instituteName, //"sdfsdfdsfsfs",
        "protestStartTimeHH": startHoursController.text, //"6",
        "protestStartTimeMM": startMinutesController.text, //"11",
        "targetInstituteOrPersonPhoneNo1": "91",
        "protestStrikeDesc":
            widget.briefDescription, //"erererewerwerwerfsdfdsdfsdf",
        "charLimitId33": 279,
        "targetInstituteOrPersonMobileNo1": "91",
        "charLimitId34": 100,
        "typeOfProtestStrike": widget.protestStrikeId, //2,//protest/strikeID
        "locationProtestStrikeName": locationNameController.text, //"werwerewr",
        "locationAreaDetails": widget.locationNumber, //"32",
        "startDateProtestStrikeStr": formattedSDate, //"07/02/2025",
        "typeStructurePlan": widget.structureNature, //"Temporary",
        "endDateProtestStrikeStr": formattedEDate, //"08/02/2025",
        "protestStartTimeStrHH": expectedHoursController.text, // "6",
        "protestStartTimeStrMM": expectedMinutesController.text, //"6",
        "charLimitId60": 90,
        "charLimitId29": 90,
        "charLimitId28": 90,
        "charLimitId30": 90,
        "charLimitId35": 90,
        "charLimitId61": 90,
        "charLimitId62": 90,
        "charLimitId63": 90
      };
      print('Request Body: \n${json.encode(payloadBody)}');

      final accountResponse = await client.post(
        Uri.parse(accountUrl),
        body: json.encode(payloadBody),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (accountResponse.statusCode == 200) {
        // final accountData = json.decode(accountResponse.body);
        // String mercid = accountData['data']['mercid'];
        // String bdorderid = accountData['data']['bdorderid'];
        // String rdata = accountData['data']['rdata'];
        // String token = accountData['data']['token'];
        _showConfirmationDialog();
        // print('$mercid, $bdorderid, $rdata');
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => PaymentPage(
        //       mercid: mercid,
        //       bdorderid: bdorderid,
        //       rdata: rdata,
        //       token: token,
        //     ),
        //   ),
        // );
      } else {
        print('Failed to enter${accountResponse.body},$loginId,$mobile2');
        _showErrorDialog('Please fill the details');
      }
    } catch (e) {
      setState(() {
        print('Error occurred: $e ');
        _showErrorDialog('Technical Server issue, Try again later');
      });
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing by tapping outside
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            // Navigate to CitizenGridPage when back button is pressed
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CitizenGridPage(),
              ),
            );
            return false; // Prevent dialog from closing by default behavior
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Column(
              children: [
                Image.asset(
                  'asset/images/hp_logo.png',
                  height: 50,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Himachal Pradesh',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Citizen Service',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: const Text(
                'Thank you for submitting your Verification details.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProtestStrikeStatusPage(),
                    ),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      // When dialog is dismissed (tap outside), navigate to CitizenGridPage
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const CitizenGridPage(),
        ),
      );
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing by tapping outside
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            // Navigate to CitizenHomePage when back button is pressed
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CitizenGridPage(),
              ),
            );
            return false; // Prevent dialog from closing by default behavior
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Column(
              children: [
                Image.asset(
                  'asset/images/hp_logo.png',
                  height: 50,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Himachal Pradesh',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Citizen Service',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CitizenGridPage(),
                    ),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      // When dialog is dismissed (tap outside), navigate to CitizenHomePage
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const CitizenGridPage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    applicantNameController.dispose();
    applicantRelationTypeController.dispose();
    applicationRelativeNameController.dispose();
    applicantGenderController.dispose();
    applicantDateOfBirthController.dispose();
    applicantAgeController.dispose();
    applicantEmailController.dispose();
    applicantMobileController.dispose();
    protestTypeController.dispose();
    briefDescriptionController.dispose();
    instituteNameController.dispose();
    locationNumberController.dispose();
    locationAreaController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    structureNatureController.dispose();
    startHoursController.dispose();
    expectedHoursController.dispose();
    startMinutesController.dispose();
    expectedMinutesController.dispose();
    super.dispose();
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _affidavitDetailsFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Please Fill the Mandatory Details first',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
                const SizedBox(height: 20),
                const Text('Applicant Personal Information',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: applicantNameController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: applicantMobileController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    prefixIcon: const Icon(Icons.phone),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: applicantEmailController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: widget.applicantGender,
                  readOnly: true, // Makes the field uneditable
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: widget.applicantRelationType,
                  readOnly: true, // Makes the field uneditable
                  decoration: InputDecoration(
                    labelText: 'Relation Type',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: applicationRelativeNameController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Relative Name',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: applicantDateOfBirthController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: applicantAgeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: paddressController,
                  decoration: InputDecoration(
                    label: RichText(
                      text: TextSpan(
                        text: 'Present Address',
                        style: TextStyle(
                            color: Colors.black), // Normal label color
                        children: [
                          TextSpan(
                            text: ' *',
                            style:
                                TextStyle(color: Colors.red), // Red color for *
                          ),
                        ],
                      ),
                    ),
                    prefixIcon: const Icon(Icons.home),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                CountryPage(
                  controller: pcountryController,
                  enabled: false,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: widget.selectedState,
                  readOnly: true, // Makes the field uneditable
                  decoration: InputDecoration(
                    labelText: 'State',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                DpPage(
                  onDistrictSelected: (districtCode) {
                    setState(() {
                      if (isChecked) {
                        permanentDistrictCode = districtCode;
                      } else {
                        presentDistrictCode = districtCode;
                      }
                    });
                  },
                  onPoliceStationSelected: (policeStationCode) {
                    setState(() {
                      if (isChecked) {
                        permanentPoliceStationCode = policeStationCode;
                      } else {
                        presentPoliceStationCode = policeStationCode;
                      }
                    });
                  },
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                          // widget.onAddressSame(isChecked);
                          if (isChecked) {
                            addressController.text = paddressController.text;
                            aCountryController.text = pcountryController.text;
                            permanentDistrictCode = presentDistrictCode;
                            permanentPoliceStationCode =
                                presentPoliceStationCode;
                          } else {
                            addressController.clear();
                            aCountryController.clear();
                            permanentDistrictCode = null;
                            permanentPoliceStationCode = null;
                          }
                        });
                      },
                    ),
                    const Text('Permanent address same as present address'),
                  ],
                ),
                if (!isChecked)
                  Column(
                    children: [
                      TextFormField(
                        controller: addressController,
                        enabled: true,
                        decoration: InputDecoration(
                          label: RichText(
                            text: TextSpan(
                              text: 'Permanent Address',
                              style: TextStyle(
                                  color: Colors.black), // Normal label color
                              children: [
                                TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                      color: Colors.red), // Red color for *
                                ),
                              ],
                            ),
                          ),
                          prefixIcon: const Icon(Icons.home),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      CountryPage(
                          controller: aCountryController, enabled: false),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: widget.selectedState,
                        readOnly: true, // Makes the field uneditable
                        decoration: InputDecoration(
                          labelText: 'State',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      DpPage(
                        onDistrictSelected: (districtCode) {
                          setState(() {
                            permanentDistrictCode = districtCode;
                          });
                        },
                        onPoliceStationSelected: (policeStationCode) {
                          setState(() {
                            permanentPoliceStationCode = policeStationCode;
                          });
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                const Text('Organization Information',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: orgNameController,
                  decoration: InputDecoration(
                    label: RichText(
                      text: TextSpan(
                        text: 'Organization Name',
                        style: TextStyle(
                            color: Colors.black), // Normal label color
                        children: [
                          TextSpan(
                            text: ' *',
                            style:
                                TextStyle(color: Colors.red), // Red color for *
                          ),
                        ],
                      ),
                    ),
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return ValidateFullName(value);
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: orgAddressController,
                  decoration: InputDecoration(
                    label: RichText(
                      text: TextSpan(
                        text: 'Organization Address',
                        style: TextStyle(
                            color: Colors.black), // Normal label color
                        children: [
                          TextSpan(
                            text: ' *',
                            style:
                                TextStyle(color: Colors.red), // Red color for *
                          ),
                        ],
                      ),
                    ),
                    prefixIcon: const Icon(Icons.home),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CountryPage(
                  controller: orgCountryController,
                  enabled: true,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: widget.selectedState,
                  readOnly: true, // Makes the field uneditable
                  decoration: InputDecoration(
                    labelText: 'State',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                DpPage(
                  onDistrictSelected: (districtCode) {
                    setState(() {
                      orgDistrictCode = districtCode;
                    });
                  },
                  onPoliceStationSelected: (policeStationCode) {
                    setState(() {
                      orgPoliceStationCode = policeStationCode;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text('Protest/Strike information',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'Name of Target Institution/Person\n(Against which Protest/Strike is planned)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: instituteNameController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Name of Target',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Expected time limit\nfor the Protest/Strike (per day)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: expectedHoursController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Expected Hours',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: expectedMinutesController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Expected Minutes',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: briefDescriptionController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Description of Protest/Strike',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: widget.protestType,
                  readOnly: true, // Makes the field uneditable
                  decoration: InputDecoration(
                    labelText: 'Protest Type',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Name of location\n(Place of Protest/Strike)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: locationNameController,
                  decoration: InputDecoration(
                    label: RichText(
                      text: TextSpan(
                        text: 'Location Name',
                        style: TextStyle(
                            color: Colors.black), // Normal label color
                        children: [
                          TextSpan(
                            text: ' *',
                            style:
                                TextStyle(color: Colors.red), // Red color for *
                          ),
                        ],
                      ),
                    ),
                    prefixIcon: const Icon(Icons.location_city),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your location name';
                    }
                    return ValidateFullName(value);
                  },
                ),
                const SizedBox(height: 10),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Address of location\n(Place of Protest/Strike)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: startAddressController,
                  decoration: InputDecoration(
                    label: RichText(
                      text: TextSpan(
                        text: 'Location Address',
                        style: TextStyle(
                            color: Colors.black), // Normal label color
                        children: [
                          TextSpan(
                            text: ' *',
                            style:
                                TextStyle(color: Colors.red), // Red color for *
                          ),
                        ],
                      ),
                    ),
                    prefixIcon: const Icon(Icons.pin_drop),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  keyboardType: TextInputType.streetAddress,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your details';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CountryPage(
                          controller: startCountryController, enabled: true),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: widget.selectedState,
                  readOnly: true, // Makes the field uneditable
                  decoration: InputDecoration(
                    labelText: 'State',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                DpPage(
                  onDistrictSelected: (districtCode) {
                    setState(() {
                      locationDistrictCode = districtCode;
                    });
                  },
                  onPoliceStationSelected: (policeStationCode) {
                    setState(() {
                      locationPoliceStationCode = policeStationCode;
                    });
                  },
                ),
                const SizedBox(height: 8),
                const Divider(),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Location Area Details',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: locationNumberController,
                        readOnly: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        initialValue: widget.locationArea,
                        readOnly: true, // Makes the field uneditable
                        decoration: InputDecoration(
                          labelText: 'Location Area Unit',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: widget.structureNature,
                  readOnly: true, // Makes the field uneditable
                  decoration: InputDecoration(
                    labelText: 'Structure Nature Type',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Start and End Date of the Protest/Strike',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: startDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          labelText: 'Start Date',
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: endDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          labelText: 'End Date',
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Start Time of the Protest/Strike',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: startHoursController,
                        readOnly: true, // Makes the field uneditable
                        decoration: InputDecoration(
                          labelText: 'Expected minutes',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: startMinutesController,
                        readOnly: true, // Makes the field uneditable
                        decoration: InputDecoration(
                          labelText: 'Expected minutes',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: isAgree,
                      onChanged: (value) {
                        setState(() {
                          isAgree = value!;
                        });
                      },
                    ),
                    const Text(
                        'All the information provided in the form is true'),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (isAgree &&
                          _affidavitDetailsFormKey.currentState!.validate() &&
                          !_isSubmitting) // Check if not already submitting
                      ? () async {
                          setState(() {
                            _isSubmitting = true; // Disable the button
                          });

                          try {
                            await _registerUser(); // Perform the registration logic
                          } finally {
                            setState(() {
                              _isSubmitting =
                                  true; // Re-enable the button after completion
                            });
                          }
                        }
                      : null, // Disable button if checkbox is not checked, form is invalid, or already submitting
                  style: AppButtonStyles.elevatedButtonStyle,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(
                          color: Colors.white) // Show a loader
                      : const Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//                 
//                 