import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:himcops/config.dart';
import 'package:himcops/layout/buttonstyle.dart';
import 'package:himcops/layout/headingstyle.dart';
import 'package:himcops/master/statedistrictdynamic.dart';
import 'package:himcops/pages/login.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/layout/formlayout.dart';
import 'package:himcops/master/country.dart';
import 'package:himcops/master/gender.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController dateDobController = TextEditingController();
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
  TextEditingController loginIDController = TextEditingController();
  bool passwordMatch = false;
  bool isPresent = true;
  bool isChecked = false;
  bool _isPasswordVisible = false;
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
  int _ageYear = 0;
  int _ageMonth = 0;
  int _yearOfBirth = 0;

  String? ValidateFullName(String value) {
    if (!RegExp(r"^[a-zA-Z\s]{1,50}$").hasMatch(value)) {
      return "Full name should only contain alphabets and spaces\nand not exceed 50 words";
    }
    return null;
  }

  String? ValidateEmail(String value) {
    if (!RegExp(
            r"^[a-zA-Z0-9._%&$!*#+-]+@(gmail\.com|yahoo\.com|hotmail\.com|outlook\.com)$")
        .hasMatch(value)) {
      return "Email should end with .com";
    }
    return null;
  }

  String? ValidateMobile(String value) {
    if (!RegExp(r"^[0-9]{10}$").hasMatch(value)) {
      return "Mobile number should only contain 10 digit";
    }
    return null;
  }

  String? ValidateUsername(String value) {
    if (!RegExp(r"^[a-zA-Z0-9._%&$!@*#+-]{6,15}$").hasMatch(value)) {
      return "Username shouldn't contain space\nnot less than 6 and not more than 15";
    }
    return null;
  }

  String? ValidatePassword(String value) {
    // ignore: valid_regexps
    if (!RegExp(r"^[a-zA-Z0-9._%&$!@*#+-]{6,15}$").hasMatch(value)) {
      return "Password should be 6-15 characters long";
    }
    return null;
  }

  void _scrollToField(GlobalKey<FormFieldState> key) {
    final RenderObject? object = key.currentContext?.findRenderObject();
    if (object is RenderBox) {
      _scrollController.animateTo(
        _scrollController.offset +
            object.localToGlobal(Offset.zero).dy -
            MediaQuery.of(context).size.height * 0.2,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _selectDob(BuildContext context) async {
    final DateTime initialDate = DateTime.now();
    final DateTime firstDate = DateTime(1924);
    final DateTime lastDate = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        dateDobController.text = DateFormat("dd/MM/yyyy").format(pickedDate);

        final DateTime now = DateTime.now();
        _ageYear = now.year - pickedDate.year;
        _ageMonth = now.month - pickedDate.month;
        _yearOfBirth = pickedDate.year;
      });
    }
  }

  Future<void> _registerUser() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      // Find the first invalid field and scroll to it
      if (!_nameFieldKey.currentState!.isValid) {
        _scrollToField(_nameFieldKey);
      } else if (!_emailFieldKey.currentState!.isValid) {
        _scrollToField(_emailFieldKey);
      } else if (!_mobileFieldKey.currentState!.isValid) {
        _scrollToField(_mobileFieldKey);
      } else if (!_dobFieldKey.currentState!.isValid) {
        _scrollToField(_dobFieldKey);
      } else if (!_passwordFieldKey.currentState!.isValid) {
        _scrollToField(_passwordFieldKey);
      } else if (!_confirmPasswordFieldKey.currentState!.isValid) {
        _scrollToField(_confirmPasswordFieldKey);
      } else if (!_pAddressFieldKey.currentState!.isValid) {
        _scrollToField(_pAddressFieldKey);
      } else if (!_preAddressFieldKey.currentState!.isValid) {
        _scrollToField(_preAddressFieldKey);
      } else if (!_loginFieldKey.currentState!.isValid) {
        _scrollToField(_loginFieldKey);
      } else if (!_aSdpFieldKey.currentState!.isValid) {
        _scrollToField(_aSdpFieldKey);
      } else if (!_genderFieldKey.currentState!.isValid) {
        _scrollToField(_genderFieldKey);
      } else if (!_aCountryFieldKey.currentState!.isValid) {
        _scrollToField(_aCountryFieldKey);
      } else if (!_pCountryFieldKey.currentState!.isValid) {
        _scrollToField(_pCountryFieldKey);
      } else if (!_pSdpFieldKey.currentState!.isValid) {
        _scrollToField(_pSdpFieldKey);
      }
      return;
    }

    final url = '$baseUrl/androidapi/oauth/token';
    String credentials =
        'cctnsws:ea5be3a221d5761d0aab36bd13357b93-28920be3928b4a02611051d04a2dcef9-f1e961fadf11b03227fa71bc42a2a99a-8f3918bc211a5f27198b04cd92c9d8fe-bfa8eb4f98e1668fc608c4de2946541a';
    String basicAuth = 'Basic ${base64Encode(utf8.encode(credentials)).trim()}';

    try {
      final response = await http.post(
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

        final accountUrl = '$baseUrl/androidapi/mobile/service/createAccount';

        final accountResponse = await http.post(
          Uri.parse(accountUrl),
          body: json.encode({
            "addressLine1": addressController.text,
            "countryCd": int.tryParse(aCountryController.text),
            "stateCd": int.tryParse(permanentStateCode!),
            "districtCd": int.tryParse(permanentDistrictCode!),
            "psCd": int.tryParse(permanentPoliceStationCode!),
            "langCd": 99,
            "originalRecord": 1,
            "recordCreatedOn":
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
            "recordCreatedBy": emailController.text,
            "addrtype": 1,
            "countryCd2": isChecked
                ? int.tryParse(aCountryController.text)
                : int.tryParse(pcountryController.text),
            "addressLine21":
                isChecked ? addressController.text : paddressController.text,
            "stateCd2": isChecked
                ? int.tryParse(permanentStateCode!)
                : int.tryParse(presentStateCode!),
            "districtCd2": isChecked
                ? int.tryParse(permanentDistrictCode!)
                : int.tryParse(presentDistrictCode!),
            "psCd2": isChecked
                ? int.tryParse(permanentPoliceStationCode!)
                : int.tryParse(presentPoliceStationCode!),
            "firstName": nameController.text,
            "loginPassword": passwordController.text,
            "citisignBean": {
              "commonPaneldateOfBirth": dateDobController.text,
              "commonPanelAgeYear": _ageYear,
              "commonPanelAgeMonth": _ageMonth,
              "commonPanelAgeRangeFrom": 18,
              "commonPanelAgeRangeTo": 35,
              "commonPanelyearOfBirth": _yearOfBirth
            },
            "gender": int.tryParse(genderController.text),
            "mobile2": int.tryParse(mobileController.text),
            "email": emailController.text,
            "loginId": emailController.text
          }),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (accountResponse.statusCode == 200 ||
            accountResponse.statusCode == 210) {
          final accountResponseData = jsonDecode(accountResponse.body);
          if (accountResponseData['messages'] == 'Success') {
            _showConfirmationDialog();
          } else if (accountResponseData['messages'] ==
              'Mobile number linked with multiple accounts') {
            _showErrorDialog("Mobile Number already exist, Use another number");
          } else if (accountResponseData['messages'] ==
              'Email already exists') {
            _showErrorDialog("Email already exist, Use another email");
          } else {
            _showErrorDialog("Registration failed");
          }
        } else {
          _showErrorDialog('Failed to create account');
        }
      } else {
        _showErrorDialog('Failed to fetch token');
      }
    } catch (e) {
      setState(() {
        _showErrorDialog('Error occurred: $e');
      });
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Column(
            children: [
              Image.asset(
                'asset/images/hp_logo.png',
                height: 50,
              ),
              const SizedBox(height: 10),
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
          content: const Text('You are now registered to Citizen Service.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Column(
            children: [
              Image.asset(
                'asset/images/hp_logo.png',
                height: 50,
              ),
              const SizedBox(height: 10),
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
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _nameFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _mobileFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _dobFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _confirmPasswordFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _pAddressFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _preAddressFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _loginFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _genderFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _aCountryFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _aSdpFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _pCountryFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _pSdpFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundPage(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset('asset/images/hp_logo.png', height: 100),
                const Text('Himachal Pradesh',
                    style: AppTextStyles.headingStyle),
                const Text('Citizen Service',
                    style: AppTextStyles.headingStyle),
                const Text(
                  'To avail the services, please register here.',
                  style: TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 255, 255, 255)),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child:
                        //only change this to scroll
                        Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: myBoxDecoration(),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                const Text(
                                  'Create Account',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  key: _nameFieldKey,
                                  controller: nameController,
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
                                      return 'Please enter your name';
                                    }
                                    return ValidateFullName(value);
                                  },
                                ),
                                const SizedBox(height: 16),
                                GenderPage(
                                    key: _genderFieldKey,
                                    controller: genderController),
                                const SizedBox(height: 16),
                                TextFormField(
                                  key: _emailFieldKey,
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email Id',
                                    prefixIcon: const Icon(Icons.email),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    return ValidateEmail(value);
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  key: _mobileFieldKey,
                                  controller: mobileController,
                                  decoration: InputDecoration(
                                    labelText: 'Mobile Number',
                                    prefixIcon: const Icon(Icons.phone),
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
                                      return 'Please enter your mobile number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        key: _dobFieldKey,
                                        controller: dateDobController,
                                        decoration: InputDecoration(
                                          labelText: 'Date of Birth',
                                          prefixIcon:
                                              const Icon(Icons.calendar_month),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onTap: () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          _selectDob(context);
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your date of birth';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Divider(),
                                const SizedBox(height: 8),
                                TextFormField(
                                  key: _loginFieldKey,
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Login ID/Username',
                                    prefixIcon: const Icon(Icons.login),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your Login ID/Username';
                                    }
                                    return ValidateEmail(value);
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  key: _passwordFieldKey,
                                  controller: passwordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(Icons.lock),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          // Toggle the visibility state
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return ValidatePassword(value);
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  key: _confirmPasswordFieldKey,
                                  controller: confirmPasswordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    prefixIcon: passwordMatch
                                        ? const Icon(Icons.check,
                                            color: Colors.green)
                                        : const Icon(Icons.close,
                                            color: Colors.red),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          // Toggle the visibility state
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      passwordMatch =
                                          value == passwordController.text;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    }
                                    if (value != passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 8),
                                const Divider(),
                                const SizedBox(height: 8),
                                TextFormField(
                                  key: _pAddressFieldKey,
                                  controller: addressController,
                                  decoration: InputDecoration(
                                    labelText: 'Permanent Address',
                                    prefixIcon: const Icon(Icons.home),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your address';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                CountryPage(
                                  key: _aCountryFieldKey,
                                  controller: aCountryController,
                                  enabled: true,
                                ),
                                const SizedBox(height: 10),
                                StateDistrictDynamicPage(
                                  key: _aSdpFieldKey,
                                  onStateSelected: (stateCode) {
                                    setState(() {
                                      if (isChecked) {
                                        presentStateCode = stateCode;
                                      } else {
                                        permanentStateCode = stateCode;
                                      }
                                    });
                                  },
                                  onDistrictSelected: (districtCode) {
                                    setState(() {
                                      if (isChecked) {
                                        presentDistrictCode = districtCode;
                                      } else {
                                        permanentDistrictCode = districtCode;
                                      }
                                    });
                                  },
                                  onPoliceStationSelected: (policeStationCode) {
                                    setState(() {
                                      if (isChecked) {
                                        presentPoliceStationCode =
                                            policeStationCode;
                                      } else {
                                        permanentPoliceStationCode =
                                            policeStationCode;
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isChecked = value ?? false;
                                          if (isChecked) {
                                            paddressController.text =
                                                addressController.text;
                                            pcountryController.text =
                                                aCountryController.text;
                                            presentStateCode =
                                                permanentStateCode;
                                            presentDistrictCode =
                                                permanentDistrictCode;
                                            presentPoliceStationCode =
                                                permanentPoliceStationCode;
                                          } else {
                                            paddressController.clear();
                                            pcountryController.clear();
                                            presentStateCode = null;
                                            presentDistrictCode = null;
                                            presentPoliceStationCode = null;
                                          }
                                        });
                                      },
                                    ),
                                    const Text(
                                        'Present address is same\nas permanent address'),
                                  ],
                                ),
                                if (!isChecked)
                                  Column(
                                    children: [
                                      TextFormField(
                                        key: _preAddressFieldKey,
                                        controller: paddressController,
                                        decoration: InputDecoration(
                                          labelText: 'Present Address',
                                          prefixIcon: const Icon(Icons.home),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your address';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      CountryPage(
                                          key: _pCountryFieldKey,
                                          controller: pcountryController,
                                          enabled: true),
                                      const SizedBox(height: 10),
                                      StateDistrictDynamicPage(
                                        key: _pSdpFieldKey,
                                        onStateSelected: (stateCode) {
                                          setState(() {
                                            presentStateCode = stateCode;
                                          });
                                        },
                                        onDistrictSelected: (districtCode) {
                                          setState(() {
                                            presentDistrictCode = districtCode;
                                          });
                                        },
                                        onPoliceStationSelected:
                                            (policeStationCode) {
                                          setState(() {
                                            presentPoliceStationCode =
                                                policeStationCode;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // Navigate to Forgot Password page to pforgetpassword
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const LoginPage()));
                  },
                  child: const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _registerUser();
                    }
                  },
                  style: AppButtonStyles.elevatedButtonStyle,
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // ),
        ],
      ),
    );
  }
}
