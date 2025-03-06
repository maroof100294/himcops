import 'package:flutter/material.dart';
import 'package:himcops/authservice.dart';
import 'package:himcops/citizen/searchstaus/Tenantverifystatus.dart';
import 'package:himcops/config.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/master/occupationMain.dart';
import 'package:himcops/master/sdp.dart';
import 'package:himcops/pages/cgridhome.dart';
import 'package:himcops/master/country.dart';
import 'package:http/io_client.dart';
// import 'package:himcops/payment/payment_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class TvrVerificationPage extends StatefulWidget {
  final String name;
  final String dateOfBirth;
  final String gender;
  final String relation;
  final int relationId;
  final int tenantId;
  final String relativeName;
  final String affidavit;
  final String commercial;
  final String tenantOccupation;
  final String tenancy;
  final String age;
  final String selectedState;
  final String selectedTenancy;
  final int genderId;
  final bool isCriminal;

  const TvrVerificationPage({
    super.key,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.relation,
    required this.relationId,
    required this.tenantId,
    required this.relativeName,
    required this.affidavit,
    required this.commercial,
    required this.tenantOccupation,
    required this.tenancy,
    required this.age,
    required this.selectedState,
    required this.selectedTenancy,
    required this.genderId,
    required this.isCriminal,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TvrVerificationPageState createState() => _TvrVerificationPageState();
}

// ignore: camel_case_types
class _TvrVerificationPageState extends State<TvrVerificationPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController paddressController = TextEditingController();
  final TextEditingController pcountryController = TextEditingController();
  final TextEditingController aCountryController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController oAddressController = TextEditingController();
  final TextEditingController oCountryController = TextEditingController();
  final TextEditingController oNameController = TextEditingController();
  final GlobalKey<FormState> _affidavitDetailsFormKey = GlobalKey<FormState>();
  bool isAgree = false;
  bool _isSubmitting = false;
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
  String? _photoWarning;
  String? _photoWarningTwo;
  // String? _documentWarning;
  File? _photoFileName;
  File? _photoFileNameTwo;
  // File? _documentFileName;
  String? photoBase64String;
  String? photoTwoBase64String;
  // String? documentBase64String;
  String? preStateCode;
  String? preDistrictCode;
  String? prePoliceStationCode;
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

      oNameController.text = firstName;
      oAddressController.text = '$addressLine1 $village $addressLine3';
      mobileController.text = mobile2 != null ? mobile2.toString() : '';
      emailController.text = email;
    });
  }

  String? ownerStateCode;
  String? ownerDistrictCode;
  String? ownerPoliceStationCode;

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

  Future<void> _uploadPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();
      final fileExtension = pickedFile.path.split('.').last.toLowerCase();

      if (fileSize > 2500 * 1024) {
        setState(() {
          _photoWarning = 'Photo must not exceed 250KB.';
          _photoFileName = null;
        });
      } else if (fileExtension != 'jpg' &&
          fileExtension != 'jpeg' &&
          fileExtension != 'png') {
        setState(() {
          _photoWarning = 'Only JPG and PNG files are allowed.';
          _photoFileName = null;
        });
      } else {
        // Convert file data to Base64
        final fileBytes = await file.readAsBytes();
        photoBase64String = base64Encode(fileBytes);

        setState(() {
          _photoWarning = null;
          _photoFileName = file; // Save the file for UI purposes
        });

        print('Photo base64: $photoBase64String');
      }
    } else {
      setState(() {
        _photoWarning = 'No photo selected.';
        _photoFileName = null;
      });
    }
  }

  Future<void> _uploadPhotoTwo() async {
    final pickerTwo = ImagePicker();
    final pickedFileTwo =
        await pickerTwo.pickImage(source: ImageSource.gallery);

    if (pickedFileTwo != null) {
      final fileTwo = File(pickedFileTwo.path);
      final fileSizeTwo = await fileTwo.length();
      final fileExtensionTwo = pickedFileTwo.path.split('.').last.toLowerCase();

      if (fileSizeTwo > 2500 * 1024) {
        setState(() {
          _photoWarningTwo = 'Photo must not exceed 250KB.';
          _photoFileNameTwo = null;
        });
      } else if (fileExtensionTwo != 'jpg' &&
          fileExtensionTwo != 'jpeg' &&
          fileExtensionTwo != 'png') {
        setState(() {
          _photoWarningTwo = 'Only JPG and PNG files are allowed.';
          _photoFileNameTwo = null;
        });
      } else {
        // Convert file data to Base64
        final fileBytesTwo = await fileTwo.readAsBytes();
        photoTwoBase64String = base64Encode(fileBytesTwo);

        setState(() {
          _photoWarningTwo = null;
          _photoFileNameTwo = fileTwo; // Save the file for UI purposes
        });

        print('Photo two base64: $photoTwoBase64String');
      }
    } else {
      setState(() {
        _photoWarningTwo = 'No photo selected.';
        _photoFileNameTwo = null;
      });
    }
  }

  // Controllers for TextFormField
  late TextEditingController nameController;
  late TextEditingController relationTypeController;
  late TextEditingController tenantOccupationController;
  late TextEditingController relativeNameController;
  late TextEditingController tenancyController;
  late TextEditingController genderController;
  late TextEditingController dateOfBirthController;
  late TextEditingController ageController;
  late TextEditingController affidavitController;
  late TextEditingController commercialDetailsController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with widget values
    nameController = TextEditingController(text: widget.name);
    relationTypeController = TextEditingController(text: widget.relation);
    tenantOccupationController =
        TextEditingController(text: widget.tenantOccupation);
    relativeNameController = TextEditingController(text: widget.relativeName);
    tenancyController = TextEditingController(text: widget.tenancy);
    genderController = TextEditingController(text: widget.gender);
    dateOfBirthController = TextEditingController(text: widget.dateOfBirth);
    ageController = TextEditingController(text: widget.age);
    affidavitController = TextEditingController(text: widget.affidavit);
    commercialDetailsController =
        TextEditingController(text: widget.commercial);

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
          '$baseUrl/androidapi/mobile/service/addTenantPgVerification';
      final DateTime dob = DateTime.parse(
          widget.dateOfBirth); // Parse the date string into DateTime object
      final String formattedDob =
          DateFormat('dd/MM/yyyy').format(dob); // Format the DateTime object
      final payloadBody = {
        "userName": loginId,
        "ownerFirstName": firstName,
        "ownerMiddleName": "",
        "ownerLastName": "",
        "ownerOccupation": int.tryParse(occupationController.text),
        "ownerEmailId": email,
        "ownerHouseNo": "",
        "ownerStreetName": "",
        "ownerColony": "",
        "ownerVillage": oAddressController.text, //"Bharoli Bhagor (17/40)",
        "ownerTehsil": "",
        "ownerCountry": 80,
        "ownerState": 12,
        "ownerDistrict": int.tryParse(ownerDistrictCode!),
        "ownerPoliceStation": int.tryParse(ownerPoliceStationCode!), //12253025,
        "ownerPincode": 0,
        "ownerMobile1": "91",
        "ownerMobile2": "8473951198", //mobile2,
        "ownerLandline1": "91",
        "ownerLandline2": "",
        "ownerLandline3": "",
        "ownerPersonCode": null,
        "ownerAddressCode": null,
        "tenantFirstName": widget.name,
        "tenantMiddleName": "",
        "tenantLastName": "",
        "tenantGender": widget.genderId,
        "tenantOccupation": widget.tenantId,
        "tenantMobile1": "91",
        "tenantMobile2": "",
        "tenantLandline1": "91",
        "tenantLandline2": "",
        "tenantLandline3": "",
        "tenantRelationType": widget.relationId,
        "tenantRelativeName": widget.relativeName,
        "tenantPurpose": null,
        "tenantCommercialDetails": null,
        "tenantPersonCode": null,
        "tenantPresentAddressCode": null,
        "tenantPreviousAddressCode": null,
        "tenantPermanentAddressCode": null,
        "tenantPresentHouseNo": "",
        "tenantPresentStreetName": "",
        "tenantPresentColony": "",
        "tenantPresentVillage": paddressController.text,
        "tenantPresentTehsil": "",
        "tenantPresentAge": null,
        "tenantPresentCountry": 80,
        "tenantPresentState": 12,
        "tenantPresentDistrict": int.tryParse(presentDistrictCode!), //12245,
        "tenantPresentPoliceStation":
            int.tryParse(presentPoliceStationCode!), //12245015,
        "tenantPresentPincode": 0,
        "tenantPermanentHouseNo": "",
        "tenantPermanentStreetName": "",
        "tenantPermanentColony": "",
        "tenantPermanentVillage": addressController.text,
        "tenantPermanentTehsil": "",
        "tenantPermanentCountry": 80,
        "tenantPermanentState": 12,
        "tenantPermanentDistrict":
            int.tryParse(permanentDistrictCode!), //12246,
        "tenantPermanentPoliceStation":
            int.tryParse(permanentPoliceStationCode!), //12246002,
        "tenantPermanentPincode": 0,
        "familyMemberFirstName": widget.relativeName,
        "familyMemberMiddleName": "",
        "familyMemberLastName": "",
        "familyMemberRelationshipWithTenant": widget.relationId,
        "familyMemberLandline1": "91",
        "familyMemberLandline2": "",
        "familyMemberLandline3": "",
        "familyMemberAddressDocuments": 0,
        "familyMemberAddressDocumentsNo": "",
        "familyMemberMobile1": "91",
        "familyMemberMobile2": "",
        "familyMemberApplicationSubmissionDate":
            DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
        "hasAnyCriminalRecord": widget.isCriminal ? 'Y' : 'N',
        "crimeDetails": widget.isCriminal ? widget.affidavit : '',
        "orRecord": 1,
        "fileTypeCd": [1, 2],
        "filedescription": ["photo", "aadhar ration"],
        "tenancypurpose":
            widget.selectedTenancy == "Residential" ? "R" : "C", //"C",
        "commercialDetails": widget.selectedTenancy == "Commercial"
            ? widget.commercial
            : "", //"gjgjhgjhgjhgjh",
        "submittenant": "submit",
        "tenantVerificationTenant": {
          "commonPaneldateOfBirth": formattedDob,
          "commonPanelAgeYear": widget.age,
          // "commonPanelAgeMonth": 3,
          // "commonPanelyearOfBirth": 1997
        },
        "tenantVerificationFamily": {
          "commonPaneldateOfBirth": "00/00/0000",
          "commonPanelAgeYear": 0,
          "commonPanelAgeMonth": 0,
          "commonPanelyearOfBirth": 0
        },
        "files": [
          {
            "fileName": "Photograph.png",
            "fieldName": "Photograph",
            "fileData": photoBase64String ?? "",
            "fileTypeCd": 1
          },
          {
            "fileName": "Scan Copy.png",
            "fieldName": "ScanCopy",
            "fileData": photoTwoBase64String ?? "",
            "fileTypeCd": 2
          }
        ]
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
                      builder: (context) =>
                          const TenantVerificaitonStatusPage(),
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
    // Dispose of the controllers when the widget is disposed
    nameController.dispose();
    relationTypeController.dispose();
    tenantOccupationController.dispose();
    relativeNameController.dispose();
    tenancyController.dispose();
    genderController.dispose();
    dateOfBirthController.dispose();
    ageController.dispose();
    addressController.dispose();
    affidavitController.dispose();

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
                  const Text('Owner Personal Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: oNameController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  MainOccupationPage(
                    controller: occupationController,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onTap: () {
                      //to be fetch when user is login
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: mobileController,
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
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    onTap: () {
                      //to be fetch when user is login
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Mobile number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: oAddressController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Owner Address',
                      prefixIcon: const Icon(Icons.home),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
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
                    controller: oCountryController,
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
                        ownerDistrictCode = districtCode;
                      });
                    },
                    onPoliceStationSelected: (policeStationCode) {
                      setState(() {
                        ownerPoliceStationCode = policeStationCode;
                      });
                    },
                  ),
                  //   ],
                  // ),
                  const SizedBox(height: 10),
                  const Text('Tenant Present Address Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
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
                    controller: pcountryController,
                    enabled: true,
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
                        presentDistrictCode = districtCode;
                      });
                    },
                    onPoliceStationSelected: (policeStationCode) {
                      setState(() {
                        presentPoliceStationCode = policeStationCode;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text('Tenant Permanent Address Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
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
                  CountryPage(controller: aCountryController, enabled: true),
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

                  const SizedBox(height: 20),
                  const Text('Tenant Personal Information',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    // validator: (value) =>
                    //     value?.isEmpty ?? true ? 'Please enter a name' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: widget.relation,
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
                    initialValue: widget.tenantOccupation,
                    decoration: InputDecoration(
                      labelText: 'Description of Service',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    // validator: (value) => value?.isEmpty ?? true
                    //     ? 'Please describe the service'
                    //     : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: relativeNameController,
                    decoration: InputDecoration(
                      labelText: 'Relative Name',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: widget.gender,
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
                    controller: dateOfBirthController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: ageController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      TextFormField(
                        initialValue: widget.selectedTenancy,
                        readOnly: true, // Makes the field uneditable
                        decoration: InputDecoration(
                          labelText: 'Tenancy',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Use Visibility to conditionally show the field
                      Visibility(
                        visible: widget.selectedTenancy == 'Commercial',
                        child: TextFormField(
                          controller: commercialDetailsController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Commercial Details',
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                            'Scan Photo of the Employee\n(Maximum file size limit 250 kb)'),
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _uploadPhoto,
                          icon: const Icon(Icons.upload, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF133371),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          label: const Text(
                            'Choose file',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (_photoFileName != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Image.file(
                        _photoFileName!,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),

                  if (_photoWarning != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        _photoWarning!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Identity Copy Upload
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                            'Upload Scan Identity Copy\n(Maximum file size limit 250 kb)'),
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _uploadPhotoTwo,
                          icon: const Icon(Icons.upload, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF133371),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          label: const Text(
                            'Choose file',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (_photoFileNameTwo != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Image.file(
                        _photoFileNameTwo!,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),

                  if (_photoWarningTwo != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        _photoWarningTwo!,
                        style: const TextStyle(color: Colors.red),
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
                          controller: affidavitController,
                          decoration: InputDecoration(
                            labelText: 'Affidavit',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          maxLines: 3,
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
                          if (_photoFileName == null ||
                              _photoFileNameTwo == null) {
                            setState(() {
                              _photoWarning = _photoFileName == null
                                  ? 'Please upload the employee photo.'
                                  : null;
                              _photoWarningTwo = _photoFileNameTwo == null
                                  ? 'Please upload the identity copy.'
                                  : null;
                            });
                          } else {
                            setState(() {
                              isAgree = value!;
                              _photoWarning = null;
                              _photoWarningTwo = null;
                            });
                          }
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
                            !_isSubmitting)
                        ? () async {
                            setState(() {
                              _isSubmitting = true;
                            });

                            try {
                              await _registerUser();
                            } finally {
                              setState(() {
                                _isSubmitting = false;
                              });
                            }
                          }
                        : null, // Disable button if checkbox is unchecked or already submitting
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
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
