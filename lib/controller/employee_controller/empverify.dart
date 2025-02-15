import 'dart:convert';
import 'package:himcops/citizen/searchstaus/empviewpage.dart';
import 'package:himcops/layout/buttonstyle.dart';
import 'package:himcops/master/country.dart';
import 'package:himcops/master/empreltype.dart';
import 'package:himcops/master/sdp.dart';
import 'package:himcops/master/statedistrictdynamic.dart';
import 'package:himcops/pages/cgridhome.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:himcops/config.dart';
import 'package:himcops/drawer/drawer.dart';
// import 'package:himcops/payment/payment_page.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class EmpVerificationPage extends StatefulWidget {
  final String name;
  final String gender;
  final String dateOfBirth;
  final String age;
  final String placeBirth;
  final String documentNo;
  final String department;
  final String employeeAffidavit;
  final String employeeAddressVerification;
  final String employeePoliceStation;
  final String applicationDate;
  final String selectedCountry;
  final String selectedState;
  final bool isCriminal;
  final bool isChecked;
  final int genderId;
  final String genderDescription;
  final int addressId;
  final String addressDescription;

  const EmpVerificationPage({
    super.key,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.age,
    required this.placeBirth,
    required this.documentNo,
    required this.department,
    required this.employeeAffidavit,
    required this.employeeAddressVerification,
    required this.employeePoliceStation,
    required this.applicationDate,
    required this.selectedCountry,
    required this.selectedState,
    required this.isCriminal,
    required this.isChecked,
    required this.genderId,
    required this.genderDescription,
    required this.addressId,
    required this.addressDescription,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EmpVerificationPageState createState() => _EmpVerificationPageState();
}

class _EmpVerificationPageState extends State<EmpVerificationPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aCountryController = TextEditingController();
  final TextEditingController paddressController = TextEditingController();
  final TextEditingController pcountryController = TextEditingController();
  final TextEditingController relativeNameController = TextEditingController();
  final TextEditingController relationTypeController = TextEditingController();
  final TextEditingController relativeAddressController =
      TextEditingController();
  final TextEditingController relativeCountryController =
      TextEditingController();
  final TextEditingController employerNameController = TextEditingController();
  final TextEditingController employerRoleController = TextEditingController();
  final TextEditingController employerAddressController =
      TextEditingController();
  final TextEditingController employerCountryController =
      TextEditingController();
  final GlobalKey<FormState> _PccaffidavitDetailsFormKey =
      GlobalKey<FormState>();
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
  String? relativeStateCode;
  String? relativeDistrictCode;
  String? relativePoliceStationCode;
  String? employerStateCode;
  String? employerDistrictCode;
  String? employerPoliceStationCode;
  String? _photoWarning;
  String? _documentWarning;
  File? _photoFileName;
  File? _documentFileName;
  String? photoBase64String;
  String? documentBase64String;

  String? ValidateRole(String value) {
    if (!RegExp(r"^[a-zA-Z\s]{1,20}$").hasMatch(value)) {
      return "Role should only contain alphabets\nand not exceed 20 words";
    }
    return null;
  }

  String? ValidateFullName(String value) {
    if (!RegExp(r"^[a-zA-Z\s]{1,50}$").hasMatch(value)) {
      return "Current Employer name should only contain alphabets and spaces\nand not exceed 50 words";
    }
    return null;
  }

  String? ValidateRelative(String value) {
    if (!RegExp(r"^[a-zA-Z\s]{1,50}$").hasMatch(value)) {
      return "Relative name should only contain alphabets\nand not exceed 50 words";
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
  late TextEditingController genderController;
  late TextEditingController dateOfBirthController;
  late TextEditingController ageController;
  late TextEditingController placeBirthController;
  late TextEditingController docController;
  late TextEditingController departmentController;
  late TextEditingController employeeAffidavitController;
  late TextEditingController employeeAddressVerificationController;
  late TextEditingController employeePoliceStationController;
  late TextEditingController applicationDateController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.name);
    genderController = TextEditingController(text: widget.gender);
    dateOfBirthController = TextEditingController(text: widget.dateOfBirth);
    ageController = TextEditingController(text: widget.age);
    placeBirthController = TextEditingController(text: widget.placeBirth);
    docController = TextEditingController(text: widget.documentNo);
    departmentController = TextEditingController(text: widget.department);
    employeeAffidavitController =
        TextEditingController(text: widget.employeeAffidavit);
    employeeAddressVerificationController =
        TextEditingController(text: widget.employeeAddressVerification);
    employeePoliceStationController =
        TextEditingController(text: widget.employeePoliceStation);
    applicationDateController =
        TextEditingController(text: widget.applicationDate);
    _fetchLoginId();
  }

  String loginId = '';
  String firstname = '';
  String fullName = '';
  String email = '';
  int? mobile2;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> _fetchLoginId() async {
    final String? storedLoginId = await _storage.read(key: 'loginId');
    final String? storedfirstname = await _storage.read(key: 'firstname');
    final String? storedfullName = await _storage.read(key: 'fullName');
    final String? storedemail = await _storage.read(key: 'email');
    final String? storedMobile2 = await _storage.read(key: 'mobile2');
    print(
        'loginID:$storedLoginId, firstname:$storedfirstname, fullname:$storedfullName, email:$storedemail');
    setState(() {
      loginId = storedLoginId ?? 'Unknown';
      firstname = storedfirstname ?? 'Unknown';
      fullName = storedfullName ?? 'Unknown';
      email = storedemail ?? 'Unknown';
      mobile2 = storedMobile2 != null ? int.tryParse(storedMobile2) : 0;
    });
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
            '$baseUrl/androidapi/mobile/service/addEmployeeVerification';
        final DateTime dob = DateTime.parse(
            widget.dateOfBirth); // Parse the date string into DateTime object
        final String formattedDob =
            DateFormat('dd/MM/yyyy').format(dob); // Format the DateTime object

        final accountResponse = await client.post(
          Uri.parse(accountUrl),
          body: json.encode({
            "userName": loginId,
            "uid": "$email",
            "basicOrganization": widget.department,
            "basicApplicationDate": DateFormat('dd/MM/yyyy HH:mm:ss')
                .format(DateTime.now()), //"21/11/2024",
            "basicEmailId": "$email",
            "employeeFirstName": widget.name,
            "employeeRelationType": int.tryParse(relationTypeController.text),
            "employeeRelativeName": relativeNameController.text,
            "employeeGender": widget.genderId,
            "employeePlaceofBirth": widget.placeBirth,
            "permenantVillageTownCity":
                isChecked ? paddressController.text : addressController.text,
            "permenantCountry": isChecked
                ? int.tryParse(pcountryController.text)
                : int.tryParse(aCountryController.text),
            "permenantDistrict": isChecked
                ? int.tryParse(presentDistrictCode!)
                : int.tryParse(permanentDistrictCode!),
            "permenantPoliceStation": isChecked
                ? int.tryParse(presentPoliceStationCode!)
                : int.tryParse(permanentPoliceStationCode!),
            "presentVillageTownCity": paddressController.text,
            "presentCountry": int.tryParse(pcountryController.text),
            "presentDistrict": int.tryParse(presentDistrictCode!),
            "presentPoliceStation": int.tryParse(presentPoliceStationCode!),
            "previousEmployerName": "",
            "previousEmployerFromDate": "",
            "previousEmployerToDate": "",
            "previousEmployerMobileNo": "91",
            "previousEmployerMobileNo1": "",
            "previousEmployerVillageTownCity": "",
            "previousEmployerCountry": 0,
            "previousEmployerState": 0,
            "previousEmployerDistrict": 0,
            "previousEmployerPoliceStation": 0,
            "currentEmployerName": employerNameController.text,
            "currentEmployerMobileNo": "91",
            "currentEmployerMobileNo1": "",
            "currentEmployerRoleOfEmployee": employerRoleController.text,
            "currentEmployerVillageTownCity": employerAddressController.text,
            "currentEmployerCountry":
                int.tryParse(employerCountryController.text),
            "currentEmployerState": int.tryParse(employerStateCode!),
            "currentEmployerDistrict": int.tryParse(employerDistrictCode!),
            "currentEmployerPoliceStation":
                int.tryParse(employerPoliceStationCode!),
            "addressVerificationDocument": widget.addressId,
            "documentNo": widget.documentNo,
            "policeStationName": int.tryParse(presentPoliceStationCode!),
            "hasAnyCriminalRecord": widget.isCriminal ? 'Y' : 'N',
            "affidivitDetails":
                widget.isCriminal ? widget.employeeAffidavit : '',
            "oRecord": 1,
            "fileTypeCd": 0,
            "fileSubTypeCd": 0,
            "submitemployee": "submit",
            "state2": 0,
            "dist2": 0,
            "emplVerificationEmployee": {
              "commonPaneldateOfBirth": formattedDob,
              "commonPanelAgeYear": widget.age,
            },
            "employeeVerificationRelativeBo": [
              {
                "employeeRelationType":
                    int.tryParse(relationTypeController.text),
                "presCountryCd": int.tryParse(relativeCountryController.text),
                "presStateCd": int.tryParse(relativeStateCode!),
                "presDistrictCd": int.tryParse(relativeDistrictCode!),
                "presVill": relativeAddressController.text,
                "presPsCd": int.tryParse(relativePoliceStationCode!),
              }
            ],
            "files": [
              {
                "fileName": 'employee_photo.jpg',
                "fieldName": "scanPhotoUpload",
                "fileData": photoBase64String ?? '',
                "fileTypeCd": 1,
              },
              {
                "fileName": 'employee_document.pdf',
                "fieldName": "docUpload",
                "fileData": documentBase64String ?? '',
                "fileTypeCd": 8
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
                          const EmployeeVerificationViewPage(),
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
    nameController.dispose();
    genderController.dispose();
    dateOfBirthController.dispose();
    ageController.dispose();
    placeBirthController.dispose();
    docController.dispose();
    departmentController.dispose();
    employeeAffidavitController.dispose();
    employeeAddressVerificationController.dispose();
    employeePoliceStationController.dispose();
    applicationDateController.dispose();

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
      child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee Verification Details',
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
                const Text('Employee Address Details',
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
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Text(
                      '*Note: If you are from other states,\nplease visit yourstate Police Station*',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
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
                            // permanentStateCode = presentStateCode;
                            permanentDistrictCode = presentDistrictCode;
                            permanentPoliceStationCode =
                                presentPoliceStationCode;
                          } else {
                            // Clear the present address fields if unchecked
                            addressController.clear();
                            aCountryController.clear();
                            // widget.selectedState.clear();
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
                  Column(children: [
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
                  ]),
                const SizedBox(height: 10),
                const Text('Please Fill the Mandatory Details',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
                const SizedBox(height: 10),
                const Text("Employee Relative's Details",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: relativeNameController,
                  decoration: InputDecoration(
                    labelText: 'Relative Full Name',
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return ValidateRelative(value);
                  },
                ),
                const SizedBox(height: 8),
                EmpRelationTypePage(controller: relationTypeController),
                const SizedBox(height: 8),
                TextFormField(
                  controller: relativeAddressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
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
                  controller: relativeCountryController,
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
                const Text("Current Employer Details",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: employerNameController,
                  decoration: InputDecoration(
                    labelText: 'Name of the Employer',
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name of your current employer';
                    }
                    return ValidateFullName(value);
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: employerRoleController,
                  decoration: InputDecoration(
                    labelText: 'Role of the Employer',
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter role of your current employer';
                    }
                    return ValidateRole(value);
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: employerAddressController,
                  decoration: InputDecoration(
                    labelText: 'Employer Address',
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
                  controller: employerCountryController,
                  enabled: true,
                ),
                const SizedBox(height: 8),
                StateDistrictDynamicPage(
                  onStateSelected: (stateCode) {
                    setState(() {
                      employerStateCode = stateCode;
                    });
                  },
                  onDistrictSelected: (districtCode) {
                    setState(() {
                      employerDistrictCode = districtCode;
                    });
                  },
                  onPoliceStationSelected: (policeStationCode) {
                    setState(() {
                      employerPoliceStationCode = policeStationCode;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text('Basic Information',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: departmentController,
                  decoration: InputDecoration(
                    labelText: 'Department Name',
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
                const SizedBox(height: 20),
                const Text('Employee Personal Information',
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
                const SizedBox(height: 20),
                const Text("Employee Other Details",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextFormField(
                  initialValue: widget.addressDescription,
                  readOnly: true, // Makes the field uneditable
                  decoration: InputDecoration(
                    labelText: 'Address Verification',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: docController,
                  decoration: InputDecoration(
                    labelText: 'Document Number',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Uploaded Files',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                          'Upload Counsellor/Pradhan Report\n(Maximum file size limit 250 kb)'),
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
                const Text('Employee Affidavit Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: employeeAffidavitController,
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
