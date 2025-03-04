import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/layout/buttonstyle.dart';
import 'package:himcops/master/country.dart';
import 'package:himcops/master/district.dart';
import 'package:himcops/master/officename.dart';
import 'package:himcops/master/policestation.dart';
import 'package:himcops/master/sdp.dart';

class ComplaintVerificationPage extends StatefulWidget {
  final String name;
  final String dateDob;
  final String age;
  final String mobile;
  final String email;
  final String complaintNature;
  final String identify;
  final String idNumber;
  final String incidentDateTimeFrom;
  final String incidentDateTimeTo;
  final String incidentPlace;
  final String date;
  final String complaintDescription;
  final String selectedState;
  // final int applicantIdentityId;
  // final int applicantComplaintId;

  const ComplaintVerificationPage({
    super.key,
    required this.name,
    required this.dateDob,
    required this.age,
    required this.mobile,
    required this.email,
    required this.complaintNature,
    required this.identify,
    required this.idNumber,
    required this.incidentDateTimeFrom,
    required this.incidentDateTimeTo,
    required this.incidentPlace,
    required this.date,
    required this.complaintDescription,
    required this.selectedState,
    // required this.applicantIdentityId,
    // required this.applicantComplaintId,
  });

  @override
  _ComplaintVerificationPageState createState() =>
      _ComplaintVerificationPageState();
}

class _ComplaintVerificationPageState extends State<ComplaintVerificationPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aCountryController = TextEditingController();
  final TextEditingController paddressController = TextEditingController();
  final TextEditingController pcountryController = TextEditingController();
  final TextEditingController submissionPoliceController =
      TextEditingController();
  final TextEditingController submissionDistrictController =
      TextEditingController();
  final TextEditingController submissionOfficeController =
      TextEditingController();
  final GlobalKey<FormState> _affidavitDetailsFormKey = GlobalKey<FormState>();
  bool isAgree = false;
  bool _isSubmitting = false;
  bool isChecked = false;
  bool isPoliceKnown = true;
  bool isDistrictKnown = true;
  String? complaintDistrictCode;
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

  late TextEditingController nameController;
  late TextEditingController dateDobController;
  late TextEditingController ageController;
  late TextEditingController mobileController;
  late TextEditingController emailController;
  late TextEditingController complaintNatureController;
  late TextEditingController identifyController;
  late TextEditingController idNumberController;
  late TextEditingController incidentDateTimeFromController;
  late TextEditingController incidentDateTimeToController;
  late TextEditingController incidentPlaceController;
  late TextEditingController dateController;
  late TextEditingController complaintDescriptionController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.name);
    dateDobController = TextEditingController(text: widget.dateDob);
    ageController = TextEditingController(text: widget.age);
    mobileController = TextEditingController(text: widget.mobile);
    emailController = TextEditingController(text: widget.email);
    complaintNatureController =
        TextEditingController(text: widget.complaintNature);
    identifyController = TextEditingController(text: widget.identify);
    idNumberController = TextEditingController(text: widget.idNumber);
    incidentDateTimeFromController =
        TextEditingController(text: widget.incidentDateTimeFrom);
    incidentDateTimeToController =
        TextEditingController(text: widget.incidentDateTimeTo);
    incidentPlaceController = TextEditingController(text: widget.incidentPlace);
    dateController = TextEditingController(text: widget.date);
    complaintDescriptionController =
        TextEditingController(text: widget.complaintDescription);
    _fetchLoginId();
  }

  @override
  void dispose() {
    nameController.dispose();
    dateDobController.dispose();
    ageController.dispose();
    mobileController.dispose();
    emailController.dispose();
    complaintNatureController.dispose();
    identifyController.dispose();
    idNumberController.dispose();
    incidentDateTimeFromController.dispose();
    incidentDateTimeToController.dispose();
    incidentPlaceController.dispose();
    dateController.dispose();
    complaintDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Complaint Details',
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
                const Text('Complainant Personal Information',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
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
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
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
                  controller: dateDobController,
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
                  controller: ageController,
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
                  initialValue: widget.identify,
                  readOnly: true, // Makes the field uneditable
                  decoration: InputDecoration(
                    labelText: 'Identification Type',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: idNumberController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Identification Number',
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
                const Text('Complaint/Incident Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: incidentDateTimeFromController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: incidentDateTimeFromController.text.isEmpty
                        ? 'Not Known'
                        : widget.incidentDateTimeFrom,
                    // hintText: incidentDateTimeFromController.text.isEmpty
                    //     ? 'Not Known'
                    //     : widget.incidentDateTimeFrom,
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: incidentDateTimeToController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: incidentDateTimeToController.text.isEmpty
                        ? 'Not Known'
                        : widget.incidentDateTimeTo,
                    // hintText: incidentDateTimeToController.text.isEmpty
                    //     ? 'Not Known'
                    //     : widget.incidentDateTimeTo,
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: incidentPlaceController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Place of Incident',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: complaintDescriptionController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Complaint Description',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLength: 3,
                ),
                const SizedBox(height: 20),
                const Text('Complaint Submission Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Do you know your police station?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        value: true,
                        groupValue: isPoliceKnown,
                        onChanged: (val) {
                          setState(() {
                            isPoliceKnown = val!;
                          });
                        },
                        title: const Text('Yes'),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        value: false,
                        groupValue: isPoliceKnown,
                        onChanged: (val) {
                          setState(() {
                            isPoliceKnown = val!;
                          });
                        },
                        title: const Text("No"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (isPoliceKnown) ...[
                  DistrictPage(
                      controller: (districtCode) {
                        setState(() {
                          complaintDistrictCode = districtCode;
                        });
                      },
                      enabled: true),
                  const SizedBox(height: 10),
                  PoliceStationPage(
                    controller: submissionPoliceController,
                    enabled: true,
                  ),
                ] else ...[
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Do you know your district ?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          value: true,
                          groupValue: isDistrictKnown,
                          onChanged: (val) {
                            setState(() {
                              isDistrictKnown = val!;
                            });
                          },
                          title: const Text('Yes'),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          value: false,
                          groupValue: isDistrictKnown,
                          onChanged: (val) {
                            setState(() {
                              isDistrictKnown = val!;
                            });
                          },
                          title: const Text("No"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (isDistrictKnown) ...[
                    DistrictPage(
                        controller: (districtCode) {
                          setState(() {
                            complaintDistrictCode = districtCode;
                          });
                        },
                        enabled: true),
                    const SizedBox(height: 10),
                    OfficeNamePage(
                        controller: submissionOfficeController, enabled: true),
                  ] else ...[
                    OfficeNamePage(
                        controller: submissionOfficeController, enabled: true),
                  ]
                ],
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
                            //await _registerUser(); // Perform the registration logic
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
