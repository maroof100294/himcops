import 'dart:convert';
import 'package:himcops/citizen/searchstaus/dmvviewpage.dart';
import 'package:himcops/layout/buttonstyle.dart';
import 'package:himcops/master/country.dart';
import 'package:himcops/master/statedistrictdynamic.dart';
import 'package:himcops/pages/cgridhome.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:himcops/payment/payment_page.dart';
import 'package:http/io_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:himcops/config.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class DmvVerificationPage extends StatefulWidget {
  final String name;
  final String applicationDate;
  final String dateofBirth;
  final String age;
  final String country;
  final String gender;
  final String languageSpoken;
  final String relationType;
  final String relativeName;
  final String placeBirth;
  final String affidavit;
  final String selectedCountry;
  final bool isCriminal;
  final bool isWorked;
  final bool isChecked;
  final int genderId;
  final String genderDescription;
  final int relationId;
  final String relationDescription;
  final int languagesId;
  final String languagesDescription;

  const DmvVerificationPage({
    super.key,
    required this.name,
    required this.applicationDate,
    required this.dateofBirth,
    required this.age,
    required this.country,
    required this.gender,
    required this.languageSpoken,
    required this.relationType,
    required this.relativeName,
    required this.placeBirth,
    required this.affidavit,
    required this.selectedCountry,
    required this.isCriminal,
    required this.isWorked,
    required this.isChecked,
    required this.genderId,
    required this.genderDescription,
    required this.relationId,
    required this.relationDescription,
    required this.languagesId,
    required this.languagesDescription,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DmvVerificationPageState createState() => _DmvVerificationPageState();
}

class _DmvVerificationPageState extends State<DmvVerificationPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aCountryController = TextEditingController();
  final TextEditingController paddressController = TextEditingController();
  final TextEditingController pcountryController = TextEditingController();
  final TextEditingController relativeInfoNameController =
      TextEditingController();
  final TextEditingController relativeInfoAddressController =
      TextEditingController();
  final TextEditingController rcountryController = TextEditingController();
  TextEditingController previousEmployerNameController =
      TextEditingController();
  TextEditingController previousEmployerMobileController =
      TextEditingController();
  TextEditingController previousEmployerAddressController =
      TextEditingController();
  TextEditingController preCountryController = TextEditingController();
  TextEditingController masterNameController = TextEditingController();
  TextEditingController masterAddressController = TextEditingController();
  TextEditingController masterCountryController = TextEditingController();
  TextEditingController masterMobileController = TextEditingController();

  // ignore: non_constant_identifier_names
  final GlobalKey<FormState> _PccaffidavitDetailsFormKey =
      GlobalKey<FormState>();
  bool isAgree = false; // Checkbox state
  bool _isSubmitting = false;
  bool isChecked = false;
  String? permanentStateCode;
  String? permanentDistrictCode;
  String? permanentPoliceStationCode;
  String? presentStateCode;
  String? presentDistrictCode;
  String? presentPoliceStationCode;
  String? relativeStateCode;
  String? relativeDistrictCode;
  String? relativePoliceStationCode;
  String? _photoWarning;
  String? _documentWarning;
  File? _photoFileName;
  File? _documentFileName;
  String? photoBase64String;
  String? documentBase64String;
  bool isWorked = false;
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

      masterNameController.text = firstName;
      masterAddressController.text =
          '$addressLine1 $village $addressLine3 $tehsil';
      masterMobileController.text = mobile2 != null ? mobile2.toString() : '';
    });
  }

  String? masterStateCode;
  String? masterDistrictCode;
  String? masterPoliceStationCode;

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

      if (fileSize > 250 * 1024) {
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

  Future<void> _uploadDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.first.path!);
      final fileSize = await file.length();

      if (fileSize > 250 * 1024) {
        setState(() {
          _documentWarning = 'Document must not exceed 250KB.';
          _documentFileName = null;
        });
      } else {
        final fileBytes = await file.readAsBytes(); // Read file bytes
        documentBase64String = base64Encode(fileBytes); // Convert to Base64

        setState(() {
          _documentWarning = null;
          _documentFileName = file;
        });

        print('Document base64: $documentBase64String');
      }
    } else {
      setState(() {
        _documentWarning = 'No document selected.';
        _documentFileName = null;
      });
    }
  }

  late TextEditingController nameController;
  late TextEditingController applicationDateController;
  late TextEditingController dateofBirthController;
  late TextEditingController ageController;
  late TextEditingController countryController;
  late TextEditingController genderController;
  late TextEditingController languageSpokenController;
  late TextEditingController relationTypeController;
  late TextEditingController relativeNameController;
  late TextEditingController placeBirthController;
  late TextEditingController affidavitController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    // addressController = TextEditingController(text: widget.address);
    applicationDateController =
        TextEditingController(text: widget.applicationDate);
    dateofBirthController = TextEditingController(text: widget.dateofBirth);
    ageController = TextEditingController(text: widget.age);
    countryController = TextEditingController(text: widget.country);
    genderController = TextEditingController(text: widget.gender);
    languageSpokenController =
        TextEditingController(text: widget.languageSpoken);
    relationTypeController = TextEditingController(text: widget.relationType);
    relativeNameController = TextEditingController(text: widget.relativeName);
    placeBirthController = TextEditingController(text: widget.placeBirth);
    affidavitController = TextEditingController(text: widget.affidavit);
    _fetchLoginId();
  }

  Future<void> _registerUser() async {
    final url = '$baseUrl/androidapi/oauth/token';
    String credentials =
        'cctnsws:ea5be3a221d5761d0aab36bd13357b93-28920be3928b4a02611051d04a2dcef9-f1e961fadf11b03227fa71bc42a2a99a-8f3918bc211a5f27198b04cd92c9d8fe-bfa8eb4f98e1668fc608c4de2946541a';
    String basicAuth = 'Basic ${base64Encode(utf8.encode(credentials)).trim()}';

    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final client = IOClient(ioc);
      final response = await client.post(
        Uri.parse(url),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'password',
          'username': 'icjsws',
          'password': 'cctns@123',
        },
      );

      if (response.statusCode == 200) {
        final tokenData = json.decode(response.body);
        String accessToken = tokenData['access_token'];

        final accountUrl =
            '$baseUrl/androidapi/mobile/service/addVerificationRequest';
        final DateTime dob = DateTime.parse(
            widget.dateofBirth); // Parse the date string into DateTime object
        final String formattedDob =
            DateFormat('dd/MM/yyyy').format(dob); // Format the DateTime object

        final accountResponse = await client.post(
          Uri.parse(accountUrl),
          body: json.encode({
            "userName": loginId,
            "email": "$email",
            "firstName": widget.name,
            "middleName": null,
            "lastName": null,
            "applicationsubmissionDate":
                DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
            "relationType": widget.relationId,
            "relativesName": widget.relativeName,
            "placeofBirth": widget.placeBirth,
            "languagesSpoken": widget.languagesId,
            // "dialect": widget.languagesId,
            "gender": widget.genderId,
            "nationality": widget.country,
            "permanentVillage":
                isChecked ? paddressController.text : addressController.text,
            "age": "31",
            "permanentTehsil": null,
            "permanentLandline": "91",
            "permanentLandline1": null,
            "permanentLandline2": null,
            "permanentCountry": isChecked
                ? int.tryParse(pcountryController.text)
                : int.tryParse(aCountryController.text),
            "permanentState": isChecked
                ? int.tryParse(presentStateCode!)
                : int.tryParse(permanentStateCode!),
            "permanentDistrict": isChecked
                ? int.tryParse(presentDistrictCode!)
                : int.tryParse(permanentDistrictCode!),
            "permanentPoliceStation": isChecked
                ? int.tryParse(presentPoliceStationCode!)
                : int.tryParse(permanentPoliceStationCode!),
            "permanentPincode": null,
            "permanentMobile": "91",
            "permanentMobile1": null,
            "presentHouseNo": null,
            "presentStreetName": null,
            "presentColony": null,
            "presentVillage": paddressController.text,
            "presentTehsil": null,
            "presentLandline": "91",
            "presentLandline1": null,
            "presentLandline2": null,
            "sameforPermanent": isChecked ? 'Y' : 'N',
            "presentCountry": int.tryParse(pcountryController.text),
            "presentState": int.tryParse(presentStateCode!),
            "presentDistrict": int.tryParse(presentDistrictCode!),
            "presentPoliceStation": int.tryParse(presentPoliceStationCode!),
            "presentPincode": null,
            "presentMobile": "91",
            "presentMobile1": null,
            "nationIdType": null,
            "rationCardDrivingLicenseNo": null,
            "anyotherIdName": 0,
            "anyotheridNo": null,
            "nameOfSarpanch": null,
            "identificationMarkOthersIfAny": null,
            "relative1FirstName": relativeInfoNameController.text,
            "relative1MiddleName": null,
            "relative1LastName": null,
            "relative1Mobile1": "91",
            "relative1Mobile2": null,
            "relative1HouseNo": null,
            "relative1StreetName": null,
            "relative1Colony": null,
            "relative1Village": relativeInfoAddressController.text,
            "relative1Tehsil": null,
            "relative1Country": int.tryParse(rcountryController.text),
            "relative1State": int.tryParse(relativeStateCode!),
            "relative1District": int.tryParse(relativeDistrictCode!),
            "relative1PoliceStation": int.tryParse(relativePoliceStationCode!),
            "relative1Pincode": null,
            "isOtherRelativeInfo": "N",
            "relative2FirstName": null,
            "relative2MiddleName": null,
            "relative2LastName": null,
            "relative2Mobile1": "91",
            "relative2Mobile2": null,
            "relative2HouseNo": null,
            "relative2StreetName": null,
            "relative2Colony": null,
            "relative2Village": null,
            "relative2Tehsil": null,
            "relative2Country": 80,
            "relative2State": 0,
            "relative2District": 0,
            "relative2PoliceStation": 0,
            "relative2Pincode": null,
            "introducerFirstName": null,
            "introducerMiddleName": null,
            "introducerLastName": null,
            "introducerLandline1": "91",
            "introducerLandline2": null,
            "introducerLandline3": null,
            "introducerMobile1": "91",
            "introducerMobile2": null,
            "introducerHouseNo": null,
            "introducerStreetName": null,
            "introducerColony": null,
            "introducerVillage": null,
            "introducerTehsil": null,
            "introducerCountry": 80,
            "introducerState": 12,
            "introducerDistrict": 0,
            "introducerPoliceStation": 0,
            "introducerPincode": null,
            "masterFirstName": "$firstName",
            "masterMiddleName": null,
            "masterLastName": null,
            "masterMobileNo2": "$mobile2",
            "masterMobileNo1": "91",
            "masterEmailId": "$email",
            "masterHouseNo": null,
            "masterStreetName": null,
            "masterColony": null,
            "masterVillage": masterAddressController.text,
            "masterCountry": int.tryParse(masterCountryController.text),
            "masterState": int.tryParse(masterStateCode!),
            "masterDistrict": int.tryParse(masterDistrictCode!),
            "masterPoliceStation": int.tryParse(masterPoliceStationCode!),
            "hasWorkExperience": isWorked ? 'Y' : 'N',
            "nameofEmployer": isWorked ? previousEmployerNameController : '',
            "dateEmployed": null,
            "employerLandline1": "91",
            "employerLandline2": null,
            "employerLandline3": null,
            "employerMobile1": "91",
            "employerMobile2": isWorked
                ? int.tryParse(previousEmployerMobileController.text)
                : '',
            "employerHouseNo": null,
            "employerStreetName": null,
            "employerColony": null,
            "employerVillage":
                isWorked ? previousEmployerAddressController : '',
            "employerTehsil": null,
            "employerCountry":
                isWorked ? int.tryParse(preCountryController.text) : 0,
            "employerState": isWorked ? int.tryParse(preStateCode!) : 0,
            "employerDistrict": isWorked ? int.tryParse(preDistrictCode!) : 0,
            "employerPoliceStation":
                isWorked ? int.tryParse(prePoliceStationCode!) : 0,
            "hasAnyCriminalDetails": widget.isCriminal ? 'Y' : 'N',
            "oRecord": 1,
            "ResidentialPresentAddress": 1,
            "ResidentialPermanentAddress": 2,
            "OtherAddress": 4,
            "LoggedInUser": "$loginId",
            "submitdomestic": "submit",
            "domesticVerificationServant": {
              "commonPaneldateOfBirth": formattedDob,
              "commonPanelAgeYear": widget.age,
            },
            "files": [
              {
                "fileName": "Helper_document.pdf",
                "fieldName": "identificationDocuments",
                "fileData": documentBase64String ?? '',
                "fileTypeCd": 8
              },
              {
                "fileName": "Helper_photo.jpg",
                "fieldName": "Photograph",
                "fileData": photoBase64String ?? '',
                "fileTypeCd": 1
              }
            ]
          }),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
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
      } else {
        print('Failed to fetch token${response.body}');
        _showErrorDialog('Technical issue, Try again later');
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
                          const DomesticHelpVerificationViewPage(),
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
                      builder: (context) =>
                          const CitizenGridPage(),
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
    applicationDateController.dispose();
    dateofBirthController.dispose();
    ageController.dispose();
    countryController.dispose();
    genderController.dispose();
    languageSpokenController.dispose();
    relationTypeController.dispose();
    relativeNameController.dispose();
    placeBirthController.dispose();
    affidavitController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldLogout = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CitizenGridPage()));
        return shouldLogout;
      },
      child:Scaffold(
      appBar: AppBar(
        title: const Text(
          'Helper Verification Details',
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
            key: _PccaffidavitDetailsFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Please Fill the Mandatory Details',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
                const SizedBox(height: 10),
                const Text('Helper Address Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: paddressController,
                  decoration: InputDecoration(
                    labelText: 'Present Address',
                    prefixIcon: const Icon(Icons.home),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 2,
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
                StateDistrictDynamicPage(
                  onStateSelected: (stateCode) {
                    setState(() {
                      if (isChecked) {
                        permanentStateCode = stateCode;
                      } else {
                        presentStateCode = stateCode;
                      }
                    });
                  },
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                          //  widget.onAddressSame(isChecked);
                          if (isChecked) {
                            addressController.text = paddressController.text;
                            aCountryController.text = pcountryController.text;
                            permanentStateCode = presentStateCode;
                            permanentDistrictCode = presentDistrictCode;
                            permanentPoliceStationCode =
                                presentPoliceStationCode;
                          } else {
                            // Clear the present address fields if unchecked
                            addressController.clear();
                            aCountryController.clear();
                            permanentStateCode = null;
                            permanentDistrictCode = null;
                            permanentPoliceStationCode = null;
                          }
                        });
                      },
                    ),
                    const Text('Permanent address\nsame as present address'),
                  ],
                ),
                if (!isChecked)
                  Column(
                    children: [
                      TextFormField(
                        controller: addressController,
                        enabled: true,
                        decoration: InputDecoration(
                          labelText: 'Permanent Address',
                          prefixIcon: const Icon(Icons.home),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      CountryPage(
                          controller: aCountryController, enabled: true),
                      const SizedBox(height: 8),
                      StateDistrictDynamicPage(
                        onStateSelected: (stateCode) {
                          setState(() {
                            permanentStateCode = stateCode;
                          });
                        },
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
                const SizedBox(height: 10),
                const Text('Please Fill the Mandatory Details',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
                const SizedBox(height: 10),
                const Text("Helper Relative Information",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: relativeInfoNameController,
                  decoration: InputDecoration(
                    labelText: 'Relative Name',
                    prefixIcon: const Icon(Icons.person_4),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter relative full name';
                    }
                    return ValidateFullName(value);
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: relativeInfoAddressController,
                  decoration: InputDecoration(
                    labelText: 'Relative Address',
                    prefixIcon: const Icon(Icons.pin),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter relative address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                CountryPage(
                  controller: rcountryController,
                  enabled: true,
                ),
                const SizedBox(height: 8),
                StateDistrictDynamicPage(
                  onStateSelected: (stateCode) {
                    setState(() {
                      relativeStateCode = stateCode;
                    });
                  },
                  onDistrictSelected: (districtCode) {
                    setState(() {
                      relativeDistrictCode = districtCode;
                    });
                  },
                  onPoliceStationSelected: (policeStationCode) {
                    setState(() {
                      relativePoliceStationCode = policeStationCode;
                    });
                  },
                ),
                const SizedBox(height: 10),
                const Text('Please Fill the Mandatory Details',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
                const SizedBox(height: 10),
                const Text("Previous Employer Information",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text('Has worked before?'),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        value: true,
                        groupValue: isWorked,
                        onChanged: (val) {
                          setState(() {
                            isWorked = val!;
                            // widget.onWorkedStatusChanged(isWorked);
                          });
                        },
                        title: const Text('Yes'),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        value: false,
                        groupValue: isWorked,
                        onChanged: (val) {
                          setState(() {
                            isWorked = val!;
                            // onWorkedStatusChanged(isWorked);
                          });
                        },
                        title: const Text("No"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (isWorked) ...[
                  TextFormField(
                    controller: previousEmployerNameController,
                    decoration: InputDecoration(
                      labelText: 'Previous Employer Name',
                      prefixIcon: const Icon(Icons.person_4_outlined),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter previous employer name';
                      }
                      return ValidateFullName(value);
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: previousEmployerAddressController,
                    decoration: InputDecoration(
                      labelText: 'Previous Employer Address',
                      prefixIcon: const Icon(Icons.home_filled),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter previous employer address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  CountryPage(controller: preCountryController, enabled: true),
                  const SizedBox(height: 8),
                  StateDistrictDynamicPage(
                    onStateSelected: (stateCode) {
                      setState(() {
                        preStateCode = stateCode;
                      });
                    },
                    onDistrictSelected: (districtCode) {
                      setState(() {
                        preDistrictCode = districtCode;
                      });
                    },
                    onPoliceStationSelected: (policeStationCode) {
                      setState(() {
                        prePoliceStationCode = policeStationCode;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: previousEmployerMobileController,
                    decoration: InputDecoration(
                      labelText: 'Previous Employer Mobile Number',
                      prefixIcon: const Icon(Icons.phone),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter previous employer mobile number';
                      }
                      return ValidateMobile(value);
                    },
                  ),
                ],
                const SizedBox(height: 10),
                const Text('Please Fill the Mandatory Details',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
                const SizedBox(height: 10),
                const Text("Master User Information",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: masterNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter full name';
                    }
                    return ValidateFullName(value);
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: masterMobileController,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    prefixIcon: const Icon(Icons.call),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter mobile number';
                    }
                    return ValidateMobile(value);
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: masterAddressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    prefixIcon: const Icon(Icons.home_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                CountryPage(controller: masterCountryController, enabled: true),
                const SizedBox(height: 8),
                StateDistrictDynamicPage(
                  onStateSelected: (stateCode) {
                    setState(() {
                      masterStateCode = stateCode;
                    });
                  },
                  onDistrictSelected: (districtCode) {
                    setState(() {
                      masterDistrictCode = districtCode;
                    });
                  },
                  onPoliceStationSelected: (policeStationCode) {
                    setState(() {
                      masterPoliceStationCode = policeStationCode;
                    });
                  },
                ),
                const Text('Helper Personal Information',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: widget.genderDescription,
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
                  controller: dateofBirthController,
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
                TextFormField(
                  controller: placeBirthController,
                  decoration: InputDecoration(
                    labelText: 'Place of Birth',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: applicationDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Application Date',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: widget.languagesDescription,
                  readOnly: true, // Makes the field uneditable
                  decoration: InputDecoration(
                    labelText: 'Language Spoken',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: widget.selectedCountry,
                  readOnly: true, // Makes the field uneditable
                  decoration: InputDecoration(
                    labelText: 'Nationality',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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
                  initialValue: widget.relationDescription,
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
                const SizedBox(height: 20),
                const Text('Uploaded Files',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                          'Upload Photograph\n(Maximum file size limit 250 kb)'),
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
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                          'Upload Identification \n(Maximum file size limit 250 kb)'),
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _uploadDocument,
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
                if (_documentFileName != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      '$_documentFileName',
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                if (_documentWarning != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _documentWarning!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 20),
                const Text('Affidavit Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: affidavitController,
                  decoration: InputDecoration(
                    labelText: 'Affidavit',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  maxLines: 2,
                  enabled: false,
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
                          _PccaffidavitDetailsFormKey.currentState!
                              .validate() &&
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
