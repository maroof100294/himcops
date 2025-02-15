import 'package:flutter/material.dart';
import 'package:himcops/citizen/searchstaus/pccviewpage.dart';
import 'package:himcops/config.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/layout/buttonstyle.dart';
import 'package:himcops/master/country.dart';
import 'package:himcops/master/statedistrictdynamic.dart';
import 'package:himcops/pages/cgridhome.dart';
import 'package:himcops/payment/payment_page.dart';
import 'package:http/io_client.dart';
// import 'package:himcops/payment/payment_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VerificationPage extends StatefulWidget {
  final String name;
  final String relationType;
  final String descriptionService;
  final String relativeName;
  final String modeReceiving;
  final String gender;
  final String dateOfBirth;
  final String age;
  final String affidavitDetails;
  final String selectedCountry;
  final bool isCriminal;
  final bool isChecked;
  final int genderId;
  final String genderDescription;
  final int relationId;
  final String relationDescription;

  const VerificationPage({
    super.key,
    required this.name,
    required this.relationType,
    required this.descriptionService,
    required this.relativeName,
    required this.modeReceiving,
    required this.gender,
    required this.dateOfBirth,
    required this.age,
    required this.affidavitDetails,
    required this.selectedCountry,
    required this.isCriminal,
    required this.isChecked,
    required this.genderId,
    required this.genderDescription,
    required this.relationId,
    required this.relationDescription,
  });

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aCountryController = TextEditingController();
  final TextEditingController aStateController = TextEditingController();
  final TextEditingController aSdistrictController = TextEditingController();
  final TextEditingController aDistrictController = TextEditingController();
  final TextEditingController aPoliceStationController =
      TextEditingController();
  final TextEditingController paddressController = TextEditingController();
  final TextEditingController pcountryController = TextEditingController();
  final TextEditingController pStateController = TextEditingController();
  final TextEditingController pSdistrictController = TextEditingController();
  final TextEditingController pDistrictController = TextEditingController();
  final TextEditingController pPoliceStationController =
      TextEditingController();
  final TextEditingController pYearsStayController = TextEditingController();
  final TextEditingController pMonthsStayController = TextEditingController();
  final TextEditingController aYearsStayController = TextEditingController();
  final TextEditingController aMonthsStayController = TextEditingController();
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
  String? _photoWarning;
  String? _documentWarning;
  File? _photoFileName;
  File? _documentFileName;
  String? photoBase64String;
  String? documentBase64String;

  // Controllers for TextFormField
  late TextEditingController nameController;
  late TextEditingController relationTypeController;
  late TextEditingController descriptionServiceController;
  late TextEditingController relativeNameController;
  late TextEditingController modeReceivingController;
  late TextEditingController genderController;
  late TextEditingController dateOfBirthController;
  late TextEditingController ageController;
  late TextEditingController affidavitDetailsController;

  String? ValidateYear(String value) {
    if (!RegExp(r"^[0-9]{1,2}$").hasMatch(value)) {
      return "Year should only contain number";
    }
    return null;
  }

  String? ValidateMonth(String value) {
    if (!RegExp(r"^[0-9]{1,2}$").hasMatch(value)) {
      return "Month should only contain number";
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

  @override
  void initState() {
    super.initState();

    // Initialize controllers with widget values
    nameController = TextEditingController(text: widget.name);
    relationTypeController = TextEditingController(text: widget.relationType);
    descriptionServiceController =
        TextEditingController(text: widget.descriptionService);
    relativeNameController = TextEditingController(text: widget.relativeName);
    modeReceivingController = TextEditingController(text: widget.modeReceiving);
    genderController = TextEditingController(text: widget.gender);
    dateOfBirthController = TextEditingController(text: widget.dateOfBirth);
    ageController = TextEditingController(text: widget.age);
    affidavitDetailsController =
        TextEditingController(text: widget.affidavitDetails);

    _fetchLoginId();
  }

  String loginId = '';
  String firstname = '';
  int? mobile2;
  String email = '';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> _fetchLoginId() async {
    final String? storedLoginId = await _storage.read(key: 'loginId');
    final String? storedfirstname = await _storage.read(key: 'firstname');
    final String? storedemail = await _storage.read(key: 'email');
    final String? storedMobile2 = await _storage.read(key: 'mobile2');
    setState(() {
      loginId = storedLoginId ?? 'Unknown';
      firstname = storedfirstname ?? 'Unknown';
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
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
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

        final accountUrl = '$baseUrl/androidapi/mobile/service/pcr';

        final accountResponse = await client.post(
          Uri.parse(accountUrl),
          body: json.encode({
            'uid': ' ',
            'userName': loginId,
            'firstname': widget.name,
            'purpose': widget.descriptionService,
            'modeofrecievingCd': 2,
            'genderCd': widget.genderId,
            'relationCd': widget.relationId,
            'relativename': widget.relativeName,
            'strmobilenum1': '91',
            'strMobilenum': '$mobile2',
            'email': '$email',
            'ccrCharacter': {
              'commonPaneldateOfBirth': widget.dateOfBirth,
              'commonPanelAgeYear': widget.age,
            },
            'permCountryCd': isChecked
                ? int.tryParse(pcountryController.text)
                : int.tryParse(aCountryController.text),
            'permStateCd': isChecked
                ? int.tryParse(presentStateCode!)
                : int.tryParse(permanentStateCode!),
            'permDistrictCd': isChecked
                ? int.tryParse(presentDistrictCode!)
                : int.tryParse(permanentDistrictCode!),
            'permvillage':
                isChecked ? paddressController.text : addressController.text,
            'permPsCd': isChecked
                ? int.tryParse(presentPoliceStationCode!)
                : int.tryParse(permanentPoliceStationCode!),
            'samepermenant': isChecked ? 'Y' : 'N',
            'permdurationyr': isChecked
                ? pYearsStayController.text
                : aYearsStayController.text,
            'permdurationmonth': isChecked
                ? pMonthsStayController.text
                : aMonthsStayController.text,
            'previllage': paddressController.text,
            'preCountryCd': int.tryParse(pcountryController.text),
            'preStateCd': int.tryParse(presentStateCode!),
            'preDistrictCd': int.tryParse(presentDistrictCode!),
            'prePsCd': int.tryParse(presentPoliceStationCode!),
            'predurationyr': int.tryParse(pYearsStayController.text),
            'predurationmonth': int.tryParse(pMonthsStayController.text),
            'criminalproceeding': widget.isCriminal ? 'Y' : 'N',
            "criminalproceedingdetails":
                widget.isCriminal ? widget.affidavitDetails : '',
            "idtypeCd": 0,
            'charLimitId': 250,
            'allinfotrue': 'Y',
            '_allinfotrue': 'on',
            'files': [
              {
                'fileName': 'Pcc_Photo.jpg',
                'fileData': photoBase64String ?? '',
                'fileTypeCd': 1,
              },
              {
                'fileName': 'Pcc_Report.pdf',
                'fileData': documentBase64String ?? '',
                'fileTypeCd': 8,
              },
            ],
          }),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (accountResponse.statusCode == 200) {
          final accountData = json.decode(accountResponse.body);
          String mercid = accountData['data']['mercid'];
          String bdorderid = accountData['data']['bdorderid'];
          String rdata = accountData['data']['rdata'];
          String token = accountData['data']['token'];
          // _showConfirmationDialog();
          print('$mercid, $bdorderid, $token');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PaymentPage(
                mercid: mercid,
                bdorderid: bdorderid,
                rdata: rdata,
                token: token,
              ),
            ),
          );
        } else {
          print('Failed to enter ${accountResponse.body}, $loginId, $mobile2');
          // _showErrorDialog('Please fill the details');
          _showErrorDialog(
              'Failed to enter ${accountResponse.body}, $loginId, $mobile2');
        }
      } else {
        print('Failed to fetch token${response.body}');
        // _showErrorDialog('Technical issue, Try again later');
        _showErrorDialog('Failed to fetch token${response.body}');
      }
    } catch (e) {
      setState(() {
        print('Error occurred: $e');
        // _showErrorDialog('Technical Server issue, Try again later');
        _showErrorDialog('Error occurred: $e');
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
            content: const Text(
                'Thank you for submitting your Verification details.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          const PoliceClearanceCertificateViewPage(),
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
    descriptionServiceController.dispose();
    relativeNameController.dispose();
    modeReceivingController.dispose();
    genderController.dispose();
    dateOfBirthController.dispose();
    ageController.dispose();
    addressController.dispose();
    affidavitDetailsController.dispose();

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
            'PCC Verification Details',
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
                  const Text('Please Fill the Address Details first',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                  const SizedBox(height: 20),
                  const Text('Address Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
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
                    enabled: false,
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
                      const Expanded(child: Text('Duration of Stay')),
                      Expanded(
                        child: TextFormField(
                          controller: pYearsStayController,
                          decoration: InputDecoration(
                            labelText: 'Years',
                            prefixIcon:
                                const Icon(Icons.calendar_today_outlined),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter year';
                            }
                            return ValidateYear(value);
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: pMonthsStayController,
                          decoration: InputDecoration(
                            labelText: 'Months',
                            prefixIcon:
                                const Icon(Icons.calendar_today_outlined),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter months';
                            }
                            return ValidateMonth(value);
                          },
                        ),
                      ),
                    ],
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
                              permanentStateCode = presentStateCode;
                              permanentDistrictCode = presentDistrictCode;
                              permanentPoliceStationCode =
                                  presentPoliceStationCode;
                              aYearsStayController.text =
                                  pYearsStayController.text;
                              aMonthsStayController.text =
                                  pMonthsStayController.text;
                            } else {
                              addressController.clear();
                              aCountryController.clear();
                              permanentStateCode = null;
                              permanentDistrictCode = null;
                              permanentPoliceStationCode = null;
                              aYearsStayController.clear();
                              aMonthsStayController.clear();
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
                            controller: aCountryController, enabled: false),
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
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Expanded(child: Text('Duration of Stay')),
                            Expanded(
                              child: TextFormField(
                                controller: aYearsStayController,
                                decoration: InputDecoration(
                                  labelText: 'Years',
                                  prefixIcon:
                                      const Icon(Icons.calendar_today_outlined),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter year';
                                  }
                                  return ValidateYear(value);
                                },
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: aMonthsStayController,
                                decoration: InputDecoration(
                                  labelText: 'Months',
                                  prefixIcon:
                                      const Icon(Icons.calendar_today_outlined),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter months';
                                  }
                                  return ValidateMonth(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  const Text('Personal Information',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nameController,
                    readOnly: true,
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
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: descriptionServiceController,
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
                    controller: modeReceivingController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Mode of Receiving',
                      filled: true,
                      fillColor: Colors.grey[100],
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
                  const SizedBox(height: 20),
                  const Text('Uploaded Files',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
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
                  const Text('Affidavit Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: affidavitDetailsController,
                    decoration: InputDecoration(
                      labelText: 'Affidavit',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
