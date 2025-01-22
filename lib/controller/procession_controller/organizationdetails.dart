import 'package:flutter/material.dart';
import 'package:himcops/master/country.dart';

class ApplicantOrganizationDetailsForm extends StatefulWidget {
  final TextEditingController orgNameController;
  final TextEditingController orgAddressController;
  final TextEditingController orgCountryController;
  final TextEditingController orgStateController;
  final TextEditingController orgDistrictController;
  final TextEditingController orgPoliceStationController;

  const ApplicantOrganizationDetailsForm({
    super.key,
    required this.orgNameController,
    required this.orgAddressController,
    required this.orgCountryController,
    required this.orgStateController,
    required this.orgDistrictController,
    required this.orgPoliceStationController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ApplicantOrganizationDetailsFormState createState() =>
      _ApplicantOrganizationDetailsFormState();
}

class _ApplicantOrganizationDetailsFormState
    extends State<ApplicantOrganizationDetailsForm> {
      int? selectedStateId;
    

  String? ValidateFullName(String value) {
    if (!RegExp(r"^[a-zA-Z\s]{1,50}$").hasMatch(value)) {
      return "Full name should only contain alphabets and spaces\nand not exceed 50 words";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.orgNameController,
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
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.orgAddressController,
          decoration: InputDecoration(
            labelText: 'Present Address',
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
          controller: widget.orgCountryController,
          enabled: true,
        ),
        const SizedBox(height: 10),
        //statedynamic
      ],
    );
  }
}
