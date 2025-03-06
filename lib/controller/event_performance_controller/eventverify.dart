import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:himcops/authservice.dart';
import 'package:himcops/citizen/searchstaus/eventperformance.dart';
import 'package:himcops/config.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/layout/buttonstyle.dart';
import 'package:himcops/master/country.dart';
import 'package:himcops/master/locationarea.dart';
import 'package:himcops/master/sdp.dart';
import 'package:himcops/pages/cgridhome.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';

class EventPerformanceVerificationPage extends StatefulWidget {
  final String applicantName;
  final String applicantRelationType;
  final String applicationRelativeName;
  final String applicantGender;
  final String applicantDateOfBirth;
  final String applicantAge;
  final String applicantEmail;
  final String applicantMobile;
  final String criminal;
  final String briefDescription;
  final String convicted;
  final String startDate;
  final String endDate;
  final String preceeding;
  final String startHours;
  final String expectedHours;
  final String startMinutes;
  final String expectedMinutes;
  final String blacklisted;
  final String eventPerformanceType;
  final String fireClearance;
  final String orgName;
  final String selectedState;
  final bool isCriminal;
  final bool isConvicted;
  final bool isPreceeding;
  final bool isBlacklisted;
  final int applicantGenderId;
  final int eventPerformanceId;
  final int applicantRelationId;

  const EventPerformanceVerificationPage({
    super.key,
    required this.applicantName,
    required this.applicantRelationType,
    required this.applicationRelativeName,
    required this.applicantGender,
    required this.applicantDateOfBirth,
    required this.applicantAge,
    required this.applicantEmail,
    required this.applicantMobile,
    required this.criminal,
    required this.briefDescription,
    required this.startDate,
    required this.endDate,
    required this.startHours,
    required this.expectedHours,
    required this.startMinutes,
    required this.expectedMinutes,
    required this.convicted,
    required this.preceeding,
    required this.blacklisted,
    required this.eventPerformanceType,
    required this.fireClearance,
    required this.orgName,
    required this.selectedState,
    required this.isBlacklisted,
    required this.isConvicted,
    required this.isCriminal,
    required this.isPreceeding,
    required this.applicantGenderId,
    required this.eventPerformanceId,
    required this.applicantRelationId,
  });

  @override
  _EventPerformanceVerificationPageState createState() =>
      _EventPerformanceVerificationPageState();
}

class _EventPerformanceVerificationPageState
    extends State<EventPerformanceVerificationPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aCountryController = TextEditingController();
  final TextEditingController paddressController = TextEditingController();
  final TextEditingController pcountryController = TextEditingController();
  final TextEditingController locationNameController = TextEditingController();
  final TextEditingController structureTypeController = TextEditingController();
  final TextEditingController structureNatureController =
      TextEditingController();
  final TextEditingController locationAreaController = TextEditingController();
  final TextEditingController locationNumberController =
      TextEditingController();
  final TextEditingController locationAddressController =
      TextEditingController();
  final TextEditingController locationCountryController =
      TextEditingController();
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
  String selectedNature = '';
  String selectedType = '';
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
  late TextEditingController applicantRelativeNameController;
  late TextEditingController applicantGenderController;
  late TextEditingController applicantDateOfBirthController;
  late TextEditingController applicantAgeController;
  late TextEditingController applicantEmailController;
  late TextEditingController applicantMobileController;
  late TextEditingController orgNameController;
  late TextEditingController criminalController;
  late TextEditingController convictedController;
  late TextEditingController preceedingController;
  late TextEditingController blacklistedController;
  late TextEditingController eventPerformanceTypeController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController briefDescriptionController;
  late TextEditingController fireClearanceController;
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
    applicantRelativeNameController =
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
    orgNameController = TextEditingController(text: widget.orgName);
    criminalController = TextEditingController(text: widget.criminal);
    convictedController = TextEditingController(text: widget.convicted);
    preceedingController = TextEditingController(text: widget.preceeding);
    blacklistedController = TextEditingController(text: widget.blacklisted);
    eventPerformanceTypeController =
        TextEditingController(text: widget.eventPerformanceType);
    startDateController = TextEditingController(text: widget.startDate);
    endDateController = TextEditingController(text: widget.endDate);
    briefDescriptionController =
        TextEditingController(text: widget.briefDescription);
    fireClearanceController = TextEditingController(text: widget.fireClearance);
    startHoursController = TextEditingController(text: widget.startHours);
    expectedHoursController = TextEditingController(text: widget.expectedHours);
    startMinutesController = TextEditingController(text: widget.startMinutes);
    expectedMinutesController =
        TextEditingController(text: widget.expectedMinutes);

    _fetchLoginId();

    if (structureNatureController.text == 'T') {
      structureNatureController.text = 'Temporary';
    } else if (structureNatureController.text == 'P') {
      structureNatureController.text = 'Permanent';
    }
    selectedNature = structureNatureController.text;

    if (structureTypeController.text == 'C') {
      structureTypeController.text = 'Close';
    } else if (structureTypeController.text == 'O') {
      structureTypeController.text = 'Open';
    }
    selectedType = structureTypeController.text;
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
          '$baseUrl/androidapi/mobile/service/eventPerformanceRequestRegistration';
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
        "userName": loginId, //"arunkumar7796",
        "applicant": {
          "firstName": widget.applicantName,
          "middleName": "",
          "gender": widget.applicantGenderId,
          "lastName": "",
          "mobile1": "91",
          "mobile2": widget.applicantMobile,
          "mRelationType": widget.applicantRelationId,
          "relativeName": widget.applicationRelativeName,
          "email": widget.applicantEmail,
          "permanentAddressFormBean": {
            "countryCd": isChecked
                ? int.tryParse(pcountryController.text)
                : int.tryParse(aCountryController.text), //80,
            "stateCd": 12,
            "districtCd": isChecked
                ? int.tryParse(presentDistrictCode!)
                : int.tryParse(permanentDistrictCode!), //12253,
            "village":
                isChecked ? paddressController.text : addressController.text,
            "policeStationCd": isChecked
                ? int.tryParse(presentPoliceStationCode!)
                : int.tryParse(permanentPoliceStationCode!), //12253025
          },
          "presentAddressFormBean": {
            "countryCd": int.tryParse(pcountryController.text), //80,
            "stateCd": 12,
            "districtCd": int.tryParse(presentDistrictCode!), //12253,
            "village": paddressController.text,
            "policeStationCd":
                int.tryParse(presentPoliceStationCode!), //12253025
          }
        },
        "eventPerformanceRegApplicant": {
          "commonPaneldateOfBirth": formattedDob,
          "commonPanelAgeYear": widget.applicantAge,
          // "commonPanelAgeMonth": 7,
          // "commonPanelyearOfBirth": 1993
        },
        "isClickedSubmit": 0,
        "isSameAsPermanent": isChecked ? 'Y' : 'N',
        "isApplCriminal": widget.isCriminal ? 'Y' : 'N',
        "anyPreventiveProceeds": widget.isPreceeding ? 'Y' : 'N',
        "charLimitId": 200,
        "charLimitId1": 200,
        "isApplConvict": widget.isConvicted ? 'Y' : 'N',
        "isApplBlacklisted": widget.isBlacklisted ? 'Y' : 'N',
        "orgnizationName": widget.orgName,
        "organizationPhone1": "91",
        "organizationMobile1": "91",
        "organization": {
          "countryCd": 80,
          "stateCd": 12,
          "districtCd": 12253,
          "policeStationCd": null
        },
        "locationAddress": {
          "countryCd": 80,
          "stateCd": 12,
          "districtCd": int.tryParse(locationDistrictCode!),
          "village": locationAddressController.text,
          "policeStationCd": int.tryParse(locationPoliceStationCode!),
          "pincode": ""
        },
        "locationName": locationNameController.text,
        "fireResistantLimit": 4,
        "free3mtrDetail": "",
        "charLimitId24": 179,
        "locationArea": locationNumberController.text,
        "locationAreaCd": locationAreaController.text, //"Sq.Mts.",
        "structureNature":
            selectedNature == "Temporary" ? "T" : "P", //"P", //isStrutureNature
        "nearChimneyDetail": "",
        "charLimitId23": 178,
        "isStructureOpen":
            selectedType == "Close" ? "C" : "O", //"O", //isStructureType
        "charLimitId22": 200,
        "charLimitId26": 15,
        "charLimitId27": 180,
        "materialNature": ["", "", ""],
        "fireRetardantTreat": ["", "", ""],
        "langCd": 99,
        "eventStartDtStr": formattedSDate,
        "eventStartTimeStrHH": startHoursController.text,
        "eventStartTimeStrMM": startMinutesController.text,
        "eventEndDtStr": formattedEDate,
        "proposedTimeLmtHH": expectedHoursController.text,
        "proposedTimeLmtMM": expectedMinutesController.text,
        "briefSynopsis": briefDescriptionController.text,
        "charLimitId18": 182,
        "isLoudspeakerUsed": "N",
        "eventTypeCd": widget.eventPerformanceId, //3, //eventPerformanceId
        "isParkingAvail": "N",
        "isFireDeptClearance":
            widget.fireClearance == "Yes" ? "Y" : "N", //isFireClearance
        "securityRoomDetail": "",
        "charLimitId10": 171,
        "exitGateWidthDesc": "",
        "charLimitId13": 181,
        "wiringFittingDetail": "",
        "charLimitId14": 183,
        "firstAidFacility": "",
        "charLimitId7": 172,
        "gangwaysDetails": "",
        "charLimitId12": 30,
        "fireDeptClearance": "",
        "charLimitId16": 171,
        "fireFightDetail": "",
        "charLimitId15": 188,
        "standbyAmbulance": "",
        "charLimitId5": 179,
        "standbyFireService": "",
        "charLimitId9": 185,
        "nearbyHospital": "",
        "charLimitId4": 176,
        "fireCntrlRoomDetail": "",
        "charLimitId11": 181,
        "publicFacilityAvail": "",
        "charLimitId8": 179,
        "medAttendants": ""
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
        print('Error occurred: $e');
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
                      builder: (context) => const EventPerformanceStatusPage(),
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
    applicantRelativeNameController.dispose();
    applicantGenderController.dispose();
    applicantDateOfBirthController.dispose();
    applicantAgeController.dispose();
    applicantEmailController.dispose();
    applicantMobileController.dispose();
    orgNameController.dispose();
    criminalController.dispose();
    convictedController.dispose();
    preceedingController.dispose();
    blacklistedController.dispose();
    eventPerformanceTypeController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    briefDescriptionController.dispose();
    fireClearanceController.dispose();
    startHoursController.dispose();
    expectedHoursController.dispose();
    startMinutesController.dispose();
    expectedMinutesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
  onWillPop: () async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CitizenGridPage()),
    );
    return false; // Prevent default back navigation
  },
    
    child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Event Performanace Request',
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
                const Text('Applicant Address Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                const Text('Eveny Location Detail',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: locationNameController,
                  decoration: InputDecoration(
                    labelText: 'Location Name',
                    prefixIcon: const Icon(Icons.location_city),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your location name';
                    }
                    return ValidateFullName(value);
                  },
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Address of the Location',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: locationAddressController,
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
                Row(
                  children: [
                    Expanded(
                      child: CountryPage(
                          controller: locationCountryController, enabled: true),
                    ),
                  ],
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
                const SizedBox(height: 8),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Area Size of Location',
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
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter loction area';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: LocationAreaPage(
                            controller: locationAreaController, enabled: true)),
                  ],
                ),
                const SizedBox(height: 10),
                // NatureStructurePage(
                //     controller: structureNatureController, enabled: true),
                DropdownButtonFormField<String>(
                  value: structureNatureController.text.isNotEmpty
                      ? structureNatureController.text
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Nature of Structure',
                    prefixIcon: const Icon(Icons.nature),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: <String>['Temporary', 'Permanent'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      structureNatureController.text =
                          newValue ?? ''; // Save full text
                      selectedNature = newValue ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a nature of structure';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // StructureTypePage(
                //     controller: structureTypeController, enabled: true),
                DropdownButtonFormField<String>(
                  value: structureTypeController.text.isNotEmpty
                      ? structureTypeController.text
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Type of Structure',
                    prefixIcon: const Icon(Icons.nature),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: <String>['Close', 'Open'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      structureTypeController.text =
                          newValue ?? ''; // Save full text
                      selectedType = newValue ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a Type of structure';
                    }
                    return null;
                  },
                ),
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
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: applicantMobileController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: applicantEmailController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                TextFormField(
                  controller: applicantRelativeNameController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Relative Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: orgNameController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Organization Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: applicantDateOfBirthController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: applicantAgeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Event Performance Information',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: widget.eventPerformanceType,
                  readOnly: true, // Makes the field uneditable
                  decoration: InputDecoration(
                    labelText: 'Event Performance Type',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Start and End Date of Procession',
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
                          fillColor: Colors.white,
                          labelText: 'Start Date',
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
                          fillColor: Colors.white,
                          labelText: 'End Date',
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
                        'Start time of the event/performance',
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
                          labelText: 'Start Hours',
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
                          labelText: 'Start Minutes',
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
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Proposed time limit of the show',
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
                        readOnly: true, // Makes the field uneditable
                        decoration: InputDecoration(
                          labelText: 'Expected Hours',
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
                        controller: expectedMinutesController,
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
                const SizedBox(height: 10),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Brief Synopsis of the performance containing\nthe content of the show(s) (Artist details etc)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: briefDescriptionController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Brief Description',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Fire department clearance obtained/applied',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  initialValue: widget.fireClearance,
                  readOnly: true, // Makes the field uneditable
                  decoration: InputDecoration(
                    labelText: 'Fire Clearance',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                  Visibility(
                    visible:
                        widget.isCriminal, // Directly use the boolean value
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Affidavit Details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: criminalController,
                          decoration: InputDecoration(
                            labelText: 'Criminal Details',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          enabled: false,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                 Visibility(
                    visible:
                        widget.isConvicted, // Directly use the boolean value
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Affidavit Details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: convictedController,
                          decoration: InputDecoration(
                            labelText: 'Convicted Details',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          enabled: false,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                Visibility(
                    visible:
                        widget.isPreceeding, // Directly use the boolean value
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Affidavit Details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: preceedingController,
                          decoration: InputDecoration(
                            labelText: 'preceeding Details',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          enabled: false,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                Visibility(
                    visible:
                        widget.isBlacklisted, // Directly use the boolean value
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Affidavit Details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: blacklistedController,
                          decoration: InputDecoration(
                            labelText: 'Blacklist Details',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          enabled: false,
                        ),
                      ],
                    ),
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
    ),
    );
  }
}
